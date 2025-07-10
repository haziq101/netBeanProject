<%@ page import="java.util.List, model.CustomerMessageBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Messages</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f8f9fa; padding: 20px; }
        nav { background-color: #3498db; padding: 15px 20px; display: flex; gap: 20px; }
        nav a { color: white; text-decoration: none; font-weight: bold; font-size: 16px; }
        nav a:hover { text-decoration: underline; }
        h2 { color: #333; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; background-color: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #007bff; color: white; }
        tr:hover { background-color: #f1f1f1; }
        .btn { padding: 6px 12px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; }
        .btn.reject { background-color: #dc3545; }
    </style>
</head>
<body>
    <nav>
        <a href="dashboard.jsp" class="logo">Return & Refund System</a>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="returns">Return Requests</a>
        <a href="refunds">Refunds</a>
        <a href="messages">Customer Messages</a>
        <a href="logout">Logout</a>
    </nav>
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
                if (messages != null) {
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
                <tr><td colspan="5">No messages found.</td></tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>