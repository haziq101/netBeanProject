package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.CustomerMessageBean;
import java.io.PrintWriter;

public class CustomerMessageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CustomerMessageBean> messages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new Exception("Database connection is null");
            }
            stmt = conn.prepareStatement("SELECT * FROM CustomerMessages");
            rs = stmt.executeQuery();

            while (rs.next()) {
                CustomerMessageBean msg = new CustomerMessageBean(
                    rs.getInt("messageId"),
                    rs.getString("username") != null ? rs.getString("username") : "",
                    rs.getString("message") != null ? rs.getString("message") : "",
                    rs.getString("status") != null ? rs.getString("status") : ""
                );
                messages.add(msg);
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(response.getWriter()));
            response.sendRedirect("error.jsp");
            return;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                DBConnection.closeConnection(conn);
            } catch (Exception e) {
                e.printStackTrace(new PrintWriter(response.getWriter()));
            }
        }

        request.setAttribute("messages", messages);
        request.getRequestDispatcher("customerMessages.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new Exception("Database connection is null");
            }

            if ("create".equals(action)) {
                String username = request.getParameter("username");
                String message = request.getParameter("message");

                stmt = conn.prepareStatement("INSERT INTO CustomerMessages (username, message, status) VALUES (?, ?, ?)");
                stmt.setString(1, username);
                stmt.setString(2, message);
                stmt.setString(3, "Pending");
                stmt.executeUpdate();
            } else if ("resolve".equals(action)) {
                int messageId = Integer.parseInt(request.getParameter("messageId"));

                stmt = conn.prepareStatement("UPDATE CustomerMessages SET status = ? WHERE messageId = ?");
                stmt.setString(1, "Resolved");
                stmt.setInt(2, messageId);
                stmt.executeUpdate();
            } else if ("delete".equals(action)) {
                int messageId = Integer.parseInt(request.getParameter("messageId"));

                stmt = conn.prepareStatement("DELETE FROM CustomerMessages WHERE messageId = ?");
                stmt.setInt(1, messageId);
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(response.getWriter()));
            response.sendRedirect("error.jsp");
            return;
        } finally {
            try {
                if (stmt != null) stmt.close();
                DBConnection.closeConnection(conn);
            } catch (Exception e) {
                e.printStackTrace(new PrintWriter(response.getWriter()));
            }
        }

        response.sendRedirect("messages");
    }
}