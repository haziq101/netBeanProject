<%@ page import="java.util.List, model.ReturnRequestBean, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, controller.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Return Requests</title>
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
        .section { margin-bottom: 20px; }
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
    <div class="section">
        <h2>Register New Return Request</h2>
        <form action="returns" method="post">
            <input type="hidden" name="action" value="create">
            Order ID: <input type="text" name="orderId" required><br>
            Username: <input type="text" name="username" required><br>
            Product Name: <input type="text" name="productName" required><br>
            Reason: <textarea name="reason" required></textarea><br>
            <input type="submit" value="Submit Request" class="btn">
        </form>
    </div>
    <div class="section">
        <h2>Existing Orders</h2>
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Username</th>
                    <th>Product Name</th>
                    <th>Order Date</th>
                    <th>Total Amount</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    try {
                        conn = DBConnection.getConnection();
                        stmt = conn.prepareStatement("SELECT orderId, username, productName, orderDate, totalAmount FROM Orders");
                        rs = stmt.executeQuery();
                        while (rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getString("orderId") != null ? rs.getString("orderId") : "" %></td>
                        <td><%= rs.getString("username") != null ? rs.getString("username") : "" %></td>
                        <td><%= rs.getString("productName") != null ? rs.getString("productName") : "" %></td>
                        <td><%= rs.getTimestamp("orderDate") != null ? rs.getTimestamp("orderDate") : "" %></td>
                        <td><%= rs.getDouble("totalAmount") %></td>
                    </tr>
                <% 
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        DBConnection.closeConnection(conn);
                    }
                %>
            </tbody>
        </table>
    </div>
    <div class="section">
        <h2>Return Requests</h2>
        <table>
            <thead>
                <tr>
                    <th>Request ID</th>
                    <th>Order ID</th>
                    <th>Product</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<ReturnRequestBean> requests = (List<ReturnRequestBean>) request.getAttribute("requests");
                    if (requests != null) {
                        for (ReturnRequestBean req : requests) { 
                %>
                    <tr>
                        <td><%= req.getRequestId() != null ? req.getRequestId() : "" %></td>
                        <td><%= req.getOrderId() != null ? req.getOrderId() : "" %></td>
                        <td><%= req.getProductName() != null ? req.getProductName() : "" %></td>
                        <td><%= req.getReason() != null ? req.getReason() : "" %></td>
                        <td><%= req.getStatus() != null ? req.getStatus() : "" %></td>
                        <td>
                            <form action="returns" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="requestId" value="<%= req.getRequestId() != null ? req.getRequestId() : "" %>">
                                <select name="status" onchange="this.form.submit()">
                                    <option value="Pending" <%= "Pending".equals(req.getStatus()) ? "selected" : "" %>>Pending</option>
                                    <option value="Approved" <%= "Approved".equals(req.getStatus()) ? "selected" : "" %>>Approved</option>
                                    <option value="Rejected" <%= "Rejected".equals(req.getStatus()) ? "selected" : "" %>>Rejected</option>
                                </select>
                            </form>
                            <form action="returns" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="requestId" value="<%= req.getRequestId() != null ? req.getRequestId() : "" %>">
                                <input type="submit" value="Delete" class="btn reject">
                            </form>
                        </td>
                    </tr>
                <% 
                        }
                    } else { 
                %>
                    <tr><td colspan="6">No return requests found.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>