package controller;

import dao.UserDAO;
import model.UserBean;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Use UserDAO for authentication
        UserDAO userDAO = new UserDAO();
        UserBean user = null;

        try {
            user = userDAO.checkLogin(email, password); // renamed to checkLogin for clarity
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while trying to login: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (user != null) {
            // ✅ Login successful: create session and redirect to dashboard
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect("dashboard.jsp");
        } else {
            // ❌ Login failed: show error message
            request.setAttribute("error", "Invalid email or password");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }
}
