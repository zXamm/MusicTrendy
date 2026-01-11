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

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"admin".equals(user.getRole())) {
            response.sendRedirect("products");
            return;
        }

        try {
            ResultSet orders = orderDAO.getAllOrders();
            double totalSales = orderDAO.getTotalSales();
            int totalOrders = orderDAO.getTotalOrders();
            ResultSet bestProduct = orderDAO.getBestSellingProduct();

            request.setAttribute("orders", orders);
            request.setAttribute("totalSales", totalSales);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("bestProduct", bestProduct);

            request.getRequestDispatcher("/admin/adminLayout.jsp?page=ordersContent.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println(" Cannot load admin orders dashboard.");
        }
    }
}
