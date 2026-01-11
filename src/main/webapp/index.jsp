<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="dao.ProductDAO" %>
<%@ page import="dao.CartDAO" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.User" %>

<%
    // --- 1. PRODUCT FETCHING LOGIC ---
    ProductDAO dao = new ProductDAO();
    List<Product> productList = null;
    try {
        productList = dao.getAllProducts();
        // Limit to top 8 for the homepage display
        if (productList != null && productList.size() > 8) {
            productList = productList.subList(0, 8);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // --- 2. SIDEBAR CART LOGIC ---
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

    // --- 3. POPUP MESSAGES (Capture Variables) ---
    String popupType = (String) session.getAttribute("popup_type");
    String popupMessage = (String) session.getAttribute("popup_message");
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
        /* --- GLOBAL VARIABLES --- */
        :root {
            --zoso-green: #4c8a2c;
            --zoso-hover: #3e7024;
            --price-red: #d9534f;
            --text-dark: #333;
            --border-light: #e5e5e5;
        }

        body { font-family: 'Open Sans', sans-serif; color: var(--text-dark); }
        a { text-decoration: none; color: inherit; transition: 0.3s; }

        /* --- HEADER & NAV --- */
        .main-header, .nav-strip {
            background-color: rgba(255, 255, 255, 0.95) !important;
            backdrop-filter: blur(5px);
        }
        .logo-container img { max-height: 120px; width: auto; transition: transform 0.3s; }
        .logo-container:hover img { transform: scale(1.05); }

        .header-icon-btn {
            width: 45px; height: 45px; display: flex; align-items: center; justify-content: center;
            border-radius: 50%; background-color: #222; color: white; transition: 0.2s; font-size: 1.1rem;
            cursor: pointer; border: none;
        }
        .header-icon-btn:hover { background-color: var(--zoso-green); color: white; transform: translateY(-2px); }

        .nav-strip { border-bottom: 1px solid var(--border-light); box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .nav-strip a { font-weight: 700; font-size: 0.85rem; text-transform: uppercase; color: #333; padding: 12px 20px; display: inline-block; }
        .nav-strip a:hover { color: var(--zoso-green); }

        /* --- HERO CAROUSEL --- */
        .hero-section { position: relative; padding: 0; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .hero-img { height: 450px; object-fit: cover; filter: brightness(0.85); } /* Slightly Taller */
        .hero-title { font-weight: 800; text-transform: uppercase; color: #fff; text-shadow: 2px 2px 4px rgba(0,0,0,0.6); margin-bottom: 10px; font-size: 3rem; }
        .carousel-caption { bottom: 20%; }
        .carousel-caption p { font-size: 1.2rem; color: #f8f9fa; text-shadow: 1px 1px 2px rgba(0,0,0,0.6); margin-bottom: 25px; }

        /* --- CATEGORIES GRID --- */
        .category-section { padding: 40px 0; text-align: center; background: #fff; border-bottom: 1px solid var(--border-light); }
        .category-grid { display: flex; justify-content: center; flex-wrap: wrap; gap: 40px; margin-top: 30px; }
        .category-item { display: flex; flex-direction: column; align-items: center; width: 100px; text-decoration: none; transition: transform 0.3s ease; cursor: pointer; }
        .category-item:hover { transform: translateY(-10px); }
        .category-item img { height: 80px; width: auto; object-fit: contain; margin-bottom: 15px; }
        .category-item span { font-size: 0.75rem; font-weight: 700; color: #555; text-transform: uppercase; }
        .category-item:hover span { color: var(--zoso-green); }

        /* --- BRAND SECTION --- */
        .brand-section { padding: 50px 0; text-align: center; background: #f9f9f9; border-bottom: 1px solid var(--border-light); }
        .brand-grid { display: flex; justify-content: center; align-items: center; flex-wrap: wrap; gap: 60px; margin-top: 40px; }
        .brand-item { width: 120px; height: 60px; opacity: 0.6; filter: grayscale(100%); transition: 0.3s; }
        .brand-item:hover { transform: scale(1.1); opacity: 1; filter: grayscale(0%); }
        .brand-item img { max-width: 100%; max-height: 100%; object-fit: contain; }

        /* --- PRODUCT CARDS --- */
        .section-header { text-align: center; margin: 50px 0 30px 0; }
        .product-card {
            border: none; box-shadow: 0 2px 15px rgba(0,0,0,0.05); transition: all 0.3s ease;
            height: 100%; border-radius: 8px; overflow: hidden; display: flex; flex-direction: column; background: #fff;
        }
        .product-card:hover { transform: translateY(-8px); box-shadow: 0 15px 30px rgba(0,0,0,0.15); }
        .card-img-container { height: 200px; padding: 25px; display: flex; align-items: center; justify-content: center; border-bottom: 1px solid #f0f0f0; background: #fff; }
        .card-img-container img { max-height: 100%; max-width: 100%; object-fit: contain; transition: transform 0.4s ease; }
        .product-card:hover .card-img-container img { transform: scale(1.1); }
        .btn-add-cart { width: 100%; background-color: var(--zoso-green); color: white; font-weight: 600; border: none; padding: 10px; text-transform: uppercase; font-size: 0.8rem; border-radius: 4px; transition: 0.2s; }
        .btn-add-cart:hover { background-color: var(--zoso-hover); color: white; }

        /* --- FEATURES & FOOTER --- */
        .features-section { padding: 50px 0; border-top: 1px solid #ddd; margin-top: 60px; background: rgba(255,255,255,0.95); }
        .feature-box { text-align: center; padding: 10px; }
        .feature-box i { font-size: 2rem; color: #444; margin-bottom: 10px; }
        .feature-title { font-weight: 800; margin-bottom: 5px; font-size: 0.95rem; color: var(--zoso-green); }
        .feature-desc { font-size: 0.85rem; color: #666; }

        footer { background-color: #222 !important; color: #fff !important; padding: 40px 0; border-top: 1px solid #444; }
        footer .text-muted { color: #999 !important; }
        .footer-link { color: #bbb; font-size: 0.85rem; display: block; margin-bottom: 8px; }
        .footer-link:hover { color: var(--zoso-green); text-decoration: underline; }

        /* --- SIDEBAR CART --- */
        .cart-item-row { border-bottom: 1px solid #f0f0f0; padding: 12px 0; }
        .cart-total-box { background: #f8f9fa; padding: 15px; border-radius: 8px; margin-top: auto; }
        .qty-btn { width: 24px; height: 24px; padding: 0; display: flex; align-items: center; justify-content: center; font-size: 0.8rem; border-radius: 4px; background: #eee; border: none; transition: 0.2s; }
        .qty-btn:hover { background: #ddd; }
    </style>
</head>
<body>

<div class="top-notification-bar" style="background:#222; color:#fff; text-align:center; padding:8px 0; font-size:0.8rem;">
    Welcome to MusicTrendy - Your #1 Music Store. WhatsApp Hotline: +60 19-563 2050
</div>

<header class="main-header">
    <div class="container">
        <div class="row align-items-center" style="padding: 10px 0;">
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

<nav class="nav-strip sticky-top" style="background: #fff;">
    <div class="container text-center">
        <a href="index.jsp" style="color: var(--zoso-green);">Home</a>
        <a href="products">Shop Catalog</a>
        <a href="orders">My Orders</a>
        <a href="about.jsp">About Us</a>
    </div>
</nav>

<section class="hero-section">
    <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="4000">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="images/Carousel1.jpg" class="d-block w-100 hero-img" alt="Guitar">
                <div class="carousel-caption d-none d-md-block">
                    <h1 class="hero-title">New Arrivals</h1>
                    <p>Check out our latest guitar electronic brand</p>
                    <a href="products" class="btn btn-add-cart" style="width: auto; padding: 12px 30px; font-size:1rem;">Shop Now</a>
                </div>
            </div>
            <div class="carousel-item">
                <img src="images/Carousel3.png" class="d-block w-100 hero-img" alt="Drums">
                <div class="carousel-caption d-none d-md-block">
                    <h1 class="hero-title">Rock the Beat</h1>
                    <p>Premium Drum Kits Available</p>
                    <a href="products?category=drums" class="btn btn-add-cart" style="width: auto; padding: 12px 30px; font-size:1rem;">View Drums</a>
                </div>
            </div>
            <div class="carousel-item">
                <img src="images/Carousel2.png" class="d-block w-100 hero-img" alt="Piano">
                <div class="carousel-caption d-none d-md-block">
                    <h1 class="hero-title">Accessories</h1>
                    <p>From beginner to professional</p>
                    <a href="products" class="btn btn-add-cart" style="width: auto; padding: 12px 30px; font-size:1rem;">Shop Accessories</a>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
        </button>
    </div>
</section>

<section class="category-section">
    <div class="container">
        <h2 style="color: var(--zoso-green); font-weight: 800; letter-spacing: 2px; text-transform: uppercase;">SHOP BY CATEGORY</h2>
        <div class="category-grid">
            <a href="products?category=amps" class="category-item"><img src="images/amplifier1.png" alt="Amps"><span>Amplifiers</span></a>
            <a href="products?category=pedals" class="category-item"><img src="images/pedal1.png" alt="Pedals"><span>Pedals</span></a>
            <a href="products?category=mics" class="category-item"><img src="images/microphone1.png" alt="Microphones"><span>Microphones</span></a>
            <a href="products?category=audio" class="category-item"><img src="images/audiointer1.png" alt="Audio"><span>Audio Interface</span></a>
            <a href="products?category=keyboards" class="category-item"><img src="images/keyboard1.png" alt="Keyboards"><span>Keyboards</span></a>
            <a href="products?category=headphones" class="category-item"><img src="images/headphone1.png" alt="Headphones"><span>Headphones</span></a>
            <a href="products?category=drums" class="category-item"><img src="images/drum1.png" alt="Drums"><span>Drums</span></a>
            <a href="products?category=guitars" class="category-item"><img src="images/guitar1.png" alt="Guitars"><span>Guitars</span></a>
        </div>
    </div>
</section>

<section class="brand-section">
    <div class="container">
        <h2 style="color: var(--zoso-green); font-weight: 800; letter-spacing: 2px; text-transform: uppercase;">PREMIUM BRANDS</h2>
        <p class="text-muted mt-2 small">AUTHORIZED DEALER FOR THE WORLD'S BEST</p>
        <div class="brand-grid">
            <a href="products?brand=fender" class="brand-item"><img src="images/fender1.png" alt="Fender"></a>
            <a href="products?brand=yamaha" class="brand-item"><img src="images/yamaha1.png" alt="Yamaha"></a>
            <a href="products?brand=roland" class="brand-item"><img src="images/roland1.png" alt="Roland"></a>
            <a href="products?brand=gibson" class="brand-item"><img src="images/gibson1.png" alt="Gibson"></a>
            <a href="products?brand=marshall" class="brand-item"><img src="images/marshall1.png" alt="Marshall"></a>
            <a href="products?brand=pearl" class="brand-item"><img src="images/pearl1.png" alt="Pearl"></a>
        </div>
    </div>
</section>

<div class="container my-5">
    <div class="section-header">
        <h2 style="color:var(--zoso-green); font-weight:800; text-transform:uppercase;">Featured Collection</h2>
        <p class="text-muted mt-2">HANDPICKED FOR MUSICIANS LIKE YOU</p>
    </div>
    <div class="row g-4">
        <% if (productList != null && !productList.isEmpty()) {
            for(Product p : productList) { %>
        <div class="col-6 col-md-4 col-lg-3">
            <div class="product-card">
                <a href="productDetails?id=<%= p.getProductId() %>">
                    <div class="card-img-container">
                        <img src="<%= (p.getImage() != null && !p.getImage().isEmpty()) ? p.getImage() : "https://via.placeholder.com/300?text=No+Image" %>" alt="<%= p.getName() %>">
                    </div>
                </a>
                <div class="p-3 text-center d-flex flex-column flex-grow-1 justify-content-between">
                    <div>
                        <div class="fw-bold mb-1 small"><%= p.getName() %></div>
                        <div class="text-danger fw-bold mb-2">RM <%= String.format("%.2f", p.getPrice()) %></div>
                    </div>
                    <form action="addToCart" method="post">
                        <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                        <button type="submit" class="btn-add-cart">Add To Cart</button>
                    </form>
                </div>
            </div>
        </div>
        <% } } else { %>
        <div class="col-12 text-center py-5">
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle"></i> No products available in the database.
            </div>
        </div>
        <% } %>
    </div>
</div>

<section class="features-section">
    <div class="container">
        <div class="row">
            <div class="col-md-3 feature-box">
                <i class="fas fa-truck"></i>
                <div class="feature-title">Fast Delivery</div>
                <div class="feature-desc">Reliable shipping nationwide</div>
            </div>
            <div class="col-md-3 feature-box">
                <i class="fas fa-guitar"></i>
                <div class="feature-title">Guitar Services</div>
                <div class="feature-desc">Expert setup before shipping</div>
            </div>
            <div class="col-md-3 feature-box">
                <i class="fas fa-headset"></i>
                <div class="feature-title">Customer Care</div>
                <div class="feature-desc">Round-the-clock assistance</div>
            </div>
            <div class="col-md-3 feature-box">
                <i class="fas fa-lock"></i>
                <div class="feature-title">Secure Checkout</div>
                <div class="feature-desc">100% Safe Payment Methods</div>
            </div>
        </div>
    </div>
</section>

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
    // --- 4. POPUP MESSAGE SCRIPT ---
    if (popupType != null) {
%>
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
<%
        // Clear immediately so it doesn't show on refresh
        session.removeAttribute("popup_type");
        session.removeAttribute("popup_message");
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>