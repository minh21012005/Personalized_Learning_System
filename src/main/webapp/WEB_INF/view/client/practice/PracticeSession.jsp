<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Luyện tập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: Arial, sans-serif;
        }

        .main-container {
            margin-top: 70px;
            padding: 20px;
            background-color: #f8f9fa;
        }

        .question-card {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .question-card h4 {
            color: #212529;
            margin-bottom: 10px;
        }

        .question-card p {
            color: #6c757d;
            margin-bottom: 20px;
        }

        .question-card img {
            width: 100%;
            object-fit: cover;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .answer-options input[type="radio"] {
            margin-right: 10px;
        }

        .answer-options label {
            display: block;
            margin-bottom: 10px;
        }

        .btn-submit {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn-submit:hover {
            background-color: #0056b3;
        }

        .timer {
            color: #dc3545;
            font-weight: bold;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>
<div class="main-container">
    <c:if test="${not empty questions}">
        <c:forEach var="question" items="${questions}" varStatus="loop">
            <div class="question-card">
                <h4>Câu hỏi ${loop.count}</h4>
                <p>${question.content}</p>
                <c:if test="${not empty question.image}">
                    <img src="/img/questions/${question.image}" alt="Question Image">
                </c:if>
                <div class="answer-options">
<%--                    <c:set var="options" value="${questionService.parseOptions(question.options)}" scope="page"/>--%>
                    <c:forEach var="option" items="${question.options}" varStatus="optLoop">
                        <label>
                            <input type="checkbox" name="answer_${question.questionId}" value="${option}">
                                ${option}
                        </label>
                    </c:forEach>
                </div>
            </div>
        </c:forEach>
        <form action="/practices/submit-answers" method="post">
            <input type="hidden" name="lessonIds" value="${lessonIds}">
            <input type="hidden" name="packageId" value="${packageId}">
            <input type="hidden" name="userId" value="${userId}">
            <c:if test="${timed}">
                <div class="timer" id="timer">Thời gian còn lại: ${questionCount * timePerQuestion} phút</div>
            </c:if>
            <button type="submit" class="btn-submit">Nộp bài</button>
        </form>
    </c:if>
    <c:if test="${empty questions}">
        <p>Không có câu hỏi nào để luyện tập.</p>
    </c:if>
</div>
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
        crossorigin="anonymous"></script>
<script>
    $(document).ready(function() {
        <c:if test="${timed}">
        var timeLeft = ${questionCount * timePerQuestion} * 60; // Convert to seconds
        var timer = setInterval(function() {
            var minutes = Math.floor(timeLeft / 60);
            var seconds = timeLeft % 60;
            $('#timer').text('Thời gian còn lại: ' + minutes + ' phút ' + seconds + ' giây');
            if (timeLeft <= 0) {
                clearInterval(timer);
                alert('Hết thời gian!');
                $('form').submit();
            }
            timeLeft--;
        }, 1000);
        </c:if>
    });
</script>
</body>
</html>