package controller;

import dao.OrderDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.ResultSet;

@WebServlet("/adminOrders")
public class AdminOrdersServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String status = request.getParameter("status");
        if (status == null) status = "All";

        try {

            if ("ship".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderDAO.markAsShipped(orderId);
                response.sendRedirect("adminOrders?status=To Receive");
                return;
            } else if ("complete".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderDAO.markAsDelivered(orderId);
                response.sendRedirect("adminOrders?status=Completed");
                return;
            } else if ("approveReturn".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderDAO.approveReturn(orderId);
                response.sendRedirect("adminOrders?status=Return/Refund");
                return;
            } else if ("rejectReturn".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderDAO.rejectReturn(orderId);
                response.sendRedirect("adminOrders?status=Return/Refund");
                return;
            }

            ResultSet orders = orderDAO.getAllOrdersByStatus(status);
            double totalSales = orderDAO.getTotalSales();
            int totalOrders = orderDAO.getTotalOrders();
            ResultSet bestProduct = orderDAO.getBestSellingProduct();

            request.setAttribute("orders", orders);
            request.setAttribute("totalSales", totalSales);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("bestProduct", bestProduct);
            request.setAttribute("currentStatus", status);

            request.getRequestDispatcher("/admin/adminLayout.jsp?page=ordersContent.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("CANNOT LOAD ADMIN DASHBOARD.");
        }
    }
}