<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Store Policies | MusicTrendy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        /* Shared Theme Styles */
        :root { --zoso-green: #4c8a2c; --zoso-hover: #3e7024; --text-dark: #333; --bg-light: #f3f5f2; }
        body { font-family: 'Open Sans', sans-serif; background-color: var(--bg-light); color: var(--text-dark); display: flex; flex-direction: column; min-height: 100vh; }
        a { text-decoration: none; color: inherit; transition: 0.3s; }

        /* Header & Footer (Same as other pages) */
        .top-notification-bar { background: #222; color: #fff; text-align: center; font-size: 0.8rem; padding: 8px 0; }
        .main-header { background: #fff; border-bottom: 1px solid #e5e5e5; padding: 15px 0; }
        .nav-strip { background: #fff; border-bottom: 1px solid #e5e5e5; }
        .nav-strip a { font-weight: 700; font-size: 0.85rem; text-transform: uppercase; color: #333; padding: 15px 25px; display: inline-block; }
        .nav-strip a:hover { color: var(--zoso-green); }

        /* Policy Page Specifics */
        .policy-section { background: #fff; padding: 40px; border-radius: 8px; margin-bottom: 30px; border: 1px solid #e5e5e5; }
        .policy-title { color: var(--zoso-green); font-weight: 800; text-transform: uppercase; margin-bottom: 20px; border-bottom: 2px solid #f0f0f0; padding-bottom: 10px; }
        .policy-text { line-height: 1.8; color: #555; }

        footer { background-color: #222; color: #fff; padding: 40px 0; margin-top: auto; }
        footer .text-muted {
            color: #999 !important;
        }
        .footer-link { color: #bbb; font-size: 0.85rem; display: block; margin-bottom: 8px; }
        .footer-link:hover { color: var(--zoso-green); text-decoration: underline; }
    </style>
</head>
<body>

<div class="top-notification-bar">Welcome to MusicTrendy - Your #1 Music Store. WhatsApp Hotline: +60 19-563 2050</div>
<header class="main-header">
    <div class="container text-center">
        <a href="index.jsp"><img src="images/MusicTrendyLogo.png" alt="MusicTrendy" style="max-height: 80px;"></a>
    </div>
</header>
<nav class="nav-strip sticky-top">
    <div class="container text-center">
        <a href="index.jsp">Home</a>
        <a href="products">Shop</a>
        <a href="about.jsp">About Us</a>
    </div>
</nav>

<div class="container my-5">
    <h1 class="text-center fw-bold mb-5">STORE POLICIES</h1>

    <div id="refund" class="policy-section">
        <h3 class="policy-title"><i class="fas fa-undo me-2"></i> Refund & Return Policy</h3>
        <div class="policy-text">
            <p><strong>1. Return Eligibility:</strong> We accept returns within <strong>7 days</strong> of receipt. To be eligible, your item must be unused, in the same condition that you received it, and in the original packaging.</p>
            <p><strong>2. Non-Returnable Items:</strong> Certain items cannot be returned for hygiene or copyright reasons, including:
            <ul>
                <li>Microphones and In-ear Monitors (if opened)</li>
                <li>Software and Digital Licenses</li>
                <li>Harmonicas and Wind Instruments</li>
            </ul>
            </p>
            <p><strong>3. Refund Process:</strong> Once your return is received and inspected, we will notify you of the approval or rejection of your refund. If approved, your refund will be processed to your original payment method within 5-7 business days.</p>
        </div>
    </div>

    <div id="privacy" class="policy-section">
        <h3 class="policy-title"><i class="fas fa-user-shield me-2"></i> Privacy Policy</h3>
        <div class="policy-text">
            <p><strong>1. Data Collection:</strong> We collect only the information necessary to process your orders, including your name, shipping address, email, and phone number.</p>
            <p><strong>2. Data Security:</strong> Your payment information is encrypted using SSL technology. We do not store your credit card details on our servers.</p>
            <p><strong>3. Third Parties:</strong> We do not sell or trade your personal information. We only share necessary details with our shipping partners (PosLaju/J&T) to deliver your goods.</p>
        </div>
    </div>

    <div id="terms" class="policy-section">
        <h3 class="policy-title"><i class="fas fa-gavel me-2"></i> Terms & Conditions</h3>
        <div class="policy-text">
            <p><strong>1. Pricing:</strong> All prices are in Malaysian Ringgit (RM) and are subject to change without notice.</p>
            <p><strong>2. Warranty:</strong> All new instruments come with a standard 1-year manufacturer warranty covering defects in materials and workmanship. Damage due to misuse is not covered.</p>
            <p><strong>3. Order Cancellation:</strong> We reserve the right to cancel any order if the product is out of stock or if there is a pricing error. In such cases, a full refund will be issued immediately.</p>
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

</body>
</html>