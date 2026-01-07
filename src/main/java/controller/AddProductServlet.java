package controller;

import dao.ProductDAO;
import model.Product;
import model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/addProduct")
public class AddProductServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();

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
        p.setName(request.getParameter("name"));
        p.setCategory(request.getParameter("category"));
        p.setDescription(request.getParameter("description"));
        p.setPrice(Double.parseDouble(request.getParameter("price")));
        p.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        p.setImage(request.getParameter("image"));

        productDAO.addProduct(p);

        response.sendRedirect("adminProducts");
    }
}
