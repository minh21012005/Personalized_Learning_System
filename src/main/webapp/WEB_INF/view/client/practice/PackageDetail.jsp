<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Chọn môn học</title>
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
            display: flex;
            flex: 1;
        }

        .content {
            margin-top: 70px;
            flex: 1;
            padding: 20px;
            background-color: #f8f9fa;
        }

        .package-header {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .package-header h2 {
            color: #212529;
            margin-bottom: 10px;
        }

        .package-header p {
            color: #6c757d;
            margin: 0;
        }

        .subject-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .subject-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
            text-align: center;
        }

        .subject-card:hover {
            transform: translateY(-5px);
        }

        .subject-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }

        .subject-card .card-body {
            padding: 15px;
        }

        .subject-card .card-title {
            color: #212529;
            font-size: 18px;
            margin-bottom: 10px;
        }

        .subject-card .progress {
            height: 5px;
            margin-bottom: 10px;
        }

        .subject-card .btn {
            width: 100%;
            background-color: #4c5358;
            color: #fff;
            border: none;
        }

        .subject-card .btn:hover {
            background-color:#212529;
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>
<div class="main-container">
    <div class="content">
        <div class="package-header">
            <div class="row">
                <div class="col-md-8">
                    <h2>${packagePractice.name}</h2>
                    <p>${packagePractice.description}</p>
                </div>
                <div class="col-md-4">
                    <img src="/img/package/${packagePractice.imageUrl != null ? packagePractice.imageUrl : '/img/default-package.jpg'}"
                         alt="${packagePractice.name}" class="img-fluid">
                </div>

            </div>

        </div>
        <h3>Các môn học trong gói</h3>
                <c:if test="${empty subjects}">
                    <p>Không có môn học nào trong gói này.</p>
                </c:if>
                <c:if test="${not empty subjects}">
                    <div class="subject-grid">
                        <c:forEach var="subject" items="${subjects}">
                            <div class="subject-card">
                                <img src="/img/subjectImg/${subject.subjectImage != null ? subject.subjectImage : '/img/default-subject.jpg'}" alt="${subject.subjectName}">
                                <div class="card-body">
                                    <h5 class="card-title">${subject.subjectName}</h5>
                                    <div class="progress">
                                        <div class="progress-bar bg-primary" style="width: 100%"></div> <!-- Placeholder progress -->
                                    </div>
                                    <a href="/practices/subject?subjectId=${subject.subjectId}&packageId=${packagePractice.packageId}" class="btn btn-primary">Bắt đầu luyện tập</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
    </div>
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