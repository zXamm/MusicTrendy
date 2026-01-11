package controller;

import dao.ProductDAO;
import model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/productDetails")
public class ProductDetailsServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the ID safely (parse can fail if id is missing)
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("products"); // Redirect if no ID provided
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);
            Product product = productDAO.getProductById(productId);

            request.setAttribute("product", product);

            // --- THE FIX IS HERE ---
            // Added "/" before productDetails.jsp
            request.getRequestDispatcher("/productDetails.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("products"); // Handle invalid ID format
        }
    }
}