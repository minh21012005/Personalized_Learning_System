<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Đặt lại mật khẩu - Hệ thống Học tập Cá nhân hóa</title>
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
        .reset-password-container {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 900px;
            width: 100%;
        }
        .reset-password-left {
            padding: 40px;
            background-color: #fff;
        }
        .reset-password-right {
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
        .form-control {
            border-radius: 5px;
            padding: 12px;
            border: 1px solid #ddd;
        }
        .form-control.is-invalid {
            border-color: #dc3545;
        }
        .invalid-feedback {
            color: #dc3545;
            font-size: 0.875em;
        }
        .btn-submit {
            background-color: #045bd8;
            border: none;
            padding: 12px;
            border-radius: 5px;
            font-weight: 500;
            width: 100%;
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
        .reset-password-right h3 {
            font-size: 24px;
            font-weight: 500;
        }
        .reset-password-right p {
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
    <div class="reset-password-container d-flex">
        <!-- Left: Reset Password Form -->
        <div class="reset-password-left col-md-6">
            <div class="logo">
                <img src="/img/logo.jpg" alt="PLS Logo">
            </div>
            <h2 class="mt-3">Đặt lại mật khẩu</h2>
            <p class="text-muted mb-4">Nhập mật khẩu mới của bạn.</p>

            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <form:form method="post" action="/reset-password" modelAttribute="resetPasswordDTO">
                <input type="hidden" name="token" value="${token}" />
                <div class="mb-3">
                    <c:set var="errorPassword">
                        <form:errors path="password" cssClass="invalid-feedback"/>
                    </c:set>
                    <form:input
                            class="form-control ${not empty errorPassword?'is-invalid':''}"
                            id="inputPassword"
                            path="password"
                            type="password"
                            placeholder="Mật khẩu mới"
                    />
                        ${errorPassword}
                </div>
                <div class="mb-3">
                    <c:set var="errorConfirmPassword">
                        <form:errors path="confirmPassword" cssClass="invalid-feedback"/>
                    </c:set>
                    <form:input
                            class="form-control ${not empty errorConfirmPassword?'is-invalid':''}"
                            id="inputConfirmPassword"
                            path="confirmPassword"
                            type="password"
                            placeholder="Xác nhận mật khẩu"
                    />
                        ${errorConfirmPassword}
                </div>
                <button type="submit" class="btn btn-primary btn-submit">Đặt lại mật khẩu</button>
            </form:form>

            <!-- Link to Login -->
            <div class="login-link">
                <p>Quay lại <a href="/login">Đăng nhập</a></p>
            </div>
        </div>

        <!-- Right: Promotional Section -->
        <div class="reset-password-right col-md-6">
            <h3>Bảo mật tài khoản của bạn.</h3>
            <p>Hãy chọn một mật khẩu mạnh để bảo vệ tài khoản của bạn.</p>
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