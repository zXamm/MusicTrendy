package dao;

import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    //CHECKOUT LOGIC
    public int checkout(int userId) {
        int orderId = -1;

        String getCartSql = "SELECT cart_id FROM cart WHERE user_id = ?";
        String getCartItemsSql =
                "SELECT ci.product_id, ci.quantity, p.price, p.quantity AS stock " +
                        "FROM cart_items ci " +
                        "JOIN products p ON ci.product_id = p.product_id " +
                        "WHERE ci.cart_id = ?";

        String insertOrderSql = "INSERT INTO orders(user_id, total_amount, status, created_at) VALUES (?, ?, 'To Ship', NOW())";

        String insertOrderItemSql = "INSERT INTO order_items(order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        String updateStockSql = "UPDATE products SET quantity = quantity - ? WHERE product_id = ?";
        String clearCartSql = "DELETE FROM cart_items WHERE cart_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Start transaction

            //Get cart_id
            int cartId = -1;
            try (PreparedStatement ps = conn.prepareStatement(getCartSql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) cartId = rs.getInt("cart_id");
            }

            if (cartId == -1) { conn.rollback(); return -1; }

            //Validate Stock & Calc Total
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

                    if (qty > stock) { conn.rollback(); return -2; } // Not enough stock
                    totalAmount += (price * qty);
                    items.add(new int[]{productId, qty});
                }
            }

            if (items.isEmpty()) { conn.rollback(); return -3; }

            //Insert Order
            try (PreparedStatement ps = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setDouble(2, totalAmount);
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) orderId = keys.getInt(1);
            }

            //Insert Items & Update Stock
            for (int[] item : items) {
                int productId = item[0];
                int qty = item[1];

                try (PreparedStatement ps = conn.prepareStatement(insertOrderItemSql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, productId);
                    ps.setInt(3, qty);

                    // Fetch current price
                    double unitPrice = 0;
                    try (PreparedStatement pps = conn.prepareStatement("SELECT price FROM products WHERE product_id = ?")) {
                        pps.setInt(1, productId);
                        ResultSet rs = pps.executeQuery();
                        if (rs.next()) unitPrice = rs.getDouble("price");
                    }
                    ps.setDouble(4, unitPrice);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = conn.prepareStatement(updateStockSql)) {
                    ps.setInt(1, qty);
                    ps.setInt(2, productId);
                    ps.executeUpdate();
                }
            }

            //Clear Cart
            try (PreparedStatement ps = conn.prepareStatement(clearCartSql)) {
                ps.setInt(1, cartId);
                ps.executeUpdate();
            }

            conn.commit();
            return orderId;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -99;
    }


    //USER ORDER HISTORY
    public ResultSet getOrdersByUserAndStatus(int userId, String status) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql;

        if ("All".equalsIgnoreCase(status)) {
            sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeQuery();
        } else if ("Return/Refund".equals(status)) {
            // Shows both requested and refunded items in this tab
            sql = "SELECT * FROM orders WHERE user_id = ? AND status IN ('Return Requested', 'Refunded') ORDER BY created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeQuery();
        } else {
            sql = "SELECT * FROM orders WHERE user_id = ? AND status = ? ORDER BY created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, status);
            return ps.executeQuery();
        }
    }

    //ADMIN ORDER MANAGEMENT
    public ResultSet getAllOrdersByStatus(String status) throws Exception {
        Connection conn = DBConnection.getConnection();
        if ("All".equalsIgnoreCase(status) || status == null) {
            String sql = "SELECT o.*, u.name AS customer_name FROM orders o JOIN users u ON o.user_id = u.user_id ORDER BY o.created_at DESC";
            return conn.prepareStatement(sql).executeQuery();
        } else if ("Return/Refund".equals(status)) {
            String sql = "SELECT o.*, u.name AS customer_name FROM orders o JOIN users u ON o.user_id = u.user_id WHERE o.status IN ('Return Requested', 'Refunded') ORDER BY o.created_at DESC";
            return conn.prepareStatement(sql).executeQuery();
        } else {
            String sql = "SELECT o.*, u.name AS customer_name FROM orders o JOIN users u ON o.user_id = u.user_id WHERE o.status = ? ORDER BY o.created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            return ps.executeQuery();
        }
    }


    //Admin marks as Shipped
    public void markAsShipped(int orderId) throws Exception {
        Connection conn = DBConnection.getConnection();

        //To generate the 5-Letter + 9-Digit code
        String trackingNum = generateTrackingNumber();

        //Update DB with the new Tracking Number
        String sql = "UPDATE orders SET status = 'To Receive', shipped_at = NOW(), tracking_number = ? WHERE order_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, trackingNum);
        ps.setInt(2, orderId);
        ps.executeUpdate();
    }

    //Generates "XXXXX123456789" Tracking ID
    private String generateTrackingNumber() {
        String letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String digits = "0123456789";
        StringBuilder sb = new StringBuilder();
        java.util.Random random = new java.util.Random();

        //To generate 5 Random Letters
        for (int i = 0; i < 5; i++) {
            sb.append(letters.charAt(random.nextInt(letters.length())));
        }

        //To generate 9 Random Digits
        for (int i = 0; i < 9; i++) {
            sb.append(digits.charAt(random.nextInt(digits.length())));
        }

        return sb.toString();
    }

    //User confirms Delivery OR Admin force completes
    public void markAsDelivered(int orderId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "UPDATE orders SET status = 'Completed', delivered_at = NOW() WHERE order_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        ps.executeUpdate();
    }

    //User requests Return with reason
    public void requestReturn(int orderId, String reason) throws Exception {
        Connection conn = DBConnection.getConnection();
        // Update status AND save the reason
        String sql = "UPDATE orders SET status = 'Return Requested', return_reason = ? WHERE order_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, reason);
        ps.setInt(2, orderId);
        ps.executeUpdate();
    }

    //Admin approves Return
    public void approveReturn(int orderId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "UPDATE orders SET status = 'Refunded' WHERE order_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        ps.executeUpdate();
    }

    //Admin rejects Return
    public void rejectReturn(int orderId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "UPDATE orders SET status = 'Completed' WHERE order_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        ps.executeUpdate();
    }

    public ResultSet getOrder(int orderId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        return ps.executeQuery();
    }

    //To secure fetch for User Receipt
    public ResultSet getOrderByUser(int orderId, int userId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM orders WHERE order_id = ? AND user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        ps.setInt(2, userId);
        return ps.executeQuery();
    }

    public ResultSet getOrderItems(int orderId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT oi.quantity, oi.unit_price, p.name FROM order_items oi JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        return ps.executeQuery();
    }

    //Admin Stats
    public double getTotalSales() throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT SUM(total_amount) AS totalSales FROM orders WHERE status != 'Cancelled'";
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
        String sql = "SELECT p.name, SUM(oi.quantity) AS totalSold FROM order_items oi JOIN products p ON oi.product_id = p.product_id GROUP BY p.product_id ORDER BY totalSold DESC LIMIT 1";
        PreparedStatement ps = conn.prepareStatement(sql);
        return ps.executeQuery();
    }

    //For Admin Order Details View
    public ResultSet getOrderById(int orderId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT o.order_id, o.total_amount, o.status, o.created_at, u.name AS customer_name " +
                "FROM orders o JOIN users u ON o.user_id=u.user_id WHERE o.order_id=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        return ps.executeQuery();
    }
}