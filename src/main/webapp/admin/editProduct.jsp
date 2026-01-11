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

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;800&display=swap" rel="stylesheet">

    <style>
        html, body { height: 100%; }

        body{
            margin:0;
            font-family:Poppins, sans-serif;

            /* ✅ same background image as login/add */
            background: url("<%=request.getContextPath()%>/images/sidebar.jpg") center/cover no-repeat fixed;

            display:flex;
            align-items:center;
            justify-content:center;
            padding: 28px;
            box-sizing: border-box;
            position: relative;
            color: #fff;
        }

        /* ✅ dark overlay */
        body::before{
            content:"";
            position:absolute;
            inset:0;
            background: rgba(0,0,0,0.55);
        }

        /* ✅ glass card */
        .glass-card{
            position: relative;
            z-index: 1;
            width: min(980px, 95vw);
            border-radius: 22px;
            padding: 34px 34px 26px;

            background: rgba(255,255,255,0.14);
            border: 1px solid rgba(255,255,255,0.22);
            box-shadow: 0 22px 60px rgba(0,0,0,0.35);

            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
        }

        .title{
            margin: 0 0 6px 0;
            font-size: 32px;
            font-weight: 800;
            letter-spacing: .2px;
        }

        .subtitle{
            margin: 0 0 22px 0;
            color: rgba(255,255,255,0.85);
            font-weight: 400;
            font-size: 14px;
        }

        .grid{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .span-2{ grid-column: span 2; }

        .field{
            display:flex;
            flex-direction:column;
            gap: 8px;
        }
        .field label{
            font-size: 13px;
            font-weight: 700;
            color: rgba(255,255,255,0.9);
        }

        /* ✅ transparent inputs */
        .field input, .field textarea{
            width: 100%;
            box-sizing: border-box;

            border-radius: 999px;
            padding: 14px 18px;
            border: 1px solid rgba(255,255,255,0.22);
            background: rgba(255,255,255,0.12);

            color: #fff;
            outline: none;
            font-size: 14px;

            transition: .15s;
        }

        .field textarea{
            border-radius: 18px;
            min-height: 120px;
            resize: vertical;
        }

        .field input::placeholder, .field textarea::placeholder{
            color: rgba(255,255,255,0.65);
        }

        /* ✅ orange focus */
        .field input:focus, .field textarea:focus{
            border-color: rgba(249,115,22,0.65);
            box-shadow: 0 0 0 4px rgba(249,115,22,0.18);
        }

        .hint{
            font-size: 12px;
            color: rgba(255,255,255,0.75);
            margin-top: -2px;
        }

        .actions{
            margin-top: 22px;
            display:flex;
            gap: 12px;
            justify-content:flex-end;
            flex-wrap: wrap;
        }

        .btnx{
            border: none;
            cursor: pointer;
            border-radius: 999px;
            padding: 14px 22px;
            font-weight: 800;
            font-size: 15px;
            text-decoration: none;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            min-width: 160px;
            transition: .15s;
        }

        .btn-back{
            background: rgba(255,255,255,0.18);
            color: #fff;
            border: 1px solid rgba(255,255,255,0.22);
        }
        .btn-back:hover{
            background: rgba(255,255,255,0.26);
            transform: translateY(-1px);
        }

        /* ✅ orangy main button */
        .btn-save{
            background: linear-gradient(135deg, #fb923c, #f97316, #ea580c);
            color: #111827;
        }
        .btn-save:hover{
            transform: translateY(-1px);
            filter: brightness(0.98);
        }

        @media (max-width: 900px){
            .grid{ grid-template-columns: 1fr; }
            .span-2{ grid-column: span 1; }
            .actions{ justify-content: stretch; }
            .btnx{ width: 100%; }
            .glass-card{ padding: 26px 18px 18px; }
            .title{ font-size: 26px; }
        }
    </style>
</head>

<body>

<div class="glass-card">
    <h1 class="title">Edit Product</h1>
    <p class="subtitle">Update product details for your MusicTrendy store.</p>

    <form action="<%= request.getContextPath() %>/editProduct" method="post">
        <input type="hidden" name="productId" value="<%= p.getProductId() %>">

        <div class="grid">
            <div class="field">
                <label>Product Name</label>
                <input type="text" name="name" value="<%= p.getName() %>" required>
            </div>

            <div class="field">
                <label>Category</label>
                <input type="text" name="category" value="<%= p.getCategory() %>" required>
            </div>

            <div class="field span-2">
                <label>Description</label>
                <textarea name="description" required><%= p.getDescription() %></textarea>
            </div>

            <div class="field">
                <label>Price (RM)</label>
                <input type="number" step="0.01" min="0" name="price" value="<%= p.getPrice() %>" required>
            </div>

            <div class="field">
                <label>Stock Quantity</label>
                <input type="number" min="0" name="quantity" value="<%= p.getQuantity() %>" required>
            </div>

            <div class="field span-2">
                <label>Image URL (optional)</label>
                <input type="text" name="image" value="<%= p.getImage() %>" placeholder="e.g. images/yamaha.png OR https://...">
                <div class="hint">Leave empty if no image. You can update later.</div>
            </div>
        </div>

        <div class="actions">
            <a class="btnx btn-back" href="<%= request.getContextPath() %>/adminProducts">Back</a>
            <button class="btnx btn-save" type="submit">Save Changes</button>
        </div>
    </form>
</div>

</body>
</html>
