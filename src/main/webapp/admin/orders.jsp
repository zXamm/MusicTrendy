<%@ page import="java.sql.ResultSet" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    ResultSet orders = (ResultSet) request.getAttribute("orders");
    double totalSales = (double) request.getAttribute("totalSales");
    int totalOrders = (int) request.getAttribute("totalOrders");
    ResultSet bestProduct = (ResultSet) request.getAttribute("bestProduct");

    String bestName = "N/A";
    int bestSold = 0;
    if (bestProduct != null && bestProduct.next()) {
        bestName = bestProduct.getString("name");
        bestSold = bestProduct.getInt("totalSold");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin - Orders Dashboard</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .cards { display:flex; gap:20px; margin-bottom:20px; }
        .card { flex:1; padding:15px; border:1px solid #ccc; border-radius:10px; background:#f9f9f9; }
        table { width:100%; border-collapse: collapse; margin-top:15px; }
        th, td { padding:10px; border:1px solid #ccc; text-align:center; }
        th { background:#f5f5f5; }
        a { text-decoration:none; padding:6px 10px; background:#0b5ed7; color:white; border-radius:6px; }
        .back { display:inline-block; padding:10px 15px; background:#333; color:white; border-radius:6px; margin-top:15px; }
    </style>
</head>
<body>

<h2> Admin Orders & Sales Dashboard</h2>

<div class="cards">
    <div class="card">
        <h3>Total Sales</h3>
        <p><b>RM <%= String.format("%.2f", totalSales) %></b></p>
    </div>

    <div class="card">
        <h3>Total Orders</h3>
        <p><b><%= totalOrders %></b></p>
    </div>

    <div class="card">
        <h3>Best Selling Product</h3>
        <p><b><%= bestName %></b></p>
        <p>Sold: <%= bestSold %></p>
    </div>
</div>

<h3> All Customer Orders</h3>

<table>
    <tr>
        <th>Order ID</th>
        <th>Customer</th>
        <th>Total (RM)</th>
        <th>Status</th>
        <th>Date</th>
        <th>Action</th>
    </tr>

    <%
        while (orders != null && orders.next()) {
            int orderId = orders.getInt("order_id");
            String customer = orders.getString("customer_name");
            double total = orders.getDouble("total_amount");
            String status = orders.getString("status");
            String date = orders.getString("created_at");
    %>
    <tr>
        <td><%= orderId %></td>
        <td><%= customer %></td>
        <td><%= total %></td>
        <td><%= status %></td>
        <td><%= date %></td>
        <td>
            <a href="<%= request.getContextPath() %>/adminOrderDetails?orderId=<%= orderId %>">
                View
            </a>
        </td>
    </tr>
    <% } %>

</table>

<a class="back" href="<%= request.getContextPath() %>/admin/dashboard.jsp"> Back</a>

</body>
</html>
