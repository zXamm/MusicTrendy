<!DOCTYPE html>
<html>
<head>
    <title>MusicTrendy - Login</title>
    <style>
        body { font-family: Arial; background:#f2f2f2; }
        .box { width:400px; margin:80px auto; background:white; padding:25px; border-radius:10px; }
        input { width:100%; padding:10px; margin:10px 0; }
        button { width:100%; padding:10px; background:#0b5ed7; color:white; border:none; border-radius:5px; cursor:pointer; }
        a { text-decoration:none; }
        .error { color:red; }
    </style>
</head>
<body>

<div class="box">
    <h2>Login</h2>

    <% if (request.getAttribute("error") != null) { %>
    <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="login" method="post">
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Login</button>
    </form>

    <p>Don't have an account? <a href="register.jsp">Register</a></p>
</div>

</body>
</html>
