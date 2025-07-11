<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - Return & Refund System</title>
    <style>
        /* Full-screen background image */
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: url('img/background login.jpg') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center; /* CENTER vertically */
        }

        /* Glass effect register box */
        .register-container {
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.3);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
            padding: 40px 30px;
            width: 350px;
            text-align: center;
        }

        .register-container h2 {
            color: #fff;
            margin-bottom: 25px;
            font-size: 28px;
            text-shadow: 1px 1px 8px rgba(0,0,0,0.5);
        }

        /* Input fields */
        .register-container input {
            width: 100%;
            padding: 12px;
            margin: 12px 0;
            border: none;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.3);
            color: #fff;
            font-size: 15px;
        }

        .register-container input::placeholder {
            color: #eee;
        }

        /* Button */
        .register-container button {
            width: 100%;
            padding: 12px;
            background: rgba(52, 152, 219, 0.9);
            border: none;
            border-radius: 8px;
            color: #fff;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .register-container button:hover {
            background: rgba(41, 128, 185, 1);
        }

        /* Error message */
        .error {
            color: #ff6b6b;
            margin-top: 10px;
            font-size: 14px;
        }

        /* Back to login link */
        .back-link {
            margin-top: 15px;
            font-size: 14px;
            color: #ddd;
        }

        .back-link a {
            color: #fff;
            text-decoration: underline;
        }

        .back-link a:hover {
            color: #ffeaa7;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h2>Return & Refund System</h2>
        <form action="register" method="post">
            <input type="text" name="username" placeholder="Enter your username" required><br>
            <input type="email" name="email" placeholder="Enter your email" required><br>
            <input type="password" name="password" placeholder="Enter your password" required><br>
            <button type="submit">Register</button>
        </form>
        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
        <div class="back-link">
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
        </div>
    </div>
</body>
</html>
