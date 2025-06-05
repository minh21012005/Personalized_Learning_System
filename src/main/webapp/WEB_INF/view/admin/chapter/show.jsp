<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
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
        @media (max-width: 767.98px) {
            .sidebar {
                width: 200px;
                position: fixed;
                top: 0;
                left: 0;
                height: 100%;
                transform: translateX(-100%);
                z-index: 1000;
            }
            .sidebar.active {
                transform: translateX(0);
            }
            .content {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
<%--    Header--%>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>
<%--    Header--%>

<%--    MAIN CONTAINER--%>
<div class="main-container">
    <!-- Sidebar -->
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../layout/sidebar.jsp"/>
    </div>
    <!-- Sidebar -->

    <!-- Main Content Area -->
    <div class="content">
        <main>
            <div class="container-fluid px-4">
                <div class="mt-4">
                    <div class="row col-12 mx-auto">
                        <div class="mb-3">
                            <h3>Danh sách chương học trong ${subject.subjectName}</h3>
                        </div>
                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-3">
                            <!-- Bộ lọc theo tên chương học -->
                            <form action="/admin/subject/${subject.subjectId}" method="get"
                                  class="d-flex flex-column flex-md-row align-items-md-center  mb-2 mb-md-0">
                                <label for="chapterName" class="mb-0 fw-bold me-md-2">Tìm chương:</label>
                                <div class="d-flex gap-2 ">
                                    <input type="text" id="chapterName" name="chapterName"
                                           class="form-control form-control-sm"
                                           value="${param.chapterName}"
                                           placeholder="Tìm theo tên chương...">
                                    <button type="submit" class="btn btn-outline-primary btn-sm">Lọc</button>
                                </div>
                            </form>

                            <!-- Nút tạo chương học mới -->
                            <a href="/admin/subject/${subject.subjectId}/save" class="btn btn-primary">Tạo chương học mới</a>
                        </div>

                        <%--SUCESS MESSAGE--%>
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <%--SUCESS MESSAGE--%>

                        <%--ERROR MESSAGE--%>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <%--ERROR MESSAGE--%>

                        <%--TABLE--%>
                        <table class="table table-bordered table-hover table-fixed">
                            <thead>
                            <tr>
                                <th scope="col" class="text-center col-1">ID</th>
                                <th scope="col" class="text-center  col-3">Tên chương học</th>
                                <th scope="col" class="text-center  col-6">Mô tả về chương học</th>
                                <th scope="col" class="text-center  col-2">Thao tác</th>

                            </tr>
                            </thead>
                            <tbody>
                                <c:if test="${not empty chapters}">
                                    <c:forEach var="chapter" items="${chapters}">
                                        <tr>
                                            <td class="text-center col-1">${chapter.chapterId}</td>
                                            <td class="col-3">${chapter.chapterName}</td>
                                            <td class="col-6">${chapter.chapterDescription}</td>
                                            <td class="text-center">
                                                <a href="/admin/subject/${subject.subjectId}/save?chapterId=${chapter.chapterId}"
                                                   class="btn btn-warning btn-sm">
                                                    Cập nhật
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                <c:if test="${empty chapters}">
                                    <tr>
                                        <td colspan="4" class="text-center">Chưa có chương học nào.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                        <%--TABLE--%>

                    </div>
                </div>
            </div>
        </main>
    </div>
    <!-- Main Content Area -->

</div>
<%--    MAIN CONTAINER--%>





<!-- Footer -->
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>
<!-- Footer -->

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>