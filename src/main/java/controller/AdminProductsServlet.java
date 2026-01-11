package controller;

import dao.ProductDAO;
import model.Product;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/adminProducts")
public class AdminProductsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Load products from DB using DAO
        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.getAllProducts();

        // ✅ Put into request
        request.setAttribute("products", products);

        // ✅ Forward to layout (NOT directly to productsContent.jsp)
        request.getRequestDispatcher("/admin/adminLayout.jsp?page=productsContent.jsp")
                .forward(request, response);
    }
}

    