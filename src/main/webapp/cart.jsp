<%@ page import="java.util.List" %>
<%@ page import="model.CartItem" %>

<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    double total = (double) request.getAttribute("total");
%>

<!DOCTYPE html>
<html>
<head>
    <title>MusicTrendy - Cart</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border: 1px solid #ccc; text-align: center; }
        th { background-color: #f5f5f5; }
        .btn { padding: 8px 12px; border: none; background: #222; color: white; cursor: pointer; border-radius: 5px; }
        .remove { background: darkred; text-decoration: none; padding: 8px 12px; color: white; border-radius: 5px; }
        .total { margin-top: 20px; font-size: 18px; font-weight: bold; }
        .back { display:inline-block; margin-top:20px; padding: 8px 12px; background: #444; color: white; text-decoration:none; border-radius: 5px; }
    </style>
</head>
<body>

<h1> Your Cart</h1>

<% if (cartItems != null && !cartItems.isEmpty()) { %>

<table>
    <tr>
        <th>Product</th>
        <th>Price (RM)</th>
        <th>Quantity</th>
        <th>Subtotal (RM)</th>
        <th>Action</th>
    </tr>

    <% for (CartItem item : cartItems) { %>
    <tr>
        <td><%= item.getProductName() %></td>
        <td><%= item.getPrice() %></td>

        <td>
            <form action="updateCart" method="post">
                <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                <input type="number" name="quantity" min="1" value="<%= item.getQuantity() %>" style="width:60px;">
                <button class="btn" type="submit">Update</button>
            </form>
        </td>

        <td><%= item.getSubtotal() %></td>

        <td>
            <a class="remove" href="removeItem?cartItemId=<%= item.getCartItemId() %>">Remove</a>
        </td>
    </tr>
    <% } %>
</table>

<div class="total">Total: RM <%= total %></div>
<form action="checkout" method="post">
    <button class="btn" type="submit" style="margin-top:15px;background:green;"> Checkout</button>
</form>


<% } else { %>
<p>Your cart is empty.</p>
<% } %>

<a class="back" href="products"> Back to Products</a>

</body>
</html>
