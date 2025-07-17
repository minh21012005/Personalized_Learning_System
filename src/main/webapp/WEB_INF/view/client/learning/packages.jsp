<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Gói học</title>
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

        .package-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .package-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }

        .package-card:hover {
            transform: translateY(-5px);
        }

        .package-card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }

        .package-card .card-body {
            padding: 15px;
            text-align: center;
        }

        .package-card .card-title {
            color:#212529;
            font-size: 18px;
            margin-bottom: 10px;
        }

        .package-card .progress {
            height: 5px;
            margin-bottom: 10px;
        }

        .package-card .rating {
            color: #ffc107;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .package-card .dates {
            font-size: 12px;
            color: #6c757d;
            margin-bottom: 10px;
        }

        .package-card .btn {
            width: 100%;
            background-color: #212529;
            color: #fff;
            border: none;
        }

        .package-card .btn:hover {
            background-color: #343a40;
        }

    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>
<div class="main-container">
    <div class="content">
        <h2>Các gói học của ban</h2>
        <c:if test="${empty packageSubjects}">
            <p>Không có gói học nào.</p>
        </c:if>
        <c:if test="${not empty packageSubjects}">
            <div class="package-grid">
                <c:forEach var="packageSubject" items="${packageSubjects}">
                    <div class="package-card">
                        <img src="/img/package/${packageSubject.imageUrl != null ? packageSubject.imageUrl : '/img/package/default-package.jpg'}"
                             alt="${packageSubject.name}">
                        <div class="card-body">
                            <h5 style="text-transform: uppercase;" class="card-title">${packageSubject.name}</h5>
                            <div class="progress">
                                <div class="progress-bar bg-primary" style="width: 100%"></div>
                            </div>
                            <div class="dates">
                                <p>Ngày bắt đầu: <span style="font-weight: bold">${packageSubject.startDate}</span></p>
                                <p>Ngày kết thúc: <span style="font-weight: bold">${packageSubject.endDate}</span></p>
                            </div>
                            <a href="/packages/detail?packageId=${packageSubject.packageId}" class="btn btn-dark">Vào học</a>
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
</body>
</html>