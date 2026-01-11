package controller;

import dao.CartDAO;
import model.User;
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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();
        String productIdParam = request.getParameter("productId");

        if (productIdParam != null && !productIdParam.isEmpty()) {
            try {
                int productId = Integer.parseInt(productIdParam);
                int cartId = cartDAO.getOrCreateCart(userId);
                cartDAO.addToCart(cartId, productId);

                int count = cartDAO.getCartCount(userId);
                session.setAttribute("cartCount", count);

                session.setAttribute("popup_type", "success");
                session.setAttribute("popup_message", "Item successfully added to the cart!");

                String buyNow = request.getParameter("buyNow");

                if ("true".equals(buyNow)) {
                    // CHANGED: Go to Buyer Info instead of Payment
                    response.sendRedirect("buyerInfo.jsp");
                } else {
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