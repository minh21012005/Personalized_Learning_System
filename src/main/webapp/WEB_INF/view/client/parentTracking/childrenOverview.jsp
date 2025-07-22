<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách con</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
            --secondary-color: #6c757d;
            --bg-color: #f8fafc;
            --card-bg: #ffffff;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-color);
            margin: 0;
            min-height: 100vh;
        }

        .content {
            width: 96%;
            min-height: 80vh;
            max-width: 1400px;
            margin: 0 auto;
            padding: 24px;
        }

        .card {
            border: none;
            border-radius: 12px;
            background-color: var(--card-bg);
            box-shadow: var(--shadow);
        }

        .card-body {
            padding: 24px;
        }

        .child-item {
            transition: all 0.3s ease;
        }

        .child-item:hover {
            background-color: #f1f5f9;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<header>
    <jsp:include page="../layout/header.jsp"/>
</header>

<div class="content mt-5">
    <h1 class="mb-4 fw-bold">Danh sách con của bạn</h1>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <div class="card">
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty children}">
                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <th>Họ và tên</th>
                            <th>Ngày sinh</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="child" items="${children}">
                            <tr class="child-item">
                                <td>${child.fullName}</td>
                                <td>${child.dob}</td>
                                <td><a href="/parent/child/${child.userId}/learning" class="btn btn-primary">Xem chi
                                    tiết</a></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <p class="text-muted">Bạn chưa có con nào được liên kết.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>
</body>
</html>