package controller;

import dao.CartDAO;
import model.User; // Import your User model
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Retrieve User ID
        // Ensure "User" is imported or use model.User
        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        // 3. Get Product ID safely
        String productIdParam = request.getParameter("productId");

        if (productIdParam != null && !productIdParam.isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdParam);

// 4. Add to Cart Logic
                int cartId = cartDAO.getOrCreateCart(userId);
                cartDAO.addToCart(cartId, productId);

                // Update Cart Count (from previous step)
                int count = cartDAO.getCartCount(userId);
                session.setAttribute("cartCount", count);

                // --- NEW: POP-UP LOGIC ---
                // Set a session flag that the JSP will read to show the popup
                session.setAttribute("popup_type", "success");
                session.setAttribute("popup_message", "Item successfully added to cart!");

                // 5. Redirect Logic
                String buyNow = request.getParameter("buyNow");
                if ("true".equals(buyNow)) {
                    response.sendRedirect("cart");
                } else {
                    // Redirect back to the SAME page (Product Details or Shop)
                    String referer = request.getHeader("Referer");
                    response.sendRedirect(referer != null ? referer : "products");
                }

            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("products?error=invalid_id");
            }
        } else {
            response.sendRedirect("products?error=missing_id");
        }
    }

}