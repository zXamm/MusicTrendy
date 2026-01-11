<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="dao.ProductDAO" %>
<%@ page import="dao.CartDAO" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.User" %>

<%
    // --- BACKEND LOGIC ---
    ProductDAO dao = new ProductDAO();
    List<Product> productList = null;
    try {
        productList = dao.getAllProducts();
        if (productList != null && productList.size() > 8) {
            productList = productList.subList(0, 8);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // --- SIDEBAR CART DATA ---
    List<CartItem> sidebarItems = null;
    double sidebarTotal = 0.0;
    User sidebarUser = (User) session.getAttribute("user");
    if (sidebarUser != null) {
        CartDAO cartDao = new CartDAO();
        sidebarItems = cartDao.getCartItems(sidebarUser.getUserId());
        if (sidebarItems != null) {
            for (CartItem item : sidebarItems) {
                sidebarTotal += item.getSubtotal();
            }
        }
    }

    // --- POPUP FIX: Capture and Clear Immediately ---
    String popupType = (String) session.getAttribute("popup_type");
    String popupMessage = (String) session.getAttribute("popup_message");
    if (popupType != null) {
        session.removeAttribute("popup_type");
        session.removeAttribute("popup_message");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MusicTrendy | Premium Instruments Store</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root { --zoso-green: #4c8a2c; --zoso-hover: #3e7024; --price-red: #d9534f; --text-dark: #333; }
        .main-header, .nav-strip, .product-card, .features-section { background-color: rgba(255, 255, 255, 0.95) !important; backdrop-filter: blur(5px); }

        /* Sidebar Styles */
        .cart-item-row { border-bottom: 1px solid #f0f0f0; padding: 12px 0; }
        .cart-total-box { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: auto; }
        .qty-btn { width: 24px; height: 24px; padding: 0; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; border-radius: 4px; background: #eee; border: none; transition: 0.2s; }
        .qty-btn:hover { background: #ddd; }

        /* General */
        footer { background-color: #222 !important; color: #fff !important; }
        .header-icon-btn { width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; border-radius: 50%; background-color: #222; color: white; transition: 0.2s; font-size: 1.1rem; cursor: pointer; border: none; text-decoration: none; }
        .header-icon-btn:hover { background-color: var(--zoso-green); color: white; transform: translateY(-2px); }
        .logo-container img { max-height: 120px; width: auto; transition: transform 0.3s; }
        .logo-container:hover img { transform: scale(1.05); }
        .nav-strip a { font-weight: 700; font-size: 0.85rem; text-transform: uppercase; color: #333; padding: 12px 20px; display: inline-block; text-decoration: none; }
        .nav-strip a:hover { color: var(--zoso-green); }
        .product-card { border: none; box-shadow: 0 2px 15px rgba(0,0,0,0.05); transition: all 0.3s ease; height: 100%; border-radius: 8px; overflow: hidden; display: flex; flex-direction: column; background: #fff; }
        .product-card:hover { transform: translateY(-8px); box-shadow: 0 15px 30px rgba(0,0,0,0.15); }
        .card-img-container { height: 180px; padding: 25px; display: flex; align-items: center; justify-content: center; border-bottom: 1px solid #f0f0f0; }
        .card-img-container img { max-height: 100%; max-width: 100%; object-fit: contain; transition: transform 0.4s ease; }
        .product-card:hover .card-img-container img { transform: scale(1.1); }
        .btn-add-cart { width: 100%; background-color: var(--zoso-green); color: white; font-weight: 600; border: none; padding: 10px; text-transform: uppercase; font-size: 0.8rem; border-radius: 4px; transition: 0.2s; }
        .btn-add-cart:hover { background-color: var(--zoso-hover); }
        a { text-decoration: none; color: inherit; transition: 0.3s; }
        .category-item { display: flex; flex-direction: column; align-items: center; width: 100px; text-decoration: none; cursor: pointer; }
        .category-item img { height: 80px; object-fit: contain; margin-bottom: 15px; }
        .category-item:hover { transform: translateY(-10px); }
        .brand-item { width: 120px; height: 60px; opacity: 0.6; filter: grayscale(100%); transition: 0.3s; }
        .brand-item:hover { transform: scale(1.1); opacity: 1; filter: grayscale(0%); }
    </style>
</head>
<body>

<div class="top-notification-bar" style="background:#222; color:#fff; text-align:center; padding:8px 0; font-size:0.8rem;">
    Welcome to MusicTrendy - Your #1 Music Store. WhatsApp Hotline: +60 19-563 2050
</div>

<header class="main-header" style="padding:10px 0; position:relative; z-index:5;">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-3 text-center text-md-start">
                <a href="index.jsp" class="logo-container">
                    <img src="images/MusicTrendyLogo.png" alt="MusicTrendy Logo" class="img-fluid">
                </a>
            </div>

            <div class="col-md-6 my-3 my-md-0">
                <form action="products" method="get" class="d-flex w-100">
                    <div class="input-group w-100">
                        <input type="text" name="search" class="form-control rounded-start-pill" placeholder="Search item..." style="background:#f9f9f9; border:1px solid #ddd; padding-left:20px;">
                        <button class="btn rounded-end-pill" type="submit" style="background-color: var(--zoso-green); color: white; padding: 0 25px;"><i class="fas fa-search"></i></button>
                    </div>
                </form>
            </div>

            <div class="col-md-3 text-center text-md-end">
                <div class="d-flex justify-content-center justify-content-md-end gap-3 align-items-center">
                    <div class="text-end d-none d-lg-block lh-1">
                        <small class="text-muted" style="font-size:0.7rem">Need Help?</small><br>
                        <span style="font-weight:700; font-size:0.9rem">+6012-3456789</span>
                    </div>
                    <div class="d-flex gap-2">
                        <% if (session.getAttribute("user") == null) { %>
                        <a href="login.jsp" title="Login" class="header-icon-btn"><i class="fas fa-user"></i></a>
                        <% } else { %>
                        <a href="logout" title="Logout" class="header-icon-btn"><i class="fas fa-sign-out-alt"></i></a>
                        <% } %>

                        <button class="header-icon-btn position-relative" type="button" data-bs-toggle="offcanvas" data-bs-target="#cartSidebar" aria-controls="cartSidebar">
                            <i class="fas fa-shopping-bag"></i>
                            <% if (sidebarItems != null && !sidebarItems.isEmpty()) { %>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:0.6rem;">
                                    <%= sidebarItems.size() %>
                                </span>
                            <% } %>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<nav class="nav-strip sticky-top" style="background:#fff; border-bottom:1px solid #e5e5e5; box-shadow:0 2px 5px rgba(0,0,0,0.02);">
    <div class="container text-center">
        <a href="index.jsp" style="color: var(--zoso-green);">Home</a>
        <a href="products">Shop Catalog</a>
        <a href="orders">My Orders</a>
        <a href="about.jsp">About Us</a>
    </div>
</nav>

<section class="hero-section" style="position: relative; padding: 0; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
    <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="3000">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="images/Carousel1.jpg" class="d-block w-100 hero-img" style="height: 380px; object-fit: cover; filter: brightness(0.85);" alt="Guitar">
            </div>
            <div class="carousel-item">
                <img src="images/Carousel3.png" class="d-block w-100 hero-img" style="height: 380px; object-fit: cover; filter: brightness(0.85);" alt="Drums">
            </div>
            <div class="carousel-item">
                <img src="images/Carousel2.png" class="d-block w-100 hero-img" style="height: 380px; object-fit: cover; filter: brightness(0.85);" alt="Piano">
            </div>
        </div>
    </div>
</section>

<section style="padding: 40px 0; text-align: center; background: #fff; border-bottom: 1px solid #e5e5e5;">
    <div class="container">
        <h2 style="color: var(--zoso-green); font-weight: 800; letter-spacing: 2px; text-transform: uppercase;">SHOP BY CATEGORY</h2>
        <div style="display: flex; justify-content: center; flex-wrap: wrap; gap: 40px; margin-top: 30px;">
            <a href="products?category=guitars" class="category-item"><img src="images/guitar1.png" alt="Guitars"><span>Guitars</span></a>
            <a href="products?category=drums" class="category-item"><img src="images/drum1.png" alt="Drums"><span>Drums</span></a>
            <a href="products?category=keyboards" class="category-item"><img src="images/keyboard1.png" alt="Keyboards"><span>Keyboards</span></a>
        </div>
    </div>
</section>

<div class="container my-5">
    <div class="section-header text-center mb-4">
        <h2 style="color:var(--zoso-green); font-weight:800; text-transform:uppercase;">Featured Collection</h2>
    </div>
    <div class="row g-4">
        <% if (productList != null && !productList.isEmpty()) {
            for(Product p : productList) { %>
        <div class="col-6 col-md-4 col-lg-3">
            <div class="product-card">
                <a href="productDetails?id=<%= p.getProductId() %>">
                    <div class="card-img-container">
                        <img src="<%= (p.getImage() != null && !p.getImage().isEmpty()) ? p.getImage() : "https://via.placeholder.com/300" %>" alt="<%= p.getName() %>">
                    </div>
                </a>
                <div class="p-3 text-center">
                    <div class="fw-bold mb-1"><%= p.getName() %></div>
                    <div class="text-danger fw-bold mb-2">RM <%= String.format("%.2f", p.getPrice()) %></div>
                    <form action="addToCart" method="post">
                        <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                        <button type="submit" class="btn-add-cart">Add To Cart</button>
                    </form>
                </div>
            </div>
        </div>
        <% } } %>
    </div>
</div>

<div class="offcanvas offcanvas-end" tabindex="-1" id="cartSidebar" aria-labelledby="cartSidebarLabel">
    <div class="offcanvas-header bg-light">
        <h5 class="offcanvas-title fw-bold text-uppercase" id="cartSidebarLabel" style="color: var(--zoso-green);">Your Cart</h5>
        <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body d-flex flex-column">

        <% if (session.getAttribute("user") == null) { %>
        <div class="text-center py-5">
            <i class="fas fa-user-lock fa-3x text-muted mb-3"></i>
            <p>Please login to view your cart.</p>
            <a href="login.jsp" class="btn btn-dark w-100">Login</a>
        </div>
        <% } else if (sidebarItems == null || sidebarItems.isEmpty()) { %>
        <div class="text-center py-5 flex-grow-1">
            <i class="fas fa-shopping-basket fa-3x text-muted mb-3"></i>
            <p class="text-muted">Your cart is empty.</p>
            <a href="products" class="btn btn-outline-success w-100">Start Shopping</a>
        </div>
        <% } else { %>
        <div class="flex-grow-1 overflow-auto pe-2">
            <% for (CartItem item : sidebarItems) { %>
            <div class="cart-item-row d-flex align-items-center justify-content-between">
                <div class="d-flex align-items-center" style="flex: 1; min-width: 0;">
                    <div class="me-2 text-muted"><i class="fas fa-music"></i></div>
                    <div style="flex: 1; min-width: 0;">
                        <div class="fw-bold small text-truncate"><%= item.getProductName() %></div>

                        <form action="updateCart" method="post" class="d-flex align-items-center mt-2">
                            <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                            <button type="submit" name="quantity" value="<%= item.getQuantity() - 1 %>" class="qty-btn" <%= item.getQuantity() <= 1 ? "disabled" : "" %>><i class="fas fa-minus"></i></button>
                            <span class="mx-2 small fw-bold" style="min-width:20px; text-align:center;"><%= item.getQuantity() %></span>
                            <button type="submit" name="quantity" value="<%= item.getQuantity() + 1 %>" class="qty-btn"><i class="fas fa-plus"></i></button>
                        </form>
                    </div>
                </div>

                <div class="text-end ms-2">
                    <div class="fw-bold text-dark small mb-2">RM <%= String.format("%.2f", item.getSubtotal()) %></div>
                    <a href="removeItem?cartItemId=<%= item.getCartItemId() %>" class="text-danger small text-decoration-none" title="Remove Item"><i class="fas fa-trash-alt me-1"></i> Remove</a>
                </div>
            </div>
            <% } %>
        </div>

        <div class="cart-total-box mt-3">
            <div class="d-flex justify-content-between mb-3">
                <span class="text-muted">Subtotal:</span>
                <span class="fw-bold">RM <%= String.format("%.2f", sidebarTotal) %></span>
            </div>
            <div class="d-grid">
                <a href="buyerInfo.jsp" class="btn btn-success fw-bold py-2">
                    CHECKOUT <i class="fas fa-arrow-right ms-2"></i>
                </a>
            </div>
        </div>
        <% } %>

    </div>
</div>

<footer class="mt-5 pt-5 pb-3 bg-dark text-white">
    <div class="container text-center">
        <p>&copy; 2026 MusicTrendy. All Rights Reserved.</p>
    </div>
</footer>



<% if (popupType != null) { %>
<script>
    Swal.fire({
        icon: '<%= popupType %>',
        title: 'Success!',
        text: '<%= popupMessage %>',
        showConfirmButton: false,
        timer: 2000,
        timerProgressBar: true,
        background: '#fff',
        iconColor: '#4c8a2c',
        toast: true,
        position: 'top-end'
    });
</script>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>