package controller;

import dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already exists!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        boolean success = userDAO.register(name, email, password);

        if (success) {
            request.setAttribute("success", "Account created successfully! Please login.");
        } else {
            request.setAttribute("error", "Registration failed! Try again.");
        }

        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}
