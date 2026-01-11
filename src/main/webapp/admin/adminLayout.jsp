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
        /* Sidebar (beautified to match main content) */
        .sidebar{
            width:240px;
            padding:20px;
            display:flex;
            flex-direction:column;

            position:fixed;
            top:0; left:0;
            height:100vh;

            /* ✅ image background */
            background-image: url("<%=request.getContextPath()%>/images/sidebar.jpg");
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;

            border-right: 1px solid rgba(255,255,255,0.15);
            overflow: hidden;
        }

        /* ✅ dark overlay for readability */
        .sidebar::before{
            content:"";
            position:absolute;
            inset:0;
            background: rgba(15, 23, 42, 0.85); /* dark overlay */
            backdrop-filter: blur(2px);         /* optional */
        }

        /* ✅ make sidebar content appear above overlay */
        .sidebar > *{
            position: relative;
            z-index: 1;
        }

        /* menu text becomes white on image */
        .menu a{ color: #fff; }
        .menu a:hover{ background: rgba(255,255,255,0.12); }
        .menu a.active{
            background: rgba(22,163,74,0.25);
            border: 1px solid rgba(22,163,74,0.35);
            color: #fff;
        }
        .brand{
            display:flex;
            align-items:center;
            gap:12px;
            margin-bottom: 28px;
            justify-content: center;

        }

        /* logo image */
        .brand-logo{
            width: 170px;          /* adjust size */
            max-width: 100%;
            height: auto;
            object-fit: contain;

            /* make it pop on dark sidebar */
            filter: invert(1) brightness(2) drop-shadow(0 8px 16px rgba(0,0,0,0.35));
        }

        .brand span{ font-size:26px; }

        /* Menu items */
        .menu{
            margin-top: 14px;
        }

        .menu a{
            display:flex;
            align-items:center;
            gap:12px;
            justify-content: center;

            width: 100%;                 /* ✅ full button width */
            box-sizing: border-box;

            padding:12px 14px;
            margin:10px 0;
            border-radius:14px;


            text-decoration:none;
            color:#fff;
            font-weight:700;

            background: rgba(255,255,255,0.10);        /* ✅ button background */
            border: 1px solid rgba(255,255,255,0.18);  /* ✅ outline */
            box-shadow: 0 6px 16px rgba(0,0,0,0.22);    /* ✅ button depth */

            transition: .2s;
            text-shadow: 0 2px 10px rgba(0,0,0,0.65);
        }

        /* Hover effect */
        .menu a:hover{
            transform: translateY(-1px);
            background: rgba(255,255,255,0.16);
            border-color: rgba(255,255,255,0.28);
        }

        /* Active button */
        .menu a.active{
            background: rgba(22,163,74,0.35);          /* ✅ theme green */
            border: 1px solid rgba(22,163,74,0.60);
            box-shadow: 0 8px 20px rgba(0,0,0,0.28);
        }

        /* Logout button style */
        .menu.logout a{
            margin-top: 18px;
            justify-content: center;
            background: rgba(15,23,42,0.55);
            border: 1px solid rgba(255,255,255,0.20);
        }
        .menu.logout a:hover{
            background: rgba(15,23,42,0.70);
        }


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
            <img class="brand-logo"
                 src="<%=request.getContextPath()%>/images/MusicTrendyLogo.png"
                 alt="MusicTrendy Logo">
        </div>


        <div class="menu">
            <a href="<%=request.getContextPath()%>/adminDashboard" > <span>Dashboard</span></a>
            <a href="<%=request.getContextPath()%>/adminProducts"> <span>Products</span></a>
            <a href="<%=request.getContextPath()%>/adminOrders"> <span>Orders</span></a>

        </div>


        <div class="menu logout">
            <a href="<%=request.getContextPath()%>/logout"> <span>Logout</span></a>
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

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
        toast: true,
        position: 'top-end'
    });
</script>
<%
        // 3. Remove attributes so the popup doesn't show again on refresh
        session.removeAttribute("popup_type");
        session.removeAttribute("popup_message");
    }
%>


</body>
</html>
