package dao;

import model.ReturnRequestBean;
import controller.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReturnRequestDAO {

    // Get all return requests
    public List<ReturnRequestBean> getAllReturnRequests() throws Exception {
        List<ReturnRequestBean> requests = new ArrayList<>();
        Connection conn = DBConnection.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement(
                "SELECT r.requestId, r.orderId, r.username, o.productName, r.reason, r.status " +
                "FROM ReturnRequests r LEFT JOIN Orders o ON r.orderId = o.orderId");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ReturnRequestBean req = new ReturnRequestBean(
                        rs.getString("requestId"),
                        rs.getString("orderId"),
                        rs.getString("username"),
                        rs.getString("productName"),
                        rs.getString("reason"),
                        rs.getString("status")
                );
                requests.add(req);
            }
        } finally {
            DBConnection.closeConnection(conn);
        }

        return requests;
    }

    // Add a new return request
    public void createReturnRequest(ReturnRequestBean request) throws Exception {
        Connection conn = DBConnection.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO ReturnRequests (requestId, orderId, username, productName, reason, status) VALUES (?, ?, ?, ?, ?, ?)")) {

            stmt.setString(1, request.getRequestId());
            stmt.setString(2, request.getOrderId());
            stmt.setString(3, request.getUsername());
            stmt.setString(4, request.getProductName());
            stmt.setString(5, request.getReason());
            stmt.setString(6, request.getStatus());
            stmt.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // Update return request status
    public void updateReturnRequestStatus(String requestId, String status) throws Exception {
        Connection conn = DBConnection.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement(
                "UPDATE ReturnRequests SET status = ? WHERE requestId = ?")) {
            stmt.setString(1, status);
            stmt.setString(2, requestId);
            stmt.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // Delete a return request
    public void deleteReturnRequest(String requestId) throws Exception {
        Connection conn = DBConnection.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM ReturnRequests WHERE requestId = ?")) {
            stmt.setString(1, requestId);
            stmt.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }
}
