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
import model.RefundBean;
import java.io.PrintWriter;

public class RefundServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<RefundBean> refunds = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new Exception("Database connection is null");
            }
            stmt = conn.prepareStatement("SELECT * FROM Refunds");
            rs = stmt.executeQuery();

            while (rs.next()) {
                RefundBean refund = new RefundBean(
                    rs.getInt("refundId"),
                    rs.getString("requestId") != null ? rs.getString("requestId") : "",
                    rs.getString("orderId") != null ? rs.getString("orderId") : "",
                    rs.getString("username") != null ? rs.getString("username") : "",
                    rs.getDouble("amount"),
                    rs.getString("status") != null ? rs.getString("status") : ""
                );
                refunds.add(refund);
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

        request.setAttribute("refunds", refunds);
        request.getRequestDispatcher("refunds.jsp").forward(request, response);
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
                String requestId = request.getParameter("requestId");
                String orderId = request.getParameter("orderId");
                String username = request.getParameter("username");
                double amount = Double.parseDouble(request.getParameter("amount"));

                // Detailed logging for debugging
                System.out.println("Action: create");
                System.out.println("requestId: " + requestId);
                System.out.println("orderId: " + orderId);
                System.out.println("username: " + username);
                System.out.println("amount: " + amount);

                if (requestId == null || orderId == null || username == null || request.getParameter("amount") == null ||
                    requestId.trim().isEmpty() || orderId.trim().isEmpty() || username.trim().isEmpty()) {
                    throw new Exception("One or more required fields are missing or empty: requestId=" + requestId + ", orderId=" + orderId + ", username=" + username + ", amount=" + request.getParameter("amount"));
                }

                stmt = conn.prepareStatement("INSERT INTO Refunds (requestId, orderId, username, amount, status) VALUES (?, ?, ?, ?, ?)");
                stmt.setString(1, requestId);
                stmt.setString(2, orderId);
                stmt.setString(3, username);
                stmt.setDouble(4, amount);
                stmt.setString(5, "Pending");
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    throw new Exception("Failed to insert refund.");
                }
            } else if ("update".equals(action)) {
                int refundId = Integer.parseInt(request.getParameter("refundId"));
                String status = request.getParameter("status");

                stmt = conn.prepareStatement("UPDATE Refunds SET status = ? WHERE refundId = ?");
                stmt.setString(1, status);
                stmt.setInt(2, refundId);
                stmt.executeUpdate();
            } else if ("delete".equals(action)) {
                int refundId = Integer.parseInt(request.getParameter("refundId"));

                stmt = conn.prepareStatement("DELETE FROM Refunds WHERE refundId = ?");
                stmt.setInt(1, refundId);
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace(new PrintWriter(response.getWriter()));
            System.out.println("Exception in doPost: " + e.getMessage());
            response.sendRedirect("error.jsp?message=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
            return;
        } finally {
            try {
                if (stmt != null) stmt.close();
                DBConnection.closeConnection(conn);
            } catch (Exception e) {
                e.printStackTrace(new PrintWriter(response.getWriter()));
            }
        }

        response.sendRedirect("refunds");
    }
}