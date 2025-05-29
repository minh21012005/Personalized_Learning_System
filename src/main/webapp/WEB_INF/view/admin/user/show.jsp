<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PLS - Quản lí người dùng</title>
            <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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
                    /* Prevent overlap with pagination */
                }

                footer {
                    background-color: #1a252f;
                    color: white;
                    height: 40px;
                    width: 100%;
                }

                /* Ensure consistent table column widths */
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

                /* Define specific widths for each column */
                .col-id {
                    width: 5%;
                }

                .col-email {
                    width: 27.5%;
                }

                .col-fullname {
                    width: 27.5%;
                }

                .col-role {
                    width: 20%;
                }

                .col-action {
                    width: 20%;
                }

                /* Style for pagination container */
                .pagination-container {
                    position: fixed;
                    bottom: 50px;
                    /* Position above the footer (footer height is 40px) */
                    left: 250px;
                    /* Offset by sidebar width */
                    width: calc(100% - 250px);
                    /* Span remaining width */
                    max-width: 1140px;
                    /* Match container-fluid max-width */
                    background-color: #f8f9fa;
                    /* Match content background */
                    padding: 10px 20px;
                    z-index: 1000;
                    /* Ensure it appears above other content */
                }

                /* Tùy chỉnh phân trang */
                .pagination .page-link {
                    color: black;
                    /* Màu chữ đen */
                    border: 1px solid #dee2e6;
                }

                .pagination .page-link:hover {
                    background-color: #e9ecef;
                    color: black;
                }

                .pagination .page-item.active .page-link {
                    background-color: #d3d3d3;
                    /* Màu nền mới cho trang hiện tại */
                    border-color: #d3d3d3;
                    color: black;
                    /* Giữ chữ đen */
                }

                .pagination .page-item.disabled .page-link {
                    color: #6c757d;
                    pointer-events: none;
                    background-color: #fff;
                    border-color: #dee2e6;
                }
            </style>
        </head>

        <body>
            <!-- Header -->
            <header>
                <jsp:include page="../layout/header.jsp" />
            </header>

            <!-- Main Container for Sidebar and Content -->
            <div class="main-container">
                <!-- Sidebar -->
                <div class="sidebar d-flex flex-column">
                    <jsp:include page="../layout/sidebar.jsp" />
                </div>

                <!-- Main Content Area -->
                <div class="content">
                    <main>
                        <div class="container-fluid px-4">
                            <div class="mt-4">
                                <div class="row col-12 mx-auto">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <!-- Bộ lọc role -->
                                        <form action="/admin/user" method="get"
                                            class="d-flex align-items-center gap-2 flex-wrap">
                                            <label for="role" class="mb-0 fw-bold me-2">Vai trò:</label>
                                            <select name="role" id="role" class="form-select form-select-sm w-auto">
                                                <option value="">Tất cả</option>
                                                <c:forEach var="r" items="${roles}">
                                                    <c:choose>
                                                        <c:when test="${r.roleName eq selectedRole}">
                                                            <option value="${r.roleName}" selected>${r.roleDescription}
                                                            </option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${r.roleName}">${r.roleDescription}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>

                                            <label for="name" class="mb-0 fw-bold me-2">Họ và tên:</label>
                                            <input type="text" id="name" name="name"
                                                class="form-control form-control-sm w-auto" value="${param.name}"
                                                placeholder="Tìm theo tên...">

                                            <button type="submit" class="btn btn-outline-primary btn-sm">Lọc</button>
                                        </form>


                                        <!-- Nút tạo user -->
                                        <a href="/admin/user/create" class="btn btn-primary">Tạo tài khoản</a>
                                    </div>

                                    <hr />
                                    <table class="table table-bordered table-hover table-fixed">
                                        <thead>
                                            <tr>
                                                <th scope="col" class="text-center col-id">ID</th>
                                                <th scope="col" class="text-center col-email">Email</th>
                                                <th scope="col" class="text-center col-fullname">Họ và tên</th>
                                                <th scope="col" class="text-center col-role">Vai trò</th>
                                                <th scope="col" class="text-center col-action">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="user" items="${users}">
                                                <tr>
                                                    <td class="text-center col-id">${user.userId}</td>
                                                    <td class="col-email">${user.email}</td>
                                                    <td class="col-fullname">${user.fullName}</td>
                                                    <td class="col-role">${user.role.roleDescription}</td>
                                                    <td class="text-center col-action">
                                                        <div class="d-flex justify-content-center gap-2">
                                                            <a href="/admin/user/${user.userId}"
                                                                class="btn btn-success btn-sm">Chi tiết</a>
                                                            <a href="/admin/user/update/${user.userId}"
                                                                class="btn btn-warning btn-sm">Cập nhật</a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                    <div class="pagination-container">
                                        <c:set var="queryString" value="" />

                                        <c:if test="${not empty selectedRole}">
                                            <c:set var="queryString" value="${queryString}&role=${selectedRole}" />
                                        </c:if>

                                        <c:if test="${not empty paramName}">
                                            <c:set var="queryString" value="${queryString}&name=${paramName}" />
                                        </c:if>
                                        <c:if test="${totalPage >1}">
                                            <nav aria-label="Page navigation example">
                                                <ul class="pagination justify-content-center">
                                                    <li class="page-item ${currentPage eq 1 ? 'disabled' : ''}">
                                                        <a class="page-link"
                                                            href="/admin/user?page=${currentPage - 1}${queryString}"
                                                            aria-label="Previous">
                                                            <span aria-hidden="true">«</span>
                                                        </a>
                                                    </li>
                                                    <c:forEach begin="1" end="${totalPage}" varStatus="loop">
                                                        <li
                                                            class="page-item ${loop.index eq currentPage ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="/admin/user?page=${loop.index}${queryString}">${loop.index}</a>
                                                        </li>
                                                    </c:forEach>
                                                    <li class="page-item ${currentPage eq totalPage ? 'disabled' : ''}">
                                                        <a class="page-link"
                                                            href="/admin/user?page=${currentPage + 1}${queryString}"
                                                            aria-label="Next">
                                                            <span aria-hidden="true">»</span>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </nav>
                                        </c:if>

                                    </div>
                                </div>
                            </div>
                    </main>
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