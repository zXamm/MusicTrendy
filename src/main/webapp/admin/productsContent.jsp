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

<div style="margin-top:25px;">

    <h2 style="margin:0 0 15px;">Manage Products</h2>

    <!-- ✅ Buttons -->
    <div style="display:flex; gap:12px; margin-bottom:20px;">
        <a class="btn-view" style="background:#16a34a;"
           href="<%= request.getContextPath() %>/admin/addProduct.jsp">
             Add New Product
        </a>

        <a class="btn-view" style="background:#2563eb;"
           href="<%= request.getContextPath() %>/admin/adminLayout.jsp?page=dashboardContent.jsp">
             Back
        </a>
    </div>

    <!-- ✅ Table -->
    <div class="section">
        <table class="styled-table">
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
                <td><%= String.format("%.2f", p.getPrice()) %></td>
                <td><%= p.getQuantity() %></td>
                <td>
                    <a class="btn-view"
                       href="<%= request.getContextPath() %>/editProduct?id=<%= p.getProductId() %>">
                        Edit
                    </a>

                    <a class="btn-view" style="background:#dc2626;"
                       href="<%= request.getContextPath() %>/deleteProduct?id=<%= p.getProductId() %>"
                       onclick="return confirm('Delete this product?')">
                        Delete
                    </a>
                </td>
            </tr>
            <% } %>

        </table>
    </div>

</div>
