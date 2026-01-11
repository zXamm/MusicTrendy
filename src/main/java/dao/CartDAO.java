package dao;

import util.DBConnection;
import model.CartItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    // Get cart_id for a user, if doesn't exist create one
    public int getOrCreateCart(int userId) {
        int cartId = -1;
        String selectSql = "SELECT cart_id FROM cart WHERE user_id = ?";
        String insertSql = "INSERT INTO cart(user_id) VALUES(?)";

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(selectSql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                cartId = rs.getInt("cart_id");
            } else {
                PreparedStatement insertPs = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                insertPs.setInt(1, userId);
                insertPs.executeUpdate();
                ResultSet keys = insertPs.getGeneratedKeys();
                if (keys.next()) {
                    cartId = keys.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cartId;
    }

    // Add product to cart_items (if exists, increase quantity)
    public void addToCart(int cartId, int productId) {
        String checkSql = "SELECT cart_item_id, quantity FROM cart_items WHERE cart_id = ? AND product_id = ?";
        String updateSql = "UPDATE cart_items SET quantity = quantity + 1 WHERE cart_item_id = ?";
        String insertSql = "INSERT INTO cart_items(cart_id, product_id, quantity) VALUES (?, ?, 1)";

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, cartId);
            checkPs.setInt(2, productId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                int cartItemId = rs.getInt("cart_item_id");
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                updatePs.setInt(1, cartItemId);
                updatePs.executeUpdate();
            } else {
                PreparedStatement insertPs = conn.prepareStatement(insertSql);
                insertPs.setInt(1, cartId);
                insertPs.setInt(2, productId);
                insertPs.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Retrieve all items in the cart (Updated to include Image)
    public List<CartItem> getCartItems(int userId) {
        List<CartItem> items = new ArrayList<>();

        String sql = "SELECT ci.cart_item_id, p.product_id, p.name, p.image, p.price, ci.quantity, (p.price * ci.quantity) AS subtotal " +
                "FROM cart_items ci " +
                "JOIN cart c ON ci.cart_id = c.cart_id " +
                "JOIN products p ON ci.product_id = p.product_id " +
                "WHERE c.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();
                item.setCartItemId(rs.getInt("cart_item_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("name"));

                // Set Image (This fixes the 'cannot find symbol' error)
                item.setImage(rs.getString("image"));

                item.setPrice(rs.getDouble("price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setSubtotal(rs.getDouble("subtotal"));
                items.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    public void updateQuantity(int cartItemId, int quantity) {
        String sql = "UPDATE cart_items SET quantity = ? WHERE cart_item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void removeCartItem(int cartItemId) {
        String sql = "DELETE FROM cart_items WHERE cart_item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartItemId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Alias for removeCartItem to ensure compatibility
    public void removeItem(int cartItemId) {
        removeCartItem(cartItemId);
    }

    // Get total count of items in cart
    public int getCartCount(int userId) {
        int count = 0;
        String sql = "SELECT SUM(ci.quantity) FROM cart_items ci JOIN cart c ON ci.cart_id = c.cart_id WHERE c.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}