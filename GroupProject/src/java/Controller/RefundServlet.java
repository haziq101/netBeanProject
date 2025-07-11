package controller;

import dao.RefundDAO;
import model.RefundBean;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class RefundServlet extends HttpServlet {

    private final RefundDAO refundDAO = new RefundDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<RefundBean> refunds = refundDAO.getAllRefunds();
            request.setAttribute("refunds", refunds);
            request.getRequestDispatcher("refunds.jsp").forward(request, response);
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
                RefundBean refund = new RefundBean();
                refund.setRequestId(request.getParameter("requestId"));
                refund.setOrderId(request.getParameter("orderId"));
                refund.setUsername(request.getParameter("username"));
                refund.setAmount(Double.parseDouble(request.getParameter("amount")));
                refundDAO.createRefund(refund);
            } else if ("update".equals(action)) {
                int refundId = Integer.parseInt(request.getParameter("refundId"));
                String status = request.getParameter("status");
                refundDAO.updateRefundStatus(refundId, status);
            } else if ("delete".equals(action)) {
                int refundId = Integer.parseInt(request.getParameter("refundId"));
                refundDAO.deleteRefund(refundId);
            }
            response.sendRedirect("refunds");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
