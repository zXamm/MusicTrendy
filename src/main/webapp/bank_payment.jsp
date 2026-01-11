<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String bankName = request.getParameter("bank");
    String amount = request.getParameter("totalAmount");
    if (bankName == null) bankName = "Bank Gateway";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Secure Payment Gateway</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f0f2f5; height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Arial', sans-serif; }
        .gateway-card { width: 100%; max-width: 450px; background: white; border-radius: 8px; box-shadow: 0 8px 30px rgba(0,0,0,0.1); overflow: hidden; }
        .gateway-header { background: #333; color: white; padding: 20px; text-align: center; }
        .gateway-body { padding: 30px; }
        .secure-badge { text-align: center; color: #4c8a2c; font-size: 0.8rem; margin-bottom: 20px; background: #e8f5e9; padding: 8px; border-radius: 4px; }
        .amount-display { text-align: center; font-size: 1.5rem; font-weight: bold; margin-bottom: 25px; color: #333; }
        .btn-pay { background: #28a745; color: white; width: 100%; padding: 12px; border: none; font-weight: bold; border-radius: 5px; font-size: 1rem; }
        .btn-pay:hover { background: #218838; }
        .loader { display: none; text-align: center; padding: 20px; }
    </style>
</head>
<body>

<div class="gateway-card" id="loginForm">
    <div class="gateway-header">
        <h4 class="m-0"><i class="fas fa-university me-2"></i> <%= bankName %></h4>
        <small>Secure FPX Payment Gateway</small>
    </div>

    <div class="gateway-body">
        <div class="secure-badge">
            <i class="fas fa-lock"></i> 256-Bit TLS Secured Connection
        </div>

        <div class="text-center text-muted small">Merchant: MusicTrendy Sdn Bhd</div>
        <div class="amount-display">RM <%= amount %></div>

        <form action="checkout" method="post" onsubmit="return showLoader()">
            <div class="mb-3">
                <label class="form-label fw-bold small text-muted">Username</label>
                <div class="input-group">
                    <span class="input-group-text bg-white"><i class="fas fa-user text-muted"></i></span>
                    <input type="text" class="form-control" required placeholder="Enter username">
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-bold small text-muted">Password</label>
                <div class="input-group">
                    <span class="input-group-text bg-white"><i class="fas fa-key text-muted"></i></span>
                    <input type="password" class="form-control" required placeholder="Enter password">
                </div>
            </div>

            <button type="submit" class="btn-pay">
                Pay Now <i class="fas fa-chevron-right ms-2"></i>
            </button>

            <div class="text-center mt-3">
                <a href="payment.jsp" class="text-muted small text-decoration-none">Cancel Transaction</a>
            </div>
        </form>
    </div>
</div>

<div class="gateway-card loader" id="processingScreen">
    <div class="py-5">
        <div class="spinner-border text-success" style="width: 3rem; height: 3rem;" role="status"></div>
        <h5 class="mt-3 fw-bold">Processing Payment...</h5>
        <p class="text-muted small">Please do not close this window.</p>
    </div>
</div>

<script>
    function showLoader() {
        document.getElementById('loginForm').style.display = 'none';
        document.getElementById('processingScreen').style.display = 'block';
        return true; // Allow form submission to checkout servlet
    }
</script>

</body>
</html>