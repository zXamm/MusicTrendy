<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
%>

<!DOCTYPE html>
<html>
<head>
    <title>MusicTrendy - Products</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .product { border: 1px solid #ccc; padding: 15px; margin: 10px; width: 250px; display:inline-block; vertical-align: top; }
        .title { font-weight: bold; font-size: 18px; }
        .price { color: green; font-size: 16px; margin-top: 5px; }
        .btn { display:inline-block; margin-top:10px; padding:8px 12px; background:#222; color:#fff; text-decoration:none; border-radius:5px; }
    </style>
</head>
<body>

<div style="
    display:flex;
    justify-content:space-between;
    align-items:center;
    background:#222;
    padding:15px;
    border-radius:8px;
    margin-bottom:20px;
">
    <div style="color:white; font-size:20px; font-weight:bold;">
         MusicTrendy
    </div>

    <div>
        <a href="index.jsp" style="color:yellowgreen; text-decoration:none; margin-right:15px;">Home</a>
        <a href="products" style="color:white; text-decoration:none; margin-right:15px;">Products</a>
        <a href="orders" style="color:white; text-decoration:none; margin-right:15px;">My Orders</a>
        <a href="cart" style="
            background:#0b5ed7;
            padding:8px 12px;
            border-radius:6px;
            color:white;
            text-decoration:none;
        ">
             Cart
        </a>

    </div>
</div>


<h1>MusicTrendy Products</h1>

<% if (products != null && !products.isEmpty()) { %>
<% for(Product p : products) { %>
<div class="product">
    <div class="title"><%= p.getName() %></div>
    <div>Category: <%= p.getCategory() %></div>
    <div class="price">RM <%= p.getPrice() %></div>
    <div>Stock: <%= p.getQuantity() %></div>
    <a class="btn" href="productDetails?id=<%= p.getProductId() %>">View Details</a>
    <a class="btn" href="addToCart?productId=<%= p.getProductId() %>">Add to Cart</a>

</div>
<% } %>
<% } else { %>
<p>No products found.</p>
<% } %>

</body>
</html>
