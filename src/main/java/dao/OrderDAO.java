package dao;

import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // ✅ Create order + order_items + reduce stock + clear cart (all inside transaction)
    public int checkout(int userId) {
        int orderId = -1;

        String getCartSql = "SELECT cart_id FROM cart WHERE user_id = ?";
        String getCartItemsSql =
                "SELECT ci.product_id, ci.quantity, p.price, p.quantity AS stock " +
                        "FROM cart_items ci " +
                        "JOIN products p ON ci.product_id = p.product_id " +
                        "WHERE ci.cart_id = ?";

        String insertOrderSql = "INSERT INTO orders(user_id, total_amount, status) VALUES (?, ?, 'Paid')";
        String insertOrderItemSql = "INSERT INTO order_items(order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        String updateStockSql = "UPDATE products SET quantity = quantity - ? WHERE product_id = ?";
        String clearCartSql = "DELETE FROM cart_items WHERE cart_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // ✅ start transaction

            // 1️⃣ Get cart_id
            int cartId = -1;
            try (PreparedStatement ps = conn.prepareStatement(getCartSql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    cartId = rs.getInt("cart_id");
                }
            }

            if (cartId == -1) {
                conn.rollback();
                return -1;
            }

            // 2️⃣ Read cart items + calculate total
            List<int[]> items = new ArrayList<>();
            double totalAmount = 0;

            try (PreparedStatement ps = conn.prepareStatement(getCartItemsSql)) {
                ps.setInt(1, cartId);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    int qty = rs.getInt("quantity");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");

                    // ✅ check stock
                    if (qty > stock) {
                        conn.rollback();
                        return -2; // not enough stock
                    }

                    totalAmount += (price * qty);
                    items.add(new int[]{productId, qty});
                }
            }

            if (items.isEmpty()) {
                conn.rollback();
                return -3; // cart empty
            }

            // 3️⃣ Insert into orders table
            try (PreparedStatement ps = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setDouble(2, totalAmount);
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    orderId = keys.getInt(1);
                }
            }

            // 4️⃣ Insert order items + reduce stock
            for (int[] item : items) {
                int productId = item[0];
                int qty = item[1];

                // Insert order_items
                try (PreparedStatement ps = conn.prepareStatement(insertOrderItemSql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, productId);
                    ps.setInt(3, qty);

                    // ✅ get unit price again
                    double unitPrice = 0;
                    try (PreparedStatement pps = conn.prepareStatement("SELECT price FROM products WHERE product_id = ?")) {
                        pps.setInt(1, productId);
                        ResultSet rs = pps.executeQuery();
                        if (rs.next()) unitPrice = rs.getDouble("price");
                    }

                    ps.setDouble(4, unitPrice);
                    ps.executeUpdate();
                }

                // Update stock
                try (PreparedStatement ps = conn.prepareStatement(updateStockSql)) {
                    ps.setInt(1, qty);
                    ps.setInt(2, productId);
                    ps.executeUpdate();
                }
            }

            // 5️⃣ Clear cart
            try (PreparedStatement ps = conn.prepareStatement(clearCartSql)) {
                ps.setInt(1, cartId);
                ps.executeUpdate();
            }

            conn.commit(); // ✅ success
            return orderId;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -99; // unknown failure
    }

    public ResultSet getOrdersByUser(int userId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT order_id, total_amount, status, created_at " +
                "FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        return ps.executeQuery();
    }

    public ResultSet getOrderByUser(int orderId, int userId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT order_id, total_amount, status, created_at " +
                "FROM orders WHERE order_id = ? AND user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        ps.setInt(2, userId);
        return ps.executeQuery();
    }



    // ✅ Get order summary
    public ResultSet getOrder(int orderId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        return ps.executeQuery();
    }

    // ✅ Get order items details
    public ResultSet getOrderItems(int orderId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql =
                "SELECT oi.quantity, oi.unit_price, p.name " +
                        "FROM order_items oi " +
                        "JOIN products p ON oi.product_id = p.product_id " +
                        "WHERE oi.order_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        return ps.executeQuery();
    }

    public ResultSet getAllOrders() throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT o.order_id, o.user_id, o.total_amount, o.status, o.created_at, u.name AS customer_name " +
                "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                "ORDER BY o.created_at DESC";
        PreparedStatement ps = conn.prepareStatement(sql);
        return ps.executeQuery();
    }

    public double getTotalSales() throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT SUM(total_amount) AS totalSales FROM orders";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) return rs.getDouble("totalSales");
        return 0;
    }

    public int getTotalOrders() throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT COUNT(*) AS totalOrders FROM orders";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) return rs.getInt("totalOrders");
        return 0;
    }

    public ResultSet getBestSellingProduct() throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT p.name, SUM(oi.quantity) AS totalSold " +
                "FROM order_items oi JOIN products p ON oi.product_id = p.product_id " +
                "GROUP BY p.product_id " +
                "ORDER BY totalSold DESC LIMIT 1";
        PreparedStatement ps = conn.prepareStatement(sql);
        return ps.executeQuery();
    }

    public ResultSet getOrderById(int orderId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT o.order_id, o.total_amount, o.status, o.created_at, u.name AS customer_name " +
                "FROM orders o JOIN users u ON o.user_id=u.user_id " +
                "WHERE o.order_id=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        return ps.executeQuery();
    }

    public ResultSet getTopSellingProducts(int limit) throws Exception {
        String sql =
                "SELECT p.product_id, p.name, p.image, p.price, SUM(oi.quantity) AS totalSold " +
                        "FROM order_items oi " +
                        "JOIN products p ON oi.product_id = p.product_id " +
                        "GROUP BY p.product_id, p.name, p.image, p.price " +
                        "ORDER BY totalSold DESC " +
                        "LIMIT ?";

        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, limit);
        return ps.executeQuery(); // make sure you close this later if you keep ResultSet
    }

}
