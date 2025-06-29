<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Bài Kiểm Tra</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .main-container {
            margin-top: 70px;
            padding: 20px;
            flex: 1;
        }
        .history-summary {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 1.2rem;
            color: #212529;
        }
        .question-card {
            background: ${answer.isCorrect ? '#e6ffe6' : '#ffffff'};
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .question-card h4 {
            color: #212529;
            font-size: 1.5rem;
            margin-bottom: 15px;
            font-weight: bold;
        }
        .question-card p {
            color: #6c757d;
            font-size: 1.1rem;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        .question-card img {
            width: 100%;
            max-height: 300px;
            object-fit: cover;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .answer-options {
            margin-top: 20px;
        }
        .answer-options label {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            margin-bottom: 10px;
            border-radius: 5px;
            font-size: 1rem;
            cursor: default;
        }
        .answer-options label.correct {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .answer-options label.incorrect {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .answer-options label.neutral {
            background-color: #ffffff;
            color: #212529;
            border: 1px solid #dee2e6;
        }
        .answer-options input[type="checkbox"] {
            margin-right: 10px;
            cursor: default;
        }
        .navigation {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .btn-back {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        .btn-back:hover {
            background-color: #0056b3;
        }
        @media (max-width: 768px) {
            .question-card {
                margin-bottom: 20px;
            }
            .btn-back {
                width: 100%;
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>
<div class="main-container">
    <c:if test="${not empty userTest}">
        <div class="history-summary">
            <p> ${testName}</p>
            <p><strong>Tổng số câu hỏi:</strong> ${userTest.totalQuestions}</p>
            <p><strong>Số câu trả lời đúng:</strong> ${userTest.correctAnswers}</p>

<%--            <p><strong>Thời gian bắt đầu:</strong> ${fn:escapeXml(userTest.timeStart)}</p>--%>
<%--            <p><strong>Thời gian kết thúc:</strong> ${userTest.timeEnd}</p>--%>
        </div>
        <c:if test="${not empty answers}">
            <c:forEach var="answer" items="${answers}" varStatus="loop">
                <div class="question-card">
                    <h4>Câu hỏi ${loop.count}</h4>
                    <p>${answer.content}</p>
                    <c:if test="${not empty answer.image}">
                        <img src="/img/question_bank/${answer.image}" alt="Question Image">
                    </c:if>
                    <div class="answer-options">
                        <c:forEach var="option" items="${answer.answerOptions}">
                            <label class="${answer.correctAnswers.contains(option) ? 'correct' : (answer.selectedAnswers.contains(option) ? 'incorrect' : 'neutral')}"
                                   title="${answer.correctAnswers.contains(option) ? 'Đáp án đúng' : (answer.selectedAnswers.contains(option) ? 'Đáp án sai' : 'Chưa chọn')}">
                                <input type="checkbox" value="${option}" disabled
                                       <c:if test="${answer.selectedAnswers.contains(option)}">checked</c:if>>
                                    ${option}
                            </label>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        <c:if test="${empty answers}">
            <p class="text-center text-muted">Không có câu trả lời nào để hiển thị.</p>
        </c:if>
        <div class="navigation">
            <a href="/practices/history" class="btn-back">Quay lại</a>
        </div>
    </c:if>
    <c:if test="${empty userTest}">
        <p class="text-center text-muted">Không tìm thấy lịch sử bài kiểm tra.</p>
    </c:if>
</div>
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
        crossorigin="anonymous"></script>
</body>
</html>