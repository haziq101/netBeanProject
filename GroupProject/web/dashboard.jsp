<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, controller.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Return & Refund System</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: url('img/background.jpg') repeat;
            background-size: 300px auto; /* Smaller background */
            color: #fff;
            display: flex;
        }

        /* Sidebar Navigation */
        nav {
            width: 220px;
            height: 100vh;
            background-color: rgba(0, 0, 0, 0.8);
            padding-top: 20px;
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            left: 0;
        }

        nav .logo {
            text-align: center;
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 30px;
            color: #fff;
        }

        nav a {
            color: #fff;
            text-decoration: none;
            padding: 12px 20px;
            display: block;
            font-size: 16px;
            transition: background 0.3s, padding-left 0.3s;
        }

        nav a:hover {
            background: rgba(255, 255, 255, 0.1);
            padding-left: 30px;
        }

        /* Main content area */
        .main-content {
            margin-left: 220px;
            padding: 30px;
            flex-grow: 1;
        }

        .header-box {
            background-color: rgba(255, 255, 255, 0.85);
            color: #333;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
            padding: 30px;
            text-align: center;
            margin-bottom: 30px;
        }

        .header-box h1 {
            font-size: 36px;
            color: #3498db;
            margin: 0;
        }

        .header-box p {
            font-size: 16px;
            color: #555;
            margin-top: 10px;
        }

        .dashboard {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 30px;
        }

        .card {
            background-color: rgba(255, 255, 255, 0.85);
            color: #333;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
            width: 250px;
            padding: 30px;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.4);
        }

        .card h2 {
            font-size: 40px;
            color: #3498db;
            margin: 0;
        }

        .card p {
            margin-top: 10px;
            font-size: 16px;
            color: #555;
        }
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
            stmt = conn.prepareStatement("SELECT COUNT(*) FROM ReturnRequests");
            rs = stmt.executeQuery();
            if (rs.next()) {
                totalReturnRequests = rs.getInt(1);
            }

            stmt.close();
            rs.close();
            stmt = conn.prepareStatement("SELECT COUNT(*) FROM Refunds WHERE status = 'Approved'");
            rs = stmt.executeQuery();
            if (rs.next()) {
                refundsProcessed = rs.getInt(1);
            }

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
    <div class="logo">Return & Refund</div>
    <a href="dashboard.jsp">Dashboard</a>
    <a href="returns">Return Requests</a>
    <a href="refunds">Refunds</a>
    <a href="messages">Customer Messages</a>
    <a href="logout">Logout</a>
</nav>

<div class="main-content">
    <div class="header-box">
        <h1>Admin Dashboard</h1>
        <p>Monitor your return & refund system at a glance</p>
    </div>

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
</div>

</body>
</html>
