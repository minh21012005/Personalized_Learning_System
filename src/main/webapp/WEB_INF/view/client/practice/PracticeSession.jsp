<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Practice Session</title>
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
            background: ${questionBackgrounds[question.questionId]};
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            transition: transform 0.2s;
        }
        .question-card:hover {
            transform: translateY(-2px);
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
            margin-top: 10px;
        }
        .answer-options label {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            margin-bottom: 10px;
            border-radius: 5px;
            font-size: 1rem;
            transition: background-color 0.3s;
            cursor: ${showResults ? 'default' : 'pointer'};
        }
        .answer-options input[type="checkbox"] {
            margin-right: 10px;
            cursor: ${showResults ? 'default' : 'pointer'};
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
        .btn-submit, .btn-back, .btn-continue {
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
        .btn-submit:hover, .btn-back:hover, .btn-continue:hover {
            background-color: #0056b3;
        }
        .timer {
            color: #dc3545;
            font-weight: bold;
            font-size: 1.2rem;
            margin-left: 20px;
        }
        @media (max-width: 768px) {
            .question-card {
                margin-bottom: 20px;
            }
            .navigation {
                flex-direction: column;
                gap: 10px;
            }
            .timer {
                margin-left: 0;
                margin-top: 10px;
            }
            .btn-submit, .btn-back, .btn-continue {
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
    <c:if test="${not empty questions}">
        <form action="/practices/submit-answers" method="post" id="practiceForm">
            <c:forEach var="question" items="${questions}" varStatus="loop">
                <div class="question-card">
                    <h4>Câu hỏi ${loop.count}</h4>
                    <p>${question.content}</p>
                    <c:if test="${not empty question.image}">
                        <img src="/img/question_bank/${question.image}" alt="Question Image">
                    </c:if>
                    <div class="answer-options">
                        <input type="hidden" name="answers[${loop.index}].questionId" value="${question.questionId}">
                        <c:choose>
                            <c:when test="${showResults}">
                                <c:forEach var="option" items="${question.options}">
                                    <c:set var="state" value="${questionAnswerStates[question.questionId][option]}"/>
                                    <label class="${state}" title="${state eq 'correct' ? 'Đáp án đúng' : (state eq 'incorrect' ? 'Đáp án sai' : 'Chưa chọn')}">
                                        <input type="checkbox" name="answers[${loop.index}].selectedAnswers" value="${option}" disabled>
                                            ${option}
                                    </label>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="option" items="${question.options}">
                                    <label class="neutral">
                                        <input type="checkbox" name="answers[${loop.index}].selectedAnswers" value="${option}">
                                            ${option}
                                    </label>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
            <div class="navigation">
                <c:if test="${canGoBack}">
                    <a href="/practices/go-back?lessonIds=${fn:join(lessonIds, ',')}&userId=${userId}&allLessonIds=${fn:join(allLessonIds, ',')}&timed=${timed}&questionCount=${questionCount}&timePerQuestion=${timePerQuestion}&currentIndex=${currentIndex}" class="btn-back">Quay lại</a>
                </c:if>
                <input type="hidden" name="testId" value="${testId}">
                <input type="hidden" name="selectedLessonIds" value="${selectedLessonIds}">

                <button type="submit" class="btn-submit">Nộp bài</button>
                <c:if test="${showResults}">
                    <a href="/practices/continue-practice?lessonIds=${fn:join(lessonIds, ',')}&userId=${userId}&allLessonIds=${fn:join(allLessonIds, ',')}&timed=${timed}&questionCount=${questionCount}&timePerQuestion=${timePerQuestion}&currentIndex=0" class="btn-continue">Tiếp tục</a>
                </c:if>
            </div>
        </form>
    </c:if>
    <c:if test="${empty questions}">
        <p class="text-center text-muted">Không có câu hỏi nào để luyện tập.</p>
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
                $('#practiceForm').submit();
            }
            timeLeft--;
        }, 1000);
        </c:if>

        $('#practiceForm').on('submit', function(e) {
            var formData = $(this).serializeArray();
            console.log("Form Data: ", formData);
        });
    });
</script>
</body>
</html>