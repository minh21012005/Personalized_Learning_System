<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết Quả Luyện Tập</title>
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
        .question-card {
            background: ${result.isCorrect ? '#e6ffe6' : '#ffffff'};
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            transition: transform 0.2s;
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
        .answer-options input[type="checkbox"] {
            margin-right: 10px;
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
        .navigation {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        .btn-continue, .btn-end {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s;
        }
        .btn-continue:hover, .btn-end:hover {
            background-color: #0056b3;
        }
        .result-summary {
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 1.2rem;
            color: #212529;
        }
        @media (max-width: 768px) {
            .question-card {
                margin-bottom: 20px;
            }
            .navigation {
                flex-direction: column;
                gap: 10px;
            }
            .btn-continue, .btn-end {
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
    <div class="result-summary">
        Kết quả: Bạn đã trả lời đúng ${correctCount} / ${fn:length(results)} câu hỏi.
    </div>
    <c:if test="${not empty results}">
        <c:forEach var="result" items="${results}" varStatus="loop">
            <c:set var="question" value="${results[loop.index]}"/>
            <div class="question-card">
                <h4>Câu hỏi ${loop.count + currentQuestionIndex}</h4>
                <p>${question.content}</p>
                <c:if test="${not empty question.image}">
                    <img src="/img/question_bank/${question.image}" alt="Question Image">
                </c:if>
                <div class="answer-options">
                    <c:forEach var="option" items="${result.answerOptions}">
                        <label class="${result.correctAnswers.contains(option) ? 'correct' : (result.selectedAnswers.contains(option) ? 'incorrect' : 'neutral')}"
                               title="${result.correctAnswers.contains(option) ? 'Đáp án đúng' : (result.selectedAnswers.contains(option) ? 'Đáp án sai' : 'Chưa chọn')}">
                            <input type="checkbox" value="${option}" disabled
                                   <c:if test="${result.selectedAnswers.contains(option)}">checked</c:if>>
                                ${option}
                        </label>
                    </c:forEach>
                </div>
            </div>
        </c:forEach>
        <div class="navigation">
            <form action="/practices/continue-practice" method="post" id="practiceForm">
                <input type="hidden" name="allLessonIds" value="${selectedLessonIds}">
                <input type="hidden" name="testId" value="${testId}">
                <input type="hidden" name="currentQuestionIndex" value="${currentQuestionIndex}">
                <input type="hidden" name="correctCount" value="${correctCount}">
                <button type="submit" class="btn-continue">Tiếp tục</button>
            </form>
            <a href="/practices/history/${testId}" class="btn-end">Kết thúc</a>
        </div>
    </c:if>
    <c:if test="${empty results}">
        <p class="text-center text-muted">Không có kết quả để hiển thị.</p>
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