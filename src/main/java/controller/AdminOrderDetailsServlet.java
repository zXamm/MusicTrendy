package controller;

import dao.OrderDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.ResultSet;

@WebServlet("/adminOrderDetails")
public class AdminOrderDetailsServlet extends HttpServlet {

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

        if (!"admin".equals(user.getRole())) {
            response.sendRedirect("products");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        try {
            ResultSet order = orderDAO.getOrderById(orderId);
            ResultSet items = orderDAO.getOrderItems(orderId);

            request.setAttribute("order", order);
            request.setAttribute("items", items);

            request.getRequestDispatcher("admin/orderDetails.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Cannot load order details.");
        }
    }
}
