package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.UserBean;
import controller.DBConnection;

public class UserDAO {

    // ✅ Check login credentials
    public UserBean checkLogin(String email, String password) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        UserBean user = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new Exception("Database connection failed.");
            }

            stmt = conn.prepareStatement("SELECT username, email, role FROM Users WHERE email = ? AND password = ?");
            stmt.setString(1, email);
            stmt.setString(2, password);
            rs = stmt.executeQuery();

            if (rs.next()) {
                user = new UserBean();
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            DBConnection.closeConnection(conn);
        }
        return user;
    }

    // ✅ Register new user
    public boolean registerUser(UserBean user) throws Exception {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean result = false;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new Exception("Database connection failed.");
            }

            stmt = conn.prepareStatement("INSERT INTO Users (username, email, password, role) VALUES (?, ?, ?, ?)");
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());
            int rowsInserted = stmt.executeUpdate();

            result = rowsInserted > 0; // return true if insertion succeeded
        } finally {
            if (stmt != null) stmt.close();
            DBConnection.closeConnection(conn);
        }
        return result;
    }
}
