<%@ page import="java.sql.ResultSet" %>
<%
    ResultSet orders = (ResultSet) request.getAttribute("orders");
    String currentStatus = (String) request.getAttribute("currentStatus");
    if (currentStatus == null) currentStatus = "All";
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Orders | MusicTrendy</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        /* THEME VARIABLES */
        :root {
            --primary-green: #558B2F;
            --primary-hover: #437d26;
            --price-red: #d32f2f;
            --bg-gray: #f9f9f9;
            --text-dark: #333;
            --card-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        body { font-family: 'Roboto', sans-serif; margin: 0; background-color: var(--bg-gray); color: var(--text-dark); }

        /* HEADER */
        .page-header { background: white; padding: 20px 40px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); margin-bottom: 30px; display: flex; align-items: center; justify-content: space-between; }
        .page-title { margin: 0; font-size: 24px; font-weight: 700; color: #222; text-transform: uppercase; letter-spacing: 1px; }

        /* CONTAINER */
        .container { max-width: 1100px; margin: 0 auto 50px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: var(--card-shadow); }

        /* TABS */
        .tabs { display: flex; border-bottom: 2px solid #eee; margin-bottom: 25px; }
        .tab {
            padding: 15px 25px;
            text-decoration: none;
            color: #777;
            font-weight: 500;
            transition: 0.3s;
            border-bottom: 3px solid transparent;
        }
        .tab:hover { color: var(--primary-green); background: #fdfdfd; }
        .tab.active {
            color: var(--primary-green);
            border-bottom: 3px solid var(--primary-green);
            font-weight: bold;
        }

        /* TABLE */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th { text-align: left; padding: 15px; background-color: #f8f9fa; color: #555; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid #eee; }
        td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; }
        tr:hover td { background-color: #fafafa; }

        /* ELEMENTS */
        .price-tag { color: var(--price-red); font-weight: bold; font-size: 16px; }
        .tracking-code { background: #e8f5e9; color: var(--primary-green); padding: 4px 8px; border-radius: 4px; font-family: monospace; font-weight: bold; font-size: 14px; }

        /* STATUS BADGES */
        .status-badge { font-weight: bold; font-size: 13px; padding: 5px 10px; border-radius: 20px; display: inline-block; }
        .status-completed { background: #e8f5e9; color: #2e7d32; } /* Green */
        .status-refunded { background: #ffebee; color: #c62828; } /* Red */
        .status-pending { background: #fff3e0; color: #ef6c00; } /* Orange */

        /* BUTTONS */
        .btn { padding: 8px 14px; text-decoration: none; border-radius: 4px; font-size: 13px; font-weight: 600; cursor: pointer; border: none; display: inline-block; transition: 0.2s; margin-right: 5px; }

        .btn-green { background-color: var(--primary-green); color: white; }
        .btn-green:hover { background-color: var(--primary-hover); transform: translateY(-1px); }

        .btn-blue { background-color: #1976D2; color: white; }
        .btn-blue:hover { background-color: #1565C0; }

        .btn-outline { border: 1px solid #ccc; color: #555; background: white; }
        .btn-outline:hover { border-color: #999; color: #333; }

        .btn-red { background-color: white; border: 1px solid var(--price-red); color: var(--price-red); }
        .btn-red:hover { background-color: var(--price-red); color: white; }

        .back-link { display: inline-block; margin-top: 20px; text-decoration: none; color: #777; font-weight: 500; }
        .back-link:hover { color: var(--primary-green); }
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

<div class="page-header">
    <h1 class="page-title">My Order History</h1>
    <a href="products" class="btn btn-outline" style="border:none;">&larr; Back to Shop</a>
</div>

<div class="container">
    <div class="tabs">
        <a href="orders?status=All" class="tab <%= "All".equals(currentStatus) ? "active" : "" %>">All Orders</a>
        <a href="orders?status=To Ship" class="tab <%= "To Ship".equals(currentStatus) ? "active" : "" %>">To Ship</a>
        <a href="orders?status=To Receive" class="tab <%= "To Receive".equals(currentStatus) ? "active" : "" %>">To Receive</a>
        <a href="orders?status=Completed" class="tab <%= "Completed".equals(currentStatus) ? "active" : "" %>">Completed</a>

        <a href="orders?status=Return/Refund" class="tab <%= "Return/Refund".equals(currentStatus) ? "active" : "" %>">Return</a>
    </div>

    <table>
        <tr>
            <th>Order ID</th>
            <th>Total Amount</th>
            <th>Date Ordered</th>
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
            <td style="font-weight:bold;">#<%= orderId %></td>
            <td class="price-tag">RM <%= String.format("%.2f", total) %></td>
            <td style="color:#777;"><%= date.substring(0, 10) %></td>

            <td><a href="receipt?orderId=<%= orderId %>" target="_blank" class="btn btn-outline">View Receipt</a></td>

            <td>
                <% if (!"-".equals(tracking)) { %>
                <span class="tracking-code"><%= tracking %></span>
                <% } else { %> <span style="color:#ccc; font-size:13px;">Processing</span> <% } %>
            </td>

            <td>
                <% if ("Completed".equals(status)) { %>
                <span class="status-badge status-completed">Completed</span>
                <% } else if ("Refunded".equals(status)) { %>

                <span class="status-badge status-refunded">Returned</span>

                <% } else { %>
                <span class="status-badge status-pending"><%= status %></span>
                <% } %>
            </td>

            <td>
                <% if ("To Receive".equals(status)) { %>
                <a href="orders?action=receive&orderId=<%= orderId %>" class="btn btn-green" onclick="return confirm('Confirm receipt?')">Item Received</a>
                <% } %>

                <% if ("Completed".equals(status)) { %>
                <button class="btn btn-red" onclick="promptReturn(<%= orderId %>)">Return Item</button>
                <% } %>

                <% if ("Return Requested".equals(status)) { %> <span style="color:#ef6c00; font-size:13px; font-weight:bold;">Wait for Approval</span> <% } %>

                <% if (!"To Receive".equals(status) && !"Completed".equals(status) && !"Return Requested".equals(status)) { %>
                <span style="color:#ccc;">-</span>
                <% } %>
            </td>
        </tr>
        <% } %>

        <% if (!hasData) { %>
        <tr><td colspan="7" style="padding: 40px; text-align:center; color:#999;">No orders found in this category.</td></tr>
        <% } %>
    </table>
</div>

</body>
</html>