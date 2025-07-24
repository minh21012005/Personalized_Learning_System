<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Hệ thống Học tập Cá nhân hóa</title>
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="/img/logo.jpg">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">

    <!-- Custom CSS -->
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

        .login-container {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 900px;
            width: 100%;
        }

        .login-left {
            padding: 40px;
            background-color: #fff;
        }

        .login-right {
            background: url("/img/login.jpg") no-repeat center center;
            background-size: cover;
        }

        .logo img {
            height: 90px; /* Adjust based on your logo size */
        }

        h2 {
            font-size: 28px;
            font-weight: 600;
            color: #333;
        }

        .social-login-btn {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 10px;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            background-color: white;
            transition: all 0.3s;
        }

        .social-login-btn img {
            width: 20px;
            margin-right: 10px;
        }

        .social-login-btn:hover {
            background-color: #f8f9fa;
        }

        .divider {
            text-align: center;
            position: relative;
            margin: 20px 0;
            color: #666;
        }

        .divider::before,
        .divider::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 45%;
            height: 1px;
            background-color: #ddd;
        }

        .divider::before {
            left: 0;
        }

        .divider::after {
            right: 0;
        }

        .form-control {
            border-radius: 5px;
            padding: 12px;
            border: 1px solid #ddd;
        }

        .form-check-label {
            color: #666;
        }

        .forgot-password {
            color: #045bd8;
            text-decoration: none;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }

        .btn-login {
            background-color: #045bd8;
            border: none;
            padding: 12px;
            border-radius: 5px;
            font-weight: 500;
            width: 100%;
        }

        .signup-link {
            text-align: center;
            margin-top: 20px;
        }

        .signup-link a {
            color: #045bd8;
            text-decoration: none;
        }

        .signup-link a:hover {
            text-decoration: underline;
        }

        .login-right h3 {
            font-size: 24px;
            font-weight: 500;
        }

        .login-right p {
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

        .message {
            margin-top: 20px;
            color: #28a745;
        }

        .dot.active {
            background-color: white;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="login-container d-flex">
        <!-- Bên trái: Form Đăng nhập -->
        <div class="login-left col-md-6">
            <div class="logo">
                <img src="/img/logo.jpg" alt="PLS Logo">
            </div>
            <h2 class="mt-3">Đăng nhập vào Tài khoản của bạn</h2>
            <p class="text-muted mb-4">Chào mừng bạn trở lại!</p>

            <!-- Form Email/Mật khẩu -->
            <form action="/login" method="post">
                <c:if test="${param.error != null}">
                    <div class="my-2" style="color: red;">Sai mật khẩu hoặc Email không tồn tại. Hoặc tài khoản chưa được kích hoạt.
                    </div>
                </c:if>
                <c:if test="${param.logout != null}">
                    <div class="my-2" style="color: green;"> Đăng Xuất thành công.
                    </div>
                </c:if>
                <c:if test="${not empty message}">
                    <div class="message">${message}</div>
                </c:if>
                <div class="mb-3">
                    <input type="email" class="form-control" name="username" placeholder="Email" required>
                </div>
                <div class="mb-3">
                    <input type="password" class="form-control" name="password" placeholder="Mật khẩu" required>
                </div>
                <div class="d-flex justify-content-between mb-4">
                    <a href="/forgot-password" class="forgot-password">Quên mật khẩu?</a>
                </div>
                <div>
                    <input type="hidden" name="${_csrf.parameterName}"
                           value="${_csrf.token}"/>
                </div>
                <button type="submit" class="btn btn-primary btn-login">Đăng nhập</button>
            </form>

            <!-- Liên kết Đăng ký -->
            <div class="signup-link">
                <p>Chưa có tài khoản? <a href="/register">Tạo tài khoản</a></p>
            </div>
        </div>

        <!-- Bên phải: Phần Quảng bá -->
        <div class="login-right col-md-6">

            <%--            <h3>Kết nối với mọi ứng dụng.</h3>--%>
            <%--            <p>Mọi thứ bạn cần trong một bảng điều khiển dễ dàng tùy chỉnh.</p>--%>
            <%--            <div class="dots">--%>
            <%--                <div class="dot active"></div>--%>
            <%--                <div class="dot"></div>--%>
            <%--                <div class="dot"></div>--%>
            <%--            </div>--%>
            <%--            <!-- Placeholder cho Hình minh họa -->--%>
            <%--            <div class="illustration">--%>
            <%--                <!-- Bạn có thể thêm hình ảnh tại đây nếu có -->--%>
            <%--            </div>--%>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="/lib/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>