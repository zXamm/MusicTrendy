<%@ page import="java.sql.ResultSet" %>

<%
    ResultSet orders = (ResultSet) request.getAttribute("orders");
%>

<!DOCTYPE html>
<html>
<head>
    <title>MusicTrendy - Order History</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        table { width:100%; border-collapse: collapse; margin-top:15px; }
        th, td { padding:12px; border:1px solid #ccc; text-align:center; }
        th { background:#f5f5f5; }
        a { text-decoration:none; color:#0b5ed7; font-weight:bold; }
        .back { display:inline-block; padding:10px 15px; background:#333; color:white; text-decoration:none; border-radius:6px; margin-top:15px;}
    </style>
</head>
<body>

<h2> Your Order History</h2>

<table>
    <tr>
        <th>Order ID</th>
        <th>Total (RM)</th>
        <th>Status</th>
        <th>Date</th>
        <th>View</th>
    </tr>

    <%
        boolean hasData = false;
        while (orders != null && orders.next()) {
            hasData = true;
            int orderId = orders.getInt("order_id");
            double total = orders.getDouble("total_amount");
            String status = orders.getString("status");
            String date = orders.getString("created_at");
    %>
    <tr>
        <td><%= orderId %></td>
        <td><%= total %></td>
        <td><%= status %></td>
        <td><%= date %></td>
        <td><a href="receipt?orderId=<%= orderId %>">View Details</a></td>
    </tr>
    <% } %>

    <% if (!hasData) { %>
    <tr><td colspan="5">You have not made any orders yet.</td></tr>
    <% } %>
</table>

<a class="back" href="products"> Back to Products</a>

</body>
</html>
