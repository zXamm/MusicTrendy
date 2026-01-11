package controller;

import dao.OrderDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/receipt")
public class ReceiptServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response encoding to handle emojis/special chars
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();
        String userRole = user.getRole(); // Get the role from the session

        //Get Order ID
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null) {
            response.sendRedirect("orders");
            return;
        }
        int orderId = Integer.parseInt(orderIdParam);

        try {
            //Security Check (UPDATED)
            ResultSet orderRs;

            //Use equalsIgnoreCase so "Admin" and "admin" both work
            if ("admin".equalsIgnoreCase(userRole)) {
                orderRs = orderDAO.getOrder(orderId); // Admin can see any order
            } else {
                orderRs = orderDAO.getOrderByUser(orderId, userId); // User sees only theirs
            }

            //If no result found, show the error
            if (orderRs == null || !orderRs.next()) {
                response.getWriter().println("<h3>❌ Error: Order not found or access denied.</h3>");
                response.getWriter().println("<p>Debug Info: Your Role is '" + userRole + "'</p>");
                return;
            }

            //Extract Order Details
            request.setAttribute("orderId", orderRs.getInt("order_id"));
            request.setAttribute("total", orderRs.getDouble("total_amount"));
            request.setAttribute("status", orderRs.getString("status"));
            request.setAttribute("date", orderRs.getString("created_at"));

            //Extract Order Items into a List
            ResultSet itemsRs = orderDAO.getOrderItems(orderId);
            List<Map<String, Object>> items = new ArrayList<>();

            while (itemsRs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("name", itemsRs.getString("name"));
                item.put("unitPrice", itemsRs.getDouble("unit_price"));
                item.put("quantity", itemsRs.getInt("quantity"));

                double sub = itemsRs.getDouble("unit_price") * itemsRs.getInt("quantity");
                item.put("subtotal", sub);

                items.add(item);
            }

            request.setAttribute("items", items);

            //Forward to JSP
            request.getRequestDispatcher("receipt.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error loading receipt: " + e.getMessage());
        }
    }
}