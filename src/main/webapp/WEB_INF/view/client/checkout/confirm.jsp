<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Xác nhận thanh toán</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            color: #333;
        }

        main {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 75vh;
            text-align: center;
        }

        .confirmation {
            padding: 20px;
        }

        .check-mark {
            font-size: 100px;
            color: #fff;
            background-color: #28a745;
            border-radius: 50%;
            width: 150px;
            height: 150px;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 20px;
        }

        h1 {
            font-size: 36px;
            color: #1a2e44;
        }

        p {
            font-size: 18px;
            color: #6c757d;
        }

        .main-footer {
            background-color: rgba(30, 41, 59, 1);
            color: rgba(203, 213, 225, 1);
            padding: 4rem 2rem;
        }

        .footer-content {
            display: flex;
            justify-content: space-between;
        }

        .footer-brand {
            max-width: 30%;
        }

        .footer-logo {
            margin-bottom: 1rem;
        }

        .brand-description {
            font-family: var(--small-text-font-family);
            font-size: var(--small-text-font-size);
            line-height: var(--small-text-line-height);
        }

        .footer-nav {
            display: flex;
            gap: 4rem;
        }

        .nav-column h3 {
            font-family: var(--heading-5-subheading-font-family);
            font-weight: var(--heading-5-subheading-font-weight);
            color: var(--grey-100);
            font-size: var(--heading-5-subheading-font-size);
            margin-bottom: 1rem;
        }

        .nav-column ul {
            list-style: none;
            padding: 0;
        }

        .nav-column li {
            margin-bottom: 0.5rem;
        }

        .nav-column a {
            font-family: var(--button-text-font-family);
            font-weight: var(--button-text-font-weight);
            color: var(--grey-300);
            font-size: var(--button-text-font-size);
            text-decoration: none;
        }

        .social-links {
            margin-top: 1rem;
        }

        .social-icons {
            max-width: 100%;
            height: auto;
        }

        h3 {
            font-size: 18px;
            margin-bottom: 10px;
        }

        a {
            display: block;
            color: #fff;
            text-decoration: none;
            margin-bottom: 5px;
        }

        a:hover {
            text-decoration: underline;
        }

        .social-icons a {
            margin-right: 10px;
            font-size: 20px;
        }
    </style>
</head>

<body>
<jsp:include page="../layout/header.jsp"/>

<main>
    <div class="confirmation">
        <div class="check-mark"><i class="fa-sharp fa-solid fa-check"></i></div>
        <h1>Xác nhận thanh toán thành công</h1>
        <p>Bạn sẽ sớm nhận được phản hồi từ chúng tôi!</p>
    </div>
</main>

<footer style="margin-top: 100px;">
    <jsp:include page="../layout/footer.jsp"/>
</footer>
</body>

</html>