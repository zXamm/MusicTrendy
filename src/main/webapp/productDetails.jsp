<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Product" %>
<%
    Product p = (Product) request.getAttribute("product");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (p != null) ? p.getName() : "Product Not Found" %> | MusicTrendy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* --- SHARED THEME (Matches products.jsp) --- */
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
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        a { text-decoration: none; color: inherit; transition: 0.3s; }

        /* --- HEADER STYLES --- */
        .top-notification-bar { background-color: #222; color: #fff; text-align: center; font-size: 0.8rem; padding: 8px 0; letter-spacing: 0.5px; }
        .main-header { padding: 15px 0; background-color: #fff; border-bottom: 1px solid var(--border-light); }
        .logo-container img { max-height: 120px; width: auto; transition: transform 0.3s; }
        .logo-container:hover img { transform: scale(1.05); }

        .search-group input { border-radius: 50px 0 0 50px; border: 1px solid #ddd; padding: 12px 20px; background: #f9f9f9; }
        .search-group button { border-radius: 0 50px 50px 0; background-color: var(--zoso-green); color: white; border: none; padding: 0 30px; font-size: 1.2rem; }
        .search-group button:hover { background-color: var(--zoso-hover); }

        .header-icon-btn { width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; border-radius: 50%; background-color: #222; color: white; font-size: 1.1rem; }
        .header-icon-btn:hover { background-color: var(--zoso-green); color: white; transform: translateY(-2px); }

        /* --- NAV STRIP --- */
        .nav-strip { background: #fff; border-bottom: 1px solid var(--border-light); box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .nav-strip a { font-weight: 700; font-size: 0.85rem; text-transform: uppercase; color: #333; padding: 15px 25px; display: inline-block; }
        .nav-strip a:hover { color: var(--zoso-green); }

        /* --- PRODUCT DETAILS SPECIFIC --- */
        .product-container { background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); margin-top: 40px; margin-bottom: 40px; }
        .product-image-box { display: flex; align-items: center; justify-content: center; padding: 20px; border: 1px solid #f0f0f0; border-radius: 8px; height: 400px; }
        .product-image-box img { max-width: 100%; max-height: 100%; object-fit: contain; }

        .product-title { font-size: 2rem; font-weight: 800; margin-bottom: 10px; }
        .product-category { font-size: 0.9rem; text-transform: uppercase; color: #888; letter-spacing: 1px; margin-bottom: 20px; }
        .product-price { font-size: 2rem; color: var(--price-red); font-weight: 800; margin-bottom: 20px; }
        .stock-status { font-size: 0.9rem; font-weight: 600; margin-bottom: 20px; }
        .text-success { color: var(--zoso-green) !important; }
        .text-danger { color: var(--price-red) !important; }

        .description-box { margin-top: 30px; line-height: 1.8; color: #555; }

        .btn-add-cart-lg { background-color: var(--zoso-green); color: white; font-weight: 700; border: none; padding: 15px 40px; text-transform: uppercase; font-size: 1rem; border-radius: 6px; width: 100%; transition: 0.2s; }
        .btn-add-cart-lg:hover { background-color: var(--zoso-hover); color: white; }

        /* --- FOOTER --- */
        footer { background-color: #222; color: #fff; padding: 40px 0; border-top: 1px solid #444; margin-top: auto; }

        footer .text-muted {
            color: #bbb !important;
        }

        .footer-link { color: #bbb; font-size: 0.85rem; display: block; margin-bottom: 8px; }
        .footer-link:hover { color: var(--zoso-green); text-decoration: underline; }
    </style>
</head>
<body>

<div class="top-notification-bar">Welcome to MusicTrendy - Your #1 Music Store. WhatsApp Hotline: +60 19-563 2050</div>
<header class="main-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-3 text-center text-md-start">
                <a href="index.jsp" class="logo-container"><img src="images/MusicTrendyLogo.png" alt="MusicTrendy Logo" class="img-fluid"></a>
            </div>
            <div class="col-md-6 my-3 my-md-0">
                <form action="products" method="get" class="d-flex w-100">
                    <div class="input-group search-group w-100">
                        <input type="text" name="search" class="form-control" placeholder="Search item..." required>
                        <button class="btn" type="submit"><i class="fas fa-search"></i></button>
                    </div>
                </form>
            </div>
            <div class="col-md-3">
                <div class="d-flex justify-content-center justify-content-md-end align-items-center gap-3">
                    <div class="text-end d-none d-lg-block lh-sm"><small class="text-muted" style="font-size:0.7rem">Need Help?</small><br><span style="font-weight:700;font-size:0.9rem">+6012-3456789</span></div>
                    <div class="d-flex gap-2">
                        <% if (session.getAttribute("user") == null) { %>
                        <a href="login.jsp" title="Login" class="header-icon-btn"><i class="fas fa-user"></i></a>
                        <% } else { %>
                        <a href="logout" title="Logout" class="header-icon-btn"><i class="fas fa-sign-out-alt"></i></a>
                        <% } %>
                        <a href="cart" title="View Cart" class="header-icon-btn position-relative"><i class="fas fa-shopping-bag"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<nav class="nav-strip sticky-top">
    <div class="container text-center">
        <a href="index.jsp">Home</a>
        <a href="products" style="color: var(--zoso-green);">Shop Catalog</a>
        <a href="orders">My Orders</a>
        <a href="about.jsp">About Us</a>
    </div>
</nav>

<div class="container">
    <% if (p != null) { %>
    <nav aria-label="breadcrumb" class="mt-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
            <li class="breadcrumb-item"><a href="products">Products</a></li>
            <li class="breadcrumb-item active" aria-current="page"><%= p.getName() %></li>
        </ol>
    </nav>

    <div class="product-container">
        <div class="row">
            <div class="col-md-6 mb-4 mb-md-0">
                <div class="product-image-box">
                    <img src="<%= (p.getImage() != null && !p.getImage().isEmpty()) ? p.getImage() : "https://via.placeholder.com/500?text=No+Image" %>" alt="<%= p.getName() %>">
                </div>
            </div>

            <div class="col-md-6">
                <div class="product-category">Category: <%= p.getCategory() %></div>
                <h1 class="product-title"><%= p.getName() %></h1>
                <div class="product-price">RM <%= String.format("%.2f", p.getPrice()) %></div>

                <div class="stock-status">
                    <% if (p.getQuantity() > 0) { %>
                    <span class="text-success"><i class="fas fa-check-circle"></i> In Stock (<%= p.getQuantity() %> units)</span>
                    <% } else { %>
                    <span class="text-danger"><i class="fas fa-times-circle"></i> Out of Stock</span>
                    <% } %>
                </div>

                <p class="description-box"><%= p.getDescription() %></p>

                <hr class="my-4">

                <% if (p.getQuantity() > 0) { %>

                <div class="d-grid gap-3">
                    <form action="addToCart" method="post">
                        <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                        <input type="hidden" name="buyNow" value="true">
                        <button type="submit" class="btn btn-add-cart-lg w-100 shadow-sm">
                            <i class="fas fa-bolt me-2"></i> Buy Now
                        </button>
                    </form>

                    <form action="addToCart" method="post">
                        <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                        <button type="submit" class="btn btn-outline-success w-100 py-3 fw-bold text-uppercase"
                                style="border-color: var(--zoso-green); color: var(--zoso-green);">
                            <i class="fas fa-cart-plus me-2"></i> Add to Cart
                        </button>
                    </form>
                </div>

                <% } else { %>
                <button class="btn btn-secondary w-100 btn-lg" disabled>Sold Out</button>
                <% } %>

                <div class="mt-4 text-center">
                    <a href="products" class="text-muted"><i class="fas fa-arrow-left me-2"></i>Continue Shopping</a>
                </div>
            </div>
        </div>
    </div>
    <% } else { %>
    <div class="text-center py-5">
        <h2 class="text-danger">Product Not Found</h2>
        <p>The product you are looking for does not exist or has been removed.</p>
        <a href="products" class="btn btn-primary mt-3">Back to Shop</a>
    </div>
    <% } %>
</div>

<footer>
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h5 class="fw-bold mb-3">MUSIC TRENDY SDN BHD</h5>
                <p class="small text-muted">
                    MusicTrendy has been the epitome of music shops since its establishment in 2026.
                    We provide musical instruments, PA systems, and recording gear for beginners to pros.
                </p>
                <div class="mt-3">
                    <a href="https://www.facebook.com" target="_blank" style="color: #bbb; margin-right: 10px;"><i class="fab fa-facebook fa-lg"></i></a>
                    <a href="https://www.instagram.com" target="_blank" style="color: #bbb; margin-right: 10px;"><i class="fab fa-instagram fa-lg"></i></a>
                    <a href="https://www.youtube.com" target="_blank" style="color: #bbb; margin-right: 10px;"><i class="fab fa-youtube fa-lg"></i></a>
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
                <a href="policies.jsp#refund" class="footer-link">Refund Policy</a>
                <a href="policies.jsp#privacy" class="footer-link">Privacy Policy</a>
                <a href="policies.jsp#terms" class="footer-link">Terms & Conditions</a>
            </div>
            <div class="col-md-3 mb-4">
                <h5 class="fw-bold mb-3">Keep in Touch</h5>
                <form action="subscribe" method="post">
                    <div class="input-group">
                        <input type="email" name="email" class="form-control" placeholder="email@example.com" required>
                        <button class="btn" type="submit" style="background-color: var(--zoso-green); color: white;">
                            <i class="fas fa-check"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <hr>
        <div class="text-center small text-muted">
            &copy; 2026 MusicTrendy. All Rights Reserved.
        </div>
    </div>
</footer>

<%
    String popupType = (String) session.getAttribute("popup_type");
    String popupMessage = (String) session.getAttribute("popup_message");

    if (popupType != null) {
%>
<script>
    Swal.fire({
        icon: '<%= popupType %>',      // 'success', 'error', 'warning', etc.
        title: 'Success!',
        text: '<%= popupMessage %>',
        showConfirmButton: false,      // No button, just auto-close
        timer: 2000,                   // Auto close after 2 seconds
        timerProgressBar: true,
        background: '#fff',
        iconColor: '#4c8a2c'           // Matches your Zoso Green
    });
</script>
<%
        // Clear the message so it doesn't appear again on refresh
        session.removeAttribute("popup_type");
        session.removeAttribute("popup_message");
    }
%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>