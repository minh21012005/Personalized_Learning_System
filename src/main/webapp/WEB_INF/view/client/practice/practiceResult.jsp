<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Kết quả bài thi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body { margin: 0; min-height: 100vh; display: flex; flex-direction: column; font-family: Arial, sans-serif; }
        .main-container { display: flex; flex: 1; }
        .content { flex: 1; padding: 20px; background-color: #f8f9fa; }
        .result-container { background: #fff; border-radius: 0.5rem; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); padding: 2rem; max-width: 800px; margin: 0 auto; }
    </style>
</head>
<body>
<header><jsp:include page="../layout/header.jsp"/></header>
<div class="main-container">
    <div class="content">
        <main>
            <div class="container-fluid">
                <div style="margin-top: 100px;">
                    <div class="result-container">
                        <h1 class="mb-4 fw-bold">Kết quả bài thi</h1>
                        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
                        <p>Thời gian bắt đầu: ${userTest.timeStart}</p>
                        <p>Thời gian kết thúc: ${userTest.timeEnd}</p>
                        <h5>Các câu trả lời của bạn:</h5>
                        <c:forEach var="answer" items="${answers}" varStatus="loop">
                            <div class="mb-3">
                                <p>Câu ${loop.count}: ${answer.question.content}</p>
                                <p>Đáp án của bạn (JSON): ${answer.answer}</p>
                            </div>
                        </c:forEach>
                        <a href="/practice/start" class="btn btn-primary">Làm lại bài thi</a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
<footer><jsp:include page="../layout/footer.jsp"/></footer>
</body>
</html>