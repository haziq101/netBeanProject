package dao;

import model.RefundBean;
import controller.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RefundDAO {

    public List<RefundBean> getAllRefunds() throws Exception {
        List<RefundBean> refunds = new ArrayList<>();
        Connection conn = DBConnection.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM Refunds");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                RefundBean refund = new RefundBean(
                        rs.getInt("refundId"),
                        rs.getString("requestId"),
                        rs.getString("orderId"),
                        rs.getString("username"),
                        rs.getDouble("amount"),
                        rs.getString("status")
                );
                refunds.add(refund);
            }
        } finally {
            DBConnection.closeConnection(conn);
        }
        return refunds;
    }

    public void createRefund(RefundBean refund) throws Exception {
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO Refunds (requestId, orderId, username, amount, status) VALUES (?, ?, ?, ?, ?)")) {
            stmt.setString(1, refund.getRequestId());
            stmt.setString(2, refund.getOrderId());
            stmt.setString(3, refund.getUsername());
            stmt.setDouble(4, refund.getAmount());
            stmt.setString(5, "Pending");
            stmt.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public void updateRefundStatus(int refundId, String status) throws Exception {
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement(
                "UPDATE Refunds SET status = ? WHERE refundId = ?")) {
            stmt.setString(1, status);
            stmt.setInt(2, refundId);
            stmt.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public void deleteRefund(int refundId) throws Exception {
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM Refunds WHERE refundId = ?")) {
            stmt.setInt(1, refundId);
            stmt.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }
}
