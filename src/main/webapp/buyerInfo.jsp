<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="dao.CartDAO" %>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>

<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  CartDAO cartDAO = new CartDAO();
  List<CartItem> cartItems = cartDAO.getCartItems(user.getUserId());
  double total = 0;
  if (cartItems != null) {
    for (CartItem item : cartItems) {
      total += item.getSubtotal();
    }
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Shipping Details | MusicTrendy</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
  <style>
    :root { --zoso-green: #4c8a2c; --zoso-dark: #3e7024; --bg-light: #f4f7f6; }
    body { background-color: var(--bg-light); font-family: 'Open Sans', sans-serif; color: #444; }

    .modern-card { background: #fff; border-radius: 16px; box-shadow: 0 10px 40px rgba(0,0,0,0.04); border: none; overflow: hidden; }
    .card-header-custom { background: #fff; border-bottom: 1px solid #f0f0f0; padding: 20px 30px; }
    .form-control, .form-select { border-radius: 8px; padding: 12px 15px; border: 1px solid #e0e0e0; background: #fdfdfd; transition: all 0.3s; }
    .form-control:focus, .form-select:focus { box-shadow: 0 0 0 3px rgba(76, 138, 44, 0.1); border-color: var(--zoso-green); background: #fff; }
    .form-label { font-weight: 600; font-size: 0.85rem; color: #666; margin-bottom: 6px; }
    .input-group-text { background: #f8f9fa; border-color: #e0e0e0; color: #888; border-radius: 8px 0 0 8px; }

    .stepper { display: flex; justify-content: center; margin: 30px 0 40px; position: relative; }
    .step { display: flex; flex-direction: column; align-items: center; width: 100px; position: relative; z-index: 2; }
    .step-circle { width: 35px; height: 35px; border-radius: 50%; background: #e9ecef; color: #fff; display: flex; align-items: center; justify-content: center; font-weight: 700; transition: 0.3s; margin-bottom: 8px; }
    .step.active .step-circle { background: var(--zoso-green); box-shadow: 0 4px 10px rgba(76, 138, 44, 0.3); }
    .step-label { font-size: 0.8rem; font-weight: 700; color: #999; }
    .step.active .step-label { color: var(--zoso-green); }
    .progress-track { position: absolute; top: 17px; left: 50%; transform: translateX(-50%); width: 200px; height: 3px; background: #e9ecef; z-index: 1; }
    .progress-fill { height: 100%; width: 50%; background: var(--zoso-green); transition: width 0.3s ease; }

    /* Summary Image Box */
    .summary-box { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 20px rgba(0,0,0,0.03); }
    .mini-item { display: flex; align-items: center; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #f8f8f8; }
    .mini-item:last-child { border-bottom: none; }
    .mini-img {
      width: 60px; height: 60px; border-radius: 8px; background: #fff;
      border: 1px solid #eee; display: flex; align-items: center; justify-content: center;
      margin-right: 15px; overflow: hidden; padding: 5px;
    }
    .mini-img img { max-width: 100%; max-height: 100%; object-fit: contain; }

    .btn-next { background: var(--zoso-green); color: white; border: none; padding: 15px; font-weight: 700; border-radius: 10px; width: 100%; font-size: 1rem; letter-spacing: 0.5px; box-shadow: 0 5px 15px rgba(76, 138, 44, 0.2); transition: 0.3s; }
    .btn-next:hover { background: var(--zoso-dark); transform: translateY(-2px); box-shadow: 0 8px 20px rgba(76, 138, 44, 0.3); }
  </style>
</head>
<body>

<div class="container pb-5">
  <div class="stepper">
    <div class="progress-track"><div class="progress-fill"></div></div>
    <div class="step active">
      <div class="step-circle"><i class="fas fa-check"></i></div>
      <div class="step-label">Cart</div>
    </div>
    <div class="step active">
      <div class="step-circle">2</div>
      <div class="step-label">Details</div>
    </div>
    <div class="step">
      <div class="step-circle">3</div>
      <div class="step-label">Payment</div>
    </div>
  </div>

  <form action="payment.jsp" method="post">
    <div class="row g-4 justify-content-center">
      <div class="col-lg-7">
        <div class="modern-card">
          <div class="card-header-custom">
            <h5 class="m-0 fw-bold"><i class="fas fa-map-marker-alt text-success me-2"></i> Shipping Address</h5>
          </div>
          <div class="p-4">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">Full Name</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="fas fa-user"></i></span>
                  <input type="text" name="fullName" class="form-control" value="<%= user.getName() %>" required placeholder="Enter recipient name">
                </div>
              </div>
              <div class="col-md-6">
                <label class="form-label">Phone Number</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="fas fa-phone"></i></span>
                  <input type="tel" name="phone" class="form-control" placeholder="e.g. 012-345 6789" required>
                </div>
              </div>
              <div class="col-12 mt-3">
                <label class="form-label">Street Address</label>
                <input type="text" name="address1" class="form-control mb-2" placeholder="House number and street name" required>
                <input type="text" name="address2" class="form-control" placeholder="Apartment, suite, unit, etc. (Optional)">
              </div>
              <div class="col-md-5">
                <label class="form-label">City</label>
                <input type="text" name="city" class="form-control" required>
              </div>
              <div class="col-md-4">
                <label class="form-label">State</label>
                <select name="state" class="form-select" required>
                  <option value="" selected disabled>Select...</option>
                  <option>Johor</option><option>Kedah</option><option>Kelantan</option><option>Melaka</option>
                  <option>Negeri Sembilan</option><option>Pahang</option><option>Penang</option><option>Perak</option>
                  <option>Perlis</option><option>Sabah</option><option>Sarawak</option><option>Selangor</option>
                  <option>Terengganu</option><option>Kuala Lumpur</option><option>Putrajaya</option><option>Labuan</option>
                </select>
              </div>
              <div class="col-md-3">
                <label class="form-label">Postcode</label>
                <input type="text" name="postcode" class="form-control" required>
              </div>
            </div>
            <div class="mt-4 pt-3 border-top">
              <label class="form-label text-muted mb-2">Contact Email (for receipt)</label>
              <input type="email" name="email" class="form-control bg-light" value="<%= user.getEmail() %>" readonly>
            </div>
          </div>
        </div>
      </div>

      <div class="col-lg-4">
        <div class="summary-box sticky-top" style="top: 20px; z-index: 1;">
          <h5 class="fw-bold mb-4">Order Summary</h5>
          <div class="mb-3" style="max-height: 250px; overflow-y: auto;">
            <% if (cartItems != null) {
              for (CartItem item : cartItems) {
                // Now this will work because backend is fixed
                String imgPath = (item.getImage() != null && !item.getImage().isEmpty())
                        ? item.getImage()
                        : "https://via.placeholder.com/60?text=No+Img";
            %>
            <div class="mini-item">
              <div class="mini-img">
                <img src="<%= imgPath %>" alt="Product Image">
              </div>
              <div class="flex-grow-1">
                <div class="small fw-bold text-dark"><%= item.getProductName() %></div>
                <div class="text-muted" style="font-size: 0.8rem;">Qty: <%= item.getQuantity() %></div>
              </div>
              <div class="fw-bold" style="font-size: 0.9rem;">RM <%= String.format("%.2f", item.getSubtotal()) %></div>
            </div>
            <%   }
            } %>
          </div>

          <div class="d-flex justify-content-between mb-2 text-muted">
            <span>Subtotal</span>
            <span>RM <%= String.format("%.2f", total) %></span>
          </div>
          <div class="d-flex justify-content-between mb-4 text-success">
            <span>Shipping</span>
            <span class="fw-bold">FREE</span>
          </div>

          <div class="d-flex justify-content-between align-items-center mb-4 pt-3 border-top">
            <span class="h5 fw-bold mb-0">Total</span>
            <span class="h4 fw-bold text-danger mb-0">RM <%= String.format("%.2f", total) %></span>
          </div>

          <button type="submit" class="btn-next">
            Continue to Payment <i class="fas fa-chevron-right ms-2"></i>
          </button>
          <div class="text-center mt-3">
            <a href="index.jsp" class="text-muted small text-decoration-none">Back to Cart</a>
          </div>
        </div>
      </div>
    </div>
  </form>
</div>

</body>
</html>