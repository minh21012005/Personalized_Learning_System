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
                    top: 55px;
                    left: 0;
                    width: 250px;
                    height: calc(100vh - 60px - 40px);
                    z-index: 1;
                    background-color: #212529;
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
                    /* Đảm bảo nội dung không bị che bởi footer */
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

                /* Tùy chỉnh container để căn giữa và thêm khoảng cách */
                .custom-container {
                    max-width: 900px;
                    /* Giới hạn chiều rộng tối đa */
                    margin: 0 auto;
                    /* Căn giữa */
                    padding: 20px;
                    background-color: #fff;
                    /* Nền trắng để nổi bật */
                    border-radius: 8px;
                    /* Bo góc nhẹ */
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                    /* Hiệu ứng bóng */
                }

                /* Căn chỉnh bảng */
                .table {
                    margin-top: 20px;
                }

                /* Căn chỉnh nút Quay lại */
                .btn-back {
                    margin-top: 20px;
                    display: block;
                    width: fit-content;
                }
            </style>
        </head>

        <body>
            <!-- Include Header -->
            <header>
                <jsp:include page="../layout/header.jsp" />
            </header>

            <!-- Include Sidebar -->
            <div class="sidebar">
                <jsp:include page="../layout/sidebar.jsp" />
            </div>

            <!-- Main Content Area -->
            <div class="content">
                <div class="custom-container">
                    <!-- Hiển thị thông báo lỗi nếu có -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Hiển thị cảnh báo nếu Grade không hoạt động -->
                    <c:if test="${empty errorMessage and not empty warning}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            ${warning}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Hiển thị danh sách nếu không có lỗi -->
                    <c:if test="${empty errorMessage}">
                        <h2 class="text-center mb-4">Danh sách môn học của ${grade.gradeName}</h2>
                        <table class="table table-bordered table-hover">
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
                                        <td>${subject.subjectImage}</td>
                                        <td>${subject.active ? 'true' : 'false'}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty subjects}">
                                    <tr>
                                        <td colspan="5" class="text-center">Không có môn học nào đang hoạt động.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                        <a href="/content-manager/grade" class="btn btn-primary btn-back">Quay lại</a>
                    </c:if>
                </div>
            </div>

            <!-- Include Footer -->
            <footer>
                <jsp:include page="../layout/footer.jsp" />
            </footer>

            <!-- Bootstrap 5 JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>