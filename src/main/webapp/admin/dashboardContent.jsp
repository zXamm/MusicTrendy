<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String username = (String) session.getAttribute("username");
    if(username == null) username = "Admin";
%>

<!-- ✅ Cards -->
<div class="cards">
    <div class="card">
        <h3>Total Revenue</h3>
        <p>RM 5,320</p>
        <small>+12% this month</small>
    </div>

    <div class="card">
        <h3>Total Orders</h3>
        <p>124</p>
        <small>+8% this month</small>
    </div>

    <div class="card">
        <h3>Total Customers</h3>
        <p>67</p>
        <small>+5% this month</small>
    </div>

    <div class="card">
        <h3>Pending Delivery</h3>
        <p>11</p>
        <small>Need action</small>
    </div>
</div>

<!-- ✅ Section Example -->
<div class="section">
    <h3>Top Selling Products</h3>
    <p>✅ Later we can show product cards like the screenshot.</p>
</div>
