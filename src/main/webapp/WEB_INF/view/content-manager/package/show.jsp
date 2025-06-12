<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Danh sách gói học</title>
                <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                    rel="stylesheet">
                <style>
                    body {
                        margin: 0;
                        padding-top: 60px;
                    }

                    header {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        height: 60px;
                        background-color: #212529;
                    }

                    .sidebar {
                        position: fixed;
                        top: 60px;
                        bottom: 40px;
                        left: 0;
                        width: 250px;
                        background-color: #212529;
                        color: #fff;
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
                    }

                    .table th,
                    .table td {
                        vertical-align: middle;
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

                <!-- Content -->
                <div class="content">
                    <h3>Danh sách gói học</h3>

                    <!-- Filter Form -->
                    <form action="/manager/package" method="get" class="row g-2 mb-4">
                        <div class="col-md-2">
                            <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên"
                                value="${param.keyword}">
                        </div>
                        <div class="col-md-3">
                            <select name="status" class="form-select">
                                <option value="" ${empty param.status ? 'selected' : '' }>Tất cả</option>
                                <option value="PENDING" ${param.status=='PENDING' ? 'selected' : '' }>Chờ duyệt</option>
                                <option value="APPROVED" ${param.status=='APPROVED' ? 'selected' : '' }>Đã duyệt
                                </option>
                                <option value="REJECTED" ${param.status=='REJECTED' ? 'selected' : '' }>Bị từ chối
                                </option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select name="gradeId" class="form-select">
                                <option value="" ${empty param.gradeId ? 'selected' : '' }>Tất cả</option>
                                <c:forEach items="${grades}" var="grade">
                                    <option value="${grade.gradeId}" ${param.gradeId==grade.gradeId ? 'selected' : '' }>
                                        ${grade.gradeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Tìm</button>
                            <a href="/manager/package" class="btn btn-secondary">Xóa lọc</a>
                        </div>
                    </form>

                    <!-- Package Table -->
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle">
                            <thead class="table-dark text-center">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên</th>
                                    <th>Trạng thái</th>
                                    <th>Mô tả</th>
                                    <th>Hình ảnh</th>
                                    <th>Người tạo</th>
                                    <th>Ngày tạo</th>
                                    <th>Ngày sửa</th>
                                    <th>Active</th>
                                    <th>Hành động</th>
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
                                                <td>
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
                                                        alt="Image" class="img-fluid rounded border" />
                                                </td>
                                                <td>${pkg.userCreated}</td>
                                                <td>${pkg.createdAt}</td>
                                                <td>${pkg.updatedAt}</td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${pkg.active}"><span
                                                                class="badge bg-success">Active</span></c:when>
                                                        <c:otherwise><span class="badge bg-secondary">Inactive</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <a href="/manager/package/view/${pkg.packageId}"
                                                        class="btn btn-success btn-sm"><i class="bi bi-eye"></i> Xem</a>


                                                </td>

                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="10" class="text-center">Không tìm thấy gói học nào</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav>
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="/manager/package?page=${currentPage - 1}&keyword=${param.keyword}&status=${param.status}&gradeId=${param.gradeId}">«</a>
                                </li>
                                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link"
                                            href="/manager/package?page=${i}&keyword=${param.keyword}&status=${param.status}&gradeId=${param.gradeId}">${i
                                            + 1}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="/manager/package?page=${currentPage + 1}&keyword=${param.keyword}&status=${param.status}&gradeId=${param.gradeId}">»</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>

                    <!-- Total -->
                    <div class="text-center mt-3">
                        <p>Tổng số gói: <strong>${totalItems}</strong></p>
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