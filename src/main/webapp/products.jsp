<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="dao.CartDAO" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.User" %>

<%
    //  1. EXISTING PRODUCT LOGIC
    List<Product> products = (List<Product>) request.getAttribute("products");

    //  2. NEW SIDEBAR CART LOGIC
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

    //  3. POPUP FIX (Clear message immediately)
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
    <title>Shop All | MusicTrendy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
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
        .clean-container-style {
            background: #ffffff;
            border: 1px solid var(--border-light);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
        }
        /* HEADER */
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
        .logo-container img { max-height: 120px; width: auto; transition: transform 0.3s; }
        .logo-container:hover img { transform: scale(1.05); }
        .search-group input { border-radius: 50px 0 0 50px; border: 1px solid #ddd; padding: 12px 20px; background: #f9f9f9; }
        .search-group button { border-radius: 0 50px 50px 0; background-color: var(--zoso-green); color: white; border: none; padding: 0 30px; font-size: 1.2rem; }
        .search-group button:hover { background-color: var(--zoso-hover); }

        .header-icon-btn {
            width: 45px;
            height: 45px; display: flex; align-items: center; justify-content: center;
            border-radius: 50%; background-color: #222; color: white; transition: 0.2s; font-size: 1.1rem; border: none; cursor: pointer;
        }
        .header-icon-btn:hover { background-color: var(--zoso-green); color: white; transform: translateY(-2px); }

        .nav-strip { background: #fff; border-bottom: 1px solid var(--border-light); box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .nav-strip a { font-weight: 700; font-size: 0.85rem; text-transform: uppercase; color: #333; padding: 15px 25px; display: inline-block; }
        .nav-strip a:hover { color: var(--zoso-green); background: rgba(0,0,0,0.02); }

        /* PRODUCT CARDS */
        .product-card {
            border: none;
            border-radius: 12px; overflow: hidden; transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%; display: flex; flex-direction: column; background: #fff;
        }
        .product-card:hover { transform: translateY(-8px); box-shadow: 0 15px 30px rgba(0,0,0,0.1); }
        .card-img-container {
            height: 220px;
            padding: 20px; display: flex; align-items: center; justify-content: center;
            background: #fff; border-bottom: 1px solid #f0f0f0; position: relative;
        }
        .card-img-container img { max-height: 100%; max-width: 100%; object-fit: contain; transition: transform 0.4s ease; }
        .product-card:hover .card-img-container img { transform: scale(1.1); }
        .card-details { padding: 20px; text-align: center; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .product-name { font-size: 0.95rem; font-weight: 700; color: #000; min-height: 45px; line-height: 1.4; margin-bottom: 10px; display: block; }
        .product-price { color: var(--price-red); font-weight: 800; font-size: 1.2rem; margin-bottom: 15px; }
        .btn-add-cart { width: 100%; background-color: var(--zoso-green); color: white; font-weight: 700; border: none; padding: 12px; text-transform: uppercase; font-size: 0.85rem; border-radius: 6px; transition: 0.2s; }
        .btn-add-cart:hover { background-color: var(--zoso-hover); }

        /* SIDEBAR / UTILS */
        .list-group-item { background: transparent; color: #555; transition: all 0.2s; }
        .list-group-item:hover { color: var(--zoso-green); transform: translateX(5px); }
        .list-group-item.text-success { color: var(--zoso-green) !important; }
        .brand-pill { transition: all 0.3s ease; opacity: 0.8; background-color: #fff; }
        .brand-pill:hover { opacity: 1; box-shadow: 0 4px 8px rgba(0,0,0,0.1); border-color: var(--zoso-green) !important; transform: translateY(-2px); }



        /*  NEW STYLES FOR SIDEBAR  */
        .cart-item-row { border-bottom: 1px solid #f0f0f0; padding: 12px 0; }
        .qty-btn { width: 24px; height: 24px; padding: 0; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; border-radius: 4px; background: #eee; border: none; }
        .qty-btn:hover { background: #ddd; }
        .cart-total-box { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: auto; }

        footer { background-color: #222 !important; color: #fff !important; padding: 40px 0; border-top: 1px solid #444; }
        footer .text-muted { color: #999 !important; }
        .footer-link { color: #bbb; font-size: 0.85rem; display: block; margin-bottom: 8px; }
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
                <form action="products" method="get" class="d-flex w-100">
                    <div class="input-group search-group w-100">
                        <input type="text" name="search" class="form-control" placeholder="Search item..." required>
                        <button class="btn" type="submit"><i class="fas fa-search"></i></button>
                    </div>
                </form>
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

<nav class="nav-strip sticky-top">
    <div class="container text-center">
        <a href="index.jsp">Home</a>
        <a href="products" style="color: var(--zoso-green);">Shop Catalog</a>
        <a href="orders">My Orders</a>
        <a href="about.jsp">About Us</a>
    </div>
</nav>

<div class="container my-5">
    <div class="row">
        <div class="col-lg-3 mb-4">
            <div class="clean-container-style p-4 rounded">
                <div class="mb-5">
                    <h5 class="fw-bold text-uppercase mb-3" style="color: var(--zoso-green); letter-spacing: 1px;">Categories</h5>
                    <div class="list-group list-group-flush">
                        <a href="products" class="list-group-item list-group-item-action border-0 px-0 <%= request.getParameter("category") == null && request.getParameter("brand") == null ? "fw-bold text-success" : "" %>"><i class="fas fa-th-large me-2"></i> All Products</a>
                        <a href="products?category=guitars" class="list-group-item list-group-item-action border-0 px-0 <%= "guitars".equals(request.getParameter("category")) ? "fw-bold text-success" : "" %>"><i class="fas fa-guitar me-2"></i> Guitars</a>
                        <a href="products?category=drums" class="list-group-item list-group-item-action border-0 px-0 <%= "drums".equals(request.getParameter("category")) ? "fw-bold text-success" : "" %>"><i class="fas fa-drum me-2"></i> Drums</a>
                        <a href="products?category=keyboards" class="list-group-item list-group-item-action border-0 px-0 <%= "keyboards".equals(request.getParameter("category")) ? "fw-bold text-success" : "" %>"><i class="fas fa-music me-2"></i> Keyboards</a>
                        <a href="products?category=amps" class="list-group-item list-group-item-action border-0 px-0 <%= "amps".equals(request.getParameter("category")) ? "fw-bold text-success" : "" %>"><i class="fas fa-plug me-2"></i> Amplifiers</a>
                        <a href="products?category=pedals" class="list-group-item list-group-item-action border-0 px-0 <%= "pedals".equals(request.getParameter("category")) ? "fw-bold text-success" : "" %>"><i class="fas fa-sliders-h me-2"></i> Pedals</a>
                        <a href="products?category=mics" class="list-group-item list-group-item-action border-0 px-0 <%= "mics".equals(request.getParameter("category")) ? "fw-bold text-success" : "" %>"><i class="fas fa-microphone-alt me-2"></i> Microphones</a>
                        <a href="products?category=headphones" class="list-group-item list-group-item-action border-0 px-0 <%= "headphones".equals(request.getParameter("category")) ? "fw-bold text-success" : "" %>"><i class="fas fa-headphones me-2"></i> Headphones</a>
                        <a href="products?category=audio" class="list-group-item list-group-item-action border-0 px-0 <%= "audio".equals(request.getParameter("category")) ? "fw-bold text-success" : "" %>"><i class="fas fa-wave-square me-2"></i> Audio Interface</a>
                    </div>
                </div>

                <div>
                    <h5 class="fw-bold text-uppercase mb-3" style="color: var(--zoso-green); letter-spacing: 1px;">Top Brands</h5>
                    <div class="row g-2">
                        <div class="col-6"><a href="products?brand=fender" class="brand-pill d-flex align-items-center justify-content-center p-2 border rounded text-decoration-none"><img src="images/fender1.png" alt="Fender" style="max-height: 25px; max-width: 100%;"></a></div>
                        <div class="col-6"><a href="products?brand=gibson" class="brand-pill d-flex align-items-center justify-content-center p-2 border rounded text-decoration-none"><img src="images/gibson1.png" alt="Gibson" style="max-height: 25px; max-width: 100%;"></a></div>
                        <div class="col-6"><a href="products?brand=yamaha" class="brand-pill d-flex align-items-center justify-content-center p-2 border rounded text-decoration-none"><img src="images/yamaha1.png" alt="Yamaha" style="max-height: 25px; max-width: 100%;"></a></div>
                        <div class="col-6"><a href="products?brand=roland" class="brand-pill d-flex align-items-center justify-content-center p-2 border rounded text-decoration-none"><img src="images/roland1.png" alt="Roland" style="max-height: 25px; max-width: 100%;"></a></div>
                        <div class="col-6"><a href="products?brand=marshall" class="brand-pill d-flex align-items-center justify-content-center p-2 border rounded text-decoration-none"><img src="images/marshall1.png" alt="Marshall" style="max-height: 25px; max-width: 100%;"></a></div>
                        <div class="col-6"><a href="products?brand=pearl" class="brand-pill d-flex align-items-center justify-content-center p-2 border rounded text-decoration-none"><img src="images/pearl1.png" alt="Pearl" style="max-height: 25px; max-width: 100%;"></a></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                <h2 class="h4 mb-0 fw-bold text-uppercase">
                    <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "OUR CATALOG" %>
                </h2>
                <span class="text-muted small"><%= products != null ? products.size() : 0 %> Results Found</span>
            </div>

            <div class="row g-4">
                <% if (products != null && !products.isEmpty()) {
                    for(Product p : products) {
                        boolean inStock = p.getQuantity() > 0;
                %>
                <div class="col-6 col-md-4">
                    <div class="product-card clean-container-style h-100 position-relative">
                        <a href="productDetails?id=<%= p.getProductId() %>">
                            <div class="card-img-container">
                                <img src="<%= (p.getImage() != null && !p.getImage().isEmpty()) ? p.getImage() : "https://via.placeholder.com/300?text=No+Image" %>" alt="<%= p.getName() %>">
                                <% if (!inStock) { %>
                                <span class="badge bg-secondary position-absolute top-0 end-0 m-2">SOLD OUT</span>
                                <% } %>
                            </div>
                        </a>
                        <div class="card-details p-3 text-center">
                            <div class="text-muted small text-uppercase mb-1"><%= p.getCategory() %></div>
                            <a href="productDetails?id=<%= p.getProductId() %>" class="fw-bold text-dark d-block mb-2 text-decoration-none"><%= p.getName() %></a>
                            <div class="h5 fw-bold text-danger mb-3">RM <%= String.format("%.2f", p.getPrice()) %></div>

                            <% if (inStock) { %>
                            <form action="addToCart" method="post">
                                <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                <button type="submit" class="btn-add-cart w-100">Add To Cart</button>
                            </form>
                            <% } else { %>
                            <button class="btn btn-secondary w-100 disabled" disabled>Sold Out</button>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="col-12 text-center py-5">
                    <div class="alert alert-light border">
                        <i class="fas fa-search me-2 text-muted"></i> No products found matching your selection.
                        <br>
                        <a href="products" class="btn btn-link mt-2">Clear Filters</a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
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
                <div style="flex: 1; min-width: 0;">
                    <div class="fw-bold small text-truncate"><%= item.getProductName() %></div>
                    <form action="updateCart" method="post" class="d-flex align-items-center mt-2">
                        <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                        <button type="submit" name="quantity" value="<%= item.getQuantity() - 1 %>" class="qty-btn" <%= item.getQuantity() <= 1 ? "disabled" : "" %>><i class="fas fa-minus"></i></button>
                        <span class="mx-2 small fw-bold" style="min-width:20px; text-align:center;"><%= item.getQuantity() %></span>
                        <button type="submit" name="quantity" value="<%= item.getQuantity() + 1 %>" class="qty-btn"><i class="fas fa-plus"></i></button>
                    </form>
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