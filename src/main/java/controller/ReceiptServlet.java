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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        try {
            // ✅ secure: check the order belongs to this user
            ResultSet orderRs = orderDAO.getOrderByUser(orderId, userId);

            if (orderRs == null || !orderRs.next()) {
                response.getWriter().println("❌ Order not found or not yours.");
                return;
            }

            // ✅ store order info in attributes
            request.setAttribute("orderId", orderRs.getInt("order_id"));
            request.setAttribute("total", orderRs.getDouble("total_amount"));
            request.setAttribute("status", orderRs.getString("status"));
            request.setAttribute("date", orderRs.getString("created_at"));

            // ✅ store items in a List<Map>
            ResultSet itemsRs = orderDAO.getOrderItems(orderId);
            List<Map<String, Object>> items = new ArrayList<>();

            while (itemsRs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("name", itemsRs.getString("name"));
                row.put("unitPrice", itemsRs.getDouble("unit_price"));
                row.put("qty", itemsRs.getInt("quantity"));
                row.put("subtotal", itemsRs.getDouble("unit_price") * itemsRs.getInt("quantity"));
                items.add(row);
            }

            request.setAttribute("items", items);

            request.getRequestDispatcher("receipt.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Cannot load receipt.");
        }
    }
}
