<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${fn:escapeXml(testName)}</title>
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
        .btn-submit, .btn-save, .btn-back {
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
        .btn-save {
            background-color: #28a745;
        }
        .btn-submit:hover, .btn-back:hover {
            background-color: #0056b3;
        }
        .btn-save:hover {
            background-color: #218838;
        }
        .timer {
            color: #dc3545;
            font-weight: bold;
            font-size: 1.2rem;
            margin-left: 20px;
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
            .btn-submit, .btn-save, .btn-back {
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
    <div class="history-summary">
        <h3>${fn:escapeXml(testName)}</h3>
        <p><strong>Thời gian còn lại: </strong><span id="timer"></span></p>
    </div>
    <c:if test="${not empty questions}">
        <form id="testForm" onsubmit="return prepareSubmit()">
            <c:forEach var="question" items="${questions}" varStatus="loop">
                <div class="question-card">
                    <h4>Câu hỏi ${loop.count}</h4>
                    <p>${fn:escapeXml(question.content)}</p>
                    <c:if test="${not empty question.image}">
                        <img src="/img/question_bank/${fn:escapeXml(question.image)}" alt="Question Image">
                    </c:if>
                    <div class="answer-options">
                        <input type="hidden" class="question-id" value="${question.questionId}">
                        <c:forEach var="option" items="${question.options}">
                            <label class="neutral">
                                <input type="checkbox" class="answer-option" value="${fn:escapeXml(option)}"
                                       <c:if test="${not empty savedAnswers[question.questionId] and savedAnswers[question.questionId].contains(option)}">checked</c:if>>
                                    ${fn:escapeXml(option)}
                            </label>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
            <div class="navigation">
                <input type="hidden" id="testId" value="${testId}">
                <button type="button" onclick="saveAnswers()" class="btn-save">Lưu đáp án</button>
                <button type="submit" class="btn-submit">Nộp bài</button>
                <a href="/tests" class="btn-back">Quay lại</a>
            </div>
        </form>
    </c:if>
    <c:if test="${empty questions}">
        <p class="text-center text-muted">Không có câu hỏi nào trong bài kiểm tra.</p>
    </c:if>
</div>
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
<script>
    let remainingTime = ${remainingTime};
    const testId = ${testId};

    function updateTimer() {
        let minutes = Math.floor(remainingTime / 60);
        let seconds = remainingTime % 60;
        $('#timer').text(minutes + ':' + (seconds < 10 ? '0' : '') + seconds);
        if (remainingTime <= 0) {
            prepareSubmit(true);
        } else {
            remainingTime--;
        }
    }
    setInterval(updateTimer, 1000);
    updateTimer();

    function getAnswers() {
        let answers = [];
        $('.question-card').each(function() {
            let questionId = $(this).find('.question-id').val();
            let selected = [];
            $(this).find('.answer-option:checked').each(function() {
                selected.push($(this).val());
            });
            answers.push({questionId: parseInt(questionId), selectedAnswers: selected});
        });
        return answers;
    }

    function saveAnswers() {
        $.ajax({
            url: '/tests/save-answers/' + testId,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({testId: testId, answers: getAnswers()}),
            success: function() {
                // alert('Đã lưu đáp án.');
                window.location.reload();
            },
            error: function() {
                alert('Lỗi khi lưu đáp án.');
            }
        });
    }

    // Tự động lưu mỗi 5 phút
    setInterval(saveAnswers, 300000); // 300000 ms = 5 phút

    function prepareSubmit(auto = false) {
        let hasSelection = false;
        $('.answer-option').each(function() {
            if ($(this).is(':checked')) {
                hasSelection = true;
                return false;
            }
        });
        if (!auto && !hasSelection) {
            alert('Vui lòng chọn ít nhất một đáp án.');
            return false;
        }

        let submission = {
            testId: testId,
            answers: getAnswers()
        };
        $.ajax({
            url: '/tests/submit/' + testId,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(submission),
            success: function() {
                window.location.href = '/tests/history/' + testId;
            },
            error: function() {
                alert('Lỗi khi nộp bài.');
            }
        });
        return false;
    }
</script>
</body>
</html>