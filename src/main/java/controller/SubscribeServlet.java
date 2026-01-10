package controller;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/subscribe")
public class SubscribeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        HttpSession session = request.getSession();

        // Validate email
        if (email != null && !email.trim().isEmpty() && email.contains("@")) {

            try (Connection conn = DBConnection.getConnection()) {
                // Check if email already exists (Optional logic could go here)
                // For now, we use INSERT IGNORE to skip duplicates without error
                String sql = "INSERT IGNORE INTO subscribers (email) VALUES (?)";

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, email);
                    int rows = ps.executeUpdate();

                    if (rows > 0) {
                        session.setAttribute("popup_type", "success");
                        session.setAttribute("popup_message", "Thanks for subscribing!");
                    } else {
                        // Email likely already exists
                        session.setAttribute("popup_type", "info");
                        session.setAttribute("popup_message", "You are already subscribed.");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("popup_type", "error");
                session.setAttribute("popup_message", "Something went wrong. Try again.");
            }
        } else {
            session.setAttribute("popup_type", "warning");
            session.setAttribute("popup_message", "Please enter a valid email.");
        }

        // Redirect back to the page the user came from
        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : "index.jsp");
    }
}