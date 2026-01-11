<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.ResultSet" %>

<%
    Integer totalOrders = (Integer) request.getAttribute("totalOrders");
    Integer totalCustomers = (Integer) request.getAttribute("totalCustomers");
    Integer productCount = (Integer) request.getAttribute("productCount");
    Integer lowStockCount = (Integer) request.getAttribute("lowStockCount");
    ResultSet topSelling = (ResultSet) request.getAttribute("topSelling");

    if (totalOrders == null) totalOrders = 0;
    if (totalCustomers == null) totalCustomers = 0;
    if (productCount == null) productCount = 0;
    if (lowStockCount == null) lowStockCount = 0;
%>

<div class="cards">
    <div class="card">
        <h3>Total Orders</h3>
        <p><%= totalOrders %></p>
        <small>Orders in system</small>
    </div>

    <div class="card">
        <h3>Total Customers</h3>
        <p><%= totalCustomers %></p>
        <small>Registered users</small>
    </div>

    <div class="card">
        <h3>Product Count</h3>
        <p><%= productCount %></p>
        <small>Active products</small>
    </div>

    <div class="card">
        <h3>Low Stock Items</h3>
        <p><%= lowStockCount %></p>
        <small>Stock ≤ 5</small>
    </div>
</div>

<div class="section" style="margin-top:25px;">
    <h3 style="margin-top:0;">Top 4 Selling Items</h3>

    <div style="
        margin-top: 15px;
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 18px;
    ">
        <%
            int shown = 0;
            while (topSelling != null && topSelling.next()) {
                shown++;
                String name = topSelling.getString("name");
                String image = topSelling.getString("image");
                double price = topSelling.getDouble("price");
                int sold = topSelling.getInt("totalSold");

                if (image == null || image.trim().isEmpty()) {
                    image = "https://via.placeholder.com/300?text=No+Image";
                }
        %>

        <div style="
            background: white;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0,0,0,0.06);
            border: 1px solid #eee;
        ">
            <div style="height: 160px; background:#fff; display:flex; align-items:center; justify-content:center; padding:15px; border-bottom:1px solid #f1f5f9;">
                <img src="<%= image %>" alt="<%= name %>" style="max-height:100%; max-width:100%; object-fit:contain;">
            </div>

            <div style="padding:14px;">
                <div style="font-weight:700; font-size:14px; margin-bottom:8px; min-height:40px;">
                    <%= name %>
                </div>

                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <div style="font-weight:800;">RM <%= String.format("%.2f", price) %></div>
                    <div style="color:#16a34a; font-weight:700;">Sold: <%= sold %></div>
                </div>
            </div>
        </div>

        <%
            }
            if (shown == 0) {
        %>
        <div style="padding: 10px; color: #64748b;">
            No sales data yet.
        </div>
        <%
            }
        %>
    </div>
</div>
