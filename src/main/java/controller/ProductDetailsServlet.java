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

        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(productId);

        request.setAttribute("product", product);
        request.getRequestDispatcher("productDetails.jsp").forward(request, response);
    }
}
