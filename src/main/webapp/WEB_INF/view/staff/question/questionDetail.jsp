<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Chi tiết câu hỏi</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
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
        }
        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
        }
        .detail-container {
            background: #fff;
            border-radius: 0.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            padding: 2rem;
            max-width: 900px;
            margin: 0 auto;
        }
        .option-item {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 0.25rem;
            margin-bottom: 1rem;
            border: 1px solid #dee2e6;
        }
        .image-preview {
            max-width: 300px;
            max-height: 300px;
            border-radius: 0.25rem;
            margin-top: 1rem;
            object-fit: contain;
        }
    </style>
    <!-- MathJax for rendering LaTeX formulas -->
    <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
    <script>
        $(document).ready(function () {
            // Trigger MathJax rendering after page load
            MathJax.typeset();
        });
    </script>
</head>
<body>
<!-- Header -->
<header>
    <jsp:include page="../layout_staff/header.jsp"/>
</header>

<!-- Main Container for Sidebar and Content -->
<div class="main-container">
    <!-- Sidebar -->
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../layout_staff/sidebar.jsp"/>
    </div>

    <!-- Main Content Area -->
    <div class="content">
        <main>
            <div class="container-fluid">
                <div class="mt-4">
                    <div class="detail-container">
                        <h1 class="mb-4 fw-bold">Chi tiết câu hỏi</h1>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <div class="mb-3">
                            <h5 class="fw-semibold">Khối</h5>
                            <p>${question.grade.gradeName}</p>
                        </div>
                        <div class="mb-3">
                            <h5 class="fw-semibold">Môn học</h5>
                            <p>${question.subject.subjectName}</p>
                        </div>
                        <div class="mb-3">
                            <h5 class="fw-semibold">Chương</h5>
                            <p>${question.chapter.chapterName}</p>
                        </div>
                        <div class="mb-3">
                            <h5 class="fw-semibold">Bài học</h5>
                            <p>${question.lesson.lessonName}</p>
                        </div>
                        <div class="mb-3">
                            <h5 class="fw-semibold">Nội dung câu hỏi</h5>
                            <p><c:out value="${question.content}" escapeXml="false"/></p>
                        </div>
                        <c:if test="${not empty question.image}">
                            <div class="mb-3">
                                <h5 class="fw-semibold">Hình ảnh</h5>
                                <img src="/img/question_bank/${question.image}" class="image-preview" alt="Hình ảnh câu hỏi"/>
                            </div>
                        </c:if>
                        <div class="mb-3">
                            <h5 class="fw-semibold">Đáp án</h5>
                            <c:forEach var="option" items="${options}" varStatus="status">
                                <div class="option-item">
                                    <p><strong>Đáp án ${status.count}:</strong> <c:out value="${option.text}" escapeXml="false"/></p>
                                    <p><strong>Trạng thái:</strong> ${option.correct ? 'Đúng' : 'Sai'}</p>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="mb-3">
                            <h5 class="fw-semibold">Mức độ</h5>
                            <p>${question.levelQuestion.levelQuestionName}</p>
                        </div>
                        <div class="mb-3">
                            <h5 class="fw-semibold">Trạng thái</h5>
                            <p>
                                <c:choose>
                                    <c:when test="${question.status.statusName == 'Pending'}">Đang xử lý</c:when>
                                    <c:when test="${question.status.statusName == 'Accepted'}">Chấp nhận</c:when>
                                    <c:when test="${question.status.statusName == 'Rejected'}">Từ chối</c:when>
                                    <c:otherwise>${question.status.statusName}</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="mb-3">
                            <h5 class="fw-semibold">Kích hoạt</h5>
                            <p>${question.active ? 'Có' : 'Không'}</p>
                        </div>
                        <c:if test="${not empty question.reason}">
                            <div class="mb-3">
                                <h5 class="fw-semibold">Lý do</h5>
                                <p><c:out value="${question.reason}" escapeXml="false"/></p>
                            </div>
                        </c:if>
                        <div class="d-flex gap-2">
                            <a href="/staff/questions" class="btn btn-secondary">Quay lại</a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Footer -->
<footer>
    <jsp:include page="../layout_staff/footer.jsp"/>
</footer>
</body>
</html>
