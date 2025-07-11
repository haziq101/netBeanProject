package dao;

import model.CustomerMessageBean;
import controller.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerMessageDAO {

    // Get all customer messages
    public List<CustomerMessageBean> getAllMessages() throws Exception {
        List<CustomerMessageBean> messages = new ArrayList<>();
        Connection conn = DBConnection.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM CustomerMessages");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                CustomerMessageBean msg = new CustomerMessageBean(
                        rs.getInt("messageId"),
                        rs.getString("username"),
                        rs.getString("message"),
                        rs.getString("status")
                );
                messages.add(msg);
            }
        } finally {
            DBConnection.closeConnection(conn);
        }

        return messages;
    }

    // Add a new customer message
    public void createMessage(CustomerMessageBean message) throws Exception {
        Connection conn = DBConnection.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO CustomerMessages (username, message, status) VALUES (?, ?, ?)")) {
            stmt.setString(1, message.getUsername());
            stmt.setString(2, message.getMessage());
            stmt.setString(3, "Pending");
            stmt.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // Mark a message as resolved
    public void resolveMessage(int messageId) throws Exception {
        Connection conn = DBConnection.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement(
                "UPDATE CustomerMessages SET status = ? WHERE messageId = ?")) {
            stmt.setString(1, "Resolved");
            stmt.setInt(2, messageId);
            stmt.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // Delete a customer message
    public void deleteMessage(int messageId) throws Exception {
        Connection conn = DBConnection.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM CustomerMessages WHERE messageId = ?")) {
            stmt.setInt(1, messageId);
            stmt.executeUpdate();
        } finally {
            DBConnection.closeConnection(conn);
        }
    }
}
