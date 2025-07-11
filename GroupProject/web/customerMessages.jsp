<%@ page import="java.util.List, model.CustomerMessageBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Messages - Return & Refund System</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: url('img/background customermessage.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            color: #333;
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

        /* Main Content */
        .main-content {
            margin-left: 220px; /* Same width as sidebar */
            padding: 30px;
            flex-grow: 1;
        }

        h2 {
            text-align: center;
            font-size: 36px;
            color: #fff;
            text-shadow: 1px 1px 6px rgba(0, 0, 0, 0.7);
            margin-bottom: 30px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            font-size: 15px;
        }

        th {
            background-color: #3498db;
            color: white;
        }

        tr:hover {
            background-color: rgba(0, 0, 0, 0.05);
        }

        .btn {
            padding: 6px 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }

        .btn.reject {
            background-color: #dc3545;
        }

        .btn:hover {
            opacity: 0.9;
        }

    </style>
</head>
<body>
    <nav>
        <div class="logo">Return & Refund</div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="returns">Return Requests</a>
        <a href="refunds">Refunds</a>
        <a href="messages">Customer Messages</a>
        <a href="logout">Logout</a>
    </nav>

    <div class="main-content">
        <h2>Customer Messages</h2>
        <table>
            <thead>
                <tr>
                    <th>Message ID</th>
                    <th>Username</th>
                    <th>Message</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<CustomerMessageBean> messages = (List<CustomerMessageBean>) request.getAttribute("messages");
                    if (messages != null && !messages.isEmpty()) {
                        for (CustomerMessageBean msg : messages) { 
                %>
                    <tr>
                        <td><%= msg.getMessageId() %></td>
                        <td><%= msg.getUsername() != null ? msg.getUsername() : "" %></td>
                        <td><%= msg.getMessage() != null ? msg.getMessage() : "" %></td>
                        <td><%= msg.getStatus() != null ? msg.getStatus() : "" %></td>
                        <td>
                            <form action="messages" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="resolve">
                                <input type="hidden" name="messageId" value="<%= msg.getMessageId() %>">
                                <input type="submit" value="Resolve" class="btn">
                            </form>
                            <form action="messages" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="messageId" value="<%= msg.getMessageId() %>">
                                <input type="submit" value="Delete" class="btn reject">
                            </form>
                        </td>
                    </tr>
                <% 
                        }
                    } else { 
                %>
                    <tr><td colspan="5" style="text-align:center;">No messages found.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
