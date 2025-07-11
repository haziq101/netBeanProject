package model;

public class ReturnRequestBean {
    private String requestId;
    private String orderId;
    private String username;
    private String productName;
    private String reason;
    private String status;

    public ReturnRequestBean() {}

    public ReturnRequestBean(String requestId, String orderId, String username, String productName, String reason, String status) {
        this.requestId = requestId;
        this.orderId = orderId;
        this.username = username;
        this.productName = productName;
        this.reason = reason;
        this.status = status;
    }

    public String getRequestId() { return requestId; }
    public void setRequestId(String requestId) { this.requestId = requestId; }

    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
