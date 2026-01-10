<%@ page import="java.sql.ResultSet" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    ResultSet orders = (ResultSet) request.getAttribute("orders");
    String currentStatus = (String) request.getAttribute("currentStatus");
    if (currentStatus == null) currentStatus = "All";

    Double totalSalesObj = (Double) request.getAttribute("totalSales");
    double totalSales = (totalSalesObj != null) ? totalSalesObj : 0.0;

    Integer totalOrdersObj = (Integer) request.getAttribute("totalOrders");
    int totalOrders = (totalOrdersObj != null) ? totalOrdersObj : 0;

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
    <title>Admin Order Management</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f4f4f4; }

        .cards { display: flex; gap: 20px; margin-bottom: 30px; }
        .card { flex: 1; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; }
        .card h3 { margin: 0 0 10px; color: #555; font-size: 16px; }
        .card p { margin: 0; font-size: 24px; font-weight: bold; color: #333; }

        .tabs { margin-bottom: 20px; border-bottom: 2px solid #ccc; }
        .tab { display: inline-block; padding: 10px 20px; text-decoration: none; color: #555; background: #e0e0e0; margin-right: 5px; border-radius: 5px 5px 0 0; }
        .tab.active { background-color: #333; color: white; }

        table { width: 100%; border-collapse: collapse; background: white; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: center; }
        th { background: #333; color: white; }

        .btn { padding: 6px 12px; text-decoration: none; border-radius: 4px; color: white; font-size: 13px; display: inline-block; margin: 2px; cursor: pointer; border: none; }
        .btn-ship { background-color: #007bff; }
        .btn-complete { background-color: #28a745; }
        .btn-view { background-color: #6c757d; }
        .btn-reason { background-color: #ffc107; color: black; font-weight: bold; } /* New Button Style */
        .btn-dark { background-color: #222; }

        .tracking-code { font-family: "Courier New", monospace; font-weight: bold; color: #007bff; letter-spacing: 1px; }
    </style>
</head>
<body>

<h2>Admin Dashboard</h2>

<div class="cards">
    <div class="card">
        <h3>Total Sales</h3>
        <p>RM <%= String.format("%.2f", totalSales) %></p>
    </div>
    <div class="card">
        <h3>Total Orders</h3>
        <p><%= totalOrders %></p>
    </div>
    <div class="card">
        <h3>Best Seller</h3>
        <p><%= bestName %> <span style="font-size:14px; color:grey;">(<%= bestSold %> sold)</span></p>
    </div>
</div>

<h3>Order Management</h3>

<div class="tabs">
    <a href="adminOrders?status=All" class="tab <%= "All".equals(currentStatus) ? "active" : "" %>">All</a>
    <a href="adminOrders?status=To Ship" class="tab <%= "To Ship".equals(currentStatus) ? "active" : "" %>">To Ship</a>
    <a href="adminOrders?status=To Receive" class="tab <%= "To Receive".equals(currentStatus) ? "active" : "" %>">To Receive</a>
    <a href="adminOrders?status=Completed" class="tab <%= "Completed".equals(currentStatus) ? "active" : "" %>">Completed</a>
    <a href="adminOrders?status=Return/Refund" class="tab <%= "Return/Refund".equals(currentStatus) ? "active" : "" %>">Return Requests</a>
</div>

<table>
    <tr>
        <th>ID</th>
        <th>Customer</th>
        <th>Total</th>
        <th>Date</th>
        <th>Receipt</th>
        <th>Tracking No.</th>
        <th>Status</th>
        <th>Action</th>
    </tr>

    <%
        boolean hasOrders = false;
        while (orders != null && orders.next()) {
            hasOrders = true;
            int orderId = orders.getInt("order_id");
            String customer = orders.getString("customer_name");
            double total = orders.getDouble("total_amount");
            String status = orders.getString("status");
            String date = orders.getString("created_at");

            String tracking = orders.getString("tracking_number");
            if (tracking == null) tracking = "-";

            //Fetch Reason safely (handle quotes for JS alert)
            String returnReason = orders.getString("return_reason");
            if (returnReason == null) returnReason = "No reason provided";
            String safeReason = returnReason.replace("'", "\\'").replace("\"", "\\\"");

            String statusColor = "orange";
            if ("Completed".equals(status)) { statusColor = "green"; }
            else if ("Refunded".equals(status)) { statusColor = "red"; }
    %>
    <tr>
        <td><%= orderId %></td>
        <td><%= customer %></td>
        <td>RM <%= String.format("%.2f", total) %></td>
        <td><%= date %></td>

        <td><a href="receipt?orderId=<%= orderId %>" target="_blank" class="btn btn-dark">View</a></td>

        <td>
            <% if (!"-".equals(tracking)) { %>
            <span class="tracking-code"><%= tracking %></span>
            <% } else { %> <span style="color:#ccc;">-</span> <% } %>
        </td>

        <td>
            <span style="font-weight:bold; color: <%= statusColor %>;">
                <%= status %>
            </span>
        </td>

        <td>
            <% if ("To Ship".equals(status)) { %>
            <a href="adminOrders?action=ship&orderId=<%= orderId %>" class="btn btn-ship" onclick="return confirm('Mark this order as Shipped?')">Ship Order</a>
            <% } %>

            <% if ("To Receive".equals(status)) { %>
            <a href="adminOrders?action=complete&orderId=<%= orderId %>" class="btn btn-complete" onclick="return confirm('Force complete this order?')">Completed</a>
            <% } %>

            <% if ("Return Requested".equals(status)) { %>
            <button class="btn btn-reason" onclick="alert('Customer Reason:\n\n<%= safeReason %>')">View Reason</button>

            <a href="adminOrders?action=approveReturn&orderId=<%= orderId %>" class="btn btn-complete" onclick="return confirm('Approve Refund?')">Approve</a>
            <a href="adminOrders?action=rejectReturn&orderId=<%= orderId %>" class="btn btn-view" style="background-color:red;" onclick="return confirm('Reject Return?')">Reject</a>
            <% } %>

            <% if (!"To Ship".equals(status) && !"To Receive".equals(status) && !"Return Requested".equals(status)) { %>
            <span style="color:#ccc;">-</span>
            <% } %>
        </td>
    </tr>
    <% } %>

    <% if (!hasOrders) { %>
    <tr><td colspan="8">No orders found for this status.</td></tr>
    <% } %>
</table>

<br>
<a href="<%= request.getContextPath() %>/admin/dashboard.jsp" style="color:black; font-weight:bold;">&larr; Back to Dashboard</a>

</body>
</html>