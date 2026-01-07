<%@ page import="model.Product" %>

<%
    Product p = (Product) request.getAttribute("product");
%>

<!DOCTYPE html>
<html>
<head>
    <title>MusicTrendy - Product Details</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .box { border: 1px solid #ccc; padding: 20px; border-radius: 10px; max-width: 600px; }
        .name { font-size: 26px; font-weight: bold; margin-bottom: 10px; }
        .price { font-size: 22px; color: green; margin: 10px 0; }
        .stock { margin: 10px 0; }
        .btn { display:inline-block; padding:10px 15px; background:#0b5ed7; color:white; text-decoration:none; border-radius:6px; margin-top: 15px; }
        .back { display:inline-block; padding:10px 15px; background:#333; color:white; text-decoration:none; border-radius:6px; margin-top: 15px; margin-right: 10px;}
    </style>
</head>

<body>

<!-- ✅ NAVBAR (same as products.jsp) -->
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
        <a href="products" style="color:white; text-decoration:none; margin-right:15px;">Products</a>
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

<% if (p != null) { %>
<div class="box">
    <div class="name"><%= p.getName() %></div>
    <div>Category: <%= p.getCategory() %></div>
    <div class="price">RM <%= p.getPrice() %></div>
    <div class="stock">
        Stock:
        <% if (p.getQuantity() > 0) { %>
         Available (<%= p.getQuantity() %>)
        <% } else { %>
         Out of Stock
        <% } %>
    </div>
    <p><%= p.getDescription() %></p>

    <% if (p.getQuantity() > 0) { %>
    <a class="btn" href="addToCart?productId=<%= p.getProductId() %>"> Add to Cart</a>
    <% } else { %>
    <p style="color:red; font-weight:bold;">This product is out of stock.</p>
    <% } %>

    <br/>
    <a class="back" href="products"> Back to Products</a>
</div>
<% } else { %>
<p>Product not found.</p>
<a class="back" href="products"> Back to Products</a>
<% } %>

</body>
</html>
