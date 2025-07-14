<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                    rel="stylesheet">
                <style>
                    body {
                        margin: 0;
                        min-height: 100vh;
                        display: flex;
                        flex-direction: column;
                        background-color: #f8f9fa;
                        font-family: Arial, sans-serif;
                    }

                    header {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        z-index: 3;
                        background-color: #212529;
                        color: #fff;
                        padding: 10px 20px;
                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
                    }

                    .sidebar {
                        position: fixed;

                        top: 8%;
                        left: 0;
                        width: 250px;
                        height: calc(110vh - 70px - 50px);
                        z-index: 1;
                        background-color: #212529;
                        color: #fff;
                        padding: 20px 0;
                        overflow-y: auto;
                    }

                    .content {
                        margin-left: 250px;
                        margin-top: 60px;
                        padding: 20px;
                        flex: 1;
                        min-height: calc(100vh - 100px);
                        padding-bottom: 120px;
                    }

                    .custom-container {
                        max-width: 1000px;
                        margin: 0 auto;
                        padding: 20px;
                        background-color: #fff;
                        border-radius: 8px;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                    }

                    h2 {
                        color: #333;
                        font-weight: 600;
                        margin-bottom: 20px;
                    }

                    .table {
                        margin-top: 20px;
                        background-color: #fff;
                    }

                    .table thead {
                        background-color: #343a40;
                        color: #fff;
                    }

                    .table th,
                    .table td {
                        vertical-align: middle;
                        text-align: center;
                        padding: 8px;
                        /* Giảm padding để hàng nhỏ gọn hơn */
                    }

                    .subject-img {
                        width: 50px;
                        height: 50px;
                        object-fit: cover;
                        border-radius: 8px;
                        border: 1px solid #ddd;
                    }

                    .btn-back {
                        margin-top: 20px;
                        background-color: #007bff;
                        /* Màu xanh dương nhạt duy nhất */
                        border: none;
                        padding: 6px 12px;
                        /* Thu nhỏ nút */
                        font-size: 0.9rem;
                        color: #fff;
                        /* Đảm bảo chữ trắng trên nền xanh */
                    }

                    .btn-back:hover {
                        background-color: #0056b3;
                        /* Hover nhẹ nhàng hơn, giữ cùng tông màu */
                    }

                    .form-control {
                        border-radius: 4px;
                        width: 250px;
                        /* Tăng chiều dài ô input */
                        display: inline-block;
                        margin-right: 10px;
                        /* Đảm bảo khoảng cách không che placeholder */
                    }

                    .btn-primary,
                    .btn-secondary {
                        border-radius: 4px;
                        padding: 6px 12px;
                        /* Thu nhỏ nút */
                        font-size: 0.9rem;
                    }

                    .description-box {
                        background-color: #e9ecef;
                        /* Nền xám cho description */
                        padding: 10px;
                        border-radius: 4px;
                        margin-bottom: 15px;
                    }

                    footer {
                        position: fixed;
                        bottom: 0;
                        left: 0;
                        right: 0;
                        z-index: 2;
                        background-color: #212529;
                        color: #fff;
                        padding: 10px 20px;
                        text-align: center;
                    }
                </style>
            </head>

            <body>
                <!-- Header -->
                <header>
                    <jsp:include page="../layout_staff/header.jsp" />
                </header>

                <!-- Sidebar -->
                <div class="sidebar">
                    <jsp:include page="../layout_staff/sidebar.jsp" />
                </div>

                <!-- Main Content -->
                <div class="content">
                    <div class="custom-container">
                        <!-- Error Message -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Warning -->
                        <c:if test="${empty errorMessage and not empty warning}">
                            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                                ${warning}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Subject List -->
                        <c:if test="${empty errorMessage}">
                            <h2 class="text-center mb-4">Gói ${pkg.name}</h2>

                            <div class="description-box">
                                <div><strong>Loại gói:</strong>
                                    <c:choose>
                                        <c:when test="${pkg.packageType == 'FULL_COURSE'}">Gói học</c:when>
                                        <c:otherwise>Gói luyện tập</c:otherwise>

                                    </c:choose>
                                </div>
                                <div><strong>Mô tả:</strong> ${pkg.description}</div>

                                <div><strong>Giá tiền:</strong>
                                    <fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true" /> VNĐ
                                </div>

                                <div><strong>Thời hạn:</strong> ${pkg.durationDays} ngày</div>
                                <div><strong>Trạng thái:</strong>
                                    <c:choose>
                                        <c:when test="${pkg.status == 'APPROVED'}">Đã duyệt</c:when>
                                        <c:when test="${pkg.status == 'PENDING'}">Chờ duyệt</c:when>
                                        <c:otherwise>Bị từ chối</c:otherwise>
                                    </c:choose>
                                </div>
                                <div><strong>Số lượng người đăng kí:</strong> ${count}</div>
                            </div>
                            <!-- Filter -->
                            <form action="/staff/package/view/${pkg.packageId}" method="get" class="d-flex mb-3">
                                <input type="text" name="keyword" class="form-control me-2"
                                    placeholder="Tìm kiếm theo tên môn học" value="${keyword}">
                                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                                <a href="/staff/package/view/${pkg.packageId}" class="btn btn-secondary ms-2">Xóa bộ
                                    lọc</a>
                            </form>
                            <!-- Table -->
                            <table class="table table-bordered table-hover align-middle text-center">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Subject Id</th>
                                        <th>Subject Name</th>
                                        <th>Description</th>
                                        <th>Image</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="subject" items="${subjects}">
                                        <tr>
                                            <td>${subject.subjectId}</td>
                                            <td>${subject.subjectName}</td>
                                            <td>${subject.subjectDescription}</td>
                                            <td>
                                                <img src="/img/subjectImg/${subject.subjectImage}" alt="Image not found"
                                                    class="subject-img">
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty subjects}">
                                        <tr>
                                            <td colspan="4" class="text-center">Không có môn học nào đang hoạt động.
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>

                            <!-- Back Button -->
                            <a href="/staff/package" class="btn btn-back">Quay lại</a>
                        </c:if>
                    </div>
                </div>

                <!-- Footer -->
                <footer>
                    <jsp:include page="../layout_staff/footer.jsp" />
                </footer>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>