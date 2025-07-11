package controller;

import dao.ReturnRequestDAO;
import model.ReturnRequestBean;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;

public class ReturnRequestServlet extends HttpServlet {

    private ReturnRequestDAO returnDAO;

    @Override
    public void init() throws ServletException {
        returnDAO = new ReturnRequestDAO(); // Initialize DAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get all return requests from DAO
            List<ReturnRequestBean> requests = returnDAO.getAllReturnRequests();
            request.setAttribute("requests", requests);

            // Forward to JSP
            request.getRequestDispatcher("returnRequests.jsp").forward(request, response);
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
                // Create new return request
                String requestId = "RR" + String.format("%03d", (int) (Math.random() * 1000));
                String orderId = request.getParameter("orderId");
                String username = request.getParameter("username");
                String productName = request.getParameter("productName");
                String reason = request.getParameter("reason");

                ReturnRequestBean newRequest = new ReturnRequestBean();
                newRequest.setRequestId(requestId);
                newRequest.setOrderId(orderId);
                newRequest.setUsername(username);
                newRequest.setProductName(productName);
                newRequest.setReason(reason);
                newRequest.setStatus("Pending");

                returnDAO.createReturnRequest(newRequest);

            } else if ("update".equals(action)) {
                // Update return request status
                String requestId = request.getParameter("requestId");
                String status = request.getParameter("status");
                returnDAO.updateReturnRequestStatus(requestId, status);

            } else if ("delete".equals(action)) {
                // Delete return request
                String requestId = request.getParameter("requestId");
                returnDAO.deleteReturnRequest(requestId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
            return;
        }

        // Redirect back to the returns page
        response.sendRedirect("returns");
    }
}
