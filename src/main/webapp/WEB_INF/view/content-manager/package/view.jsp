<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chi tiết gói học - ${pkg.name}</title>
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
                        z-index: 1000;
                        /* Thêm z-index để đảm bảo header nổi trên cùng */
                    }

                    .content {
                        margin-left: 250px;
                        padding: 20px;
                        padding-top: 30px;
                        /* Tăng để chừa không gian header (60px) + thêm chút khoảng cách */
                        padding-bottom: 100px;
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

                    .package-title {
                        border-bottom: 2px solid #212529;
                        padding-bottom: 10px;
                        margin-bottom: 20px;
                    }

                    .info-label {
                        font-weight: bold;
                        width: 150px;
                        display: inline-block;
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
                    <!-- Package Title -->
                    <h2 class="package-title">${pkg.name}</h2>

                    <!-- Warnings and Errors -->
                    <c:if test="${not empty warning}">
                        <div class="alert alert-warning">${warning}</div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>

                    <!-- Package Info -->
                    <h4>Thông tin gói học</h4>
                    <div class="card mb-4">
                        <div class="card-body">
                            <p><span class="info-label">Mô tả:</span> ${pkg.description}</p>
                            <p><span class="info-label">Giá:</span>
                                <fmt:formatNumber value="${pkg.price}" type="number" groupingUsed="true" /> VNĐ
                            </p>



                            <p><span class="info-label">Thời hạn:</span> ${pkg.durationDays} ngày</p>
                            <p><span class="info-label">Khối lớp:</span> ${pkg.grade.gradeName}</p>
                            <p><span class="info-label">Trạng thái:</span>
                                <c:choose>
                                    <c:when test="${pkg.status == 'APPROVED'}"><span class="badge bg-success">Đã
                                            duyệt</span></c:when>
                                    <c:when test="${pkg.status == 'PENDING'}"><span class="badge bg-warning">Chờ
                                            duyệt</span></c:when>
                                    <c:otherwise><span class="badge bg-danger">Bị từ chối</span></c:otherwise>
                                </c:choose>
                            </p>

                            <p><span class="info-label">Người tạo:</span> ${pkg.userCreated}</p>
                            <p><span class="info-label">Ngày tạo:</span> ${pkg.createdAt}</p>
                            <p><span class="info-label">Ngày sửa:</span> ${pkg.updatedAt}</p>

                            <p><span class="info-label">Hình ảnh:</span>
                                <img src="/img/package/${pkg.image}" alt="Image" class="img-fluid rounded"
                                    style="max-height: 200px;" />
                            </p>
                        </div>
                    </div>

                    <!-- Subjects List -->
                    <h4>Danh sách môn học</h4>

                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Tên môn học</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty subjects}">
                                        <c:forEach var="subject" items="${subjects}">
                                            <tr>
                                                <td>${subject.subjectId}</td>
                                                <td>${subject.subjectName}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="2" class="text-center">Không có môn học nào</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Action Buttons -->
                    <div class="mt-3">
                        <c:if test="${pkg.status == 'PENDING'}">
                            <form action="/admin/package/approve/${pkg.packageId}" method="post"
                                style="display:inline;">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn btn-success"><i class="bi bi-check-circle"></i>
                                    Duyệt</button>
                            </form>
                            <form action="/admin/package/reject/${pkg.packageId}" method="post"
                                style="display:inline;">
                                <button type="submit" class="btn btn-danger mx-2"><i class="bi bi-x-circle"></i> Từ
                                    chối</button>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            </form>
                        </c:if>
                        <c:if test="${pkg.status == 'APPROVED'}">
                            <form action="/admin/package/edit/${pkg.packageId}" method="post" style="display:inline;">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="btn btn-warning mx-2">
                                    <i class="bi ${pkg.active ? 'bi-toggle-off' : 'bi-toggle-on'}"></i>
                                    ${pkg.active ? 'Ngừng bán' : 'Tiếp tục bán'}
                                </button>
                            </form>
                        </c:if>
                        <a href="/admin/package" class="btn btn-secondary">Quay lại</a>
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