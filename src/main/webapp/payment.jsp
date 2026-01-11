<%@ page import="dao.CartDAO" %>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- CAPTURE SHIPPING DATA ---
    if (request.getMethod().equalsIgnoreCase("POST") && request.getParameter("fullName") != null) {
        session.setAttribute("ship_name", request.getParameter("fullName"));
        session.setAttribute("ship_phone", request.getParameter("phone"));
        session.setAttribute("ship_addr1", request.getParameter("address1"));
        session.setAttribute("ship_addr2", request.getParameter("address2"));
        session.setAttribute("ship_city", request.getParameter("city"));
        session.setAttribute("ship_state", request.getParameter("state"));
        session.setAttribute("ship_postcode", request.getParameter("postcode"));

        String fullAddr = request.getParameter("address1") + ", " +
                (request.getParameter("address2") != null && !request.getParameter("address2").isEmpty() ? request.getParameter("address2") + ", " : "") +
                request.getParameter("city") + " " +
                request.getParameter("postcode") + ", " +
                request.getParameter("state");
        session.setAttribute("ship_addr_full", fullAddr);
    }

    String shipName = (String) session.getAttribute("ship_name");
    String shipAddrFull = (String) session.getAttribute("ship_addr_full");
    String shipPhone = (String) session.getAttribute("ship_phone");

    if (shipName == null) {
        response.sendRedirect("buyerInfo.jsp");
        return;
    }

    CartDAO cartDAO = new CartDAO();
    List<CartItem> cartItems = cartDAO.getCartItems(user.getUserId());
    double total = 0;
    for (CartItem item : cartItems) {
        total += item.getSubtotal();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Secure Payment | MusicTrendy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root { --zoso-green: #4c8a2c; --zoso-dark: #3e7024; --bg-light: #f4f7f6; }
        body { background-color: var(--bg-light); font-family: 'Open Sans', sans-serif; color: #444; }

        .modern-card { background: #fff; border-radius: 16px; box-shadow: 0 10px 40px rgba(0,0,0,0.04); overflow: hidden; height: 100%; }
        .section-header { padding: 20px 30px; border-bottom: 1px solid #f0f0f0; display: flex; align-items: center; justify-content: space-between; }
        .section-title { font-weight: 700; font-size: 1.1rem; margin: 0; color: #333; }

        /* Stepper */
        .stepper { display: flex; justify-content: center; margin: 30px 0 40px; position: relative; }
        .step { display: flex; flex-direction: column; align-items: center; width: 100px; position: relative; z-index: 2; }
        .step-circle { width: 35px; height: 35px; border-radius: 50%; background: #e9ecef; color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 700; }
        .step.active .step-circle { background: var(--zoso-green); box-shadow: 0 4px 10px rgba(76, 138, 44, 0.3); }
        .step-label { font-size: 0.8rem; font-weight: 700; color: #999; margin-top: 5px; }
        .step.active .step-label { color: var(--zoso-green); }
        .progress-track { position: absolute; top: 17px; left: 50%; transform: translateX(-50%); width: 300px; height: 3px; background: #e9ecef; z-index: 1; }
        .progress-fill { height: 100%; width: 75%; background: var(--zoso-green); }

        /* Payment Tabs */
        .nav-pills { gap: 10px; margin-bottom: 25px; }
        .nav-link { border-radius: 12px; font-weight: 600; color: #555; background: #f8f9fa; border: 1px solid #eee; padding: 12px 20px; transition: 0.3s; }
        .nav-link.active { background: var(--zoso-green); color: white; border-color: var(--zoso-green); box-shadow: 0 4px 15px rgba(76, 138, 44, 0.2); }

        /* Bank Grid */
        .bank-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 15px; }
        .bank-option { position: relative; }
        .bank-option input { position: absolute; opacity: 0; cursor: pointer; }
        .bank-card {
            border: 2px solid #f0f0f0; border-radius: 12px; padding: 10px 5px; text-align: center; cursor: pointer; transition: all 0.2s; background: #fff;
            display: flex; flex-direction: column; align-items: center; height: 100px; justify-content: center;
        }
        .bank-card:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.05); border-color: #ddd; }
        .bank-option input:checked + .bank-card { border-color: var(--zoso-green); background: #f4fbf0; color: var(--zoso-dark); box-shadow: 0 4px 12px rgba(76, 138, 44, 0.15); }
        .bank-logo { max-width: 80px; max-height: 40px; object-fit: contain; margin-bottom: 8px; filter: grayscale(100%) opacity(0.7); transition: all 0.3s ease; }
        .bank-option input:checked + .bank-card .bank-logo { filter: grayscale(0%) opacity(1); transform: scale(1.05); }

        /* Credit Card Visual */
        .credit-card-visual {
            background: linear-gradient(135deg, #222, #444);
            color: #fff; border-radius: 15px; padding: 25px; margin-bottom: 25px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2); position: relative; overflow: hidden;
        }
        .cc-chip { width: 50px; height: 35px; background: #d4af37; border-radius: 6px; margin-bottom: 20px; position: relative; }
        .cc-chip::before { content:''; position: absolute; border: 1px solid rgba(0,0,0,0.2); width: 100%; height: 60%; top: 20%; border-left: 0; border-right: 0; }
        .cc-number { font-size: 1.4rem; letter-spacing: 2px; font-family: monospace; margin-bottom: 15px; text-shadow: 0 2px 2px rgba(0,0,0,0.5); }
        .cc-labels { font-size: 0.6rem; text-transform: uppercase; opacity: 0.7; letter-spacing: 1px; }
        .cc-info { font-size: 0.9rem; font-family: monospace; letter-spacing: 1px; text-transform: uppercase; }

        /* Buttons & Layout */
        .btn-pay { background: var(--zoso-green); color: white; border: none; padding: 18px; font-weight: 800; border-radius: 12px; width: 100%; font-size: 1.1rem; letter-spacing: 0.5px; box-shadow: 0 5px 20px rgba(76, 138, 44, 0.25); transition: 0.3s; }
        .btn-pay:hover { background: var(--zoso-dark); transform: translateY(-2px); box-shadow: 0 8px 25px rgba(76, 138, 44, 0.35); }
        .summary-item { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px dashed #eee; font-size: 0.9rem; }
    </style>
</head>
<body>

<div class="container pb-5">

    <div class="stepper">
        <div class="progress-track"><div class="progress-fill"></div></div>
        <div class="step active"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Cart</div></div>
        <div class="step active"><div class="step-circle"><i class="fas fa-check"></i></div><div class="step-label">Details</div></div>
        <div class="step active"><div class="step-circle">3</div><div class="step-label">Payment</div></div>
        <div class="step"><div class="step-circle">4</div><div class="step-label">Receipt</div></div>
    </div>

    <form action="checkout" method="post" id="checkoutForm">
        <input type="hidden" name="totalAmount" value="<%= total %>">

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="modern-card p-4">
                    <h5 class="fw-bold mb-4">Choose Payment Method</h5>

                    <ul class="nav nav-pills" id="pills-tab" role="tablist">
                        <li class="nav-item"><button class="nav-link active" id="pills-online-tab" data-bs-toggle="pill" data-bs-target="#pills-online" type="button" role="tab" onclick="setMethod('online')"><i class="fas fa-university me-2"></i>Online Banking</button></li>
                        <li class="nav-item"><button class="nav-link" id="pills-card-tab" data-bs-toggle="pill" data-bs-target="#pills-card" type="button" role="tab" onclick="setMethod('card')"><i class="far fa-credit-card me-2"></i>Debit / Credit</button></li>
                        <li class="nav-item"><button class="nav-link" id="pills-cod-tab" data-bs-toggle="pill" data-bs-target="#pills-cod" type="button" role="tab" onclick="setMethod('cod')"><i class="fas fa-truck me-2"></i>COD</button></li>
                    </ul>

                    <div class="tab-content pt-2" id="pills-tabContent">

                        <div class="tab-pane fade show active" id="pills-online" role="tabpanel">
                            <div class="alert alert-light border mb-3 small"><i class="fas fa-lock text-success me-2"></i> You will be redirected to your bank's secure portal.</div>
                            <div class="bank-grid">
                                <%
                                    String[] banks = {"Maybank2u", "CIMB Clicks", "Public Bank", "RHB Now", "Hong Leong", "AmOnline", "Bank Islam", "UOB"};
                                    String[] logos = {"maybank.jpg", "cimb.jpg", "publicbank.png", "rhb.png", "hongleong.jpg", "ambank.png", "bankislam.png", "uob.jpg"};
                                    for(int i=0; i<banks.length; i++) {
                                %>
                                <label class="bank-option">
                                    <input type="radio" name="bank" value="<%= banks[i] %>" <%= i==0 ? "checked" : "" %> onchange="updateBankButton(this.value)">
                                    <div class="bank-card">
                                        <img src="images/<%= logos[i] %>" onerror="this.onerror=null; this.src='https://placehold.co/80x40?text=<%= banks[i].split(" ")[0] %>';" alt="<%= banks[i] %>" class="bank-logo">
                                        <div class="small fw-bold text-muted" style="font-size: 0.7rem;"><%= banks[i] %></div>
                                    </div>
                                </label>
                                <% } %>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="pills-card" role="tabpanel">
                            <div class="row">
                                <div class="col-md-6 order-md-2 mb-4">
                                    <div class="credit-card-visual">
                                        <div class="d-flex justify-content-between text-white-50 mb-3">
                                            <span>Debit</span>
                                            <i class="fab fa-cc-visa fa-lg text-white"></i>
                                        </div>
                                        <div class="cc-chip"></div>
                                        <div class="cc-number" id="visualCardNum">•••• •••• •••• ••••</div>
                                        <div class="d-flex justify-content-between mt-4">
                                            <div>
                                                <div class="cc-labels">Card Holder</div>
                                                <div class="cc-info" id="visualName">YOUR NAME</div>
                                            </div>
                                            <div class="text-end">
                                                <div class="cc-labels">Expires</div>
                                                <div class="cc-info" id="visualExpiry">MM/YY</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 order-md-1">
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">Card Number</label>
                                        <input type="text" id="cardNumberInput" class="form-control" placeholder="0000 0000 0000 0000" maxlength="19">
                                    </div>
                                    <div class="row g-2 mb-3">
                                        <div class="col-6">
                                            <label class="form-label small fw-bold">Expiry</label>
                                            <input type="text" id="expiryInput" class="form-control" placeholder="MM/YY" maxlength="5">
                                        </div>
                                        <div class="col-6">
                                            <label class="form-label small fw-bold">CVV</label>
                                            <input type="password" class="form-control" placeholder="123" maxlength="3" oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">Name on Card</label>
                                        <input type="text" id="nameInput" class="form-control" placeholder="FULL NAME">
                                    </div>
                                </div>
                            </div>

                            <div class="bg-light p-3 rounded border mt-2">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6 class="fw-bold m-0 small text-uppercase">Billing Address</h6>
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="sameAddressCheck" onclick="fillBillingAddress()">
                                        <label class="form-check-label small" for="sameAddressCheck">Same as shipping</label>
                                    </div>
                                </div>
                                <div class="row g-2">
                                    <div class="col-12"><input type="text" id="billName" class="form-control form-control-sm" placeholder="Full Name"></div>
                                    <div class="col-12"><input type="text" id="billAddr1" class="form-control form-control-sm" placeholder="Address Line 1"></div>
                                    <div class="col-6"><input type="text" id="billCity" class="form-control form-control-sm" placeholder="City"></div>
                                    <div class="col-3"><input type="text" id="billState" class="form-control form-control-sm" placeholder="State"></div>
                                    <div class="col-3"><input type="text" id="billPostcode" class="form-control form-control-sm" placeholder="Postcode"></div>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="pills-cod" role="tabpanel">
                            <div class="d-flex align-items-center p-4 bg-light rounded border border-warning">
                                <i class="fas fa-truck fa-2x text-warning me-3"></i>
                                <div>
                                    <h6 class="fw-bold mb-1">Cash On Delivery</h6>
                                    <p class="mb-0 small text-muted">Prepare exact cash <strong>RM <%= String.format("%.2f", total) %></strong> upon delivery.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="modern-card">
                    <div class="section-header bg-light">
                        <h6 class="section-title">Order Summary</h6>
                        <a href="buyerInfo.jsp" class="small text-decoration-none">Edit Info</a>
                    </div>
                    <div class="p-4">
                        <div class="alert alert-light border mb-4">
                            <small class="text-muted fw-bold d-block mb-1">SHIPPING TO:</small>
                            <div class="fw-bold text-dark"><%= shipName %></div>
                            <div class="small text-muted text-truncate"><%= shipAddrFull %></div>
                        </div>

                        <div class="mb-4">
                            <% for (CartItem item : cartItems) { %>
                            <div class="summary-item">
                                <span class="text-muted"><%= item.getProductName() %> <small>x<%= item.getQuantity() %></small></span>
                                <span class="fw-bold">RM <%= String.format("%.2f", item.getSubtotal()) %></span>
                            </div>
                            <% } %>
                        </div>

                        <div class="d-flex justify-content-between mb-4 pt-3 border-top">
                            <span class="h5 fw-bold">Total Pay</span>
                            <span class="h4 fw-bold text-danger">RM <%= String.format("%.2f", total) %></span>
                        </div>

                        <button type="button" id="submitBtn" class="btn-pay" onclick="handlePayment()">
                            Proceed to Maybank2u <i class="fas fa-external-link-alt ms-2"></i>
                        </button>

                        <div class="text-center mt-3">
                            <small class="text-muted"><i class="fas fa-shield-alt text-success"></i> SSL Secured Payment</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    // --- Card Number Formatter & Logic ---
    const cardInput = document.getElementById('cardNumberInput');
    const visualNumber = document.getElementById('visualCardNum');
    const nameInput = document.getElementById('nameInput');
    const visualName = document.getElementById('visualName');
    const expiryInput = document.getElementById('expiryInput');
    const visualExpiry = document.getElementById('visualExpiry');

    if(cardInput) {
        cardInput.addEventListener('input', function(e) {
            // 1. Remove non-digits
            let value = e.target.value.replace(/\D/g, '');
            // 2. Limit to 16 digits
            value = value.substring(0, 16);
            // 3. Add spacing every 4 chars
            let formatted = value.match(/.{1,4}/g)?.join(' ') || value;
            e.target.value = formatted;

            // 4. Update Visual
            visualNumber.innerText = formatted.length > 0 ? formatted : '•••• •••• •••• ••••';
        });
    }

    if(nameInput) {
        nameInput.addEventListener('input', function(e) {
            visualName.innerText = e.target.value.toUpperCase() || 'YOUR NAME';
        });
    }

    if(expiryInput) {
        expiryInput.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, ''); // Digits only
            if (value.length >= 3) {
                value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
            e.target.value = value;
            visualExpiry.innerText = value || 'MM/YY';
        });
    }

    // --- Billing Address Logic ---
    const shipName = "<%= session.getAttribute("ship_name") != null ? session.getAttribute("ship_name") : "" %>";
    const shipAddr1 = "<%= session.getAttribute("ship_addr1") != null ? session.getAttribute("ship_addr1") : "" %>";
    const shipCity = "<%= session.getAttribute("ship_city") != null ? session.getAttribute("ship_city") : "" %>";
    const shipState = "<%= session.getAttribute("ship_state") != null ? session.getAttribute("ship_state") : "" %>";
    const shipPostcode = "<%= session.getAttribute("ship_postcode") != null ? session.getAttribute("ship_postcode") : "" %>";

    function fillBillingAddress() {
        const isChecked = document.getElementById('sameAddressCheck').checked;
        if (isChecked) {
            document.getElementById('billName').value = shipName;
            document.getElementById('billAddr1').value = shipAddr1;
            document.getElementById('billCity').value = shipCity;
            document.getElementById('billState').value = shipState;
            document.getElementById('billPostcode').value = shipPostcode;
        } else {
            document.getElementById('billName').value = "";
            document.getElementById('billAddr1').value = "";
            document.getElementById('billCity').value = "";
            document.getElementById('billState').value = "";
            document.getElementById('billPostcode').value = "";
        }
    }

    //  Payment Method Logic
    let currentMethod = 'online';
    let selectedBank = 'Maybank2u';

    function setMethod(method) {
        currentMethod = method;
        updateButtonText();
    }
    function updateBankButton(bank) {
        selectedBank = bank;
        updateButtonText();
    }
    function updateButtonText() {
        const btn = document.getElementById('submitBtn');
        if (currentMethod === 'online') {
            btn.innerHTML = `Proceed to ` + selectedBank + ` <i class="fas fa-external-link-alt ms-2"></i>`;
            btn.style.background = '#4c8a2c';
            btn.style.color = 'white';
        } else if (currentMethod === 'card') {
            btn.innerHTML = `Pay Now RM <%= String.format("%.2f", total) %>`;
            btn.style.background = '#0d6efd';
            btn.style.color = 'white';
        } else {
            btn.innerHTML = `Place Order (COD)`;
            btn.style.background = '#ffc107';
            btn.style.color = '#000';
        }
    }
    function handlePayment() {
        const form = document.getElementById('checkoutForm');
        form.action = (currentMethod === 'online') ? 'bank_payment.jsp' : 'checkout';
        form.submit();
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>