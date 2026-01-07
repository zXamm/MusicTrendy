package controller;

import dao.OrderDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

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

        int orderId = orderDAO.checkout(userId);

        if (orderId > 0) {
            response.sendRedirect("receipt?orderId=" + orderId);
        } else if (orderId == -2) {
            response.getWriter().println("❌ Not enough stock for one of your items!");
        } else if (orderId == -3) {
            response.getWriter().println("❌ Your cart is empty!");
        } else {
            response.getWriter().println("❌ Checkout failed! Try again.");
        }
    }
}
