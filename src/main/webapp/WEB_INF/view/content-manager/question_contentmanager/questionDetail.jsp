<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Chi tiết câu hỏi</title>
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
            padding-bottom: 100px;
        }

        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
        }

        .question-image {
            max-width: 100%;
            height: auto;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
    <script>
        $(document).ready(function () {
            MathJax.typeset();
        });
    </script>
</head>
<body>
<!-- Header -->
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>

<!-- Main Container for Sidebar and Content -->
<div class="main-container">
    <!-- Sidebar -->
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../layout/sidebar.jsp"/>
    </div>

    <!-- Main Content Area -->
    <div class="content">
        <main>
            <div class="container-fluid">
                <h2>Chi tiết câu hỏi</h2>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <c:if test="${not empty question}">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Câu hỏi ID: ${question.questionId}</h5>
                            <p><strong>Nội dung:</strong></p>
                            <p><c:out value="${question.content}" escapeXml="false"/></p>
                            <c:if test="${not empty question.image}">
                                <p><strong>Hình ảnh:</strong></p>
                                <img style="width: 500px;height:auto;" src="/img/question_bank/${question.image}" alt="Question Image" class="question-image">
                            </c:if>
                            <p><strong>Đáp án:</strong></p>
                            <ul>
                                <c:forEach var="option" items="${options}" varStatus="loop">
                                    <li>
                                            ${loop.index + 1}. <c:out value="${option.text}" escapeXml="false"/>
                                        <c:if test="${option.correct}"><span class="text-success">(Đúng)</span></c:if>
                                    </li>
                                </c:forEach>
                            </ul>
                            <p><strong>Khối:</strong> ${question.grade.gradeName}</p>
                            <p><strong>Môn học:</strong> ${question.subject.subjectName}</p>
                            <p><strong>Chương:</strong> ${question.chapter.chapterName}</p>
                            <p><strong>Bài học:</strong> ${question.lesson.lessonName}</p>
                            <p><strong>Mức độ:</strong> ${question.levelQuestion.levelQuestionName}</p>
                            <p><strong>Trạng thái:</strong> Đang xử lý</p>
                            <div class="d-flex gap-2">
                                <form action="/admin/questions/approve/${question.questionId}" method="post">
                                    <button type="submit" class="btn btn-primary approve-btn">Phê duyệt</button>
                                </form>
                                <form action="/admin/questions/reject/${question.questionId}" method="post">
                                    <button type="submit" class="btn btn-danger reject-btn">Từ chối</button>
                                </form>
                                <a href="/admin/questions" class="btn btn-secondary">Quay lại</a>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>

<!-- Footer -->
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>
</body>
</html>