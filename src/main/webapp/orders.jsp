<%@ page import="java.sql.ResultSet" %>
<%
    ResultSet orders = (ResultSet) request.getAttribute("orders");
    String currentStatus = (String) request.getAttribute("currentStatus");
    if (currentStatus == null) currentStatus = "All";
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; }
        h2 { color: #333; }

        .tabs { margin-bottom: 20px; border-bottom: 2px solid #ddd; }
        .tab { display: inline-block; padding: 10px 20px; text-decoration: none; color: #555; border-radius: 5px 5px 0 0; }
        .tab:hover { background-color: #e9e9e9; }
        .tab.active { background-color: #0b5ed7; color: white; font-weight: bold; }

        table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: center; }
        th { background: #f8f9fa; color: #333; }
        tr:hover { background-color: #f1f1f1; }

        .btn { padding: 8px 12px; text-decoration: none; border-radius: 4px; font-size: 14px; cursor: pointer; border: none; display: inline-block; }
        .btn-blue { background-color: #0b5ed7; color: white; }
        .btn-green { background-color: #28a745; color: white; }
        .btn-dark { background-color: #222; color: white; }

        .tracking-code { font-family: "Courier New", monospace; font-weight: bold; color: #555; letter-spacing: 1px; }
        .back-link { display: inline-block; margin-top: 20px; text-decoration: none; color: #333; font-weight: bold; }
    </style>

    <script>
        function promptReturn(orderId) {
            let reason = prompt("Please enter the reason for return:");
            if (reason != null && reason.trim() !== "") {
                // Redirect to Servlet with the Reason attached
                window.location.href = "orders?action=return&orderId=" + orderId + "&reason=" + encodeURIComponent(reason);
            }
        }
    </script>
</head>
<body>

<h2>My Order History</h2>

<div class="tabs">
    <a href="orders?status=All" class="tab <%= "All".equals(currentStatus) ? "active" : "" %>">All</a>
    <a href="orders?status=To Ship" class="tab <%= "To Ship".equals(currentStatus) ? "active" : "" %>">To Ship</a>
    <a href="orders?status=To Receive" class="tab <%= "To Receive".equals(currentStatus) ? "active" : "" %>">To Receive</a>
    <a href="orders?status=Completed" class="tab <%= "Completed".equals(currentStatus) ? "active" : "" %>">Completed</a>
    <a href="orders?status=Return/Refund" class="tab <%= "Return/Refund".equals(currentStatus) ? "active" : "" %>">Return/Refund</a>
</div>

<table>
    <tr>
        <th>Order ID</th>
        <th>Total (RM)</th>
        <th>Date</th>
        <th>Receipt</th>
        <th>Tracking No.</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>

    <%
        boolean hasData = false;
        while (orders != null && orders.next()) {
            hasData = true;
            int orderId = orders.getInt("order_id");
            double total = orders.getDouble("total_amount");
            String status = orders.getString("status");
            String date = orders.getString("created_at");
            String tracking = orders.getString("tracking_number");
            if (tracking == null) tracking = "-";
    %>
    <tr>
        <td>#<%= orderId %></td>
        <td>RM <%= String.format("%.2f", total) %></td>
        <td><%= date %></td>

        <td><a href="receipt?orderId=<%= orderId %>" target="_blank" class="btn btn-dark">View</a></td>

        <td>
            <% if (!"-".equals(tracking)) { %>
            <span class="tracking-code"><%= tracking %></span>
            <% } else { %> <span style="color:#ccc;">Pending</span> <% } %>
        </td>

        <td>
            <span style="font-weight:bold; color: <%= "Completed".equals(status) ? "green" : "orange" %>;">
                <%= status %>
            </span>
        </td>

        <td>
            <% if ("To Receive".equals(status)) { %>
            <a href="orders?action=receive&orderId=<%= orderId %>" class="btn btn-green" onclick="return confirm('Confirm you received this item?')">Item Delivered</a>
            <% } %>

            <% if ("Completed".equals(status)) { %>
            <button class="btn btn-blue" onclick="promptReturn(<%= orderId %>)">Request Return</button>
            <% } %>

            <% if ("Return Requested".equals(status)) { %>
            <span style="font-size:12px; color:orange; font-weight:bold;">(Processing Return)</span>
            <% } %>

            <% if ("Refunded".equals(status)) { %>
            <span style="font-size:12px; color:red; font-weight:bold;">(Refunded)</span>
            <% } %>

            <% if (!"To Receive".equals(status) && !"Completed".equals(status) && !"Return Requested".equals(status) && !"Refunded".equals(status)) { %>
            <span style="color:#ccc;">-</span>
            <% } %>
        </td>
    </tr>
    <% } %>

    <% if (!hasData) { %>
    <tr><td colspan="7" style="padding: 20px;">No orders found in this tab.</td></tr>
    <% } %>
</table>

<a class="back-link" href="products"> &larr; Continue Shopping</a>

</body>
</html>