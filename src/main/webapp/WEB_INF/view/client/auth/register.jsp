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
    <title>Đăng ký - Hệ thống Học tập Cá nhân hóa</title>
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
        .register-container {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 900px;
            width: 100%;
        }
        .register-left {
            padding: 40px;
            background-color: #fff;
        }
        .register-right {
            background: url('/img/register.jpg') no-repeat center;
            background-size: cover;
        }
        .logo img {
            height: 40px;
        }
        h2 {
            font-size: 28px;
            font-weight: 600;
            color: #333;
        }
        .social-signup-btn {
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
        .social-signup-btn img {
            width: 20px;
            margin-right: 10px;
        }
        .social-signup-btn:hover {
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
        .form-control.is-invalid {
            border-color: #dc3545;
        }
        .invalid-feedback {
            color: #dc3545;
            font-size: 0.875em;
        }
        .btn-register {
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
        .register-right h3 {
            font-size: 24px;
            font-weight: 500;
        }
        .register-right p {
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
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="register-container d-flex">

        <!-- Right: Promotional Section -->
        <div class="register-right col-md-6">

        </div>
        <!-- Left: Registration Form -->
        <div class="register-left col-md-6">
            <div class="logo">
                <img src="/img/logo.jpg" alt="PLS Logo">
            </div>
            <h2 class="mt-3">Đăng ký Tài khoản</h2>
            <p class="text-muted mb-4">Tạo tài khoản để bắt đầu học tập!</p>

            <!-- Registration Form -->
            <form:form method="post" action="/register" modelAttribute="registerUser">
                <div class="mb-3">
                    <c:set var="errorFullName">
                        <form:errors path="fullName" cssClass="invalid-feedback"/>
                    </c:set>
                    <form:input
                            class="form-control ${not empty errorFullName?'is-invalid':''}"
                            id="inputFullName"
                            path="fullName"
                            type="text"
                            placeholder="Họ và tên"
                    />
                        ${errorFullName}
                </div>
                <div class="mb-3">
                    <c:set var="errorEmail">
                        <form:errors path="email" cssClass="invalid-feedback"/>
                    </c:set>
                    <form:input
                            class="form-control ${not empty errorEmail?'is-invalid':''}"
                            id="inputEmail"
                            type="email"
                            path="email"
                            placeholder="Email"
                    />
                        ${errorEmail}
                </div>
                <div class="mb-3">
                    <c:set var="errorPhoneNumber">
                        <form:errors path="phoneNumber" cssClass="invalid-feedback"/>
                    </c:set>
                    <form:input
                            class="form-control ${not empty errorPhoneNumber?'is-invalid':''}"
                            id="inputPhoneNumber"
                            path="phoneNumber"
                            type="text"
                            placeholder="Số điện thoại"
                    />
                        ${errorPhoneNumber}
                </div>
                <div class="mb-3">
                    <c:set var="errorDob">
                        <form:errors path="dob" cssClass="invalid-feedback"/>
                    </c:set>
                    <form:input
                            class="form-control ${not empty errorDob?'is-invalid':''}"
                            id="inputDob"
                            path="dob"
                            type="date"
                            placeholder="Ngày sinh"
                    />
                        ${errorDob}
                </div>
                <div class="mb-3">
                    <c:set var="errorRole">
                        <form:errors path="role" cssClass="invalid-feedback"/>
                    </c:set>
                    <form:select
                            class="form-control ${not empty errorRole?'is-invalid':''}"
                            id="inputRole"
                            path="role"
                    >
                        <form:option value="" label="-- Chọn vai trò --"/>
                        <form:option value="STUDENT" label="Học sinh"/>
                        <form:option value="PARENT" label="Phụ huynh"/>

                    </form:select>
                        ${errorRole}
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <c:set var="errorPassword">
                            <form:errors path="password" cssClass="invalid-feedback"/>
                        </c:set>
                        <form:input
                                class="form-control ${not empty errorPassword?'is-invalid':''}"
                                id="inputPassword"
                                path="password"
                                type="password"
                                placeholder="Mật khẩu"
                        />
                            ${errorPassword}
                    </div>
                    <div class="col-md-6">
                        <c:set var="errorConfirmPassword">
                            <form:errors path="confirmPassword" cssClass="invalid-feedback"/>
                        </c:set>
                        <form:input
                                class="form-control ${not empty errorConfirmPassword?'is-invalid':''}"
                                id="inputPasswordConfirm"
                                path="confirmPassword"
                                type="password"
                                placeholder="Xác nhận mật khẩu"
                        />
                            ${errorConfirmPassword}
                    </div>
                </div>
                <button type="submit" class="btn btn-primary btn-register">Đăng ký</button>

                <!-- Link to Login -->
                <div class="login-link">
                    <p>Đã có tài khoản? <a href="/login">Đăng nhập</a></p>
                </div>
            </form:form>
        </div>


    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="/js/scripts.js"></script>
</body>
</html>