<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, controller.DBConnection, model.UserBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Return & Refund System</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f6f8; }
        nav { background-color: #3498db; padding: 15px 20px; display: flex; gap: 20px; }
        nav a { color: white; text-decoration: none; font-weight: bold; font-size: 16px; }
        nav a:hover { text-decoration: underline; }
        header { background-color: #3498db; color: white; padding: 20px; text-align: center; }
        .dashboard { display: flex; flex-wrap: wrap; justify-content: center; padding: 40px; gap: 20px; }
        .card { background-color: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); width: 250px; text-align: center; transition: transform 0.2s; }
        .card:hover { transform: scale(1.05); }
        .card h2 { margin: 0; font-size: 36px; color: #3498db; }
        .card p { margin-top: 10px; color: #777; font-size: 16px; }
    </style>
</head>
<body>
    <%
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int totalReturnRequests = 0;
        int refundsProcessed = 0;
        int pendingMessages = 0;

        try {
            conn = DBConnection.getConnection();
            if (conn != null) {
                // Total Return Requests
                stmt = conn.prepareStatement("SELECT COUNT(*) FROM ReturnRequests");
                rs = stmt.executeQuery();
                if (rs.next()) {
                    totalReturnRequests = rs.getInt(1);
                }

                // Refunds Processed (assuming 'Approved' indicates processed)
                stmt.close();
                rs.close();
                stmt = conn.prepareStatement("SELECT COUNT(*) FROM Refunds WHERE status = 'Approved'");
                rs = stmt.executeQuery();
                if (rs.next()) {
                    refundsProcessed = rs.getInt(1);
                }

                // Pending Customer Messages
                stmt.close();
                rs.close();
                stmt = conn.prepareStatement("SELECT COUNT(*) FROM CustomerMessages WHERE status = 'Pending'");
                rs = stmt.executeQuery();
                if (rs.next()) {
                    pendingMessages = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                DBConnection.closeConnection(conn);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>
    <nav>
        <a href="dashboard.jsp" class="logo">Return & Refund System</a>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="returns">Return Requests</a>
        <a href="refunds">Refunds</a>
        <a href="messages">Customer Messages</a>
        <a href="logout">Logout</a>
    </nav>
    <header>
        <h1>Admin Dashboard</h1>
        <p>Overview of return & refund system</p>
    </header>
    <div class="dashboard">
        <div class="card">
            <h2><%= totalReturnRequests %></h2>
            <p>Total Return Requests</p>
        </div>
        <div class="card">
            <h2><%= refundsProcessed %></h2>
            <p>Refunds Processed</p>
        </div>
        <div class="card">
            <h2><%= pendingMessages %></h2>
            <p>Pending Customer Messages</p>
        </div>
    </div>
</body>
</html>