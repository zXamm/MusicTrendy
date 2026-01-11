<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String username = (String) session.getAttribute("username");
    if(username == null) username = "Admin";

    String pageContent = request.getParameter("page");
    if(pageContent == null) pageContent = "dashboardContent.jsp";

    String active = pageContent;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        body {margin:0;font-family:Poppins;background:#f8fafc;}
        .container{display:flex;min-height:100vh;}

        /* Sidebar */
        .sidebar{
            width:240px;
            background:linear-gradient(180deg,#14b8a6,#0ea5e9);
            color:white;padding:20px;
            display:flex;flex-direction:column;

            position: fixed;
            top: 0;
            left: 0;
            height: 95vh;
        }
        .brand{font-size:22px;font-weight:600;margin-bottom:40px;display:flex;gap:10px;align-items:center;}
        .brand span{font-size:28px;}

        .menu a{
            text-decoration:none;color:white;
            display:flex;align-items:center;gap:12px;
            padding:12px 15px;border-radius:10px;
            margin:6px 0;transition:.2s;
            font-size:15px;font-weight:500;
        }
        .menu a:hover{background:rgba(255,255,255,.2);}
        .menu a.active{background:white;color:#0f172a;font-weight:600;}

        .logout{margin-top:auto;}
        .logout a{background:rgba(0,0,0,0.2);}

        /* Main */
        .main{margin-left:270px;
            flex:1;
            padding:25px;}
        .topbar{
            background:white;padding:15px 20px;border-radius:12px;
            box-shadow:0 5px 15px rgba(0,0,0,0.05);
            display:flex;justify-content:space-between;align-items:center;
        }
        .avatar{
            width:40px;height:40px;border-radius:50%;
            background:#0ea5e9;color:white;font-weight:bold;
            display:flex;justify-content:center;align-items:center;
        }
        .user-box{display:flex;gap:12px;align-items:center;}

        /* ✅ Cards */
        .cards {
            margin-top: 25px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 18px;
        }

        .card {
            background: white;
            padding: 18px;
            border-radius: 14px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.06);
        }

        .card h3 {
            margin: 0;
            font-size: 14px;
            color: #64748b;
        }

        .card p {
            font-size: 26px;
            font-weight: 600;
            margin: 10px 0 0;
        }

        .card small {
            color: #16a34a;
            font-weight: 500;
        }

        /* ✅ Tables */
        .styled-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }

        .styled-table th,
        .styled-table td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            text-align: center;
        }

        .styled-table th {
            background: #f1f5f9;
            font-weight: 600;
        }

        /* ✅ View Button */
        .btn-view {
            padding: 7px 14px;
            background: #2563eb;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
        }

        .btn-view:hover {
            background: #1d4ed8;
        }


    </style>
</head>

<body>
<div class="container">

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="brand">
            <span>🎵</span> MusicTrendy
        </div>

        <div class="menu">
            <a href="<%=request.getContextPath()%>/admin/adminLayout.jsp?page=dashboardContent.jsp">🏠 <span>Dashboard</span></a>
            <a href="<%=request.getContextPath()%>/adminProducts">🛒 <span>Products</span></a>
            <a href="<%=request.getContextPath()%>/adminOrders">📦 <span>Orders</span></a>

        </div>


        <div class="menu logout">
            <a href="<%=request.getContextPath()%>/logout">🚪 <span>Logout</span></a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main">

        <div class="topbar">
            <h2>Admin Panel</h2>
            <div class="user-box">
                <div class="avatar"><%= username.substring(0,1).toUpperCase() %></div>
                <div>
                    <strong><%= username %></strong><br>
                    <small>Administrator</small>
                </div>
            </div>
        </div>

        <!-- ✅ Load Dynamic Content -->
        <jsp:include page="<%= pageContent %>" />

    </div>

</div>
</body>
</html>
