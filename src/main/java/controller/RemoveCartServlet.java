package controller;

import dao.CartDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/removeItem")
public class RemoveCartServlet extends HttpServlet {

    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));

        cartDAO.removeItem(cartItemId);

        response.sendRedirect("cart");
    }
}
