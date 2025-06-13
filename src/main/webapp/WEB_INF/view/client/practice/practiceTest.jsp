<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Làm Bài Luyện Tập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body { margin: 0; min-height: 100vh; display: flex; flex-direction: column; font-family: Arial, sans-serif; }
        .main-container { display: flex; flex: 1; }
        .content { flex: 1; padding: 20px; background-color: #f8f9fa; }
        .split-container {
            display: flex;
            margin-top: 100px;
            gap: 20px;
        }
        .questions-section {
            flex: 3;
            background: #fff;
            border-radius: 0.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            padding: 2rem;
            max-height: 80vh;
            overflow-y: auto;
        }
        .sidebar-section {
            flex: 1;
            background: #fff;
            border-radius: 0.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            padding: 2rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 300px;
        }
        .question-container { border: 1px solid #dee2e6; border-radius: 0.25rem; padding: 1rem; margin-bottom: 1rem; }
        .mandatory::after { content: "*"; color: red; margin-left: 5px; }
    </style>
</head>
<body>
<header><jsp:include page="../layout/header.jsp"/></header>
<div class="main-container">
    <div class="content">
        <main>
            <div class="container-fluid">
                <div class="split-container">
                    <div class="questions-section">
                        <h1 class="mb-4 fw-bold">Làm Bài Luyện Tập</h1>
                        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
                        <form action="/practice/submit-test" method="post" id="testForm">
                            <input type="hidden" name="userTestId" value="${userTest.userTestId}">
                            <input type="hidden" name="testId" value="${test.testId}">
                            <c:forEach var="question" items="${questions}" varStatus="loop">
                                <div class="question-container">
                                    <h6>Câu ${loop.count}: ${question.content}</h6>
                                    <input type="hidden" name="jsonAnswers" value="[]">
                                    <input type="hidden" name="jsonAnswers[${loop.index}]" id="jsonAnswer${loop.index}" value="[]">
                                    <c:forEach var="option" items="${question.options}" varStatus="optLoop">
                                        <div class="form-check">
                                            <input type="checkbox" name="checkbox_${loop.index}" value="${optLoop.index}" id="q${loop.index}o${optLoop.index}" onchange="updateJson(${loop.index}, ${optLoop.index}, '${option}')">
                                            <label class="form-check-label" for="q${loop.index}o${optLoop.index}">${option}</label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:forEach>
                        </form>
                    </div>
                    <div class="sidebar-section">
                        <div>
                            <h5>Thời gian còn lại: <span id="timer">${test.durationTime} phút</span></h5>
                        </div>
                        <div>
                            <button type="submit" form="testForm" class="btn btn-primary w-100">Nộp bài</button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
<footer><jsp:include page="../layout/footer.jsp"/></footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function updateJson(questionIndex, optionIndex, optionText) {
        let jsonInput = $('#jsonAnswer' + questionIndex);
        let currentAnswers = JSON.parse(jsonInput.val() || '[]');
        let found = currentAnswers.find(item => item.index === optionIndex);

        if ($('#q' + questionIndex + 'o' + optionIndex).is(':checked')) {
            if (!found) {
                currentAnswers.push({ index: optionIndex, text: optionText });
            }
        } else {
            if (found) {
                currentAnswers = currentAnswers.filter(item => item.index !== optionIndex);
            }
        }
        jsonInput.val(JSON.stringify(currentAnswers));
    }

    $(document).ready(function () {
        let timeLeft = ${test.durationTime} * 60; // Chuyển phút thành giây
        const timer = $('#timer');
        const interval = setInterval(function () {
            let minutes = Math.floor(timeLeft / 60);
            let seconds = timeLeft % 60;
            timer.text(minutes + ':' + (seconds < 10 ? '0' : '') + seconds);
            if (--timeLeft < 0) {
                clearInterval(interval);
                $('#testForm').submit();
            }
        }, 1000);
    });
</script>
</body>
</html>