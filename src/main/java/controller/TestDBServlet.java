package controller;

import util.DBConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/testdb")
public class TestDBServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        Connection conn = DBConnection.getConnection();

        response.setContentType("text/plain");

        if (conn != null) {
            response.getWriter().println(" Database Connected Successfully!");
        } else {
            response.getWriter().println("❌ Database Connection Failed.");
        }
    }
}
