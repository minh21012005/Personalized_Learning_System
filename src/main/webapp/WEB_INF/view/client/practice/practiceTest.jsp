<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>PLS - Làm bài luyện tập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body { margin: 0; min-height: 100vh; display: flex; flex-direction: column; font-family: Arial, sans-serif; }
        .main-container { display: flex; flex: 1; }
        .content { flex: 1; padding: 20px; background-color: #f8f9fa; }
        .question-card { background: #fff; border-radius: 0.5rem; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); padding: 1rem; margin-bottom: 1rem; }
        .timer { font-size: 1.5rem; font-weight: bold; color: #dc3545; }
        .current-question { border: 2px solid #007bff; }
        .form-check-input:disabled { cursor: not-allowed; }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
    <script>
        $(document).ready(function () {
            MathJax.typeset();

            let endTime = new Date('${userTest.timeEnd}').getTime();
            if (isNaN(endTime)) {
                $('.timer').text("Thời gian không hợp lệ");
                return;
            }

            let timerInterval = setInterval(() => {
                let now = new Date().getTime();
                let distance = endTime - now;
                if (distance < 0) {
                    clearInterval(timerInterval);
                    alert("Hết giờ!");
                    window.location.href = "/practice/finish?userTestId=${userTest.userTestId}";
                    return;
                }
                let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                let seconds = Math.floor((distance % (1000 * 60)) / 1000);
                $('.timer').text(minutes + "m " + seconds + "s ");
            }, 1000);

            $('.answer-option').on('click', function () {
                let questionId = $(this).data('question-id');
                let answer = $(this).data('answer');
                let token = $("meta[name='_csrf']").attr("content");
                let header = $("meta[name='_csrf_header']").attr("content");

                $.ajax({
                    url: '/practice/submit-answer',
                    method: 'POST',
                    data: {
                        questionId: questionId,
                        answer: answer,
                        userTestId: '${userTest.userTestId}'
                    },
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader(header, token);
                    },
                    success: function (data) {
                        if (data.redirect) {
                            window.location.href = data.redirect;
                        } else {
                            window.location.reload();
                        }
                    },
                    error: function () {
                        alert('Lỗi khi gửi đáp án.');
                    }
                });
            });

            // Highlight current question
            <%--$(`#question-${${userTest.currentQuestionIndex}}`).addClass('current-question');--%>
        });
    </script>
</head>
<body>
<header><jsp:include page="../layout/header.jsp"/></header>
<div class="main-container">
    <div class="content">
        <main>
            <div class="container-fluid">
                <div class="mt-4">
                    <h1 class="mb-4 fw-bold">Làm bài luyện tập</h1>
                    <div class="timer mb-3">Thời gian còn lại: Loading...</div>
                    <c:choose>
                        <c:when test="${not empty questions}">
                            <c:forEach var="question" items="${questions}" varStatus="status">
                                <div class="question-card" id="question-${status.index}">
                                    <h5>Câu ${status.count}: <c:out value="${question.content}" escapeXml="false"/></h5>
                                    <c:if test="${not empty question.image}">
                                        <img src="/resources/img/question_bank/${question.image}" class="img-fluid mt-2" alt="Question Image" style="max-width: 300px;">
                                    </c:if>
                                    <c:forEach var="option" items="${question.options}" varStatus="optStatus">
                                        <div class="form-check mt-2">
                                            <input type="radio" class="form-check-input answer-option"
                                                   name="answer${status.index}"
                                                   data-question-id="${question.questionId}"
                                                   data-answer="${option}"
                                                   <c:if test="${status.index != userTest.currentQuestionIndex}">disabled</c:if>>
                                            <label class="form-check-label"><c:out value="${option}" escapeXml="false"/></label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning">Không có câu hỏi để hiển thị.</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>
<footer><jsp:include page="../layout/footer.jsp"/></footer>
</body>
</html>