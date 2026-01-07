package controller;

import dao.OrderDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.ResultSet;

@WebServlet("/orderDetails")
public class OrderDetailsServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        try {
            // ✅ secure: must belong to this user
            ResultSet order = orderDAO.getOrderByUser(orderId, userId);
            ResultSet items = orderDAO.getOrderItems(orderId);

            request.setAttribute("order", order);
            request.setAttribute("items", items);

            request.getRequestDispatcher("orderDetails.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Cannot load order details.");
        }
    }
}
