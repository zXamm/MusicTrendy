<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="dao.ProductDAO" %>

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

        :root {
            --zoso-green: #4c8a2c;
            --zoso-hover: #3e7024;
            --price-red: #d9534f;
            --text-dark: #333;
        }

        /* Glass/Clean Container Style for Readability */
        .main-header, .nav-strip, .product-card, .features-section {
            background-color: rgba(255, 255, 255, 0.95) !important;
            backdrop-filter: blur(5px);
        }

        /* Footer specific style override - Dark Theme */
        footer {
            background-color: #222 !important; /* Dark background */
            color: #fff !important;           /* White text */
            backdrop-filter: none;            /* Remove blur if needed or keep it subtle */
        }

        .section-header h2 {
            background: rgba(255,255,255,0.9);
        }

        a { text-decoration: none; color: inherit; transition: 0.3s; }

        /* --- HEADER & NAV STYLES --- */
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
            padding: 10px 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            position: relative;
            z-index: 5;
        }

        .logo-container { display: flex; align-items: center; text-decoration: none !important; }
        .logo-container img { max-height: 120px; width: auto; transition: transform 0.3s; }
        .logo-container:hover img { transform: scale(1.05); }

        .search-group input { border-radius: 30px 0 0 30px; border: 1px solid #ddd; padding-left: 20px; background: #f9f9f9; }
        .search-group button { border-radius: 0 30px 30px 0; background-color: var(--zoso-green); color: white; border: none; padding: 0 25px; }
        .search-group button:hover { background-color: var(--zoso-hover); }

        .nav-strip { border-bottom: 1px solid #e5e5e5; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .nav-strip a { font-weight: 700; font-size: 0.85rem; text-transform: uppercase; color: #333; padding: 12px 20px; display: inline-block; }
        .nav-strip a:hover { color: var(--zoso-green); }

        /* --- CAROUSEL (UPDATED SIZE) --- */
        .hero-section { position: relative; padding: 0; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }

        .hero-img {
            height: 380px;
            object-fit: cover;
            filter: brightness(0.85); /* Slightly brighter */
        }

        /* --- SHOP BY CATEGORY SECTION --- */
        .category-section {
            padding: 40px 0;
            text-align: center;
            background: #fff;
            border-bottom: 1px solid var(--border-light);
        }

        .category-grid {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 40px; /* Space between items */
            margin-top: 30px;
        }

        .category-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100px;
            text-decoration: none;
            transition: transform 0.3s ease;
            cursor: pointer;
        }

        .category-item:hover {
            transform: translateY(-10px);
        }

        .category-item img {
            height: 80px;
            width: auto;
            object-fit: contain;
            margin-bottom: 15px;
        }

        .category-item span {
            font-size: 0.75rem;
            font-weight: 700;
            color: #555;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .category-item:hover span {
            color: var(--zoso-green);
        }

        /* --- SHOP BY BRANDS SECTION --- */
        .brand-section {
            padding: 50px 0;
            text-align: center;
            background: #f9f9f9;
            border-bottom: 1px solid var(--border-light);
        }

        .brand-grid {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
            gap: 60px;
            margin-top: 40px;
        }

        .brand-item {
            display: block;
            width: 120px;
            height: 60px;
            position: relative;
            transition: transform 0.3s ease;
            opacity: 0.6;
            filter: grayscale(100%);
        }

        .brand-item img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }

        .brand-item:hover {
            transform: scale(1.1);
            opacity: 1;
            filter: grayscale(0%);
        }

        .carousel-caption { bottom: 20%; }
        .hero-title { font-weight: 800; text-transform: uppercase; color: #fff; text-shadow: 2px 2px 4px rgba(0,0,0,0.6); margin-bottom: 10px; font-size: 3rem; }
        .carousel-caption p { font-size: 1.2rem; color: #f8f9fa; text-shadow: 1px 1px 2px rgba(0,0,0,0.6); margin-bottom: 25px; }

        /* --- PRODUCT CARD STYLES (UPDATED SIZE) --- */
        .section-header { text-align: center; margin: 50px 0 30px 0; }
        .section-header h2 { color: var(--zoso-green); font-weight: 800; text-transform: uppercase; letter-spacing: 2px; display: inline-block; padding: 5px 15px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); border-radius: 4px; }

        .product-card {
            border: none;
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            height: 100%;
            position: relative;
            border-radius: 8px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        .product-card:hover { transform: translateY(-8px); box-shadow: 0 15px 30px rgba(0,0,0,0.15); }

        /* --- SIMPLE ZOOM CONTAINER --- */
        .card-img-container {
            height: 180px;
            padding: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #fff;
            border-bottom: 1px solid #f0f0f0;
            overflow: hidden;
            position: relative;
        }

        .card-img-container img {
            max-height: 100%;
            max-width: 100%;
            object-fit: contain;
            transition: transform 0.4s ease;
        }

        .product-card:hover .card-img-container img { transform: scale(1.1); }

        .header-icon-btn {
            width: 45px; height: 45px; display: flex; align-items: center; justify-content: center;
            border-radius: 50%; background-color: #222; color: white; transition: 0.2s; font-size: 1.1rem;
        }
        .header-icon-btn:hover { background-color: var(--zoso-green); color: white; transform: translateY(-2px); }

        .card-details { padding: 15px; text-align: center; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .product-name { font-size: 0.9rem; font-weight: 700; color: #000; min-height: 40px; line-height: 1.4; margin-bottom: 10px; display: block; }
        .product-price { color: var(--price-red); font-weight: 800; font-size: 1.1rem; margin-bottom: 10px; }
        .btn-add-cart { width: 100%; background-color: var(--zoso-green); color: white; font-weight: 600; border: none; padding: 10px; text-transform: uppercase; font-size: 0.8rem; border-radius: 4px; transition: 0.2s; }
        .btn-add-cart:hover { background-color: var(--zoso-hover); color: #fff; }

        /* --- FOOTER --- */
        .features-section { padding: 50px 0; border-top: 1px solid #ddd; margin-top: 60px; }
        .feature-box { text-align: center; padding: 10px; }
        .feature-box i { font-size: 2rem; color: #444; margin-bottom: 10px; }
        .feature-title { font-weight: 800; margin-bottom: 5px; font-size: 0.95rem; color: var(--zoso-green); }
        .feature-desc { font-size: 0.85rem; color: #666; }

        footer {
            padding: 40px 0;
            border-top: 1px solid #444;
        }
        .footer-link {
            color: #bbb;
            font-size: 0.85rem;
            display: block;
            margin-bottom: 8px;
        }
        .footer-link:hover {
            color: var(--zoso-green);
            text-decoration: underline;
        }
        /* Override Bootstrap text-muted for footer to be visible on dark bg */
        footer .text-muted {
            color: #999 !important;
        }
        footer h5 {
            color: #fff;
        }
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
        <a href="index.jsp" style="color: var(--zoso-green);">Home</a>
        <a href="products">Shop Catalog</a>
        <a href="orders">My Orders</a>
        <a href="about.jsp">About Us</a>
    </div>
</nav>

<section class="hero-section">
    <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="3000">
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
                    <a href="products" class="btn btn-add-cart" style="width: auto; padding: 10px 30px;">Shop Now</a>
                </div>
            </div>
            <div class="carousel-item">
                <img src="images/Carousel3.png" class="d-block w-100 hero-img" alt="Drums">
                <div class="carousel-caption d-none d-md-block">
                    <h1 class="hero-title">Rock the Beat</h1>
                    <p>Premium Drum Kits Available</p>
                    <a href="products?category=Drums" class="btn btn-add-cart" style="width: auto; padding: 10px 30px;">View Drums</a>
                </div>
            </div>
            <div class="carousel-item">
                <img src="images/Carousel2.png" class="d-block w-100 hero-img" alt="Piano">
                <div class="carousel-caption d-none d-md-block">
                    <h1 class="hero-title">Accessories</h1>
                    <p>From beginner to professional</p>
                    <a href="products?category=Accessories" class="btn btn-add-cart" style="width: auto; padding: 10px 30px;">Shop Accessories</a>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>
</section>

<section class="category-section">
    <div class="container">
        <h2 style="color: var(--zoso-green); font-weight: 800; letter-spacing: 2px; text-transform: uppercase;">SHOP BY CATEGORY</h2>

        <div class="category-grid">
            <a href="products?category=amps" class="category-item">
                <img src="images/amplifier1.png" alt="Amps">
                <span>Amplifiers</span>
            </a>

            <a href="products?category=pedals" class="category-item">
                <img src="images/pedal1.png" alt="Pedals">
                <span>Pedals</span>
            </a>

            <a href="products?category=mics" class="category-item">
                <img src="images/microphone1.png" alt="Microphones">
                <span>Microphones</span>
            </a>

            <a href="products?category=audio" class="category-item">
                <img src="images/audiointer1.png" alt="Audio Interface">
                <span>Audio Interface</span>
            </a>

            <a href="products?category=keyboards" class="category-item">
                <img src="images/keyboard1.png" alt="Keyboards">
                <span>Keyboards</span>
            </a>

            <a href="products?category=headphones" class="category-item">
                <img src="images/headphone1.png" alt="Headphones">
                <span>Headphones</span>
            </a>

            <a href="products?category=drums" class="category-item">
                <img src="images/drum1.png" alt="Drums">
                <span>Drums</span>
            </a>

            <a href="products?category=quitars" class="category-item">
                <img src="images/guitar1.png" alt="Guitars">
                <span>Guitars</span>
            </a>
        </div>
    </div>
</section>

<section class="brand-section">
    <div class="container">
        <h2 style="color: var(--zoso-green); font-weight: 800; letter-spacing: 2px; text-transform: uppercase;">PREMIUM BRANDS</h2>
        <p class="text-muted mt-2" style="font-size: 0.9rem;">AUTHORIZED DEALER FOR THE WORLD'S BEST</p>

        <div class="brand-grid">
            <a href="products?brand=fender" class="brand-item" title="Fender">
                <img src="images/fender1.png" alt="Fender">
            </a>

            <a href="products?brand=yamaha" class="brand-item" title="Yamaha">
                <img src="images/yamaha1.png" alt="Yamaha">
            </a>

            <a href="products?brand=roland" class="brand-item" title="Roland">
                <img src="images/roland1.png" alt="Roland">
            </a>

            <a href="products?brand=gibson" class="brand-item" title="Gibson">
                <img src="images/gibson1.png" alt="Gibson">
            </a>

            <a href="products?brand=marshall" class="brand-item" title="Marshall">
                <img src="images/marshall1.png" alt="Marshall">
            </a>

            <a href="products?brand=pearl" class="brand-item" title="Pearl">
                <img src="images/pearl1.png" alt="Pearl">
            </a>
        </div>
    </div>
</section>

<div class="container">
    <div class="section-header">
        <h2>Featured Collection</h2>
        <p class="text-muted">HANDPICKED FOR MUSICIANS LIKE YOU</p>
    </div>

    <div class="row g-4">
        <%
            if (productList != null && !productList.isEmpty()) {
                for(Product p : productList) {
        %>
        <div class="col-6 col-md-4 col-lg-3">
            <div class="product-card clean-container-style">

                <a href="productDetails?id=<%= p.getProductId() %>">
                    <div class="card-img-container">
                        <img src="<%= (p.getImage() != null && !p.getImage().isEmpty()) ? p.getImage() : "https://via.placeholder.com/300?text=No+Image" %>"
                             alt="<%= p.getName() %>">
                    </div>
                </a>

                <div class="card-details">
                    <div>
                        <a href="productDetails?id=<%= p.getProductId() %>" class="product-name">
                            <%= p.getName() %>
                        </a>

                        <div class="product-price">
                            RM <%= String.format("%.2f", p.getPrice()) %>
                        </div>
                    </div>

                    <form action="addToCart" method="post">
                        <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                        <button type="submit" class="btn-add-cart">Add To Cart</button>
                    </form>
                </div>
            </div>
        </div>
        <%
            }
        } else {
        %>
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
        icon: '<%= popupType %>',
        title: 'Success!',
        text: '<%= popupMessage %>',
        showConfirmButton: false,
        timer: 2000,
        timerProgressBar: true,
        background: '#fff',
        iconColor: '#4c8a2c',
        toast: true,                // Optional: Makes it a small toast notification
        position: 'top-end'         // Optional: Shows at top right like a notification
    });
</script>
<%
        session.removeAttribute("popup_type");
        session.removeAttribute("popup_message");
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>