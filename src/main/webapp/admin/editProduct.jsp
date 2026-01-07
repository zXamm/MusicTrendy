<%@ page import="model.Product" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    Product p = (Product) request.getAttribute("product");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Product</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        form { max-width: 500px; }
        input, textarea { width:100%; padding:10px; margin:10px 0; }
        button { padding:10px 15px; background:#0b5ed7; color:white; border:none; border-radius:6px; cursor:pointer; }
        a { display:inline-block; margin-top:10px; padding:10px 15px; background:#333; color:white; text-decoration:none; border-radius:6px; }
    </style>
</head>
<body>

<h2> Edit Product</h2>

<form action="<%= request.getContextPath() %>/editProduct" method="post">
    <input type="hidden" name="productId" value="<%= p.getProductId() %>">

    <input type="text" name="name" value="<%= p.getName() %>" required>
    <input type="text" name="category" value="<%= p.getCategory() %>" required>
    <textarea name="description" required><%= p.getDescription() %></textarea>
    <input type="number" step="0.01" name="price" value="<%= p.getPrice() %>" required>
    <input type="number" name="quantity" value="<%= p.getQuantity() %>" required>
    <input type="text" name="image" value="<%= p.getImage() %>">

    <button type="submit"> Save Changes</button>
</form>

<a href="<%= request.getContextPath() %>/adminProducts"> Back</a>

</body>
</html>
