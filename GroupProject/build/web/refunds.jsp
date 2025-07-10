<%@ page import="java.util.List, model.RefundBean, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, controller.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Refunds</title>
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
        <h2>Register New Refund</h2>
        <form action="refunds" method="post">
            <input type="hidden" name="action" value="create">
            Request ID: <input type="text" name="requestId" required><br>
            Order ID: <input type="text" name="orderId" required><br>
            Username: <input type="text" name="username" required><br>
            Amount: <input type="number" step="0.01" name="amount" required><br>
            <input type="submit" value="Submit Refund" class="btn">
        </form>
    </div>
    <div class="section">
        <h2>Existing Orders</h2>
        <table>
            <thead>
                <tr>
                    <th>Request ID</th>
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
                        stmt = conn.prepareStatement(
                        "SELECT r.requestId, r.orderId, r.username, r.productName, r.reason, r.status, o.orderDate, o.totalAmount " +
                        "FROM ReturnRequests r LEFT JOIN Orders o ON r.orderId = o.orderId");
                        rs = stmt.executeQuery();
                        while (rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getString("requestId") != null ? rs.getString("requestId") : "" %></td>
                        <td><%= rs.getString("orderId") != null ? rs.getString("orderId") : "" %></td>
                        <td><%= rs.getString("username") != null ? rs.getString("username") : "" %></td>
                        <td><%= rs.getString("productName") != null ? rs.getString("productName") : "" %></td>
                        <td><%= rs.getTimestamp("orderDate") != null ? rs.getTimestamp("orderDate").toString() : "" %></td>
                        <td><%= rs.getDouble("totalAmount") != 0 ? rs.getDouble("totalAmount") : "" %></td>
                        

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
        <h2>Refunds</h2>
        <table>
            <thead>
                <tr>
                    <th>Refund ID</th>
                    <th>Request ID</th>
                    <th>Order ID</th>
                    <th>Username</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    List<RefundBean> refunds = (List<RefundBean>) request.getAttribute("refunds");
                    if (refunds != null) {
                        for (RefundBean refund : refunds) { 
                %>
                    <tr>
                        <td><%= refund.getRefundId() %></td>
                        <td><%= refund.getRequestId() != null ? refund.getRequestId() : "" %></td>
                        <td><%= refund.getOrderId() != null ? refund.getOrderId() : "" %></td>
                        <td><%= refund.getUsername() != null ? refund.getUsername() : "" %></td>
                        <td><%= refund.getAmount() %></td>
                        <td><%= refund.getStatus() != null ? refund.getStatus() : "" %></td>
                        <td>
                            <form action="refunds" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="refundId" value="<%= refund.getRefundId() %>">
                                <select name="status" onchange="this.form.submit()">
                                    <option value="Pending" <%= "Pending".equals(refund.getStatus()) ? "selected" : "" %>>Pending</option>
                                    <option value="Approved" <%= "Approved".equals(refund.getStatus()) ? "selected" : "" %>>Approved</option>
                                    <option value="Rejected" <%= "Rejected".equals(refund.getStatus()) ? "selected" : "" %>>Rejected</option>
                                </select>
                            </form>
                            <form action="refunds" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="refundId" value="<%= refund.getRefundId() %>">
                                <input type="submit" value="Delete" class="btn reject">
                            </form>
                        </td>
                    </tr>
                <% 
                        }
                    } else { 
                %>
                    <tr><td colspan="7">No refunds found.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>