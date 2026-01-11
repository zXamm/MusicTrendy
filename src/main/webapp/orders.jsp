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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
        .tab { padding: 15px 25px; text-decoration: none; color: #777; font-weight: 500; transition: 0.3s; border-bottom: 3px solid transparent; }
        .tab:hover { color: var(--primary-green); background: #fdfdfd; }
        .tab.active { color: var(--primary-green); border-bottom: 3px solid var(--primary-green); font-weight: bold; }

        /* TABLE - IMPROVED UI */
        table { width: 100%; border-collapse: separate; border-spacing: 0 10px; margin-top: 10px; }
        th { text-align: left; padding: 15px; background-color: white; color: #777; font-size: 12px; text-transform: uppercase; letter-spacing: 1px; border-bottom: 2px solid #eee; }

        td { padding: 15px 20px; background: white; vertical-align: middle; border-top: 1px solid #eee; border-bottom: 1px solid #eee; }

        /* Rounded corners for rows */
        td:first-child { border-left: 1px solid #eee; border-top-left-radius: 8px; border-bottom-left-radius: 8px; }
        td:last-child { border-right: 1px solid #eee; border-top-right-radius: 8px; border-bottom-right-radius: 8px; }

        tr:hover td { background-color: #fafafa; }

        /* ELEMENTS */
        .price-tag { color: var(--price-red); font-weight: bold; font-size: 16px; }
        .tracking-code { background: #e8f5e9; color: var(--primary-green); padding: 5px 10px; border-radius: 6px; font-family: monospace; font-weight: bold; font-size: 14px; letter-spacing: 0.5px; }

        /* STATUS BADGES */
        .status-badge { font-weight: bold; font-size: 12px; padding: 6px 12px; border-radius: 20px; display: inline-block; text-transform: uppercase; letter-spacing: 0.5px; }
        .status-completed { background: #e8f5e9; color: #2e7d32; } /* Green */
        .status-refunded { background: #ffebee; color: #c62828; } /* Red */
        .status-pending { background: #fff3e0; color: #ef6c00; } /* Orange */
        .status-default { background: #f5f5f5; color: #777; }

        /* BUTTONS */
        .btn { padding: 8px 16px; text-decoration: none; border-radius: 6px; font-size: 13px; font-weight: 600; cursor: pointer; border: none; display: inline-flex; align-items: center; justify-content: center; gap: 6px; transition: all 0.2s ease; margin-right: 5px; }

        /* Improved Green Button for Receipt */
        .btn-green {
            background: linear-gradient(135deg, #66bb6a, #43a047);
            color: white;
            box-shadow: 0 2px 5px rgba(76, 175, 80, 0.3);
        }
        .btn-green:hover {
            background: linear-gradient(135deg, #43a047, #2e7d32);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(76, 175, 80, 0.4);
        }

        .btn-blue { background-color: #1976D2; color: white; }
        .btn-blue:hover { background-color: #1565C0; }

        .btn-outline { border: 1px solid #ddd; color: #555; background: white; }
        .btn-outline:hover { border-color: #999; color: #333; background: #f8f8f8; }

        .btn-red { background-color: white; border: 1px solid var(--price-red); color: var(--price-red); }
        .btn-red:hover { background-color: var(--price-red); color: white; box-shadow: 0 4px 6px rgba(211, 47, 47, 0.2); }

        .back-link { display: inline-block; margin-top: 20px; text-decoration: none; color: #777; font-weight: 500; }
        .back-link:hover { color: var(--primary-green); }

        /*  MODAL STYLES (Kept for Return Reason)  */
        .modal {
            display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%;
            overflow: hidden; background-color: rgba(0,0,0,0.5); backdrop-filter: blur(3px);
            align-items: center; justify-content: center;
        }
        .modal.show { display: flex; }

        .modal-content {
            background-color: #fff; padding: 0; border-radius: 12px; box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            width: 90%; max-width: 500px; animation: slideDown 0.3s ease-out; display: flex; flex-direction: column;
        }

        @keyframes slideDown { from { transform: translateY(-30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .modal-header { padding: 20px; border-bottom: 1px solid #f0f0f0; display: flex; justify-content: space-between; align-items: center; background: #fcfcfc; border-top-left-radius: 12px; border-top-right-radius: 12px;}
        .modal-header h3 { margin: 0; color: #333; font-size: 18px; }
        .close-btn { font-size: 24px; color: #aaa; cursor: pointer; line-height: 1; }
        .close-btn:hover { color: #333; }

        .modal-body { padding: 25px; }
        .modal-body p { margin-top: 0; color: #666; font-size: 14px; margin-bottom: 15px; }

        textarea {
            width: 100%; height: 120px; padding: 15px; border: 1px solid #ddd; border-radius: 8px;
            font-family: inherit; font-size: 14px; resize: vertical; box-sizing: border-box; background: #fafafa;
            transition: 0.2s;
        }
        textarea:focus { outline: none; border-color: var(--primary-green); background: white; box-shadow: 0 0 0 4px rgba(85, 139, 47, 0.1); }

        .modal-footer { padding: 20px; border-top: 1px solid #f0f0f0; text-align: right; background: #fcfcfc; border-bottom-left-radius: 12px; border-bottom-right-radius: 12px;}
    </style>

    <script>
        let currentReturnOrderId = null;

        //  Return Reason Modal Functions
        function openReturnModal(orderId) {
            currentReturnOrderId = orderId;
            document.getElementById("returnModal").classList.add("show");
            document.getElementById("returnReason").value = "";
            document.getElementById("returnReason").focus();
        }

        function closeReturnModal() {
            document.getElementById("returnModal").classList.remove("show");
            currentReturnOrderId = null;
        }

        function submitReturn() {
            const reason = document.getElementById("returnReason").value;
            if (reason.trim() === "") {
                Swal.fire('Error', 'Please enter a reason for the return.', 'error');
                return;
            }
            if (currentReturnOrderId) {
                window.location.href = "orders?action=return&orderId=" + currentReturnOrderId + "&reason=" + encodeURIComponent(reason);
            }
        }

        //  NEW: Confirm Receipt Function with SweetAlert2
        function confirmReceipt(orderId) {
            Swal.fire({
                title: 'Received your Order?',
                text: "Only confirm if you have received the correct items in good condition.",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#43a047', // Green
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, Confirm Receipt',
                cancelButtonText: 'Not yet'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = "orders?action=receive&orderId=" + orderId;
                }
            });
        }

        window.onclick = function(event) {
            const modal = document.getElementById("returnModal");
            if (event.target === modal) {
                closeReturnModal();
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
                <% } else { %> <span style="color:#ccc; font-size:12px; font-weight:bold;">PENDING</span> <% } %>
            </td>

            <td>
                <% if ("Completed".equals(status)) { %>
                <span class="status-badge status-completed">Completed</span>
                <% } else if ("Refunded".equals(status)) { %>
                <span class="status-badge status-refunded">Returned</span>
                <% } else if ("To Receive".equals(status)) { %>
                <span class="status-badge status-pending">Shipped</span>
                <% } else { %>
                <span class="status-badge status-default"><%= status %></span>
                <% } %>
            </td>

            <td>
                <% if ("To Receive".equals(status)) { %>
                <button class="btn btn-green" onclick="confirmReceipt(<%= orderId %>)">
                    &#10003; Order Received
                </button>
                <% } %>

                <% if ("Completed".equals(status)) { %>
                <button class="btn btn-red" onclick="openReturnModal(<%= orderId %>)">Return Item</button>
                <% } %>

                <% if ("Return Requested".equals(status)) { %>
                <span style="color:#ef6c00; font-size:12px; font-weight:bold;">Processing Return</span>
                <% } %>

                <% if (!"To Receive".equals(status) && !"Completed".equals(status) && !"Return Requested".equals(status)) { %>
                <span style="color:#eee;">&mdash;</span>
                <% } %>
            </td>
        </tr>
        <% } %>

        <% if (!hasData) { %>
        <tr><td colspan="7" style="padding: 60px; text-align:center; color:#999; font-size: 16px;">No orders found in this category.</td></tr>
        <% } %>
    </table>
</div>

<div id="returnModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Request Return / Refund</h3>
            <span class="close-btn" onclick="closeReturnModal()">&times;</span>
        </div>
        <div class="modal-body">
            <p>We're sorry you're not satisfied with your purchase. Please tell us the reason for your return so we can improve:</p>
            <textarea id="returnReason" placeholder="Example: The item arrived damaged, wrong size, or not as described..."></textarea>
        </div>
        <div class="modal-footer">
            <button class="btn btn-outline" onclick="closeReturnModal()">Cancel</button>
            <button class="btn btn-red" onclick="submitReturn()">Submit Request</button>
        </div>
    </div>
</div>

</body>
</html>