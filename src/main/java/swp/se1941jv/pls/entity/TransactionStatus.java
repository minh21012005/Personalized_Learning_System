package swp.se1941jv.pls.entity;

public enum TransactionStatus {
    PENDING, // Chờ admin duyệt
    APPROVED, // Đã duyệt, mở khóa học
    REJECTED // Bị từ chối (sai mã chuyển khoản, ảnh không hợp lệ, v.v.)
}
