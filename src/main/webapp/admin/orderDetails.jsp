<%@ page import="java.sql.ResultSet" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    ResultSet order = (ResultSet) request.getAttribute("order");
    ResultSet items = (ResultSet) request.getAttribute("items");

    int orderId = 0;
    double total = 0;
    String status = "";
    String date = "";
    String customer = "";

    if(order != null && order.next()) {
        orderId = order.getInt("order_id");
        total = order.getDouble("total_amount");
        status = order.getString("status");
        date = order.getString("created_at");
        customer = order.getString("customer_name");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin - Order Details</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .box { max-width: 800px; margin:auto; border:1px solid #ccc; padding:20px; border-radius:10px; }
        table { width:100%; border-collapse: collapse; margin-top:15px; }
        th, td { padding:10px; border:1px solid #ccc; text-align:center; }
        th { background:#f5f5f5; }
        .total { margin-top:15px; font-size:18px; font-weight:bold; text-align:right; }
        .btn { display:inline-block; padding:10px 15px; background:#333; color:white; border-radius:6px; text-decoration:none; margin-top:15px; }
    </style>
</head>
<body>

<div class="box">

    <h2> Order Details (Admin View)</h2>

    <p><b>Order ID:</b> <%= orderId %></p>
    <p><b>Customer:</b> <%= customer %></p>
    <p><b>Status:</b> <%= status %></p>
    <p><b>Date:</b> <%= date %></p>

    <table>
        <tr>
            <th>Product</th>
            <th>Unit Price</th>
            <th>Quantity</th>
            <th>Subtotal</th>
        </tr>

        <%
            while(items != null && items.next()) {
                String name = items.getString("name");
                double price = items.getDouble("unit_price");
                int qty = items.getInt("quantity");
                double subtotal = price * qty;
        %>
        <tr>
            <td><%= name %></td>
            <td><%= price %></td>
            <td><%= qty %></td>
            <td><%= subtotal %></td>
        </tr>
        <% } %>
    </table>

    <div class="total">Total: RM <%= total %></div>

    <a class="btn" href="<%= request.getContextPath() %>/adminOrders"> Back</a>

</div>

</body>
</html>
