<%@ page import="java.sql.ResultSet" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    ResultSet order = (ResultSet) request.getAttribute("order"); //Ensure AdminOrderDetailsServlet sets this
    ResultSet items = (ResultSet) request.getAttribute("items"); //Ensure AdminOrderDetailsServlet sets this

    int orderId = 0;
    double total = 0;
    String status = "";
    String customerName = "";
    String dateOrdered = "";
    String dateShipped = "N/A";
    String dateDelivered = "N/A";

    if (order != null && order.next()) {
        orderId = order.getInt("order_id");
        total = order.getDouble("total_amount");
        status = order.getString("status");
        customerName = order.getString("customer_name");
        dateOrdered = order.getString("created_at");
        if (order.getString("shipped_at") != null) dateShipped = order.getString("shipped_at");
        if (order.getString("delivered_at") != null) dateDelivered = order.getString("delivered_at");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin - Order #<%= orderId %></title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f4f4f4; }
        .container { max-width: 900px; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
        .box { padding: 15px; background: #f9f9f9; border: 1px solid #ddd; border-radius: 6px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #333; color: white; }
        .status { display: inline-block; padding: 5px 10px; border-radius: 4px; font-weight: bold; background: #eee; }
        .status.Completed { background: #d4edda; color: #155724; }
        .status.Return { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>

<div class="container">
    <h2>Order Management: #<%= orderId %></h2>

    <div class="info-grid">
        <div class="box">
            <h3>Customer Info</h3>
            <p><strong>Name:</strong> <%= customerName %></p>
            <p><strong>Current Status:</strong> <span class="status <%= status.contains("Return") ? "Return" : status %>"><%= status %></span></p>
        </div>
        <div class="box">
            <h3>Timeline</h3>
            <p><strong>Ordered:</strong> <%= dateOrdered %></p>
            <p><strong>Shipped:</strong> <%= dateShipped %></p>
            <p><strong>Delivered:</strong> <%= dateDelivered %></p>
        </div>
    </div>

    <h3>Order Items</h3>
    <table>
        <tr>
            <th>Product</th>
            <th>Qty</th>
            <th>Price</th>
            <th>Total</th>
        </tr>
        <%
            while (items != null && items.next()) {
                double pTotal = items.getDouble("unit_price") * items.getInt("quantity");
        %>
        <tr>
            <td><%= items.getString("name") %></td>
            <td><%= items.getInt("quantity") %></td>
            <td>RM <%= String.format("%.2f", items.getDouble("unit_price")) %></td>
            <td>RM <%= String.format("%.2f", pTotal) %></td>
        </tr>
        <% } %>
    </table>

    <br>
    <a href="adminOrders" style="text-decoration:none; color:black; font-weight:bold;">&larr; Back to Dashboard</a>
</div>

</body>
</html>