<%@ page import="java.util.*" %>

<%
    int orderId = (int) request.getAttribute("orderId");
    double total = (double) request.getAttribute("total");
    String status = (String) request.getAttribute("status");
    String date = (String) request.getAttribute("date");

    List<Map<String, Object>> items = (List<Map<String, Object>>) request.getAttribute("items");
%>

<!DOCTYPE html>
<html>
<head>
    <title>MusicTrendy - Receipt</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .box { max-width: 700px; margin:auto; border:1px solid #ccc; padding:20px; border-radius:10px; }
        table { width:100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 10px; border:1px solid #ddd; text-align:center; }
        th { background:#f5f5f5; }
        .total { font-size: 18px; font-weight:bold; margin-top: 15px; text-align:right; }
        .btn { display:inline-block; padding:10px 15px; background:#0b5ed7; color:white; text-decoration:none; border-radius:6px; margin-top: 15px;}
        @media print {
            .btn {
                display: none;
            }
        }
    </style>
</head>
<body>

<div class="box">
    <h2> Order Receipt</h2>
    <p><b>Order ID:</b> <%= orderId %></p>
    <p><b>Status:</b> <%= status %></p>
    <p><b>Date:</b> <%= date %></p>

    <h3>Items Purchased</h3>
    <table>
        <tr>
            <th>Product</th>
            <th>Unit Price (RM)</th>
            <th>Quantity</th>
            <th>Subtotal (RM)</th>
        </tr>

        <% for (Map<String, Object> row : items) { %>
        <tr>
            <td><%= row.get("name") %></td>
            <td><%= row.get("unitPrice") %></td>
            <td><%= row.get("qty") %></td>
            <td><%= row.get("subtotal") %></td>
        </tr>
        <% } %>
    </table>

    <div class="total">Total Paid: RM <%= total %></div>

    <a class="btn" href="products">Continue Shopping</a>
    <button class="btn" onclick="window.print()" style="background:green;">Print Receipt</button>

    <a class="btn" href="orders" style="background:#333;">My Orders</a>
</div>

</body>
</html>
