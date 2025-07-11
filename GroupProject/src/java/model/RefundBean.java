package model;

public class RefundBean {
    private int refundId;
    private String requestId;
    private String orderId;
    private String username;
    private double amount;
    private String status;

    public RefundBean() {}
    public RefundBean(int refundId, String requestId, String orderId, String username, double amount, String status) {
        this.refundId = refundId;
        this.requestId = requestId;
        this.orderId = orderId;
        this.username = username;
        this.amount = amount;
        this.status = status;
    }

    public int getRefundId() { return refundId; }
    public void setRefundId(int refundId) { this.refundId = refundId; }
    public String getRequestId() { return requestId; }
    public void setRequestId(String requestId) { this.requestId = requestId; }
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}