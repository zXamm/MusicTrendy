<!DOCTYPE html>
<html>
<head>
    <title>MusicTrendy - Register</title>
    <style>
        body { font-family: Arial; background:#f2f2f2; }
        .box { width:400px; margin:80px auto; background:white; padding:25px; border-radius:10px; }
        input { width:100%; padding:10px; margin:10px 0; }
        button { width:100%; padding:10px; background:#198754; color:white; border:none; border-radius:5px; cursor:pointer; }
        .error { color:red; }
        .success { color:green; }
    </style>
</head>
<body>

<div class="box">
    <h2>Register</h2>

    <% if (request.getAttribute("error") != null) { %>
    <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <% if (request.getAttribute("success") != null) { %>
    <p class="success"><%= request.getAttribute("success") %></p>
    <% } %>

    <form action="register" method="post">
        <input type="text" name="name" placeholder="Full Name" required>
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Create Account</button>
    </form>

    <p>Already have an account? <a href="login.jsp">Login</a></p>
</div>

</body>
</html>
