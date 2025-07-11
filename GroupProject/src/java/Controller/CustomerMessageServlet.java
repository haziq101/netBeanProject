package controller;

import dao.CustomerMessageDAO;
import model.CustomerMessageBean;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;

public class CustomerMessageServlet extends HttpServlet {

    private CustomerMessageDAO messageDAO;

    @Override
    public void init() throws ServletException {
        messageDAO = new CustomerMessageDAO(); // Initialize DAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get all customer messages from DAO
            List<CustomerMessageBean> messages = messageDAO.getAllMessages();
            request.setAttribute("messages", messages);

            // Forward to JSP
            request.getRequestDispatcher("customerMessages.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                // Create new message
                String username = request.getParameter("username");
                String message = request.getParameter("message");

                CustomerMessageBean newMessage = new CustomerMessageBean();
                newMessage.setUsername(username);
                newMessage.setMessage(message);
                newMessage.setStatus("Pending");

                messageDAO.createMessage(newMessage);

            } else if ("resolve".equals(action)) {
                // Resolve a message
                int messageId = Integer.parseInt(request.getParameter("messageId"));
                messageDAO.resolveMessage(messageId);

            } else if ("delete".equals(action)) {
                // Delete a message
                int messageId = Integer.parseInt(request.getParameter("messageId"));
                messageDAO.deleteMessage(messageId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
            return;
        }

        // Redirect back to the messages page
        response.sendRedirect("messages");
    }
}
