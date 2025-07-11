package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.UserBean;
import java.io.PrintWriter;

public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        Connection conn = null;

        if (username == null || username.trim().isEmpty() || password == null || password.length() < 6
                || email == null || !email.contains("@")) {
            request.setAttribute("error", "Invalid input: Username cannot be empty, password must be at least 6 characters, and email must be valid.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new Exception("Database connection is null");
            }
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO Users (username, email, password, role) VALUES (?, ?, ?, ?)");
            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setString(4, "user");
            int rows = stmt.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("login.jsp");
            } else {
                request.setAttribute("error", "Registration failed.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(response.getWriter()));
            response.sendRedirect("error.jsp");
        } finally {
            DBConnection.closeConnection(conn);
        }
    }
}