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
        <jsp:include page="../layout/head.jsp" />

        <main>
            <div class="confirmation">
                <div class="check-mark"><i class="fa-sharp fa-solid fa-check"></i></div>
                <h1>Xác nhận thanh toán thành công</h1>
                <p>Bạn sẽ sớm nhận được phản hồi từ chúng tôi!</p>
            </div>
        </main>

        <footer class="main-footer">
            <div class="footer-content">
                <div class="footer-brand">
                    <img src="https://c.animaapp.com/mc0hohc0Q9222b/img/image-4.png" alt="Byway logo"
                        class="footer-logo" />
                    <p class="brand-description">
                        Empowering learners through accessible and engaging online education.<br />
                        Byway is a leading online learning platform dedicated to providing
                        high-quality,
                        flexible, and affordable educational experiences.
                    </p>
                </div>
                <nav class="footer-nav">
                    <div class="nav-column">
                        <h3>Get Help</h3>
                        <ul>
                            <li><a href="#">Contact Us</a></li>
                            <li><a href="#">Latest Articles</a></li>
                            <li><a href="#">FAQ</a></li>
                        </ul>
                    </div>
                    <div class="nav-column">
                        <h3>Programs</h3>
                        <ul>
                            <li><a href="#">Art & Design</a></li>
                            <li><a href="#">Business</a></li>
                            <li><a href="#">IT & Software</a></li>
                            <li><a href="#">Languages</a></li>
                            <li><a href="#">Programming</a></li>
                        </ul>
                    </div>
                    <div class="nav-column">
                        <h3>Contact Us</h3>
                        <address>
                            <p>Address: 123 Main Street, Anytown, CA 12345</p>
                            <p>Tel: +(123) 456-7890</p>
                            <p>Mail: bywayedu@webkul.in</p>
                        </address>
                        <div class="social-links">
                            <img src="https://c.animaapp.com/mc0hohc0Q9222b/img/image-3.png" alt="Social media icons"
                                class="social-icons" />
                        </div>
                    </div>
                </nav>
            </div>
        </footer>
    </body>

    </html>