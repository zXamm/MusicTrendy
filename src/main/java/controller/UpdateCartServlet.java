package controller;

import dao.CartDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/updateCart")
public class UpdateCartServlet extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity > 0) {
                cartDAO.updateQuantity(cartItemId, quantity);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        // REDIRECT TO REFERER (Stay on the same page)
        String referer = request.getHeader("Referer");
        if (referer != null) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("index.jsp");
        }
    }
}