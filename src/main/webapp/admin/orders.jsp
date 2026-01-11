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

    //Dashboard Data (From your logic)
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
    <title>Admin Dashboard | MusicTrendy</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --admin-dark: #222;
            --admin-green: #558B2F;
            --bg-gray: #f4f4f4;
        }

        body { font-family: 'Roboto', sans-serif; margin: 0; background-color: var(--bg-gray); padding-bottom: 50px; }

        /* HEADER */
        .admin-header { background: var(--admin-dark); color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .admin-title { margin: 0; font-size: 20px; font-weight: 500; letter-spacing: 1px; }
        .back-btn { color: white; text-decoration: none; font-size: 14px; opacity: 0.8; }
        .back-btn:hover { opacity: 1; text-decoration: underline; }

        /* STATS CARDS */
        .stats-container { display: flex; gap: 20px; max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .stat-card { flex: 1; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); text-align: center; border-left: 5px solid var(--admin-green); }
        .stat-card h3 { margin: 0 0 10px; color: #777; font-size: 14px; text-transform: uppercase; }
        .stat-card p { margin: 0; font-size: 28px; font-weight: 700; color: #333; }

        /* MAIN CONTAINER */
        .main-container { max-width: 1200px; margin: 0 auto; background: white; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden; }

        /* TABS */
        .tabs { display: flex; background: #f8f9fa; border-bottom: 1px solid #ddd; padding: 0 20px; }
        .tab { padding: 15px 20px; text-decoration: none; color: #555; font-size: 14px; font-weight: 500; border-bottom: 3px solid transparent; }
        .tab:hover { color: var(--admin-green); }
        .tab.active { color: var(--admin-green); border-bottom: 3px solid var(--admin-green); font-weight: bold; }

        /* TABLE */
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 15px 20px; background: white; color: #888; font-size: 12px; text-transform: uppercase; border-bottom: 2px solid #eee; }
        td { padding: 15px 20px; border-bottom: 1px solid #f0f0f0; color: #333; }
        tr:hover { background-color: #fcfcfc; }

        /* BADGES */
        .badge { padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: bold; text-transform: uppercase; }
        .badge-green { background: #e8f5e9; color: #2e7d32; }
        .badge-orange { background: #fff3e0; color: #ef6c00; }
        .badge-red { background: #ffebee; color: #c62828; }

        /* BUTTONS */
        .btn { padding: 6px 14px; border-radius: 4px; color: white; text-decoration: none; font-size: 12px; font-weight: bold; border: none; cursor: pointer; display: inline-block; margin-right: 5px; }
        .btn-ship { background-color: #007bff; }
        .btn-complete { background-color: #28a745; }
        .btn-reject { background-color: #dc3545; }
        .btn-view { background-color: #6c757d; }
        .btn-reason { background-color: #ffc107; color: black; }
        .btn-dark { background-color: #333; }
    </style>
</head>
<body>

<div class="admin-header">
    <h1 class="admin-title">ADMINISTRATOR PANEL</h1>
    <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="back-btn">&larr; Back to Dashboard</a>
</div>

<div class="stats-container">
    <div class="stat-card">
        <h3>Total Sales Revenue</h3>
        <p>RM <%= String.format("%.2f", totalSales) %></p>
    </div>
    <div class="stat-card" style="border-left-color: #007bff;">
        <h3>Total Orders</h3>
        <p><%= totalOrders %></p>
    </div>
    <div class="stat-card" style="border-left-color: #ffc107;">
        <h3>Best Selling Product</h3>
        <p style="font-size:20px;"><%= bestName %></p>
        <span style="font-size:14px; color:#777;">(<%= bestSold %> Sold)</span>
    </div>
</div>

<div class="main-container">
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
            <th>Amount</th>
            <th>Date</th>
            <th>Receipt</th>
            <th>Tracking</th>
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

                //Return Reason handling
                String returnReason = orders.getString("return_reason");
                if (returnReason == null) returnReason = "No reason provided";
                String safeReason = returnReason.replace("'", "\\'").replace("\"", "\\\"");
        %>
        <tr>
            <td>#<%= orderId %></td>
            <td style="font-weight:500;"><%= customer %></td>
            <td style="color:#d32f2f; font-weight:bold;">RM <%= String.format("%.2f", total) %></td>
            <td style="color:#777;"><%= date.substring(0, 10) %></td>

            <td><a href="receipt?orderId=<%= orderId %>" target="_blank" class="btn btn-dark">View</a></td>

            <td style="font-family:monospace; color:#558B2F; font-weight:bold;">
                <% if (!"-".equals(tracking)) { %><%= tracking %><% } else { %><span style="color:#ccc;">-</span><% } %>
            </td>

            <td>
                <% if ("Completed".equals(status)) { %> <span class="badge badge-green">Completed</span> <% }
            else if ("Refunded".equals(status)) { %>
                <span class="badge badge-red">Returned</span>
                <% }
                else { %> <span class="badge badge-orange"><%= status %></span> <% } %>
            </td>

            <td>
                <% if ("To Ship".equals(status)) { %>
                <a href="adminOrders?action=ship&orderId=<%= orderId %>" class="btn btn-ship" onclick="return confirm('Mark as Shipped?')">Ship Now</a>
                <% } %>

                <% if ("To Receive".equals(status)) { %>
                <a href="adminOrders?action=complete&orderId=<%= orderId %>" class="btn btn-complete" onclick="return confirm('Force Complete?')">Mark Done</a>
                <% } %>

                <% if ("Return Requested".equals(status)) { %>
                <button class="btn btn-reason" onclick="alert('Reason:\n<%= safeReason %>')">Reason</button>
                <a href="adminOrders?action=approveReturn&orderId=<%= orderId %>" class="btn btn-complete">Approve</a>
                <a href="adminOrders?action=rejectReturn&orderId=<%= orderId %>" class="btn btn-reject">Reject</a>
                <% } %>

                <% if (!"To Ship".equals(status) && !"To Receive".equals(status) && !"Return Requested".equals(status)) { %>
                <span style="color:#ccc;">-</span>
                <% } %>
            </td>
        </tr>
        <% } %>

        <% if (!hasOrders) { %>
        <tr><td colspan="8" style="text-align:center; padding:30px; color:#999;">No orders found in this category.</td></tr>
        <% } %>
    </table>
</div>

</body>
</html>