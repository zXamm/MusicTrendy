package controller;

import dao.ProductDAO;
import model.Product;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/editProduct")
public class EditProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect("products");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        Product p = productDAO.getProductById(id);

        request.setAttribute("product", p);
        request.getRequestDispatcher("admin/editProduct.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect("products");
            return;
        }

        Product p = new Product();
        p.setProductId(Integer.parseInt(request.getParameter("productId")));
        p.setName(request.getParameter("name"));
        p.setCategory(request.getParameter("category"));
        p.setDescription(request.getParameter("description"));
        p.setPrice(Double.parseDouble(request.getParameter("price")));
        p.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        p.setImage(request.getParameter("image"));

        productDAO.updateProduct(p);

        response.sendRedirect("adminProducts");
    }
}
