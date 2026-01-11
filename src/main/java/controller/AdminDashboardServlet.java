package controller;

import dao.OrderDAO;
import dao.ProductDAO;
import dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.ResultSet;


@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // optional: check role
        // User user = (User) session.getAttribute("user");
        // if (!"admin".equals(user.getRole())) { response.sendRedirect("products"); return; }

        try {
            int totalOrders = orderDAO.getTotalOrders();
            int totalCustomers = userDAO.getTotalCustomers();
            int productCount = productDAO.getTotalProducts();
            int lowStockCount = productDAO.getLowStockCount(5);   // implement (threshold 5)


            ResultSet topSelling = orderDAO.getTopSellingProducts(4);


            request.setAttribute("topSelling", topSelling);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("productCount", productCount);
            request.setAttribute("lowStockCount", lowStockCount);

            request.getRequestDispatcher("/admin/adminLayout.jsp?page=dashboardContent.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Cannot load admin dashboard.");
        }
    }
}
