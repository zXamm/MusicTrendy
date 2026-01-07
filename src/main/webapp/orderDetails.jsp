<%@ page import="java.sql.ResultSet" %>

<%
    ResultSet order = (ResultSet) request.getAttribute("order");
    ResultSet items = (ResultSet) request.getAttribute("items");

    int orderId = 0;
    double total = 0;
    String status = "";
    String date = "";

    boolean found = false;
    if (order != null && order.next()) {
        found = true;
        orderId = order.getInt("order_id");
        total = order.getDouble("total_amount");
        status = order.getString("status");
        date = order.getString("created_at");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>MusicTrendy - Order Details</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .box { max-width: 800px; margin:auto; border:1px solid #ccc; padding:20px; border-radius:10px; }
        table { width:100%; border-collapse: collapse; margin-top:15px; }
        th, td { padding:12px; border:1px solid #ddd; text-align:center; }
        th { background:#f5f5f5; }
        .total { margin-top:15px; font-size:18px; font-weight:bold; text-align:right; }
        .btn { display:inline-block; padding:10px 15px; background:#333; color:white; text-decoration:none; border-radius:6px; margin-top:15px;}
    </style>
</head>
<body>

<div class="box">

    <% if (found) { %>
    <h2>🧾 Order Details</h2>
    <p><b>Order ID:</b> <%= orderId %></p>
    <p><b>Status:</b> <%= status %></p>
    <p><b>Date:</b> <%= date %></p>

    <table>
        <tr>
            <th>Product</th>
            <th>Unit Price (RM)</th>
            <th>Quantity</th>
            <th>Subtotal (RM)</th>
        </tr>

        <%
            while (items != null && items.next()) {
                String name = items.getString("name");
                double unitPrice = items.getDouble("unit_price");
                int qty = items.getInt("quantity");
                double subtotal = unitPrice * qty;
        %>
        <tr>
            <td><%= name %></td>
            <td><%= unitPrice %></td>
            <td><%= qty %></td>
            <td><%= subtotal %></td>
        </tr>
        <% } %>
    </table>

    <div class="total">Total Paid: RM <%= total %></div>

    <% } else { %>
    <p>❌ Order not found (or not yours).</p>
    <% } %>

    <a class="btn" href="orders">← Back to Order History</a>

</div>

</body>
</html>
