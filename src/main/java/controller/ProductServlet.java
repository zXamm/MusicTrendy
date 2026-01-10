package controller;

import dao.ProductDAO;
import model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        String brand = request.getParameter("brand");
        String searchQuery = request.getParameter("search");

        List<Product> productList;

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            // Case 1: Search Bar
            productList = productDAO.searchProducts(searchQuery);
            request.setAttribute("pageTitle", "Search Results: " + searchQuery);
        } else if (category != null && !category.trim().isEmpty()) {
            // Case 2: Shop by Category
            if ("Accessories".equalsIgnoreCase(category)) {
                // Fetch the group of accessories (Amps, Mics, Pedals, etc.)
                productList = productDAO.getAccessoriesGroup();
                request.setAttribute("pageTitle", "Category: Accessories");
            } else {
                // Standard behavior for other categories
                productList = productDAO.getProductsByCategory(category);
                request.setAttribute("pageTitle", "Category: " + category.substring(0, 1).toUpperCase() + category.substring(1));
            }
        } else if (brand != null && !brand.trim().isEmpty()) {
            // Case 3: Shop by Brand
            productList = productDAO.getProductsByBrand(brand);
            request.setAttribute("pageTitle", "Brand: " + brand.substring(0, 1).toUpperCase() + brand.substring(1));
        } else {
            // Case 4: View All
            productList = productDAO.getAllProducts();
            request.setAttribute("pageTitle", "Our Catalog");
        }

        request.setAttribute("products", productList);
        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
}