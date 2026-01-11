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

        // Perform checkout
        int orderId = orderDAO.checkout(userId);

        if (orderId > 0) {
            // ✅ SUCCESS: Set popup and redirect to Receipt
            session.setAttribute("popup_type", "success");
            session.setAttribute("popup_message", "Payment Successful! Order #" + orderId + " confirmed.");
            response.sendRedirect("receipt?orderId=" + orderId);
        } else if (orderId == -2) {
            // ❌ FAIL: Stock Issue
            session.setAttribute("popup_type", "error");
            session.setAttribute("popup_message", "Checkout Failed: One or more items are out of stock!");
            // Redirect back to home so user sees the error and cart is still there
            response.sendRedirect("index.jsp");
        } else if (orderId == -3) {
            // ❌ FAIL: Cart Empty
            session.setAttribute("popup_type", "warning");
            session.setAttribute("popup_message", "Your cart is empty.");
            response.sendRedirect("index.jsp");
        } else {
            // ❌ FAIL: General Error
            session.setAttribute("popup_type", "error");
            session.setAttribute("popup_message", "Payment Failed. Please try again.");
            response.sendRedirect("index.jsp");
        }
    }
}