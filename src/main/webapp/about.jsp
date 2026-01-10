<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | MusicTrendy</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* --- SHARED THEME --- */
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

        /* --- NAV STRIP --- */
        .nav-strip { background: #fff; border-bottom: 1px solid var(--border-light); box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .nav-strip a { font-weight: 700; font-size: 0.85rem; text-transform: uppercase; color: #333; padding: 15px 25px; display: inline-block; }
        .nav-strip a:hover { color: var(--zoso-green); background: rgba(0,0,0,0.02); }

        /* --- UTILITIES --- */
        .clean-container-style { background: #ffffff; border: 1px solid var(--border-light); box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03); }

        /* --- ABOUT US SPECIFIC --- */
        .about-hero {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://media1.tenor.com/m/9Ldmap76p1IAAAAC/playing-playing-guitar.gif');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            color: #fff;
            padding: 100px 0;
            text-align: center;
            margin-bottom: 50px;
        }
        .about-img-container {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }

        .btn-add-cart {
            background-color: var(--zoso-green); color: white; font-weight: 700; border: none; padding: 12px 25px;
            text-transform: uppercase; font-size: 0.85rem; border-radius: 6px; transition: 0.2s; display: inline-block;
        }
        .btn-add-cart:hover { background-color: var(--zoso-hover); color: #fff; }

        /* --- FOOTER (MATCHING INDEX.JSP) --- */
        footer {
            background-color: #222 !important;
            color: #fff !important;
            padding: 40px 0;
            border-top: 1px solid #444;
            margin-top: auto;
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
        <a href="products">Shop Catalog</a>
        <a href="orders">My Orders</a>
        <a href="about.jsp" style="color: var(--zoso-green);">About Us</a>
    </div>
</nav>

<div class="about-hero">
    <div class="container">
        <h1 class="fw-bold display-4">About <span style="color: #6ec045;">MusicTrendy</span></h1>
        <p class="lead mt-3">Your trusted partner in musical excellence since 2026.</p>
    </div>
</div>

<div class="container my-5">
    <div class="row align-items-center g-5">
        <div class="col-md-6">
            <div class="about-img-container">
                <img src="images/MusicTrendyLogo.png" class="img-fluid w-100 p-4 bg-white" alt="About Us">
            </div>
        </div>
        <div class="col-md-6">
            <h3 class="fw-bold mb-4" style="color: var(--text-dark); text-transform: uppercase;">Our Story</h3>
            <p class="text-muted" style="line-height: 1.8;">
                MusicTrendy began with a simple mission: to provide high-quality instruments to musicians of all levels at affordable prices.
                What started as a small passion project has grown into Malaysia's premier destination for musical gear.
            </p>
            <p class="text-muted" style="line-height: 1.8;">
                Located in the heart of Kuala Lumpur, we are authorized dealers for major brands like <strong>Yamaha, Fender, Roland, and Marshall</strong>.
                Whether you are a bedroom guitarist or a touring professional, we have the gear, the knowledge, and the passion to support your musical journey.
            </p>

            <div class="mt-4">
                <a href="products" class="btn-add-cart" style="max-width: 200px; text-align: center;">Browse Catalog</a>
            </div>
        </div>
    </div>
</div>

<div class="clean-container-style py-5 mt-5 mb-5">
    <div class="container text-center">
        <h2 class="fw-bold mb-3" style="color: var(--zoso-green);">VISIT OUR SHOWROOM</h2>
        <div class="row justify-content-center mt-4">
            <div class="col-md-4 mb-3">
                <i class="fas fa-map-marker-alt fa-2x mb-3 text-muted"></i>
                <h5 class="fw-bold">Location</h5>
                <p class="text-muted">123 Music Street, Melody Plaza,<br>Kuala Lumpur, Malaysia</p>
            </div>
            <div class="col-md-4 mb-3">
                <i class="fas fa-phone-alt fa-2x mb-3 text-muted"></i>
                <h5 class="fw-bold">Contact</h5>
                <p class="text-muted">+60 19-563 2050<br>support@musictrendy.com</p>
            </div>
            <div class="col-md-4 mb-3">
                <i class="fas fa-clock fa-2x mb-3 text-muted"></i>
                <h5 class="fw-bold">Opening Hours</h5>
                <p class="text-muted">Mon - Sun: 10:00 AM - 10:00 PM</p>
            </div>
        </div>
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
                <a href="products?category=guitars" class="footer-link">Guitars</a>
                <a href="products?category=drums" class="footer-link">Drums</a>
                <a href="products?category=keyboards" class="footer-link">Keyboards</a>
                <a href="products?category=audio" class="footer-link">Audio</a>
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
        toast: true,
        position: 'top-end'
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