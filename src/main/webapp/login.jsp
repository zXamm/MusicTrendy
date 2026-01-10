<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | MusicTrendy</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        /* 2. GLOBAL RESETS */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            /* Your GIF Background */
            background: url('https://media1.tenor.com/m/qqvZ9xmHUIgAAAAC/electric-guitar.gif') no-repeat center center fixed;
            background-size: cover;

            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        /* Dark Overlay for text readability */
        .overlay {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.5); /* Slightly lighter overlay so the glass pops */
            z-index: 1;
        }

        /* 3. LOGIN CARD (The Glass Effect) */
        .login-container {
            position: relative; z-index: 2;

            /* GLASS STYLES: Semi-transparent white + Blur */
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);

            width: 420px;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            text-align: center;
        }

        /* 4. LOGO & BRANDING */
        .logo-img {
            width: 80px;
            margin-bottom: 10px;
            filter: drop-shadow(0 0 5px rgba(255,255,255,0.5)); /* Makes logo glow slightly */
        }

        .brand-text {
            font-size: 1.8rem;
            font-weight: bold;
            color: white; /* Changed to White */
            margin-bottom: 5px;
            display: block;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        p.subtitle {
            color: rgba(255, 255, 255, 0.8); /* Semi-transparent white */
            margin-bottom: 30px;
            font-size: 0.95rem;
        }

        /* 5. TRANSPARENT INPUT FIELDS */
        .input-group { margin-bottom: 20px; text-align: left; }
        .input-group label {
            display: block; margin-bottom: 8px;
            color: white; /* Label is now white */
            font-weight: 500; font-size: 0.9rem;
        }

        .input-group input {
            width: 100%;
            padding: 14px;

            /* Transparent Input Background */
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white; /* Text typed is white */

            border-radius: 30px; /* Modern Pill Shape */
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        /* Placeholder Color */
        .input-group input::placeholder { color: rgba(255, 255, 255, 0.6); }

        .input-group input:focus {
            background: rgba(255, 255, 255, 0.2);
            border-color: white;
            outline: none;
            box-shadow: 0 0 15px rgba(13, 110, 253, 0.3);
        }

        /* 6. NEON BUTTON */
        .btn-login {
            width: 100%;
            padding: 15px;
            background: white; /* White button pops on dark glass */
            color: #0d6efd;    /* Blue Text */
            border: none;
            border-radius: 30px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 10px;
            letter-spacing: 1px;
        }
        .btn-login:hover {
            transform: scale(1.05);
            box-shadow: 0 0 20px rgba(255, 255, 255, 0.4);
        }

        /* 7. LINKS & ALERTS */
        .register-link { margin-top: 25px; font-size: 0.9rem; color: rgba(255,255,255,0.8); }
        .register-link a { color: white; text-decoration: none; font-weight: 600; border-bottom: 1px dashed white; }
        .register-link a:hover { color: #8bb9fe; border-color: #8bb9fe; }

        .alert { padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 0.9rem; }
        .error {
            background: rgba(220, 53, 69, 0.8); /* Semi-transparent Red */
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
        }
    </style>
</head>
<body>

<div class="overlay"></div>

<div class="login-container">
    <div class="logo-area">
        <img src="images/MusicTrendyLogo.png" alt="MusicTrendy Logo" class="logo-img">
        <span class="brand-text">MusicTrendy</span>
    </div>

    <p class="subtitle">Log in to manage your orders & music gear.</p>


    <% if (request.getAttribute("error") != null) { %>
    <div class="alert error">⚠️ <%= request.getAttribute("error") %></div>
    <% } %>

    <form action="login" method="post">
        <div class="input-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" placeholder="name@example.com" required>
        </div>

        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required>
        </div>

        <button type="submit" class="btn-login">Sign In</button>

        <div class="register-link">
            Don't have an account? <a href="register.jsp">Create one</a>
        </div>
    </form>
</div>

</body>
</html>