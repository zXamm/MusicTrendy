<%@ page import="java.sql.ResultSet" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    ResultSet orders = (ResultSet) request.getAttribute("orders");
    double totalSales = (double) request.getAttribute("totalSales");
    int totalOrders = (int) request.getAttribute("totalOrders");
    ResultSet bestProduct = (ResultSet) request.getAttribute("bestProduct");

    String bestName = "N/A";
    int bestSold = 0;
    if (bestProduct != null && bestProduct.next()) {
        bestName = bestProduct.getString("name");
        bestSold = bestProduct.getInt("totalSold");
    }
%>

<!-- ✅ Page Title -->
<div style="margin-top: 25px;">
    <h2 style="margin: 0 0 15px;">Admin Orders & Sales Dashboard</h2>

    <!-- ✅ Cards -->
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

    <!-- ✅ Orders Table Section -->
    <div class="section" style="margin-top: 25px;">
        <h3 style="margin-top:0;">All Customer Orders</h3>

        <table class="styled-table">
            <tr>
                <th>Order ID</th>
                <th>Customer</th>
                <th>Total (RM)</th>
                <th>Status</th>
                <th>Date</th>
                <th>Action</th>
            </tr>

            <%
                while (orders != null && orders.next()) {
                    int orderId = orders.getInt("order_id");
                    String customer = orders.getString("customer_name");
                    double total = orders.getDouble("total_amount");
                    String status = orders.getString("status");
                    String date = orders.getString("created_at");
            %>
            <tr>
                <td><%= orderId %></td>
                <td><%= customer %></td>
                <td><%= String.format("%.2f", total) %></td>
                <td><%= status %></td>
                <td><%= date %></td>
                <td>
                    <a class="btn-view"
                       href="<%= request.getContextPath() %>/adminOrderDetails?orderId=<%= orderId %>">
                        View
                    </a>
                </td>
            </tr>
            <% } %>

        </table>
    </div>
</div>
