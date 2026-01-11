<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | MusicTrendy</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        /* 2. GLOBAL RESETS */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            /* Same GIF Background as Login */
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
            background: rgba(0, 0, 0, 0.5); /* Match Login Overlay */
            z-index: 1;
        }

        /* 3. REGISTER CARD (Glass Effect) */
        .register-container {
            position: relative; z-index: 2;

            /* GLASS STYLES: Semi-transparent white + Blur */
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);

            width: 450px;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
            text-align: center;
            color: white; /* Default text color is now white */
        }

        /* 4. HEADERS & ICON */
        .logo-img {
            width: 80px;
            margin-bottom: 10px;
            filter: drop-shadow(0 0 5px rgba(255,255,255,0.5)); /* Makes logo glow slightly */
        }

        h2 {
            font-weight: 600;
            color: white;
            margin-bottom: 5px;
            font-size: 2rem;
            letter-spacing: 1px;
        }
        p.subtitle {
            color: rgba(255, 255, 255, 0.8);
            margin-bottom: 25px;
            font-size: 0.95rem;
        }

        /* 5. TRANSPARENT INPUT FIELDS */
        .input-group { margin-bottom: 15px; text-align: left; }
        .input-group label {
            display: block; margin-bottom: 8px; color: white; font-weight: 500; font-size: 0.9rem;
        }
        .input-group input {
            width: 100%;
            padding: 14px;

            /* Transparent Input Background */
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;

            border-radius: 30px; /* Pill Shape */
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
        .btn-register {
            width: 100%;
            padding: 15px;
            background: white;
            color: #0d6efd; /* Blue Text */
            border: none;
            border-radius: 30px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 10px;
            letter-spacing: 1px;
        }
        .btn-register:hover {
            transform: scale(1.05);
            box-shadow: 0 0 20px rgba(255, 255, 255, 0.4);
        }

        /* 7. LINKS & ALERTS */
        .login-link { margin-top: 25px; font-size: 0.9rem; color: rgba(255, 255, 255, 0.8); }
        .login-link a { color: white; text-decoration: none; font-weight: 600; border-bottom: 1px dashed white; }
        .login-link a:hover { color: #8bb9fe; border-color: #8bb9fe; }

        .alert { padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 0.9rem; border: 1px solid rgba(255,255,255,0.3); }
        .error { background-color: rgba(220, 53, 69, 0.8); color: white; }
        .success { background-color: rgba(25, 135, 84, 0.8); color: white; }
    </style>
</head>
<body>

<div class="overlay"></div>

<div class="register-container">

    <div class="logo-area">
        <img src="images/MusicTrendyLogo.png" alt="MusicTrendy Logo" class="logo-img">
    </div>

    <h2>Create Account</h2>
    <p class="subtitle">Join MusicTrendy to start shopping.</p>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert error">⚠️ <%= request.getAttribute("error") %></div>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
    <div class="alert success">✅ <%= request.getAttribute("success") %></div>
    <% } %>

    <form action="register" method="post">
        <div class="input-group">
            <label for="name">Full Name</label>
            <input type="text" id="name" name="name" placeholder="John Doe" required>
        </div>

        <div class="input-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" placeholder="name@example.com" required>
        </div>

        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Create a strong password" required>
        </div>

        <button type="submit" class="btn-register">Sign Up Now</button>

        <div class="login-link">
            Already have an account? <a href="login.jsp">Log In here</a>
        </div>
    </form>
</div>

</body>
</html>