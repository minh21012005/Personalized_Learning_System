<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>PLS - Quản lí giao dịch</title>
                    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css" />
                    <script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
                    <style>
                        body {
                            margin: 0;
                            min-height: 100vh;
                            display: flex;
                            flex-direction: column;
                            overflow-x: hidden;
                            font-family: Arial, sans-serif;
                        }

                        header {
                            background-color: #1a252f;
                            color: white;
                            width: 100%;
                        }

                        .main-container {
                            display: flex;
                            flex: 1;
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
                            padding-bottom: 80px;
                        }

                        footer {
                            background-color: #1a252f;
                            color: white;
                            height: 40px;
                            width: 100%;
                        }

                        .table-fixed {
                            table-layout: fixed;
                            width: 100%;
                        }

                        .table-fixed th,
                        .table-fixed td {
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap;
                        }

                        .col-id {
                            width: 4%;
                            min-width: 50px;
                        }

                        .col-transfer-code {
                            width: 12.5%;
                            min-width: 120px;
                            word-break: break-word;
                        }

                        .col-customer {
                            width: 17.5%;
                            min-width: 150px;
                            word-break: break-word;
                        }

                        .col-package {
                            width: 17%;
                            min-width: 180px;
                            word-break: break-word;
                        }

                        .col-amount {
                            width: 10%;
                            min-width: 100px;
                            text-align: right;
                        }

                        .col-created-at {
                            width: 14%;
                            min-width: 140px;
                            white-space: nowrap;
                        }

                        .col-status {
                            width: 10%;
                            min-width: 100px;
                            text-align: center;
                        }

                        .col-action {
                            width: 10%;
                            min-width: 100px;
                            text-align: center;
                        }

                        .pagination-container {
                            margin-top: 20px;
                            margin-bottom: -30px;
                            width: 100%;
                            background-color: #f8f9fa;
                            padding: 10px 20px;
                            z-index: 1000;
                            display: flex;
                            justify-content: center;
                        }

                        .pagination .page-link {
                            color: black;
                            border: 1px solid #dee2e6;
                        }

                        .pagination .page-link:hover {
                            background-color: #e9ecef;
                            color: black;
                        }

                        .pagination .page-item.active .page-link {
                            background-color: #d3d3d3;
                            border-color: #d3d3d3;
                            color: black;
                        }

                        .pagination .page-item.disabled .page-link {
                            color: #6c757d;
                            pointer-events: none;
                            background-color: #fff;
                            border-color: #dee2e6;
                        }

                        .status-pending {
                            color: orange;
                        }

                        .status-approved {
                            color: green;
                        }

                        .status-rejected {
                            color: red;
                        }

                        .comment-preview {
                            max-width: 400px;
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap;
                        }

                        .container {
                            flex: 1;
                        }

                        .body {
                            margin: 0;
                            min-height: 100vh;
                            display: flex;
                            flex-direction: column;
                            overflow-x: hidden;
                            /* Prevent horizontal scroll from fixed elements */
                        }

                        .sidebar {
                            width: 250px;
                            background-color: #1a252f;
                            color: white;
                            overflow-y: auto;

                        }

                        .header {
                            position: fixed;
                            top: 0;
                            left: 0;
                            right: 0;
                            z-index: 3;
                            /* On top */
                            background-color: #212529;
                            /* Dark background to match image */
                        }

                        .content {
                            padding: 20px;
                            flex: 1;
                            /* Fill available space */
                        }

                        .footer {
                            margin-top: 14%;
                            background-color: #212529;
                            color: white;
                            height: 40px;
                            text-align: center;
                            line-height: 40px;
                        }


                     .table-bordered td:nth-child(3),
.table-bordered td:nth-child(5) {
    max-width: 300px;
    word-wrap: break-word;
    white-space: normal;
}


                       .table-bordered td:nth-child(4) {
    white-space: nowrap;
}
                       


                        .table-bordered td:nth-child(1) {
                            width: 1px;
                            /* Reduced width to make it smaller */
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .table-bordered td:nth-child(2) {
                            width: 1px;
                            /* Reduced width to make it smaller */
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .table-bordered td:nth-child(6) {
                            width: 25px;
                            /* Reduced width to make it smaller */
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }
                    </style>
                    </style>
                </head>

                <body>
                    <header>
                        <jsp:include page="../layout/header.jsp" />
                    </header>
                    <div class="main-container">
                        <div class="sidebar d-flex flex-column">
                            <jsp:include page="../layout/sidebar.jsp" />
                        </div>
                        <div class="content">
                            <main>
                                <div class="container-fluid px-4">
                                    <div class="mt-4">
                                        <h1>Quản lý đánh giá</h1>

                                        <!-- Filter Panel -->
                                        <form method="get" action="/admin/reviews" class="mb-4">
                                            <div class="row">
                                                <div class="col-md-2">
                                                    <label>Loại đánh giá</label>
                                                    <select name="type" class="form-select">
                                                        <option value="">Tất cả</option>
                                                        <option value="Package" ${type=='Package' ? 'selected' : '' }>
                                                            Package
                                                        </option>
                                                        <option value="Subject" ${type=='Subject' ? 'selected' : '' }>
                                                            Subject
                                                        </option>
                                                    </select>
                                                </div>
                                                <div class="col-md-3">
                                                    <label>Package/Subject</label>
                                                    <select name="packageId" class="form-select" ${type !='Package'
                                                        ? 'disabled' : '' }>
                                                        <option value="">Chọn Package</option>
                                                        <option value="" ${packageId=='all' ? 'selected' : '' }>Tất cả
                                                        </option>
                                                        <c:forEach var="pkg" items="${packages}">
                                                            <option value="${pkg.packageId}" ${packageId==pkg.packageId
                                                                ? 'selected' : '' }>
                                                                ${pkg.name}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                    <select name="subjectId" class="form-select" ${type !='Subject'
                                                        ? 'disabled' : '' }>
                                                        <option value="">Chọn Subject</option>
                                                        <option value="" ${subjectId=='all' ? 'selected' : '' }>Tất cả
                                                        </option>
                                                        <c:forEach var="subject" items="${subjects}">
                                                            <option value="${subject.subjectId}"
                                                                ${subjectId==subject.subjectId ? 'selected' : '' }>
                                                                ${subject.subjectName}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <label>Trạng thái</label>
                                                    <select name="status" class="form-select">
                                                        <option value="" ${param.status==null || param.status==''
                                                            ? 'selected' : '' }>Tất cả
                                                        </option>
                                                        <c:forEach var="s" items="${statuses}">
                                                            <option value="${s}" ${s==param.status ? 'selected' : '' }>
                                                                ${s}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <label>Rating</label>
                                                    <select name="rating" class="form-select">
                                                        <option value="" ${rating==null || rating=='' ? 'selected' : ''
                                                            }>Tất cả
                                                        </option>
                                                        <c:forEach var="r" items="${ratings}">
                                                            <option value="${r}" ${rating==r ? 'selected' : '' }>${r}
                                                                sao
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <label>Từ khóa bình luận</label>
                                                    <input type="text" name="comment" class="form-control"
                                                        value="${comment}">
                                                </div>
                                            </div>
                                            <div class="mt-2">
                                                <button type="submit" class="btn btn-primary">Lọc</button>
                                                <a href="/admin/reviews" class="btn btn-secondary">Xóa bộ lọc</a>
                                            </div>
                                        </form>

                                        <!-- Review Table -->
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>STT</th>
                                                    <th>ID</th>
                                                    <th>Gói học</th>
                                                    <th>Rating</th>
                                                    <th>Bình luận</th>
                                                    <th>Trạng thái</th>
                                                    <th class="actioncss">Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="review" items="${reviews}" varStatus="loop">
                                                    <tr>
                                                        <td>${loop.index + 1 + (currentPage * size)}</td>
                                                        <td>${review.reviewId}</a></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${review.pkg != null}">${review.pkg.name}
                                                                </c:when>
                                                                <c:when test="${review.subject != null}">
                                                                    ${review.subject.subjectName}</c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                                                        </td>
                                                        <td class="comment-preview" title="${review.comment}">
                                                            ${review.comment}
                                                        </td>
                                                        <td class="status-${review.status.toString().toLowerCase()}">
                                                            ${review.status}</td>
                                                        <td>
                                                            <c:if test="${review.status == 'PENDING'}">
                                                                 <div class="d-flex gap-1">
                                                                <form action="/admin/reviews/${review.reviewId}/approve"
                                                                    method="post" style="display:inline;">
                                                                    <button type="submit"
                                                                        class="btn btn-success btn-sm">Approve</button>
                                                                </form>
                                                                <form action="/admin/reviews/${review.reviewId}/reject"
                                                                    method="post" style="display:inline;">
                                                                    <button type="submit"
                                                                        class="btn btn-danger btn-sm">Reject</button>
                                                                </form>
                                                            </div>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>

                                        <c:if test="${totalPages > 1}">
                                            <nav>
                                                <ul class="pagination justify-content-center">
                                                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                                        <a class="page-link"
                                                            href="/admin/reviews?page=${currentPage - 1}&type=${type}&packageId=${packageId}&subjectId=${subjectId}&status=${status}&rating=${rating}&comment=${comment}">«</a>
                                                    </li>
                                                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="/admin/reviews?page=${i}&type=${type}&packageId=${packageId}&subjectId=${subjectId}&status=${status}&rating=${rating}&comment=${comment}">${i
                                                                + 1}</a>
                                                        </li>
                                                    </c:forEach>
                                                    <li
                                                        class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                                        <a class="page-link"
                                                            href="/admin/reviews?page=${currentPage + 1}&type=${type}&packageId=${packageId}&subjectId=${subjectId}&status=${status}&rating=${rating}&comment=${comment}">»</a>
                                                    </li>
                                                </ul>
                                            </nav>
                                        </c:if>


                                        <!-- Success/Error Messages -->
                                        <c:if test="${not empty success}">
                                            <div class="alert alert-success">${success}</div>
                                        </c:if>
                                        <c:if test="${not empty error}">
                                            <div class="alert alert-danger">${error}</div>
                                        </c:if>
                                    </div>
                            </main>
                        </div>
                    </div>
                    <footer>
                        <jsp:include page="../layout/footer.jsp" />
                    </footer>
                </body>

                </html>