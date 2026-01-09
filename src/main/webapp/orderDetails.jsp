<%@ page import="java.sql.ResultSet" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ResultSet order = (ResultSet) request.getAttribute("order");
    ResultSet items = (ResultSet) request.getAttribute("items");

    int orderId = 0;
    double total = 0;
    String status = "";
    String dateOrdered = "";
    String dateShipped = null;
    String dateDelivered = null;

    if (order != null && order.next()) {
        orderId = order.getInt("order_id");
        total = order.getDouble("total_amount");
        status = order.getString("status");
        dateOrdered = order.getString("created_at");
        dateShipped = order.getString("shipped_at");
        dateDelivered = order.getString("delivered_at");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order #<%= orderId %> Details</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f9f9f9; }
        .container { max-width: 800px; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        h2, h3 { color: #333; }

        .timeline { display: flex; justify-content: space-between; margin: 20px 0; border-bottom: 2px solid #eee; padding-bottom: 20px; }
        .step { text-align: center; flex: 1; color: #ccc; font-size: 14px; }
        .step.active { color: #28a745; font-weight: bold; }
        .step div { font-size: 24px; margin-bottom: 5px; }

        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 10px; border-bottom: 1px solid #ddd; }
        th { text-align: left; background: #f1f1f1; }
        .total-row td { border-top: 2px solid #333; font-weight: bold; font-size: 18px; }

        .back-btn { display: inline-block; margin-top: 20px; text-decoration: none; color: #555; }
    </style>
</head>
<body>

<div class="container">
    <h2>Order Details #<%= orderId %></h2>

    <div class="timeline">
        <div class="step active">
            <div>1</div>
            Ordered<br><small><%= dateOrdered %></small>
        </div>

        <div class="step <%= (dateShipped != null) ? "active" : "" %>">
            <div>2</div>
            Shipped<br><small><%= (dateShipped != null) ? dateShipped : "Pending" %></small>
        </div>

        <div class="step <%= (dateDelivered != null) ? "active" : "" %>">
            <div>3</div>
            Delivered<br><small><%= (dateDelivered != null) ? dateDelivered : "Pending" %></small>
        </div>

        <% if ("Return Requested".equals(status) || "Refunded".equals(status)) { %>
        <div class="step active" style="color:orange;">
            <div style="border-color:orange; background:orange; color:white;">!</div>
            Return<br><small><%= status %></small>
        </div>
        <% } %>
    </div>

    <h3>Items in this Order</h3>
    <table>
        <tr>
            <th>Product</th>
            <th>Quantity</th>
            <th>Unit Price</th>
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
        <tr class="total-row">
            <td colspan="3" style="text-align:right;">Grand Total:</td>
            <td>RM <%= String.format("%.2f", total) %></td>
        </tr>
    </table>

    <a href="orders" class="back-btn">&larr; Back to Order History</a>
</div>

</body>
</html>