package controller;

import dao.CartDAO;
import model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // int userId = 2; // Customer One (temporary until login system)

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        model.User user = (model.User) session.getAttribute("user");
        int userId = user.getUserId();


        List<CartItem> cartItems = cartDAO.getCartItems(userId);

        double total = 0;
        for (CartItem item : cartItems) {
            total += item.getSubtotal();
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("total", total);

        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
}
