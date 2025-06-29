<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="subject.list.title" text="Manage Subjects"/></title>
    <link rel="stylesheet" href="<c:url value='/lib/bootstrap/css/bootstrap.css'/>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />

    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
            background-color: #f8f9fa;
            font-size: 1rem;
        }

        header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1030;
            height: 55px;
            background-color: #1a252f;
        }

        .main-container {
            display: flex;
            flex: 1;
            margin-top: 55px;
        }

        .sidebar {
            width: 250px;
            background-color: #1a252f;
            color: white;
            overflow-y: auto;
        }

        .content {
            flex: 1;
            padding: 20px;
            background-color: #f8f9fa;
            overflow-y: auto;
            padding-bottom: 80px;
        }

        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
        }

        
        .table {
            background-color: #ffffff;
            font-size: 1rem;
            border: 1px solid #dee2e6;
            margin-bottom: 1.5rem;
        }

        .table th,
        .table td {
            padding: 0.85rem 0.75rem;
            vertical-align: middle;
            border-left: 1px solid #dee2e6;
        }

        .table th:first-child,
        .table td:first-child {
            border-left: none;
        }

        .table thead th {
            background-color: #ffffff; /* NỀN TRẮNG CHO HEADER BẢNG */
            color: #212529;            /* CHỮ MÀU ĐEN/XÁM ĐẬM */
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
            border-top: none;
        }

        .table thead th a.table-header-sort-link {
            color: inherit;
            text-decoration: none;
        }

        .table thead th a.table-header-sort-link:hover {
            color: #0d6efd;
        }

        .table tbody tr {
            background-color: #ffffff !important;
        }

        .table-hover tbody tr:hover {
            background-color: #f0f0f0 !important;
        }
        /* --- KẾT THÚC CSS CHO BẢNG --- */

        .subject-img-thumbnail {
            max-width: 70px;
            max-height: 50px;
            object-fit: cover;
        }

        /* --- CSS CHO PHÂN TRANG (THEO YÊU CẦU MỚI) --- */
        .pagination-wrapper {
            margin-top: 1.5rem;
            margin-bottom: 1rem;
        }

        .pagination .page-link {
            color: #212529; /* MÀU CHỮ ĐEN/XÁM ĐẬM MẶC ĐỊNH CHO TẤT CẢ CÁC NÚT */
            background-color: #ffffff; /* Nền trắng mặc định */
            border: 1px solid #dee2e6;
            margin-left: -1px;
        }
        .pagination .page-item:first-child .page-link {
            margin-left: 0;
            border-top-left-radius: .25rem;
            border-bottom-left-radius: .25rem;
        }
        .pagination .page-item:last-child .page-link {
            border-top-right-radius: .25rem;
            border-bottom-right-radius: .25rem;
        }

        /* Khi hover vào các nút không active và không disabled */
        .pagination .page-item:not(.active):not(.disabled) .page-link:hover {
            z-index: 2;
            color: #000000; /* Giữ màu chữ đen/xám đậm khi hover */
            background-color: #e9ecef; /* Nền xám nhạt khi hover */
            border-color: #dee2e6;
        }

        /* Nút trang hiện tại (active) */
        .pagination .page-item.active .page-link {
            z-index: 3;
            color: #212529; /* CHỮ MÀU ĐEN/XÁM ĐẬM */
            background-color: #e0e0e0; /* NỀN MÀU XÁM NHẠT (Ví dụ, bạn có thể dùng #e9ecef hoặc một màu xám khác) */
            border-color: #adb5bd;     /* Viền xám đậm hơn một chút cho nút active */
        }
        /* Bỏ box-shadow mặc định của Bootstrap cho nút active nếu có */
        .pagination .page-item.active .page-link:focus,
        .pagination .page-item.active .page-link:hover {
            box-shadow: none;
            background-color: #d3d3d3; /* Màu nền xám nhạt hơn một chút khi hover nút active */
            color: #212529;
        }

        
        .pagination .page-item.disabled .page-link {
            color: #adb5bd; 
            pointer-events: none;
            background-color: #ffffff; 
            border-color: #dee2e6;
        }
        

    </style>
</head>
<body>
    <header>
        <jsp:include page="../layout_staff/header.jsp" />
    </header>

    <div class="main-container">
        <div class="sidebar">
            <jsp:include page="../layout_staff/sidebar.jsp" />
        </div>

        <div class="content">
            <main>
                <div class="container-fluid px-4">
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                            <spring:message code="${successMessage}" text="${successMessage}"/>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                                <spring:message code="${errorMessage}" text="${errorMessage}"/>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessageGlobal}">
                        <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                            <spring:message code="${errorMessageGlobal}" text="${errorMessageGlobal}"/>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${not empty viewName}">
                            <jsp:include page="${viewName}.jsp" />
                        </c:when>
<%--                        <c:otherwise>--%>
<%--                            <p class="mt-3"><spring:message code="admin.welcomeMessage" text="Welcome to the Admin!"/></p>--%>
<%--                        </c:otherwise>--%>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>

    <footer>
        <jsp:include page="../layout_staff/footer.jsp" />
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>