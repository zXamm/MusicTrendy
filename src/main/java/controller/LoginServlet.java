package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // --- NEW CODE STARTS HERE ---
            // 1. Set the success message in the session
            session.setAttribute("popup_type", "success");
            session.setAttribute("popup_message", "Login Successful! Welcome back.");
            // --- NEW CODE ENDS HERE ---

            if ("admin".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/adminDashboard");
            } else {
                // The popup will show on the 'products' page because we are redirecting there
                response.sendRedirect("products");
            }

        } else {
            // You can also add a popup for failure if you want
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
