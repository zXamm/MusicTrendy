<%@ page import="java.sql.ResultSet" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    ResultSet orders = (ResultSet) request.getAttribute("orders");

    // Status for tabs
    String currentStatus = (String) request.getAttribute("currentStatus");
    if (currentStatus == null) currentStatus = "All";

    // Safe dashboard numbers
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
    .orders-tabs{
        display:flex; gap:10px; flex-wrap:wrap; margin-top:14px; margin-bottom:14px;
    }
    .orders-tab{
        text-decoration:none; font-weight:800; font-size:13px; color:#0f172a;
        padding:10px 14px; border-radius:12px; background:#fff;
        border:1px solid #e2e8f0; box-shadow:0 6px 16px rgba(0,0,0,0.05); transition:.15s;
    }
    .orders-tab:hover{ background:#f8fafc; transform: translateY(-1px); }
    .orders-tab.active{
        background: rgba(22,163,74,0.14); border-color: rgba(22,163,74,0.35); color:#15803d;
    }

    .badge{
        display:inline-flex; align-items:center; padding:6px 10px; border-radius:999px;
        font-size:12px; font-weight:900; border:1px solid transparent;
    }
    .badge-green{ background: rgba(22,163,74,.14); color:#15803d; border-color: rgba(22,163,74,.25); }
    .badge-orange{ background: rgba(245,158,11,.14); color:#b45309; border-color: rgba(245,158,11,.25); }
    .badge-red{ background: rgba(220,38,38,.12); color:#b91c1c; border-color: rgba(220,38,38,.22); }
    .badge-blue{ background: #dbeafe; color:#1e40af; border-color: #93c5fd; }

    .btn{
        display:inline-flex; align-items:center; justify-content:center;
        padding:8px 12px; border-radius:10px; text-decoration:none;
        font-weight:900; font-size:12px; border:none; cursor:pointer;
        color:#fff; margin-right:6px; transition:.15s;
    }
    .btn:hover{ transform: translateY(-1px); }
    .btn-ship{ background:#2563eb; }
    .btn-complete{ background:#16a34a; }
    .btn-reject{ background:#dc2626; }
    .btn-view2{ background:#334155; }
    .btn-reason{ background:#f59e0b; color:#111827; }

    .mono{ font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
</style>

<div style="margin-top: 25px;">
    <h2 style="margin: 0 0 15px;">Orders & Sales Dashboard</h2>

    <div class="cards">
        <div class="card">
            <h3>Total Sales</h3>
            <p>RM <%= String.format("%.2f", totalSales) %></p>
        </div>
        <div class="card">
            <h3>Total Orders</h3>
            <p><%= totalOrders %></p>
            <small>Orders in system</small>
        </div>
        <div class="card">
            <h3>Best Selling Product</h3>
            <p><%= bestName %></p>
            <small>Sold: <%= bestSold %></small>
        </div>
    </div>

    <div class="orders-tabs">
        <a class="orders-tab <%= "All".equals(currentStatus) ? "active" : "" %>" href="<%=request.getContextPath()%>/adminOrders?status=All">All</a>
        <a class="orders-tab <%= "To Ship".equals(currentStatus) ? "active" : "" %>" href="<%=request.getContextPath()%>/adminOrders?status=To Ship">To Ship</a>
        <a class="orders-tab <%= "To Receive".equals(currentStatus) ? "active" : "" %>" href="<%=request.getContextPath()%>/adminOrders?status=To Receive">To Receive</a>
        <a class="orders-tab <%= "Completed".equals(currentStatus) ? "active" : "" %>" href="<%=request.getContextPath()%>/adminOrders?status=Completed">Completed</a>
        <a class="orders-tab <%= "Return/Refund".equals(currentStatus) ? "active" : "" %>" href="<%=request.getContextPath()%>/adminOrders?status=Return/Refund">Return Requests</a>
    </div>

    <div class="section" style="margin-top: 10px;">
        <h3 style="margin-top:0;">Customer Orders</h3>

        <table class="styled-table">
            <tr>
                <th>ID</th>
                <th>Customer</th>
                <th>Total (RM)</th>
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

                    // --- FIX: Safer Reason Handling ---
                    String returnReason = orders.getString("return_reason");
                    if (returnReason == null) returnReason = "No reason provided";

                    // Escape quotes properly for HTML attribute usage
                    String safeReason = returnReason.replace("\"", "&quot;");
            %>
            <tr>
                <td>#<%= orderId %></td>
                <td style="font-weight:700;"><%= customer %></td>
                <td style="font-weight:900; color:#dc2626;">RM <%= String.format("%.2f", total) %></td>

                <td style="color:#64748b;">
                    <%= (date != null && date.length() >= 10) ? date.substring(0,10) : (date == null ? "-" : date) %>
                </td>

                <td>
                    <a class="btn btn-view2" href="<%=request.getContextPath()%>/receipt?orderId=<%= orderId %>" target="_blank">View</a>
                </td>

                <td class="mono" style="font-weight:900; color:#16a34a; min-width: 100px;">
                    <% if (!"-".equals(tracking)) { %>
                    <%= tracking %>
                    <% } else { %>
                    <span style="color:#cbd5e1;">&mdash;</span>
                    <% } %>
                </td>

                <td>
                    <% if ("Return Rejected".equals(status)) { %>
                    <span class="badge badge-red">Return Rejected</span>
                    <% } else if ("Refunded".equals(status)) { %>
                    <span class="badge badge-red">Returned</span>
                    <% } else if ("Completed".equals(status)) { %>
                    <span class="badge badge-green">Completed</span>
                    <% } else if ("To Receive".equals(status)) { %>
                    <span class="badge badge-blue">Shipped</span>
                    <% } else if ("To Ship".equals(status)) { %>
                    <span class="badge badge-orange">To Ship</span>
                    <% } else { %>
                    <span class="badge" style="background:#eee; color:#666;"><%= status %></span>
                    <% } %>
                </td>

                <td>
                    <% if ("To Ship".equals(status)) { %>
                    <button class="btn btn-ship" onclick="confirmShip(<%= orderId %>)">Ship</button>
                    <% } %>

                    <% if ("To Receive".equals(status)) { %>
                    <button class="btn btn-complete" onclick="confirmForceComplete(<%= orderId %>)">Done</button>
                    <% } %>

                    <% if ("Return Requested".equals(status)) { %>
                    <button class="btn btn-reason" type="button"
                            data-reason="<%= safeReason %>"
                            onclick="showReturnReason(this)">
                        Reason
                    </button>

                    <button class="btn btn-complete" type="button" onclick="confirmApproveReturn(<%= orderId %>)">Approve</button>
                    <button class="btn btn-reject" type="button" onclick="confirmRejectReturn(<%= orderId %>)">Reject</button>
                    <% } %>

                    <% if (!"To Ship".equals(status) && !"To Receive".equals(status) && !"Return Requested".equals(status)) { %>
                    <span style="color:#cbd5e1;">-</span>
                    <% } %>
                </td>
            </tr>
            <% } %>

            <% if (!hasOrders) { %>
            <tr>
                <td colspan="8" style="text-align:center; padding:24px; color:#94a3b8;">
                    No orders found in this category.
                </td>
            </tr>
            <% } %>
        </table>
    </div>
</div>

<script>
    // 1. Confirm Ship (Auto Tracking)
    function confirmShip(orderId) {
        Swal.fire({
            title: 'Ship Order?',
            text: "The system will automatically generate a tracking number for Order #" + orderId + ".",
            icon: 'info',
            showCancelButton: true,
            confirmButtonColor: '#2563eb',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Yes, Ship It',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '<%=request.getContextPath()%>/adminOrders?action=ship&orderId=' + orderId;
            }
        });
    }

    // 2. Confirm Force Complete
    function confirmForceComplete(orderId) {
        Swal.fire({
            title: 'Complete Order?',
            text: "Mark Order #" + orderId + " as 'Completed'? Use this if the customer has received the item but hasn't confirmed it yet.",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#16a34a',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Yes, Complete Order',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '<%=request.getContextPath()%>/adminOrders?action=complete&orderId=' + orderId;
            }
        });
    }

    // --- FIX: Better UI for Return Reason ---
    function showReturnReason(buttonElement) {
        // Retrieve the reason safely from the data attribute
        const reasonText = buttonElement.getAttribute('data-reason');

        Swal.fire({
            title: '<span style="color:#333">Return Request Details</span>',
            html: `
                <div style="text-align: left; background: #f8fafc; padding: 15px; border-radius: 8px; border: 1px solid #e2e8f0;">
                    <strong style="color: #64748b; font-size: 12px; text-transform: uppercase;">Customer Reason:</strong>
                    <p style="margin-top: 5px; color: #334155; font-size: 15px; line-height: 1.5;">` + reasonText + `</p>
                </div>
            `,
            icon: 'info',
            confirmButtonColor: '#f59e0b',
            confirmButtonText: 'Close',
            customClass: {
                popup: 'swal-wide'
            }
        });
    }

    // 4. Confirm Approve Return
    function confirmApproveReturn(orderId) {
        Swal.fire({
            title: 'Approve Return?',
            text: "This will accept the return and process the refund for Order #" + orderId + ".",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#16a34a',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Yes, Approve',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '<%=request.getContextPath()%>/adminOrders?action=approveReturn&orderId=' + orderId;
            }
        });
    }

    // 5.. Confirm Reject Return
    function confirmRejectReturn(orderId) {
        Swal.fire({
            title: 'Reject Return?',
            text: "This will decline the return request for Order #" + orderId + " and mark it as 'Return Rejected'.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc2626',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Yes, Reject',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = '<%=request.getContextPath()%>/adminOrders?action=rejectReturn&orderId=' + orderId;
            }
        });
    }
</script>