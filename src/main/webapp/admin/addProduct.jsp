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
    <title>Add Product</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        form { max-width: 500px; }
        input, textarea { width:100%; padding:10px; margin:10px 0; }
        button { padding:10px 15px; background:green; color:white; border:none; border-radius:6px; cursor:pointer; }
        a { display:inline-block; margin-top:10px; padding:10px 15px; background:#333; color:white; text-decoration:none; border-radius:6px; }
    </style>
</head>
<body>

<h2> Add New Product</h2>

<form action="<%= request.getContextPath() %>/addProduct" method="post">
    <input type="text" name="name" placeholder="Product Name" required>
    <input type="text" name="category" placeholder="Category (Instrument/Accessory)" required>
    <textarea name="description" placeholder="Description" required></textarea>
    <input type="number" step="0.01" name="price" placeholder="Price" required>
    <input type="number" name="quantity" placeholder="Stock Quantity" required>
    <input type="text" name="image" placeholder="Image URL (optional)">
    <button type="submit"> Add Product</button>
</form>

<a href="../adminProducts"> Back</a>

</body>
</html>
