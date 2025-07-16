<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Practice Test</title>
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
            background: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
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
            cursor: pointer;
            background-color: #ffffff;
            color: #212529;
            border: 1px solid #dee2e6;
        }

        .answer-options input[type="checkbox"] {
            margin-right: 10px;
            cursor: pointer;
        }

        .navigation {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .btn-submit, .btn-back {
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

        .btn-submit:hover, .btn-back:hover {
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

            .btn-submit, .btn-back {
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
        <form action="/practices/submit-answers" method="post" id="practiceForm" onsubmit="return prepareForm()">
            <c:forEach var="question" items="${questions}" varStatus="loop">
                <div class="question-card">
                    <h4>Câu hỏi ${loop.count + currentQuestionIndex} - level : ${question.levelQuestionName}</h4>
                    <p>${fn:escapeXml(question.content)}</p>
                    <c:if test="${not empty question.image}">
                        <img src="/img/question_bank/${fn:escapeXml(question.image)}" alt="Question Image">
                    </c:if>
                    <div class="answer-options">
                        <input type="hidden" class="question-id" value="${question.questionId}">
                        <c:forEach var="option" items="${question.options}">
                            <label class="neutral">
                                <input type="checkbox" class="answer-option" value="${fn:escapeXml(option)}">
                                    ${fn:escapeXml(option)}
                            </label>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
            <div class="navigation">
                <input type="hidden" id="testId" name="testId" value="${testId}">
                <input type="hidden" id="selectedLessonIds" name="selectedLessonIds" value="${selectedLessonIds}">
                <input type="hidden" id="currentQuestionIndex" name="currentQuestionIndex" value="${currentQuestionIndex}">
                <input type="hidden" id="submissionData" name="submissionData">
                <button type="submit" class="btn-submit">Nộp bài</button>
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
    function prepareForm() {
        // Kiểm tra ít nhất một đáp án được chọn cho ít nhất một câu hỏi
        var hasSelection = false;
        $('input.answer-option').each(function () {
            if ($(this).is(':checked')) {
                hasSelection = true;
                return false;
            }
        });
        if (!hasSelection) {
            alert('Vui lòng chọn ít nhất một đáp án.');
            return false; // Ngăn form gửi đi
        }

        // Lấy và kiểm tra dữ liệu
        var testId = $('#testId').val();
        var selectedLessonIds = $('#selectedLessonIds').val();
        var currentQuestionIndex = $('#currentQuestionIndex').val();

        if (!testId || isNaN(testId) || !currentQuestionIndex || isNaN(currentQuestionIndex)) {
            alert('Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.');
            return false;
        }

        // Tạo đối tượng JSON
        var submissionDto = {
            testId: parseInt(testId),
            selectedLessonIds: selectedLessonIds || "",
            currentQuestionIndex: parseInt(currentQuestionIndex),
            answers: []
        };

        // Thu thập tất cả câu hỏi, kể cả câu không có đáp án
        $('.question-card').each(function () {
            var questionId = parseInt($(this).find('.question-id').val());
            if (isNaN(questionId)) return;

            var selectedAnswers = [];
            $(this).find('.answer-option:checked').each(function () {
                selectedAnswers.push($(this).val());
            });

            submissionDto.answers.push({
                questionId: questionId,
                selectedAnswers: selectedAnswers
            });
        });


        // Gán JSON vào input ẩn
        $('#submissionData').val(JSON.stringify(submissionDto));

        // Cho phép form gửi đi
        return true;
    }
</script>
</body>
</html>