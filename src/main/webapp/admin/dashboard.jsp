<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .box { padding:20px; border:1px solid #ccc; border-radius:10px; max-width:600px; }
        a { display:block; margin:10px 0; padding:10px; background:#0b5ed7; color:white; text-decoration:none; border-radius:6px; }
        .logout { background:darkred; }
    </style>
</head>
<body>

<div class="box">
    <h2> Admin Dashboard</h2>
    <p>Welcome, <b><%= user.getName() %></b></p>

    <a href="../adminProducts"> Manage Products</a>
    <a href="<%= request.getContextPath() %>/adminOrders"> View Orders & Sales</a>
    <a class="logout" href="../logout"> Logout</a>
</div>

</body>
</html>
