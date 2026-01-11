package model;

public class CartItem {
    private int cartItemId;
    private int productId;
    private String productName;
    private String image; // <--- Added this field
    private double price;
    private int quantity;
    private double subtotal;

    public int getCartItemId() { return cartItemId; }
    public void setCartItemId(int cartItemId) { this.cartItemId = cartItemId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    // --- NEW METHODS FOR IMAGE ---
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    // -----------------------------

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
}