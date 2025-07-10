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
import model.ReturnRequestBean;
import java.io.PrintWriter;

public class ReturnRequestServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ReturnRequestBean> requests = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new Exception("Database connection is null");
            }
            stmt = conn.prepareStatement(
                "SELECT r.requestId, r.orderId, r.username, o.productName, r.reason, r.status " +
                "FROM ReturnRequests r LEFT JOIN Orders o ON r.orderId = o.orderId"
            );
            rs = stmt.executeQuery();

            while (rs.next()) {
                ReturnRequestBean req = new ReturnRequestBean(
                    rs.getString("requestId"),
                    rs.getString("orderId") != null ? rs.getString("orderId") : "",
                    rs.getString("username") != null ? rs.getString("username") : "",
                    rs.getString("productName") != null ? rs.getString("productName") : "",
                    rs.getString("reason") != null ? rs.getString("reason") : "",
                    rs.getString("status") != null ? rs.getString("status") : ""
                );
                requests.add(req);
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

        request.setAttribute("requests", requests);
        request.getRequestDispatcher("returnRequests.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new Exception("Database connection is null");
            }

            if ("create".equals(action)) {
                String requestId = "RR" + String.format("%03d", (int) (Math.random() * 1000));
                String orderId = request.getParameter("orderId");
                String username = request.getParameter("username");
                String productName = request.getParameter("productName");
                String reason = request.getParameter("reason");

                // Detailed logging for debugging
                System.out.println("Action: create");
                System.out.println("Generated requestId: " + requestId);
                System.out.println("orderId: " + orderId);
                System.out.println("username: " + username);
                System.out.println("productName: " + productName);
                System.out.println("reason: " + reason);

                // Validate all parameters
                if (orderId == null || username == null || productName == null || reason == null ||
                    orderId.trim().isEmpty() || username.trim().isEmpty() || productName.trim().isEmpty() || reason.trim().isEmpty()) {
                    throw new Exception("One or more required fields are missing or empty: orderId=" + orderId + ", username=" + username + ", productName=" + productName + ", reason=" + reason);
                }

                // Check for duplicate requestId
                stmt = conn.prepareStatement("SELECT COUNT(*) FROM ReturnRequests WHERE requestId = ?");
                stmt.setString(1, requestId);
                rs = stmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    throw new Exception("Duplicate requestId generated: " + requestId);
                }
                rs.close();
                stmt.close();

                // Execute insert
                stmt = conn.prepareStatement("INSERT INTO ReturnRequests (requestId, orderId, username, productName, reason, status) VALUES (?, ?, ?, ?, ?, ?)");
                stmt.setString(1, requestId);
                stmt.setString(2, orderId);
                stmt.setString(3, username);
                stmt.setString(4, productName);
                stmt.setString(5, reason);
                stmt.setString(6, "Pending");
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    throw new Exception("Failed to insert return request.");
                }
            } else if ("update".equals(action)) {
                String requestId = request.getParameter("requestId");
                String status = request.getParameter("status");

                stmt = conn.prepareStatement("UPDATE ReturnRequests SET status = ? WHERE requestId = ?");
                stmt.setString(1, status);
                stmt.setString(2, requestId);
                stmt.executeUpdate();
            } else if ("delete".equals(action)) {
                String requestId = request.getParameter("requestId");

                stmt = conn.prepareStatement("DELETE FROM ReturnRequests WHERE requestId = ?");
                stmt.setString(1, requestId);
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(response.getWriter()));
            System.out.println("Exception in doPost: " + e.getMessage());
            response.sendRedirect("error.jsp?message=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
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

        response.sendRedirect("returns");
    }
}