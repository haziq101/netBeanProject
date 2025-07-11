<%@ page import="java.util.List, model.ReturnRequestBean, java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, controller.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Return Requests - Return & Refund System</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: url('img/background return.jpg') repeat; /* Repeat the background image */
            background-size: 300px auto; /* Set background image size smaller */
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

        .section {
            margin-bottom: 40px;
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
        }

        .section h3 {
            color: #3498db;
            margin-bottom: 15px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
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

        input[type="text"],
        textarea,
        select {
            padding: 8px;
            margin: 8px 0;
            width: 100%;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        .btn {
            padding: 8px 16px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            margin-top: 10px;
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
        <h2>Return Requests</h2>

        <!-- Section: Register New Return Request -->
        <div class="section">
            <h3>Register New Return Request</h3>
            <form action="returns" method="post">
                <input type="hidden" name="action" value="create">
                Order ID: <input type="text" name="orderId" required><br>
                Username: <input type="text" name="username" required><br>
                Product Name: <input type="text" name="productName" required><br>
                Reason: <textarea name="reason" rows="3" required></textarea><br>
                <input type="submit" value="Submit Request" class="btn">
            </form>
        </div>

        <!-- Section: Existing Orders -->
        <div class="section">
            <h3>Existing Orders</h3>
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
                            <td><%= rs.getString("orderId") %></td>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getString("productName") %></td>
                            <td><%= rs.getTimestamp("orderDate") != null ? rs.getTimestamp("orderDate").toString() : "" %></td>
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

        <!-- Section: Return Requests -->
        <div class="section">
            <h3>Return Requests</h3>
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
                        if (requests != null && !requests.isEmpty()) {
                            for (ReturnRequestBean req : requests) { 
                    %>
                        <tr>
                            <td><%= req.getRequestId() %></td>
                            <td><%= req.getOrderId() %></td>
                            <td><%= req.getProductName() %></td>
                            <td><%= req.getReason() %></td>
                            <td><%= req.getStatus() %></td>
                            <td>
                                <form action="returns" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="requestId" value="<%= req.getRequestId() %>">
                                    <select name="status" onchange="this.form.submit()">
                                        <option value="Pending" <%= "Pending".equals(req.getStatus()) ? "selected" : "" %>>Pending</option>
                                        <option value="Approved" <%= "Approved".equals(req.getStatus()) ? "selected" : "" %>>Approved</option>
                                        <option value="Rejected" <%= "Rejected".equals(req.getStatus()) ? "selected" : "" %>>Rejected</option>
                                    </select>
                                </form>
                                <form action="returns" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="requestId" value="<%= req.getRequestId() %>">
                                    <input type="submit" value="Delete" class="btn reject">
                                </form>
                            </td>
                        </tr>
                    <% 
                            }
                        } else { 
                    %>
                        <tr><td colspan="6" style="text-align:center;">No return requests found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
