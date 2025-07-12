<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Lịch Sử Bài Kiểm Tra</title>
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
            background: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .question-card.correct {
            background: #e6ffe6;
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
        .answer-options label.correct-selected {
            background-color: #a3e4d7;
            color: #0f5132;
            border: 1px solid #81c784;
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
    <c:if test="${not empty history}">
        <div class="history-summary">
            <p><strong>${fn:escapeXml(history.testName)}</strong></p>
            <p><strong>Tổng số câu hỏi:</strong> ${history.userTest.totalQuestions}</p>
            <p><strong>Số câu trả lời đúng:</strong> ${history.userTest.correctAnswers}</p>
            <p><strong>Điểm:</strong> <fmt:formatNumber value="${(history.userTest.correctAnswers / history.userTest.totalQuestions) * 10}" maxFractionDigits="2"/> / 10</p>
            <p><strong>Thời gian bắt đầu:</strong> ${fn:escapeXml(history.startTime)}</p>
            <p><strong>Thời gian kết thúc:</strong> ${fn:escapeXml(history.endTime)}</p>
        </div>
        <c:if test="${not empty history.answers}">
            <c:forEach var="answer" items="${history.answers}" varStatus="loop">
                <div class="question-card">
                    <h4>Câu hỏi ${loop.count}</h4>
                    <p>${fn:escapeXml(answer.content)}</p>
                    <c:if test="${not empty answer.image}">
                        <img src="/img/question_bank/${fn:escapeXml(answer.image)}" alt="Question Image">
                    </c:if>
                    <div class="answer-options">
                        <c:forEach var="option" items="${answer.answerOptions}">
                            <c:set var="isCorrect" value="${answer.correctAnswers.contains(option)}"/>
                            <c:set var="isSelected" value="${answer.selectedAnswers.contains(option)}"/>
                            <c:set var="cssClass" value="${isCorrect ? (isSelected ? 'correct-selected' : 'correct') : (isSelected ? 'incorrect' : 'neutral')}"/>
                            <c:set var="title" value="${isCorrect ? 'Đáp án đúng' : (isSelected ? 'Đáp án sai' : 'Chưa chọn')}"/>
                            <label class="${cssClass}" title="${title}">
                                <input type="checkbox" value="${fn:escapeXml(option)}" disabled
                                       <c:if test="${isSelected}">checked</c:if>>
                                    ${fn:escapeXml(option)}
                            </label>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        <c:if test="${empty history.answers}">
            <p class="text-center text-muted">Không có câu trả lời nào để hiển thị.</p>
        </c:if>
        <div class="navigation">
            <a href="/tests/history" class="btn-back">Quay lại</a>
        </div>
    </c:if>
    <c:if test="${empty history}">
        <p class="text-center text-muted">Không tìm thấy lịch sử bài kiểm tra.</p>
    </c:if>
</div>
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>