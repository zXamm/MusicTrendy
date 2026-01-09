<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    //Retrieve data prepared by ReceiptServlet
    Integer orderId = (Integer) request.getAttribute("orderId");
    Double total = (Double) request.getAttribute("total");
    String status = (String) request.getAttribute("status");
    String date = (String) request.getAttribute("date");
    List<Map<String, Object>> items = (List<Map<String, Object>>) request.getAttribute("items");

    if (total == null) total = 0.0;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Invoice #<%= orderId %></title>
    <style>
        body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; background: #eee; padding: 20px; color: #555; }

        .invoice-box {
            max-width: 800px;
            margin: auto;
            padding: 30px;
            border: 1px solid #eee;
            background: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.15);
        }

        .header-table { width: 100%; margin-bottom: 20px; }
        .header-table td { padding: 5px; vertical-align: top; }

        .invoice-title { font-size: 40px; line-height: 40px; color: #333; font-weight: bold; }
        .company-info { text-align: right; }

        .items-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .items-table th { background: #eee; border-bottom: 1px solid #ddd; font-weight: bold; padding: 10px; text-align: left; }
        .items-table td { padding: 10px; border-bottom: 1px solid #eee; }
        .items-table tr.total td { border-top: 2px solid #333; font-weight: bold; font-size: 18px; color: #000; }

        .btn-container { text-align: center; margin-top: 30px; }
        .print-btn { background: #333; color: white; padding: 12px 25px; border: none; font-size: 16px; cursor: pointer; border-radius: 4px; }
        .print-btn:hover { background: #555; }
        .close-link { display: block; margin-top: 10px; color: #777; text-decoration: none; }

        /*Hides buttons when saving as PDF */
        @media print {
            body { background: white; margin: 0; padding: 0; }
            .invoice-box { box-shadow: none; border: none; width: 100%; max-width: 100%; padding: 0; }
            .btn-container { display: none; }
        }
    </style>
</head>
<body>

<% if (orderId != null) { %>

<div class="invoice-box">

    <table class="header-table">
        <tr>
            <td>
                <div class="invoice-title">INVOICE</div>
                <br>
                <strong>Order ID:</strong> #<%= orderId %><br>
                <strong>Date:</strong> <%= date %><br>
                <strong>Status:</strong> <%= status %>
            </td>
            <td class="company-info">
                <strong>MusicTrendy Inc.</strong><br>
                123 Music Lane<br>
                Georgetown, Penang<br>
                Malaysia, 10200<br>
                support@musictrendy.com
            </td>
        </tr>
    </table>

    <table class="items-table">
        <tr>
            <th>Item Description</th>
            <th style="text-align:center;">Qty</th>
            <th style="text-align:right;">Unit Price</th>
            <th style="text-align:right;">Total</th>
        </tr>

        <%
            if (items != null) {
                for (Map<String, Object> item : items) {
        %>
        <tr>
            <td><%= item.get("name") %></td>
            <td style="text-align:center;"><%= item.get("quantity") %></td>
            <td style="text-align:right;">RM <%= String.format("%.2f", item.get("unitPrice")) %></td>
            <td style="text-align:right;">RM <%= String.format("%.2f", item.get("subtotal")) %></td>
        </tr>
        <%
                }
            }
        %>

        <tr class="total">
            <td colspan="3" style="text-align:right;">Grand Total:</td>
            <td style="text-align:right;">RM <%= String.format("%.2f", total) %></td>
        </tr>
    </table>

    <div class="btn-container">
        <button class="print-btn" onclick="window.print()">Print / Save as PDF</button>
        <a href="javascript:window.close()" class="close-link">Close Window</a>
    </div>

</div>

<% } else { %>
<h3 style="text-align:center; color:red; margin-top:50px;">Order details not found.</h3>
<div style="text-align:center;"><a href="orders">Return to Orders</a></div>
<% } %>

</body>
</html>