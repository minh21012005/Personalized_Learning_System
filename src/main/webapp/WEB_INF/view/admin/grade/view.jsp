<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
            <style>
                body {
                    margin: 0;
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                    overflow-x: hidden;
                }

                .sidebar {
                    position: fixed;
                    top: 50px;
                    bottom: 40px;
                    /* dính với footer */
                    left: 0;
                    width: 250px;
                    background-color: #212529;
                    color: #fff;
                    overflow-y: auto;
                }
                header {
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    z-index: 3;
                    background-color: #212529;
                }

                .content {
                    margin-left: 250px;
                    margin-top: 60px;
                    padding: 20px;
                    flex: 1;
                    min-height: calc(100vh - 100px);
                }

                footer {
                    position: fixed;
                    bottom: 0;
                    left: 0;
                    right: 0;
                    z-index: 2;
                    background-color: #212529;
                    height: 40px;
                }

                .custom-container {
                    max-width: 1000px;
                    margin: 0 auto;
                    padding: 20px;
                    background-color: #fff;
                    border-radius: 8px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                }

                .table {
                    margin-top: 20px;
                }

                .btn-back {
                    margin-top: 20px;
                    display: block;
                    width: fit-content;
                }

                .subject-img {
                    width: 70px;
                    height: 70px;
                    object-fit: cover;
                    border-radius: 8px;
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
                <div class="custom-container">
                    <!-- Error Message -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Warning -->
                    <c:if test="${empty errorMessage and not empty warning}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            ${warning}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Subject List -->
                    <c:if test="${empty errorMessage}">
                        <h2 class="text-center mb-4">Danh sách môn học của <strong>${grade.gradeName}</strong></h2>

                        <!-- Filter -->
                        <form action="/admin/grade/view/${grade.gradeId}" method="get" class="d-flex mb-3">
                            <input type="text" name="keyword" class="form-control me-2"
                                placeholder="Tìm kiếm theo tên môn học" value="${keyword}">
                            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                            <a href="/admin/grade/view/${grade.gradeId}" class="btn btn-secondary ms-2">Xóa bộ lọc</a>
                        </form>

                        <!-- Table -->
                        <table class="table table-bordered table-hover align-middle text-center">
                            <thead class="table-dark">
                                <tr>
                                    <th>Subject ID</th>
                                    <th>Subject Name</th>
                                    <th>Description</th>
                                    <th>Image</th>
                                    <th>Active</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="subject" items="${subjects}">
                                    <tr>
                                        <td>${subject.subjectId}</td>
                                        <td>${subject.subjectName}</td>
                                        <td>${subject.subjectDescription}</td>
                                        <td>
                                            <img style="max-height: 50px" src="/img/subjectImg/${subject.subjectImage}"
                                                alt="Image not found" class="img-fluid rounded border" />
                                        </td>
                                        <td>
                                            <span class="badge ${subject.isActive ? 'bg-success' : 'bg-secondary'}">
                                                ${subject.isActive ? 'true' : 'false'}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty subjects}">
                                    <tr>
                                        <td colspan="5" class="text-center">Không có môn học nào đang hoạt động.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav>
                                <ul class="pagination justify-content-center">
                                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                        <a class="page-link"
                                            href="/admin/grade/view/${grade.gradeId}?page=${currentPage - 1}&size=${pageable.size}&sort=${pageable.sort}&keyword=${keyword}"
                                            aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link"
                                                href="/admin/grade/view/${grade.gradeId}?page=${i}&size=${pageable.size}&sort=${pageable.sort}&keyword=${keyword}">
                                                ${i + 1}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                        <a class="page-link"
                                            href="/admin/grade/view/${grade.gradeId}?page=${currentPage + 1}&size=${pageable.size}&sort=${pageable.sort}&keyword=${keyword}"
                                            aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>

                        <!-- Back Button -->
                        <a href="/admin/grade" class="btn btn-primary btn-back">Quay lại</a>
                    </c:if>
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