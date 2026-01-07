package controller;

import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // TEMPORARY USER ID (until login system is built)
        // int userId = 2;

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        model.User user = (model.User) session.getAttribute("user");
        int userId = user.getUserId();


        int productId = Integer.parseInt(request.getParameter("productId"));

        int cartId = cartDAO.getOrCreateCart(userId);
        cartDAO.addToCart(cartId, productId);

        response.sendRedirect("products");
    }
}
