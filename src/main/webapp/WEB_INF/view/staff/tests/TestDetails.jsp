<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Chi Tiết Bài Kiểm Tra</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
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
            display: flex;
            align-items: center;
            justify-content: center;
        }
        h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #1a252f;
            margin-bottom: 20px;
        }
        hr {
            border-top: 2px solid #dee2e6;
            margin: 20px 0;
        }
        .question-item {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            background-color: #ffffff;
            border-radius: 0.25rem;
            margin-bottom: 10px;
        }
        .question-item:last-child {
            border-bottom: none;
        }
        .question-item .chapter-info {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 10px;
        }
        .question-item .options {
            margin-top: 10px;
        }
        .question-item .option {
            padding: 8px;
            border-radius: 0.25rem;
            margin-bottom: 5px;
        }
        .question-item .option.correct {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .question-item .option.neutral {
            background-color: #ffffff;
            color: #212529;
            border: 1px solid #dee2e6;
        }
        .btn-back {
            background-color: #6c757d;
            border: none;
            padding: 10px 20px;
            font-size: 1rem;
            border-radius: 0.25rem;
            font-weight: 500;
            color: white;
            transition: background-color 0.3s;
        }
        .btn-back:hover {
            background-color: #5a6268;
        }
    </style>
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
                <div class="row mt-4">
                    <div class="col-md-10 col-12 mx-auto">
                        <h1>Chi Tiết Bài Kiểm Tra</h1>
                        <hr/>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <div class="mb-3">
                            <h4>Tên bài kiểm tra: ${fn:escapeXml(test.testName)}</h4>
                            <p><strong>Môn học:</strong> ${fn:escapeXml(test.subjectName)}</p>
                            <p><strong>Chương:</strong> ${fn:escapeXml(test.chapterName)}</p>
                            <p><strong>Thời gian (phút):</strong> ${test.durationTime}</p>
                            <p><strong>Thời gian bắt đầu:</strong> ${test.startAt}</p>
                            <p><strong>Thời gian kết thúc:</strong> ${test.endAt}</p>
                            <p><strong>Trạng thái:</strong> ${fn:escapeXml(test.statusName)}</p>
                            <p><strong>Danh mục:</strong> ${fn:escapeXml(test.categoryName)}</p>
                        </div>
                        <hr/>
                        <h5>Danh Sách Câu Hỏi</h5>
                        <div class="question-list">
                            <c:forEach var="question" items="${test.questions}">
                                <div class="question-item">
                                    <p><strong>Câu hỏi:</strong> ${fn:escapeXml(question.content)} (ID: ${question.questionId})</p>
                                    <p class="chapter-info"><strong>Chương:</strong> ${fn:escapeXml(question.chapterName)}</p>
                                    <div class="options">
                                        <c:forEach var="option" items="${question.options}">
                                            <div class="option ${option.isCorrect ? 'correct' : 'neutral'}">${fn:escapeXml(option.text)}</div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="mt-3">
                            <a href="/admin/tests/list" class="btn btn-back">Quay lại</a>
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