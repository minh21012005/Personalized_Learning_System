<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Grade List</title>
            <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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
                }

                .btn-lg {
                    padding: 0.5rem 1.2rem;
                }
            </style>
        </head>

        <body>
            <!-- Header -->
            <header>
                <jsp:include page="../layout/header.jsp" />
            </header>

            <!-- Sidebar -->
            <div class="sidebar">
                <jsp:include page="../layout/sidebar.jsp" />
            </div>

            <!-- Main Content -->
            <div class="content">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h3 class="mb-0">Grade List</h3>
                    <a href="/admin/grade/create" class="btn btn-primary btn-lg">
                        <i class="bi bi-plus-lg"></i> Create
                    </a>
                </div>

                <!-- Search + Filter Form -->
                <form action="/admin/grade" method="get" class="row g-2 align-items-center mb-4">
                    <div class="col-md-4">
                        <input type="text" id="keyword" name="keyword" class="form-control"
                            placeholder="Search by Grade Name" value="${param.keyword}">
                    </div>
                    <div class="col-md-3">
                        <select id="isActive" name="isActive" class="form-select">
                            <option value="" <c:if test="${empty param.isActive}">selected</c:if>>Tất cả</option>
                            <option value="true" <c:if test="${param.isActive eq 'true'}">selected</c:if>>Hoạt động
                            </option>
                            <option value="false" <c:if test="${param.isActive eq 'false'}">selected</c:if>>Không hoạt
                                động
                            </option>
                        </select>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Tìm</button>
                        <a href="/admin/grade" class="btn btn-secondary">Xóa lọc</a>
                    </div>
                </form>

                <!-- Grade Table -->
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="table-dark text-center">
                            <tr>
                                <th>Grade ID</th>
                                <th>Grade Name</th>
                                <th>Active</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty grades}">
                                    <c:forEach var="grade" items="${grades}">
                                        <tr>
                                            <td class="text-center">${grade.gradeId}</td>
                                            <td>${grade.gradeName}</td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${grade.active}"><span
                                                            class="badge bg-success">Active</span></c:when>
                                                    <c:otherwise><span class="badge bg-danger">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <a href="/admin/grade/view/${grade.gradeId}"
                                                    class="btn btn-success btn-sm"><i class="bi bi-eye"></i> Xem chi
                                                    tiết</a>
                                                <a href="/admin/grade/update/${grade.gradeId}"
                                                    class="btn btn-warning btn-sm mx-1"><i
                                                        class="bi bi-pencil-square"></i> Sửa</a>

                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="text-center">Không có khổi nào được tìm thấy</td>
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
                                    href="/admin/grade?page=${currentPage - 1}&keyword=${param.keyword}&isActive=${param.isActive}">«</a>
                            </li>
                            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link"
                                        href="/admin/grade?page=${i}&keyword=${param.keyword}&isActive=${param.isActive}">${i
                                        + 1}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                    href="/admin/grade?page=${currentPage + 1}&keyword=${param.keyword}&isActive=${param.isActive}">»</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>

                <!-- Total Count -->
                <div class="text-center mt-3">
                    <p>Total Grades: <strong>${totalItems}</strong></p>
                </div>
            </div>

            <!-- Footer -->
            <footer>
                <jsp:include page="../layout/footer.jsp" />
            </footer>

            <!-- Bootstrap JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>