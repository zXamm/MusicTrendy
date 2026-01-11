package controller;

import dao.OrderDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.ResultSet;

@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {

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

        //Get parameters
        String action = request.getParameter("action");
        String status = request.getParameter("status"); // The tab selected
        if (status == null) status = "All"; // Default view

        try {
            //Item Delivered Action (User confirms receipt)
            if ("receive".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderDAO.markAsDelivered(orderId);
                response.sendRedirect("orders?status=Completed"); // Refresh to Completed tab
                return;
            } else if ("return".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            //Capture the reason from the URL
            String reason = request.getParameter("reason");
            if (reason == null || reason.trim().isEmpty()) {
                reason = "No reason provided.";
            }

            //Pass it to the DAO
            orderDAO.requestReturn(orderId, reason);

            response.sendRedirect("orders?status=Return/Refund");
            return;
        }

            //Fetch Orders filtered by Status
            ResultSet orders = orderDAO.getOrdersByUserAndStatus(userId, status);

            request.setAttribute("orders", orders);
            request.setAttribute("currentStatus", status); // To highlight the active tab button

            request.getRequestDispatcher("orders.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Cannot load order history.");
        }
    }
}