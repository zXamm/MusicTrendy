<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>

<%
    List<Product> products = (List<Product>) request.getAttribute("products");
%>

<style>
    .page-title{
        margin-top: 25px;
        display:flex;
        align-items:center;
        justify-content:space-between;
        gap:15px;
        flex-wrap:wrap;
    }
    .page-title h2{ margin:0; }

    .btn{
        display:inline-flex;
        align-items:center;
        gap:8px;
        padding:10px 14px;
        border-radius:10px;
        text-decoration:none;
        font-weight:600;
        color:white;
        border:none;
    }
    .btn-add{ background:#16a34a; }
    .btn-add:hover{ background:#15803d; }

    .product-grid{
        margin-top:18px;
        display:grid;
        grid-template-columns:repeat(auto-fit, minmax(230px, 1fr));
        gap:18px;
    }

    .product-card{
        background:white;
        border-radius:14px;
        overflow:hidden;
        box-shadow:0 8px 20px rgba(0,0,0,0.06);
        display:flex;
        flex-direction:column;
    }

    .product-img{
        height:200px;
        background:#fff;
        display:flex;
        align-items:center;
        justify-content:center;
        overflow:hidden;
        border-bottom:1px solid #eef2f7;
        padding:16px;
        position:relative;
    }
    .product-img img{
        width:100%;
        height:100%;
        object-fit:contain;
    }

    .badge-soldout{
        position:absolute;
        top:10px;
        right:10px;
        background:#64748b;
        color:white;
        padding:6px 10px;
        border-radius:999px;
        font-size:12px;
        font-weight:700;
    }

    .product-body{
        padding:14px 16px 16px;
        display:flex;
        flex-direction:column;
        gap:8px;
        flex:1;
        text-align:center;
    }

    .prod-cat{
        font-size:12px;
        letter-spacing:1px;
        color:#64748b;
        text-transform:uppercase;
    }
    .prod-name{
        font-weight:800;
        font-size:15px;
        color:#0f172a;
        line-height:1.2;
        min-height:38px;
    }
    .prod-price{
        font-weight:900;
        font-size:18px;
        color:#ef4444;
    }
    .prod-stock{
        font-size:13px;
        color:#334155;
    }

    .card-actions{
        margin-top:auto;
        display:flex;
        gap:10px;
    }
    .btn-small{
        flex:1;
        text-align:center;
        padding:10px 12px;
        border-radius:10px;
        text-decoration:none;
        font-weight:800;
        color:white;
    }
    .btn-edit{ background:#2563eb; }
    .btn-edit:hover{ background:#1d4ed8; }
    .btn-del{ background:#dc2626; }
    .btn-del:hover{ background:#b91c1c; }
</style>

<div class="page-title">
    <h2>Manage Products</h2>
    <a class="btn btn-add" href="<%= request.getContextPath() %>/admin/addProduct.jsp">
        Add New Product</a>
</div>

<div class="product-grid">
    <%
        if (products != null && !products.isEmpty()) {
            for (Product p : products) {
                boolean inStock = p.getQuantity() > 0;

                // ✅ SAME AS CATALOG: image comes from DB
                String imgUrl = (p.getImage() != null && !p.getImage().isEmpty())
                        ? p.getImage()
                        : "https://via.placeholder.com/300?text=No+Image";
    %>

    <div class="product-card">
        <div class="product-img">
            <img src="<%= imgUrl %>" alt="<%= p.getName() %>">
            <% if (!inStock) { %>
            <span class="badge-soldout">SOLD OUT</span>
            <% } %>
        </div>

        <div class="product-body">
            <div class="prod-cat"><%= p.getCategory() %></div>
            <div class="prod-name"><%= p.getName() %></div>

            <div class="prod-price">RM <%= String.format("%.2f", p.getPrice()) %></div>
            <div class="prod-stock">Stock: <b><%= p.getQuantity() %></b></div>

            <div class="card-actions">
                <a class="btn-small btn-edit"
                   href="<%= request.getContextPath() %>/editProduct?id=<%= p.getProductId() %>">Edit</a>

                <a class="btn-small btn-del"
                   href="<%= request.getContextPath() %>/deleteProduct?id=<%= p.getProductId() %>"
                   onclick="return confirm('Delete this product?')">Delete</a>
            </div>
        </div>
    </div>

    <%
        }
    } else {
    %>
    <div style="grid-column:1/-1; background:white; padding:20px; border-radius:14px; box-shadow:0 8px 20px rgba(0,0,0,0.06);">
        No products found.
    </div>
    <%
        }
    %>
</div>
