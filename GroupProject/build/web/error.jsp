<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error - Return & Refund System</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f6f8; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .error-container { background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); width: 400px; text-align: center; }
        h2 { color: #dc3545; margin-bottom: 20px; }
        p { color: #333; }
        .error-message { color: #dc3545; margin: 10px 0; }
        a { color: #3498db; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="error-container">
        <h2>Error</h2>
        <% String errorMessage = request.getParameter("message");
           if (errorMessage != null) { %>
            <p class="error-message"><%= java.net.URLDecoder.decode(errorMessage, "UTF-8") %></p>
        <% } else { %>
            <p>An unexpected error occurred. Please try again or contact support.</p>
        <% } %>
        <p><a href="dashboard.jsp">Back to Dashboard</a></p>
    </div>
</body>
</html>