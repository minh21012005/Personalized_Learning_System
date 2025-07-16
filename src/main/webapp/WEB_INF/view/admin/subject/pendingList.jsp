<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Danh sách môn học chờ duyệt</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: Arial, sans-serif;
        }

        header {
            background-color: #1a252f;
            color: white;
            width: 100%;
            flex-shrink: 0;
        }

        .sidebar {
            width: 250px;
            background-color: #1a252f;
            color: white;
            overflow-y: auto;
            position: fixed;
            height: calc(100vh - 40px); /* Trừ chiều cao footer */
            top: 60px; /* Giả định header cao 60px */
            left: 0;
            transition: width 0.3s;
        }

        .main-content {
            margin-left: 250px; /* Khoảng cách để tránh chồng lấn sidebar */
            padding: 20px;
            flex: 1;
            background-color: #f8f9fa;
            transition: margin-left 0.3s;
        }

        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
            flex-shrink: 0;
            text-align: center;
            padding-top: 10px;
        }

        /* Responsive Sidebar */
        @media (max-width: 768px) {
            .sidebar {
                width: 0;
                display: none;
            }
            .main-content {
                margin-left: 0;
            }
        }

        /* TABLE STYLES */
        .pending-table-container {
            margin-top: 20px;
        }

        .pending-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background-color: #fff;
            border: 1px solid #dee2e6;
        }

        .pending-table th {
            background-color: #e9ecef;
            color: #333;
            font-weight: 600;
            padding: 12px 15px;
            text-align: left;
            border-bottom: 2px solid #dee2e6;
        }

        .pending-table td {
            padding: 10px 15px;
            border-bottom: 1px solid #dee2e6;
        }

        .pending-table tr:hover {
            background-color: #f1f1f1;
        }

        .table-cell-id {
            font-weight: 500;
        }

        .table-cell-image .subject-img {
            max-width: 60px;
            max-height: 40px;
            object-fit: cover;
            border-radius: 4px;
        }

        .status-badge {
            padding: 5px 10px;
            border-radius: 10px;
            font-size: 12px;
        }

        .table-cell-actions .action-btn {
            margin-right: 5px;
            padding: 5px 10px;
        }

        .table-empty {
            padding: 20px;
            color: #666;
        }

        /* PAGINATION STYLES */
        .pagination-container {
            margin-top: 20px;
        }

        .pagination-info {
            color: #666;
        }

        .pagination-nav .page-link {
            color: #333;
            background-color: #fff;
            border: 1px solid #dee2e6;
            margin-left: -1px;
        }

        .pagination-nav .page-item:first-child .page-link {
            border-top-left-radius: 4px;
            border-bottom-left-radius: 4px;
        }

        .pagination-nav .page-item:last-child .page-link {
            border-top-right-radius: 4px;
            border-bottom-right-radius: 4px;
        }

        .pagination-nav .page-item:hover:not(.active):not(.disabled) .page-link {
            background-color: #e9ecef;
            color: #000;
        }

        .pagination-nav .page-item.active .page-link {
            background-color: #007bff;
            color: #fff;
            border-color: #007bff;
        }

        .pagination-nav .page-item.disabled .page-link {
            color: #6c757d;
            pointer-events: none;
            background-color: #fff;
            border-color: #dee2e6;
        }

        /* Responsive Table */
        @media (max-width: 768px) {
            .pending-table th,
            .pending-table td {
                padding: 8px;
                font-size: 14px;
            }
            .table-cell-image .subject-img {
                max-width: 40px;
                max-height: 30px;
            }
            .table-cell-actions .action-btn {
                padding: 3px 8px;
                font-size: 12px;
            }
        }

        @media (max-width: 480px) {
            .pending-table th,
            .pending-table td {
                padding: 6px;
                font-size: 12px;
            }
            .table-cell-image .subject-img {
                max-width: 30px;
                max-height: 20px;
            }
            .table-cell-actions .action-btn {
                padding: 2px 6px;
                font-size: 10px;
            }
            .pagination-info {
                font-size: 12px;
            }
            .pagination-nav .page-link {
                padding: 4px 8px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp" />
</header>
<div class="sidebar">
    <jsp:include page="../layout/sidebar.jsp" />
</div>
<div class="main-content">
    <div class="row align-items-center mb-4">
        <div class="col ">
            <div class="flex-column align-items-center">
                <a href="<c:url value='/admin/subject'/>" class="btn btn-secondary me-2 d-inline" title="Quay lại">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
            <h1 class="mt-2 mb-2 d-inline align-items-end">Danh sách môn học chờ duyệt</h1>
        </div>
    </div>

    <!-- FILTER FORM -->
    <div class="filter-container mb-4">
        <form action="<c:url value='/admin/subject/pending'/>" method="GET" class="row g-3 align-items-center">
            <div class="col-md-4 col-sm-6">
                <div class="filter-group">
                    <label for="filterName" class="filter-label">Tên môn học:</label>
                    <input type="text" name="filterName" id="filterName" class="filter-input form-control"
                           value="<c:out value='${filterName}'/>" placeholder="Nhập tên môn học">
                </div>
            </div>
            <div class="col-md-4 col-sm-6">
                <div class="filter-group">
                    <label for="submittedByName" class="filter-label">Tên người nộp:</label>
                    <input type="text" name="submittedByName" id="submittedByName" class="filter-input form-control"
                           value="<c:out value='${submittedByName}'/>" placeholder="Nhập tên người nộp">
                </div>
            </div>
            <div class="col-md-4 col-sm-12">
                <div class="filter-actions">
                    <button type="submit" class="filter-btn btn btn-primary">
                        <i class="fas fa-filter"></i> Lọc
                    </button>
                    <a href="<c:url value='/admin/subject/pending'/>" class="reset-btn btn btn-secondary">
                        <i class="fas fa-eraser"></i> Xóa lọc
                    </a>
                </div>
            </div>
        </form>
    </div>

    <!-- TABLE DISPLAY -->
    <div class="pending-table-container">
        <table class="pending-table table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Hình ảnh</th>
                <th>Tên</th>
                <th>Mô tả</th>
                <th>Trạng thái</th>
                <th>Người nộp</th>
                <th>Ngày nộp</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="subject" items="${subjects}" varStatus="loop">
                <tr>
                    <td class="table-cell-id"><c:out value="${subject.subjectId}" default=""/></td>
                    <td class="table-cell-image">
                        <c:choose>
                            <c:when test="${not empty subject.subjectImage and subject.subjectImage != ''}">
                                <img src="/img/subjectImg/<c:out value='${subject.subjectImage}'/>" alt="<c:out value='${subject.subjectName}'/>" class="subject-img">
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">Không có hình ảnh</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><c:out value="${subject.subjectName}" default=""/></td>
                    <td><c:out value="${subject.subjectDescription}" default=""/></td>
                    <td>
                        <c:if test="${not empty subject.status}">
                        <span class="status-badge bg-warning">
                                ${subject.status == 'PENDING' ? 'Chờ duyệt' : ""}
                            </c:if>
                    </td>
                    <td><c:out value="${subject.submittedByFullName}" default="Chưa có"/></td>
                    <td><c:out value="${not empty subject.submittedAt ? subject.submittedAt : 'Chưa nộp'}" default="Chưa nộp"/></td>
                    <td class="table-cell-actions">
                        <a href="<c:url value='/admin/subject/${subject.subjectId}/detail'/>" class="action-btn btn btn-info btn-sm" title="Chi tiết">
                            <i class="fas fa-info-circle"></i> Chi tiết
                        </a>
                        <a href="<c:url value='/admin/subject/review/${subject.subjectId}'/>" class="action-btn btn btn-info btn-sm" title="Duyệt">
                            <i class="fas fa-check-circle"></i> Duyệt
                        </a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty subjects}">
                <tr>
                    <td colspan="8" class="table-empty text-center">Không tìm thấy môn học</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <c:if test="${subjectPage.totalPages > 0}">
        <div class="pagination-container text-center">
            <div class="pagination-info mb-2">
                <small>Hiển thị ${subjectPage.numberOfElements} trong tổng ${subjectPage.totalElements} mục (Trang ${subjectPage.number + 1} của ${subjectPage.totalPages})</small>
            </div>
            <div class="pagination-nav">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${subjectPage.first ? 'disabled' : ''}">
                            <c:url value="/admin/subject/pending" var="firstPageLink">
                                <c:param name="filterName" value="${filterName}" />
                                <c:param name="submittedByName" value="${submittedByName}" />
                                <c:param name="page" value="0" />
                                <c:param name="size" value="${pageSize}" />
                            </c:url>
                            <a class="page-link" href="${firstPageLink}" aria-label="First">
                                <span aria-hidden="true">««</span>
                            </a>
                        </li>
                        <li class="page-item ${subjectPage.first ? 'disabled' : ''}">
                            <c:url value="/admin/subject/pending" var="prevPageLink">
                                <c:param name="filterName" value="${filterName}" />
                                <c:param name="submittedByName" value="${submittedByName}" />
                                <c:param name="page" value="${subjectPage.number - 1}" />
                                <c:param name="size" value="${pageSize}" />
                            </c:url>
                            <a class="page-link" href="${prevPageLink}" aria-label="Previous">
                                <span aria-hidden="true">«</span>
                            </a>
                        </li>
                        <c:set var="windowSize" value="2" />
                        <c:set var="startPageLoop" value="${subjectPage.number - windowSize > 0 ? subjectPage.number - windowSize : 0}" />
                        <c:set var="endPageLoop" value="${subjectPage.number + windowSize < subjectPage.totalPages - 1 ? subjectPage.number + windowSize : subjectPage.totalPages - 1}" />
                        <c:if test="${startPageLoop > 0}">
                            <c:url value="/admin/subject/pending" var="pageLinkFirstDots">
                                <c:param name="filterName" value="${filterName}" />
                                <c:param name="submittedByName" value="${submittedByName}" />
                                <c:param name="page" value="0" />
                                <c:param name="size" value="${pageSize}" />
                            </c:url>
                            <li class="page-item"><a class="page-link" href="${pageLinkFirstDots}">1</a></li>
                            <c:if test="${startPageLoop > 1}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:if>
                        </c:if>
                        <c:forEach begin="${startPageLoop}" end="${endPageLoop}" var="i">
                            <li class="page-item ${i == subjectPage.number ? 'active' : ''}">
                                <c:url value="/admin/subject/pending" var="pageLink">
                                    <c:param name="filterName" value="${filterName}" />
                                    <c:param name="submittedByName" value="${submittedByName}" />
                                    <c:param name="page" value="${i}" />
                                    <c:param name="size" value="${pageSize}" />
                                </c:url>
                                <a class="page-link" href="${pageLink}">${i + 1}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${endPageLoop < subjectPage.totalPages - 1}">
                            <c:if test="${endPageLoop < subjectPage.totalPages - 2}">
                                <li class="page-item disabled"><span class="page-link">...</span></li>
                            </c:if>
                            <c:url value="/admin/subject/pending" var="pageLinkLastDots">
                                <c:param name="filterName" value="${filterName}" />
                                <c:param name="submittedByName" value="${submittedByName}" />
                                <c:param name="page" value="${subjectPage.totalPages - 1}" />
                                <c:param name="size" value="${pageSize}" />
                            </c:url>
                            <li class="page-item"><a class="page-link" href="${pageLinkLastDots}">${subjectPage.totalPages}</a></li>
                        </c:if>
                        <li class="page-item ${subjectPage.last ? 'disabled' : ''}">
                            <c:url value="/admin/subject/pending" var="nextPageLink">
                                <c:param name="filterName" value="${filterName}" />
                                <c:param name="submittedByName" value="${submittedByName}" />
                                <c:param name="page" value="${subjectPage.number + 1}" />
                                <c:param name="size" value="${pageSize}" />
                            </c:url>
                            <a class="page-link" href="${nextPageLink}" aria-label="Next">
                                <span aria-hidden="true">»</span>
                            </a>
                        </li>
                        <li class="page-item ${subjectPage.last ? 'disabled' : ''}">
                            <c:url value="/admin/subject/pending" var="lastPageLink">
                                <c:param name="filterName" value="${filterName}" />
                                <c:param name="submittedByName" value="${submittedByName}" />
                                <c:param name="page" value="${subjectPage.totalPages - 1}" />
                                <c:param name="size" value="${pageSize}" />
                            </c:url>
                            <a class="page-link" href="${lastPageLink}" aria-label="Last">
                                <span aria-hidden="true">»»</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </c:if>
</div>
<footer>
    <jsp:include page="../../content-manager/layout/footer.jsp" />
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>