<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>

<%
    // Retrieve product list from Servlet
    List<Product> products = (List<Product>) request.getAttribute("products");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop All | MusicTrendy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        /* --- SHARED THEME (Matches index.jsp) --- */
        :root {
            --zoso-green: #4c8a2c;
            --zoso-hover: #3e7024;
            --price-red: #d9534f;
            --text-dark: #333;
            --bg-light: #f3f5f2;
            --border-light: #e5e5e5;
        }

        body {
            font-family: 'Open Sans', sans-serif;
            color: var(--text-dark);
            background-color: var(--bg-light);
        }

        a { text-decoration: none; color: inherit; transition: 0.3s; }

        /* --- UTILITIES --- */
        .clean-container-style {
            background: #ffffff;
            border: 1px solid var(--border-light);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
        }

        /* --- HEADER --- */
        .top-notification-bar {
            background-color: #222;
            color: #fff;
            text-align: center;
            font-size: 0.8rem;
            padding: 8px 0;
            letter-spacing: 0.5px;
            position: relative;
            z-index: 10;
        }

        .main-header {
            padding: 15px 0;
            position: relative;
            z-index: 5;
            border-bottom: 1px solid var(--border-light);
            background-color: #fff;
        }

        .logo-container { display: flex; align-items: center; text-decoration: none !important; }
        .logo-container img { max-height: 120px; width: auto; transition: transform 0.3s; }
        .logo-container:hover img { transform: scale(1.05); }

        .search-group input { border-radius: 50px 0 0 50px; border: 1px solid #ddd; padding: 12px 20px; background: #f9f9f9; }
        .search-group button { border-radius: 0 50px 50px 0; background-color: var(--zoso-green); color: white; border: none; padding: 0 30px; font-size: 1.2rem; }
        .search-group button:hover { background-color: var(--zoso-hover); }

        .header-icon-btn {
            width: 45px; height: 45px; display: flex; align-items: center; justify-content: center;
            border-radius: 50%; background-color: #222; color: white; transition: 0.2s; font-size: 1.1rem;
        }
        .header-icon-btn:hover { background-color: var(--zoso-green); color: white; transform: translateY(-2px); }

        /* --- NAV --- */
        .nav-strip { background: #fff; border-bottom: 1px solid var(--border-light); box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .nav-strip a { font-weight: 700; font-size: 0.85rem; text-transform: uppercase; color: #333; padding: 15px 25px; display: inline-block; }
        .nav-strip a:hover { color: var(--zoso-green); background: rgba(0,0,0,0.02); }

        /* --- PRODUCT GRID --- */
        .page-header { text-align: center; margin: 50px 0 40px 0; }
        .page-header h2 {
            color: var(--zoso-green); font-weight: 800; text-transform: uppercase; letter-spacing: 2px;
            background: #fff; display: inline-block; padding: 10px 30px; border-radius: 50px; border: 1px solid var(--border-light);
        }

        .product-card {
            border: none; border-radius: 12px; overflow: hidden; transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%; display: flex; flex-direction: column;
        }
        .product-card:hover { transform: translateY(-8px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }

        .card-img-container {
            height: 220px; padding: 20px; display: flex; align-items: center; justify-content: center;
            background: #fff; border-bottom: 1px solid #f0f0f0; position: relative;
        }
        .card-img-container img { max-height: 100%; max-width: 100%; object-fit: contain; transition: transform 0.4s ease; }
        .product-card:hover .card-img-container img { transform: scale(1.1); }

        .card-details { padding: 20px; text-align: center; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; }

        .product-category { font-size: 0.75rem; text-transform: uppercase; color: #999; letter-spacing: 1px; margin-bottom: 5px; }
        .product-name { font-size: 0.95rem; font-weight: 700; color: #000; min-height: 45px; line-height: 1.4; margin-bottom: 10px; display: block; }
        .product-price { color: var(--price-red); font-weight: 800; font-size: 1.2rem; margin-bottom: 15px; }

        .btn-add-cart { width: 100%; background-color: var(--zoso-green); color: white; font-weight: 700; border: none; padding: 12px; text-transform: uppercase; font-size: 0.85rem; border-radius: 6px; transition: 0.2s; }
        .btn-add-cart:hover { background-color: var(--zoso-hover); }
        .btn-disabled { background-color: #ccc; cursor: not-allowed; }
        .btn-disabled:hover { background-color: #ccc; }

        /* --- FOOTER --- */
        footer { padding: 50px 0; margin-top: 80px; }
        .footer-link { color: #555; font-size: 0.9rem; display: block; margin-bottom: 10px; }
        .footer-link:hover { color: var(--zoso-green); text-decoration: underline; }
    </style>
</head>
<body>

<div class="top-notification-bar">
    Welcome to MusicTrendy - Your #1 Music Store. WhatsApp Hotline: +60 19-563 2050
</div>

<header class="main-header clean-container-style">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-3 text-center text-md-start">
                <a href="index.jsp" class="logo-container">
                    <img src="images/MusicTrendyLogo.png" alt="MusicTrendy Logo" class="img-fluid">
                </a>
            </div>
            <div class="col-md-6 my-3 my-md-0">
                <div class="input-group search-group">
                    <input type="text" class="form-control" placeholder="Search item...">
                    <button class="btn" type="button"><i class="fas fa-search"></i></button>
                </div>
            </div>
            <div class="col-md-3">
                <div class="d-flex justify-content-center justify-content-md-end align-items-center gap-3">
                    <div class="text-end d-none d-lg-block lh-sm">
                        <small class="text-muted" style="font-size: 0.7rem;">Need Help?</small><br>
                        <span style="font-weight: 700; font-size: 0.9rem; color: #000;">+6012-3456789</span>
                    </div>
                    <div class="d-flex gap-2">
                        <% if (session.getAttribute("user") == null) { %>
                        <a href="login.jsp" title="Login" class="header-icon-btn"><i class="fas fa-user"></i></a>
                        <% } else { %>
                        <a href="logout" title="Logout" class="header-icon-btn"><i class="fas fa-sign-out-alt"></i></a>
                        <% } %>
                        <a href="cart" title="View Cart" class="header-icon-btn position-relative">
                            <i class="fas fa-shopping-bag"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<nav class="nav-strip sticky-top">
    <div class="container text-center">
        <a href="index.jsp">Home</a>
        <a href="products" style="color: var(--zoso-green);">Shop by Category</a>
        <a href="products">Shop by Brands</a>
        <a href="orders">My Orders</a>
        <a href="#">About Us</a>
    </div>
</nav>

<div class="container">

    <div class="page-header">
        <h2>OUR CATALOG</h2>
        <p class="text-muted mt-2">EXPLORE THE FINEST COLLECTION OF MUSICAL INSTRUMENTS</p>
    </div>

    <div class="row g-4">
        <%
            if (products != null && !products.isEmpty()) {
                for(Product p : products) {
                    boolean inStock = p.getQuantity() > 0;
        %>
        <div class="col-6 col-md-4 col-lg-3">
            <div class="product-card clean-container-style">

                <a href="productDetails?id=<%= p.getProductId() %>">
                    <div class="card-img-container">
                        <img src="<%= (p.getImage() != null && !p.getImage().isEmpty()) ? p.getImage() : "https://via.placeholder.com/300?text=No+Image" %>"
                             alt="<%= p.getName() %>">

                        <% if (!inStock) { %>
                        <span class="badge bg-secondary position-absolute top-0 end-0 m-2">SOLD OUT</span>
                        <% } %>
                    </div>
                </a>

                <div class="card-details">
                    <div>
                        <div class="product-category"><%= p.getCategory() %></div>
                        <a href="productDetails?id=<%= p.getProductId() %>" class="product-name"><%= p.getName() %></a>
                        <div class="product-price">RM <%= String.format("%.2f", p.getPrice()) %></div>
                    </div>

                    <% if (inStock) { %>
                    <form action="addToCart" method="post">
                        <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                        <button type="submit" class="btn-add-cart">Add To Cart</button>
                    </form>
                    <% } else { %>
                    <button class="btn btn-add-cart btn-disabled" disabled>Sold Out</button>
                    <% } %>
                </div>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <div class="col-12 text-center py-5">
            <div class="alert alert-warning clean-container-style">
                <i class="fas fa-search me-2"></i> No products found in the catalog.
            </div>
        </div>
        <% } %>
    </div>
</div>

<footer class="clean-container-style">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h5 class="fw-bold mb-3">MUSIC TRENDY SDN BHD</h5>
                <p class="small text-muted">MusicTrendy has been the epitome of music shops since its establishment in 2026.</p>
                <div class="mt-3">
                    <i class="fab fa-facebook fa-lg me-2 text-muted"></i>
                    <i class="fab fa-instagram fa-lg me-2 text-muted"></i>
                    <i class="fab fa-youtube fa-lg text-muted"></i>
                </div>
            </div>
            <div class="col-md-2 mb-4">
                <h5 class="fw-bold mb-3">Shop</h5>
                <a href="#" class="footer-link">Guitars</a>
                <a href="#" class="footer-link">Drums</a>
                <a href="#" class="footer-link">Keyboards</a>
                <a href="#" class="footer-link">Audio</a>
            </div>
            <div class="col-md-3 mb-4">
                <h5 class="fw-bold mb-3">Store Policy</h5>
                <a href="#" class="footer-link">Refund Policy</a>
                <a href="#" class="footer-link">Privacy Policy</a>
                <a href="#" class="footer-link">Terms & Conditions</a>
            </div>
            <div class="col-md-3 mb-4">
                <h5 class="fw-bold mb-3">Keep in Touch</h5>
                <div class="input-group">
                    <input type="email" class="form-control" placeholder="email@example.com">
                    <button class="btn btn-outline-secondary" type="button">✔</button>
                </div>
            </div>
        </div>
        <hr>
        <div class="text-center small text-muted">&copy; 2026 MusicTrendy. All Rights Reserved.</div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>