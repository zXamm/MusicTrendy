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

    // Statistics (Null safe)
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

<style>
    /* Dashboard Specific Styles */
    .orders-tabs { display:flex; gap:10px; flex-wrap:wrap; margin:20px 0; }
    .orders-tab {
        text-decoration:none; color:#555; font-size:13px; font-weight:600;
        padding:10px 18px; border-radius:30px; background:#fff;
        border:1px solid #e2e8f0; box-shadow:0 2px 5px rgba(0,0,0,0.05); transition:.2s;
    }
    .orders-tab:hover { background:#f8fafc; transform:translateY(-2px); }
    .orders-tab.active {
        background: #558B2F; color: white; border-color: #558B2F;
        box-shadow: 0 4px 10px rgba(85, 139, 47, 0.3);
    }

    .badge { padding:6px 12px; border-radius:20px; font-size:11px; font-weight:800; text-transform:uppercase; letter-spacing:0.5px;}
    .badge-green { background: #dcfce7; color:#166534; }
    .badge-yellow { background: #fef9c3; color:#854d0e; }
    .badge-red { background: #fee2e2; color:#991b1b; }
    .badge-blue { background: #dbeafe; color:#1e40af; }

    .btn-action {
        border:none; cursor:pointer; padding:8px 14px; border-radius:8px;
        font-size:12px; font-weight:700; color:white; transition:.2s; text-decoration:none; display:inline-flex; align-items:center; gap:5px;
    }
    .btn-action:hover { transform:translateY(-2px); opacity:0.9; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }

    .btn-ship { background:#2563eb; }
    .btn-complete { background:#16a34a; }
    .btn-reject { background:#ef4444; }
    .btn-reason { background:#f59e0b; color:#fff; }
    .btn-view2 { background:#64748b; }
</style>

<div style="margin-top: 10px;">
    <h2>Orders Management</h2>

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
            <h3>Top Product</h3>
            <p style="font-size:18px; margin-top:15px;"><%= bestName %></p>
            <small><%= bestSold %> sold</small>
        </div>
    </div>

    <div class="orders-tabs">
        <a class="orders-tab <%= "All".equals(currentStatus) ? "active" : "" %>" href="<%=request.getContextPath()%>/adminOrders?status=All">All Orders</a>
        <a class="orders-tab <%= "To Ship".equals(currentStatus) ? "active" : "" %>" href="<%=request.getContextPath()%>/adminOrders?status=To Ship">To Ship</a>
        <a class="orders-tab <%= "To Receive".equals(currentStatus) ? "active" : "" %>" href="<%=request.getContextPath()%>/adminOrders?status=To Receive">To Receive</a>
        <a class="orders-tab <%= "Completed".equals(currentStatus) ? "active" : "" %>" href="<%=request.getContextPath()%>/adminOrders?status=Completed">Completed</a>
        <a class="orders-tab <%= "Return/Refund".equals(currentStatus) ? "active" : "" %>" href="<%=request.getContextPath()%>/adminOrders?status=Return/Refund">Return Requests</a>
    </div>

    <div class="section">
        <table class="styled-table">
            <thead>
            <tr>
                <th>Order #</th>
                <th>Customer</th>
                <th>Amount</th>
                <th>Date</th>
                <th>Status</th>
                <th>Receipt</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                boolean hasOrders = false;
                while (orders != null && orders.next()) {
                    hasOrders = true;
                    int orderId = orders.getInt("order_id");
                    String customer = orders.getString("customer_name");
                    double total = orders.getDouble("total_amount");
                    String status = orders.getString("status");
                    String date = orders.getString("created_at");

                    // Robust Escaping for JavaScript
                    String returnReason = orders.getString("return_reason");
                    if (returnReason == null) returnReason = "No reason provided.";

                    String safeReason = returnReason
                            .replace("\\", "\\\\")
                            .replace("'", "\\'")
                            .replace("\"", "&quot;")
                            .replace("\r", " ")
                            .replace("\n", "\\n");
            %>
            <tr>
                <td>#<%= orderId %></td>
                <td style="font-weight:bold; color:#333;"><%= customer %></td>
                <td style="color:#d32f2f; font-weight:bold;">RM <%= String.format("%.2f", total) %></td>
                <td style="color:#777; font-size:13px;"><%= date.substring(0, 10) %></td>

                <td>
                    <% if ("To Ship".equals(status)) { %> <span class="badge badge-yellow">To Ship</span>
                    <% } else if ("To Receive".equals(status)) { %> <span class="badge badge-blue">Shipped</span>
                    <% } else if ("Completed".equals(status)) { %> <span class="badge badge-green">Completed</span>
                    <% } else if ("Return Requested".equals(status)) { %> <span class="badge badge-red" style="background:#fff7ed; color:#c2410c;">Requesting Return</span>
                    <% } else if ("Refunded".equals(status)) { %> <span class="badge badge-red">Refunded</span>
                    <% } else { %> <span class="badge" style="background:#f1f5f9; color:#64748b;"><%= status %></span>
                    <% } %>
                </td>

                <td>
                    <a href="receipt?orderId=<%= orderId %>" target="_blank" class="btn-action btn-view2">View</a>
                </td>

                <td>
                    <% if ("To Ship".equals(status)) { %>
                    <a href="<%=request.getContextPath()%>/adminOrders?action=ship&orderId=<%= orderId %>"
                       class="btn-action btn-ship" onclick="return confirm('Confirm shipment?')">Ship Now</a>

                    <% } else if ("To Receive".equals(status)) { %>
                    <span style="font-size:12px; color:#aaa;">Wait for user</span>

                    <% } else if ("Return Requested".equals(status)) { %>
                    <button class="btn-action btn-reason"
                            onclick="showReason('<%= orderId %>', '<%= safeReason %>')">
                        Reason
                    </button>

                    <div style="margin-top:8px; display:flex; gap:8px;">
                        <button class="btn-action btn-complete"
                                onclick="approveReturn('<%= orderId %>')"
                                title="Approve Return">
                            &#10003; Approve
                        </button>

                        <button class="btn-action btn-reject"
                                onclick="rejectReturn('<%= orderId %>')"
                                title="Reject Return">
                            &#10005; Reject
                        </button>
                    </div>

                    <% } else { %>
                    <span style="color:#ccc;">-</span>
                    <% } %>
                </td>
            </tr>
            <% } %>

            <% if (!hasOrders) { %>
            <tr><td colspan="7" style="padding:30px; text-align:center; color:#999;">No orders found.</td></tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    // 1. Show Reason Modal
    function showReason(orderId, reasonText) {
        Swal.fire({
            title: '<strong>Return Request #' + orderId + '</strong>',
            html: '<div style="text-align:left; background:#f9f9f9; padding:15px; border-radius:8px;">' +
                '<b>Customer Reason:</b><br><br>' +
                '<span style="white-space: pre-wrap; font-size:14px; color:#333;">' + reasonText + '</span>' +
                '</div>',
            showCloseButton: true,
            focusConfirm: false,
            confirmButtonText: 'Close',
            confirmButtonColor: '#64748b'
        });
    }

    // 2. Approve Return Modal (Renamed from Refund)
    function approveReturn(orderId) {
        Swal.fire({
            title: 'Approve Return?',
            text: "Are you sure you want to approve the return for Order #" + orderId + "?",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#16a34a', // Green
            cancelButtonColor: '#64748b', // Gray
            confirmButtonText: 'Yes, Approve Return',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '<%=request.getContextPath()%>/adminOrders?action=approveReturn&orderId=' + orderId;
            }
        });
    }

    // 3. Reject Return Modal
    function rejectReturn(orderId) {
        Swal.fire({
            title: 'Reject Return?',
            text: "Are you sure you want to reject the return request for Order #" + orderId + "?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444', // Red
            cancelButtonColor: '#64748b', // Gray
            confirmButtonText: 'Yes, Reject Return',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '<%=request.getContextPath()%>/adminOrders?action=rejectReturn&orderId=' + orderId;
            }
        });
    }
</script>