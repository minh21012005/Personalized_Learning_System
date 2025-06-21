<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- Tiêu đề trang sẽ được truyền từ NotificationController --%>
    <title><c:out value="${pageTitle}" default="Quản lý Thông báo"/></title> 
    
    <%-- Sử dụng các link CSS giống như grade/show.jsp để đồng bộ --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/bootstrap/css/bootstrap.css"> <%-- Giả sử đây là Bootstrap cũ hơn, giữ lại nếu cần --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <%-- Thêm FontAwesome nếu bạn muốn dùng icon từ đó (đã có trong các ví dụ trước) --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


    <style>
        body {
            margin: 0;
            padding-top: 60px; /* để tránh header */
            display: flex; /* Thêm để footer dính đáy khi content ngắn */
            flex-direction: column; /* Thêm */
            min-height: 100vh; /* Thêm */
            background-color: #212529; 
        }
        header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: 60px;
            z-index: 1030;
            background-color: #212529; /* Màu header từ grade */
        }
        .sidebar {
            position: fixed;
            top: 60px;
            /* bottom: 40px; */ /* Bỏ bottom để footer tự điều chỉnh */
            left: 0;
            width: 250px;
            background-color: #212529; /* Màu sidebar từ grade */
            color: #fff;
            overflow-y: auto;
            height: calc(100vh - 60px - 40px); /* Chiều cao sidebar = viewport - header - footer */
            z-index: 1025;
        }
        .content-wrapper { /* Đổi tên class để rõ ràng hơn */
            margin-left: 250px;
            padding: 20px;
            flex-grow: 1; /* Cho phép content co giãn để đẩy footer xuống */
            background-color: #ffffff; /* Màu nền cho content */
            border-radius: 0.25rem; /* Bo góc nhẹ cho content area */
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); /* Thêm shadow nhẹ */
          overflow-x: hidden; 
           
        }
        .main-layout-footer { /* Đổi tên class để tránh xung đột */
            background-color: #212529; /* Màu footer từ grade */
            color: white;
            text-align: center;
            height: 40px;
            line-height: 40px;
            /* position: fixed; */ /* Bỏ fixed để nó nằm tự nhiên cuối trang */
            /* bottom: 0; */
            /* left: 0; */
            /* right: 0; */
            z-index: 1020;
            width: 100%; /* Đảm bảo footer chiếm toàn bộ chiều ngang */
            margin-top: auto; /* Đẩy footer xuống đáy nếu content ngắn */
        }

        /* Các style khác từ grade/show.jsp nếu cần cho form, table */
        .form-control, .form-select {
            /* width: auto; */ /* Để Bootstrap tự quản lý width tốt hơn, hoặc set cụ thể */
            max-width: 100%; /* Đảm bảo không tràn */
        }
        .table th,
        .table td {
            vertical-align: middle;
        }
        .btn-lg { /* Giữ lại nếu bạn muốn nút "Thêm mới" to như grade */
            /* padding: 0.5rem 1.2rem; */ 
        }
        .page-header h3, .page-header h2 {
             color: #343a40;
             font-weight: 600;
        }
        .alert {
            margin-bottom: 1.5rem;
        }
    </style>
</head>

<body>
    <!-- Header -->
    <header>
        <%-- Đường dẫn đến header.jsp trong /WEB-INF/view/admin/layout/ --%>
        <jsp:include page="../layout/header.jsp" />
    </header>

    <div style="display: flex; flex-grow: 1;"> <%-- Wrapper cho sidebar và content --%>
        <!-- Sidebar -->
        <div class="sidebar">
            <%-- Đường dẫn đến sidebar.jsp trong /WEB-INF/view/admin/layout/ --%>
            <jsp:include page="../layout/sidebar.jsp" />
        </div>

        <!-- Main Content Area -->
        <div class="content-wrapper">
            <%-- Hiển thị Success Message --%>
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i><c:out value="${successMessage}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <%-- Hiển thị Error Message --%>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i><c:out value="${errorMessage}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <%-- Hiển thị lỗi tải form (nếu có từ populateFormModel trong controller) --%>
            <c:if test="${not empty formErrorMessage}">
                <div class="alert alert-warning alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i><c:out value="${formErrorMessage}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <%--
                Include nội dung chính (list_content.jsp hoặc form_content.jsp)
                Controller sẽ truyền biến 'contentPage' với giá trị là tên file JSP (ví dụ: "list_content.jsp")
                VÀ 'pageTitle' cho tiêu đề.
            --%>
            <c:if test="${not empty contentPage}">
                <jsp:include page="${contentPage}" />
            </c:if>
            <c:if test="${empty contentPage}">
                <div class="alert alert-warning" role="alert">
                    Lỗi: Trang nội dung không được chỉ định hoặc không tìm thấy.
                </div>
            </c:if>
        </div>
    </div>

     <!-- Footer -->
            <footer>
                <jsp:include page="../layout/footer.jsp" />
            </footer>

    <!-- Bootstrap JS (phiên bản phù hợp với CSS) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <%-- Các script JS khác nếu cần --%>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Tự động ẩn success/error messages sau một khoảng thời gian
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(function(alert) {
                // Không tự động đóng alert-warning (có thể là lỗi tải form quan trọng)
                // và alert-danger (để người dùng đọc kỹ lỗi)
                if (!alert.classList.contains('alert-warning') && !alert.classList.contains('alert-danger')) { 
                    setTimeout(function() {
                        const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
                        if (bsAlert) {
                           try { bsAlert.close(); } catch(e){}
                        }
                    }, 7000); // 7 giây
                }
            });
        });
    </script>
</body>
</html>