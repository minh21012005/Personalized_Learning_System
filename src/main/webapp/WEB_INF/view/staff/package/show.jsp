<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Package List</title>
                <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                    rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

                <style>
                    body {
                        margin: 0;
                        padding-top: 60px;
                        /* để tránh header */
                    }

                    header {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 60px;
                        z-index: 1030;
                        background-color: #212529;
                    }

                    .sidebar {
                        position: fixed;
                        top: 60px;
                        bottom: 40px;
                        /* dính với footer */
                        left: 0;
                        width: 250px;
                        background-color: #212529;
                        color: #fff;
                        overflow-y: auto;
                    }

                    .content {
                        margin-left: 250px;
                        padding: 20px;
                    }

                    footer {
                        background-color: #212529;
                        color: white;
                        text-align: center;
                        height: 40px;
                        line-height: 40px;
                        position: fixed;
                        bottom: 0;
                        left: 0;
                        right: 0;
                        z-index: 1020;
                    }

                    .form-control {
                        width: auto;
                    }

                    .table th,
                    .table td {
                        vertical-align: middle;
                        padding: 8px;
                        /* Reduced padding for a tighter table */
                        font-size: 14px;
                        /* Adjusted font size for better readability */
                    }

                    .table th {
                        background-color: #343a40;
                        /* Darker header background */
                        color: #fff;
                        border-color: #454d55;
                        /* Matching border color */
                    }

                    .table td {
                        border-color: #dee2e6;
                        /* Lighter border for cells */
                    }

                    .table-hover tbody tr:hover {
                        background-color: #f8f9fa;
                        /* Subtle hover effect */
                    }

                    .btn-lg {
                        padding: 0.25rem 0.5rem;
                        /* Reduced padding for smaller buttons */
                        font-size: 1rem;
                        /* Smaller font size */
                    }

                    .pagination .page-item .page-link {
                        color: #000;
                        /* Default text color */
                        background-color: #e9ecef;
                        /* Gray background like in the image */
                        border: 1px solid #ddd;
                        /* Subtle border */
                        padding: 0.25rem 0.5rem;
                        /* Match button size */
                    }

                    .pagination .page-item.active .page-link {
                        background-color: #6c757d;
                        /* Gray active button like in the image */
                        border-color: #6c757d;
                        color: #fff;
                    }

                    .pagination .page-item.disabled .page-link {
                        background-color: #e9ecef;
                        /* Gray for disabled state */
                        color: #6c757d;
                    }

                    .description {
                        max-width: 270px;
                        /* Reduced width for description */
                        overflow: hidden;
                        text-overflow: ellipsis;
                        white-space: nowrap;
                    }

                    .custom-btn {
                        font-size: 12px;
                        /* Nhỏ lại chữ */
                        padding: 2px 8px;
                        /* Giảm khoảng cách trên/dưới và trái/phải */
                        line-height: 1.2;
                        border-radius: 3px;
                        /* Bo góc giống hình */
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
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h3 class="mb-0">Danh sách gói học</h3>
                        <a href="/staff/package/create" class="btn btn-primary btn-lg">
                            <i class="bi bi-plus-lg"></i> Thêm mới
                        </a>
                    </div>

                    <!-- Search + Filter Form -->
                    <form action="/staff/package" method="get" class="row g-2 align-items-center mb-4">
                        <div class="col-md-4">
                            <input type="text" id="keyword" name="keyword" class="form-control"
                                placeholder="Tìm theo tên" value="${param.keyword}">
                        </div>
                        <div class="col-md-3">
                            <select id="status" name="status" class="form-select">
                                <option value="" <c:if test="${empty param.status}">selected</c:if>>Tất cả</option>
                                <option value="PENDING" <c:if test="${param.status eq 'PENDING'}">selected</c:if>>Chờ
                                    duyệt</option>
                                <option value="APPROVED" <c:if test="${param.status eq 'APPROVED'}">selected</c:if>>Đã
                                    duyệt</option>
                                <option value="REJECTED" <c:if test="${param.status eq 'REJECTED'}">selected</c:if>>Bị
                                    từ chối</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select id="gradeId" name="gradeId" class="form-select">
                                <option value="" <c:if test="${empty param.gradeId}">selected</c:if>>Tất cả</option>
                                <c:forEach items="${grades}" var="grade">
                                    <option value="${grade.gradeId}" <c:if test="${param.gradeId == grade.gradeId}">
                                        selected
                                        </c:if>>
                                        ${grade.gradeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>


                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Tìm</button>
                            <a href="/staff/package" class="btn btn-secondary">Xóa lọc</a>
                        </div>
                    </form>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle">
                            <thead class="table-dark text-center">
                                <tr>
                                    <th>Package ID</th>
                                    <th>Package Name</th>
                                    <th>Active</th>
                                    <th>Description</th>
                                    <th>Image</th>
                                    <th>userCreated</th>
                                    <th>createdAt</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty packages}">
                                        <c:forEach var="pkg" items="${packages}">
                                            <tr>
                                                <td class="text-center">${pkg.packageId}</td>
                                                <td>${pkg.name}</td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${pkg.status == 'APPROVED'}"><span
                                                                class="badge bg-success">Đã duyệt</span></c:when>
                                                        <c:when test="${pkg.status == 'PENDING'}"><span
                                                                class="badge bg-warning">Chờ duyệt</span></c:when>
                                                        <c:otherwise><span class="badge bg-danger">Bị từ chối</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="description">
                                                    <c:choose>
                                                        <c:when test="${fn:length(pkg.description) > 100}">
                                                            ${fn:substring(pkg.description, 0, 100)}...
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${pkg.description}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td>
                                                    <img style="max-height: 50px" src="/img/package/${pkg.image}"
                                                        alt="Image not found" class="img-fluid rounded border" />
                                                </td>
                                                <td>
                                                    ${pkg.userCreated}
                                                </td>
                                                <td> ${pkg.createdAt}</td>



                                                <td class="text-center">
                                                    <div class="d-flex justify-content-center gap-2">
                                                        <a href="/staff/package/view/${pkg.packageId}"
                                                            class="btn btn-success btn-sm custom-btn">
                                                            <i class="bi bi-eye"></i> Chi tiết
                                                        </a>
                                                        <a href="/staff/package/update/${pkg.packageId}"
                                                            class="btn btn-warning btn-sm custom-btn">
                                                            <i class="bi bi-pencil-square"></i> Sửa
                                                        </a>
                                                    </div>
                                                </td>

                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="text-center">Không có gói nào được tìm thấy</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="/staff/package?page=${currentPage - 1}&keyword=${param.keyword}&isActive=${param.isActive}&gradeId=${param.gradeId}">«</a>
                                </li>
                                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link"
                                            href="/staff/package?page=${i}&keyword=${param.keyword}&status=${param.status}&gradeId=${param.gradeId}">${i
                                            + 1}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="/staff/package?page=${currentPage + 1}&keyword=${param.keyword}&status=${param.status}&gradeId=${param.gradeId}">»</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>

                    <!-- Total Count -->
                    <div class="text-center mt-3">
                        <p>Tổng số khối: <strong>${totalItems}</strong></p>
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