<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Xác thực Email - Hệ thống Học tập Cá nhân hóa</title>
    <link href="/css/styles.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
    <style>
        body {
            background-color: #f5f7fa;
            font-family: 'Poppins', sans-serif;
        }
        .container-fluid {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .verify-email-container {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 900px;
            width: 100%;
        }
        .verify-email-left {
            padding: 40px;
            background-color: #fff;
        }
        .verify-email-right {
            background: linear-gradient(135deg, #045bd8 0%, #2a5298 100%);
            color: white;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
        }
        .logo img {
            height: 40px;
        }
        h2 {
            font-size: 28px;
            font-weight: 600;
            color: #333;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        .login-link a {
            color: #045bd8;
            text-decoration: none;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .verify-email-right h3 {
            font-size: 24px;
            font-weight: 500;
        }
        .verify-email-right p {
            font-size: 14px;
            opacity: 0.8;
        }
        .illustration {
            position: absolute;
            top: 50%;
            right: 40px;
            transform: translateY(-50%);
            width: 250px;
            height: auto;
        }
        .dots {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .dot {
            width: 8px;
            height: 8px;
            background-color: #ffffff50;
            border-radius: 50%;
            margin: 0 5px;
        }
        .dot.active {
            background-color: white;
        }
        .message {
            margin-top: 20px;
            color: #28a745;
        }
        .error {
            margin-top: 20px;
            color: #dc3545;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="verify-email-container d-flex">
        <!-- Left: Verification Result -->
        <div class="verify-email-left col-md-6">
            <div class="logo">
                <img src="/img/logo.jpg" alt="PLS Logo">
            </div>
            <h2 class="mt-3">Xác thực Email</h2>
            <p class="text-muted mb-4">Kết quả xác thực email của bạn.</p>

            <c:if test="${not empty message}">
                <div class="message">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <!-- Link to Login -->
            <div class="login-link">
                <p><a href="/login">Quay lại Đăng nhập</a></p>
            </div>
        </div>

        <!-- Right: Promotional Section -->
        <div class="verify-email-right col-md-6">
            <h3>Chào mừng đến với hệ thống!</h3>
            <p>Xác thực email để bắt đầu hành trình học tập của bạn.</p>
            <div class="dots">
                <div class="dot active"></div>
                <div class="dot"></div>
                <div class="dot"></div>
            </div>
            <!-- Placeholder for Illustration -->
            <div class="illustration">
                <!-- You can add an image here if available -->
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="/js/scripts.js"></script>
</body>
</html>