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

        .main-container {
            display: flex;
            flex: 1;
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
        }

        .main-content {
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

        /* Main Content Styles */
        .subject-img-thumbnail {
            max-width: 50px;
            max-height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        .pagination .page-link {
            color: #007bff;
        }
        .pagination .page-item.active .page-link {
            background-color: #007bff;
            border-color: #007bff;
        }
        .form-control-sm, .form-select-sm {
            font-size: 0.875rem;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp" />
</header>
<div class="main-container">
    <div class="sidebar">
        <jsp:include page="../layout/sidebar.jsp" />
    </div>
    <div class="main-content">
        <div class="container mt-4">
            <a href=" /admin/subject" class="btn btn-outline-secondary btn-sm mb-2">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
            <div class="card">
                <div class="card-header  align-items-center">

                    <h5 class="mb-0">Danh sách môn học chờ duyệt</h5>
                </div>
                <div class="card-body">
                    <!-- FILTER FORM -->
                    <form action="<c:url value='/admin/subject/pending'/>" method="GET" class="mb-4">
                        <div class="row g-3 align-items-center">
                            <div class="col-auto">
                                <label for="filterName" class="col-form-label">Tên môn học:</label>
                            </div>
                            <div class="col-auto">
                                <input type="text" name="filterName" id="filterName" class="form-control form-control-sm"
                                       value="<c:out value='${filterName}'/>" placeholder="Nhập tên môn học">
                            </div>
                            <div class="col-auto">
                                <label for="submittedByName" class="col-form-label">Tên người nộp:</label>
                            </div>
                            <div class="col-auto">
                                <input type="text" name="submittedByName" id="submittedByName" class="form-control form-control-sm"
                                       value="<c:out value='${submittedByName}'/>" placeholder="Nhập tên người nộp">
                            </div>
                            <div class="col-auto">
                                <button type="submit" class="btn btn-info btn-sm">
                                    <i class="fas fa-filter"></i> Lọc
                                </button>
                                <a href="<c:url value='/admin/subject/pending'/>" class="btn btn-secondary btn-sm ms-2">
                                    <i class="fas fa-eraser"></i> Xóa lọc
                                </a>
                            </div>
                        </div>
                    </form>

                    <!-- TABLE DISPLAY -->
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered">
                            <thead class="table-light">
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
                                    <td><c:out value="${subject.subjectId}" default=""/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty subject.subjectImage and subject.subjectImage != ''}">
                                                <img src="/img/subjectImg/<c:out value='${subject.subjectImage}'/>"
                                                     alt="<c:out value='${subject.subjectName}'/>" class="subject-img-thumbnail"/>
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
                                        <span class="badge bg-warning">
                                                ${subject.status == 'PENDING' ? 'Chờ duyệt' : ""}
                                        </span>
                                        </c:if>
                                    </td>
                                    <td><c:out value="${subject.submittedByFullName}" default="Chưa có"/></td>
                                    <td><c:out value="${not empty subject.submittedAt ? subject.submittedAt : 'Chưa nộp'}" default="Chưa nộp"/></td>
                                    <td>
                                        <a href="<c:url value='/admin/subject/${subject.subjectId}/detail'/>" class="btn btn-sm btn-success me-1 mb-1" title="Chi tiết">
                                            <i class="fas fa-info-circle"></i> Chi tiết
                                        </a>
                                        <a href="<c:url value='/admin/subject/review/${subject.subjectId}'/>" class="btn btn-sm btn-info me-1 mb-1" title="Duyệt">
                                            <i class="fas fa-check-circle"></i> Duyệt
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty subjects}">
                                <tr>
                                    <td colspan="8" class="text-center text-muted">Không tìm thấy môn học</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- PAGINATION -->
                    <c:if test="${subjectPage.totalPages > 0}">
                        <div class="pagination-wrapper text-center mt-4">
                            <div class="mb-2">
                                <small>Hiển thị ${subjectPage.numberOfElements} trên tổng số ${subjectPage.totalElements} môn học (Trang ${subjectPage.number + 1}/${subjectPage.totalPages})</small>
                            </div>
                            <nav aria-label="Page navigation">
                                <ul class="pagination justify-content-center">
                                    <li class="page-item ${subjectPage.first ? 'disabled' : ''}">
                                        <c:url value="/admin/subject/pending" var="firstPageLink">
                                            <c:param name="filterName" value="${filterName}" />
                                            <c:param name="submittedByName" value="${submittedわるByName}" />
                                            <c:param name="page" value="0" />
                                            <c:param name="size" value="${pageSize}" />
                                        </c:url>
                                        <a class="page-link" href="${firstPageLink}" aria-label="First">««</a>
                                    </li>
                                    <li class="page-item ${subjectPage.first ? 'disabled' : ''}">
                                        <c:url value="/admin/subject/pending" var="prevPageLink">
                                            <c:param name="filterName" value="${filterName}" />
                                            <c:param name="submittedByName" value="${submittedByName}" />
                                            <c:param name="page" value="${subjectPage.number - 1}" />
                                            <c:param name="size" value="${pageSize}" />
                                        </c:url>
                                        <a class="page-link" href="${prevPageLink}" aria-label="Previous">«</a>
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
                                        <a class="page-link" href="${nextPageLink}" aria-label="Next">»</a>
                                    </li>
                                    <li class="page-item ${subjectPage.last ? 'disabled' : ''}">
                                        <c:url value="/admin/subject/pending" var="lastPageLink">
                                            <c:param name="filterName" value="${filterName}" />
                                            <c:param name="submittedByName" value="${submittedByName}" />
                                            <c:param name="page" value="${subjectPage.totalPages - 1}" />
                                            <c:param name="size" value="${pageSize}" />
                                        </c:url>
                                        <a class="page-link" href="${lastPageLink}" aria-label="Last">»»</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<footer>
    <jsp:include page="../../content-manager/layout/footer.jsp" />
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>