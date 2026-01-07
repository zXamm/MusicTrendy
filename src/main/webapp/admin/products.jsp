<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp");
        return;
    }

    List<Product> products = (List<Product>) request.getAttribute("products");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin - Manage Products</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        table { width:100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border:1px solid #ccc; text-align:center; }
        th { background:#f5f5f5; }
        a { padding:6px 10px; border-radius:5px; text-decoration:none; color:white; }
        .add { background:green; }
        .edit { background:#0b5ed7; }
        .del { background:darkred; }
    </style>
</head>
<body>

<h2> Manage Products</h2>

<a class="add" href="<%= request.getContextPath() %>/admin/addProduct.jsp"> Add New Product</a>
<a class="edit"
   href="<%= request.getContextPath() %>/admin/dashboard.jsp"
   style="margin-left:10px;"> Back</a>


<table>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Category</th>
        <th>Price (RM)</th>
        <th>Stock</th>
        <th>Action</th>
    </tr>

    <% for(Product p : products) { %>
    <tr>
        <td><%= p.getProductId() %></td>
        <td><%= p.getName() %></td>
        <td><%= p.getCategory() %></td>
        <td><%= p.getPrice() %></td>
        <td><%= p.getQuantity() %></td>
        <td>
            <a class="edit" href="<%= request.getContextPath() %>/editProduct?id=<%= p.getProductId() %>">Edit</a>
            <a class="del"
               href="<%= request.getContextPath() %>/deleteProduct?id=<%= p.getProductId() %>"
               onclick="return confirm('Delete this product?')">Delete</a>

        </td>
    </tr>
    <% } %>
</table>

</body>
</html>
