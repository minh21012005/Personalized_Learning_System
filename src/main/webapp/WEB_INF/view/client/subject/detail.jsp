<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Detail Subject</title>
            <script src="https://unpkg.com/lucide@latest"></script>
            <style>
                :root {
                    --black: rgba(2, 6, 23, 1);
                    --colorsneutralblack: rgba(19, 19, 19, 1);
                    --colorsneutralwhite: rgba(255, 255, 255, 1);
                    --error-600: rgba(220, 38, 38, 1);
                    --grey: rgba(100, 116, 139, 1);
                    --grey-100: rgba(241, 245, 249, 1);
                    --grey-300: rgba(203, 213, 225, 1);
                    --grey-700: rgba(51, 65, 85, 1);
                    --grey-800: rgba(30, 41, 59, 1);
                    --grey-900: rgba(15, 23, 42, 1);
                    --greybackground: rgba(248, 250, 252, 1);
                    --greyborder: rgba(226, 232, 240, 1);
                    --greytext-dark: rgba(2, 6, 23, 1);
                    --primary-600: rgba(37, 99, 235, 1);
                    --warning-300: rgba(254, 200, 75, 1);
                    --white: rgba(255, 255, 255, 1);
                }

                /* Reset and base styles */
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Inter', sans-serif;
                    line-height: 1.5;
                    color: #0f172a;
                    background-color: #f8fafc;
                }

                .container {
                    max-width: 1440px;
                    margin: 0 auto;
                    padding: 0 20px;
                }

                .content {
                    max-width: 1350px;
                    margin: 0 auto;
                    padding: 0 20px;
                }

                /* Header styles */
                .header {
                    width: 100%;
                    height: 79px;
                    background-color: var(--white);
                    border-bottom: 1px solid var(--greyborder);
                }

                .header-container {
                    height: 100%;
                    position: relative;
                    max-width: 1440px;
                    margin: 0 auto;
                    padding: 0 16px;
                }

                .header-content {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    height: 100%;
                }

                .logo {
                    flex-shrink: 0;
                }

                .logo-img {
                    width: 97px;
                    height: 33px;
                }

                /* Navigation styles */
                .nav-menu {
                    margin: 0 auto;
                }

                .nav-list {
                    display: flex;
                    align-items: center;
                    gap: 52px;
                    list-style: none;
                }

                .nav-item {
                    display: flex;
                }

                .nav-link {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    padding: 10px;
                    cursor: pointer;
                    text-decoration: none;
                }

                .nav-icon {
                    width: 18px;
                    height: 18px;
                    background-image: url(https://c.animaapp.com/mbgux5dcnDKIHL/img/iconly-light-arrow---right-2.svg);
                    background-size: 100% 100%;
                }

                .nav-text {
                    font-family: 'Inter', Helvetica;
                    font-weight: 700;
                    color: var(--colorsneutralblack);
                    font-size: 16px;
                }

                /* User actions styles */
                .user-actions {
                    display: flex;
                    align-items: center;
                    gap: 24px;
                }

                .action-icon {
                    width: 24px;
                    height: 24px;
                    color: var(--grey-700);
                    cursor: pointer;
                }

                .avatar {
                    width: 40px;
                    height: 40px;
                    background-color: var(--grey-700);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }

                .avatar-text {
                    color: var(--white);
                    font-weight: 500;
                }

                /* Course List Section */
                .course-list {
                    background-color: var(--greybackground);
                    padding: 60px 0;
                }

                .course-list-container {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-start;
                    gap: 40px;
                    flex-wrap: wrap;
                }

                .course-info {
                    flex: 1 1 60%;
                    min-width: 300px;
                }

                .breadcrumb ol {
                    display: flex;
                    list-style-type: none;
                    padding: 0;
                    margin-bottom: 20px;
                }

                .breadcrumb li:not(:last-child)::after {
                    content: ">";
                    margin: 0 10px;
                    color: var(--grey-600);
                }

                .breadcrumb a {
                    color: var(--grey-700);
                    text-decoration: none;
                }

                .breadcrumb li:last-child {
                    color: var(--primary-600);
                }

                h1 {
                    font-size: 40px;
                    margin-bottom: 20px;
                    font-weight: 700;
                }

                .course-description {
                    font-size: 16px;
                    color: var(--grey-700);
                    margin-bottom: 20px;
                    max-width: 800px;
                }

                .creator-info {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .creator-avatar {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                }

                /* Course Card (Right Side) */
                .course-card {
                    flex: 0 0 320px;
                    border: 1px solid var(--greyborder);
                    border-radius: 16px;
                    overflow: hidden;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    background-color: var(--white);
                }

                .course-image {
                    width: 100%;
                    height: 200px;
                    object-fit: cover;
                    border-top-left-radius: 16px;
                    border-top-right-radius: 16px;
                }

                .price-section {
                    display: flex;
                    align-items: center;
                    gap: 13px;
                    padding: 20px;
                }

                .current-price {
                    font-size: 24px;
                    font-weight: bold;
                }

                .original-price {
                    text-decoration: line-through;
                    color: var(--greydisable-color);
                    position: relative;
                }

                .original-price::after {
                    content: '';
                    position: absolute;
                    left: 0;
                    top: 50%;
                    width: 100%;
                    height: 1px;
                    background-color: var(--greydisable-color);
                }

                .discount-badge {
                    background-color: var(--active-600);
                    color: var(--white);
                    padding: 4px 8px;
                    border-radius: 4px;
                    font-size: 14px;
                }

                .add-to-cart-btn {
                    width: calc(100% - 40px);
                    margin: 0 20px 20px;
                    padding: 12px;
                    background-color: var(--greytext-dark);
                    color: var(--white);
                    border: none;
                    border-radius: 8px;
                    font-size: 16px;
                    font-weight: 500;
                    cursor: pointer;
                }


                /* Main content styles */
                .main-content {
                    padding: 40px 0;
                }

                .breadcrumb {
                    display: flex;
                    gap: 10px;
                    margin-bottom: 20px;
                }

                .breadcrumb a {
                    color: #64748b;
                    text-decoration: none;
                }

                .breadcrumb .active {
                    color: #2563eb;
                }

                h1 {
                    font-size: 40px;
                    font-weight: 700;
                    margin-bottom: 20px;
                    max-width: 840px;
                }

                .author {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    margin-bottom: 40px;
                }

                .author-avatar {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                }

                .author-name {
                    color: #2563eb;
                }

                /* Course details styles */
                .course-details {
                    background-color: #ffffff;
                    padding: 40px;
                    border-radius: 8px;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                }

                .course-details h2 {
                    font-size: 24px;
                    margin-bottom: 15px;
                }

                .course-details p {
                    margin-bottom: 20px;
                }

                .curriculum {
                    border: 1px solid #e2e8f0;
                    border-radius: 8px;
                    overflow: hidden;
                }

                .curriculum-item {
                    border-bottom: 1px solid #e2e8f0;
                    padding: 20px;
                }

                .curriculum-item:last-child {
                    border-bottom: none;
                }

                .curriculum-item-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    cursor: pointer;
                }

                .curriculum-item-title {
                    font-weight: 600;
                }

                .curriculum-item-meta {
                    font-size: 14px;
                    color: #64748b;
                }

                /* Footer styles */
                footer {
                    background-color: #1e293b;
                    color: #f1f5f9;
                    padding: 60px 0;
                }

                .footer-content {
                    display: flex;
                    justify-content: space-between;
                    flex-wrap: wrap;
                    gap: 40px;
                }

                .footer-column {
                    flex: 1;
                    min-width: 200px;
                }

                .footer-column h3 {
                    font-size: 18px;
                    margin-bottom: 20px;
                }

                .footer-column ul {
                    list-style-type: none;
                }

                .footer-column ul li {
                    margin-bottom: 10px;
                }

                .footer-column a {
                    color: #cbd5e1;
                    text-decoration: none;
                }

                .social-icons img {
                    height: 24px;
                    margin-right: 10px;
                }

                .course-info {
                    margin-top: -60px;
                    /* Đẩy lên trên */
                }

                /* Nút back */
                .back-button {
                    position: relative;
                    display: flex;
                    justify-content: flex-start;
                    margin-top: 20px;
                }

                .back-button a {
                    padding: 10px 20px;
                    background-color: rgba(51, 65, 85, 1);
                    /* Giống màu nền */
                    color: #e2e8f0;
                    border: 1px solid #cbd5e1;
                    border-radius: 10px;
                    text-decoration: none;
                    font-weight: bold;
                    transition: all 0.3s ease;
                }
            </style>
        </head>

        <body>
            <header class="header">
                <div class="header-container">
                    <div class="header-content">
                        <!-- Logo -->
                        <div class="logo">
                            <img class="logo-img" alt="Logo" src="https://c.animaapp.com/mbgux5dcnDKIHL/img/logo.svg" />
                        </div>

                        <!-- Navigation Menu -->
                        <nav class="nav-menu">
                            <ul class="nav-list">
                                <li class="nav-item">
                                    <a href="#" class="nav-link">
                                        <span class="nav-text">Trang chủ</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="#" class="nav-link">
                                        <span class="nav-text">Khóa học</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="#" class="nav-link">
                                        <span class="nav-text">Dịch vụ</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="#" class="nav-link">
                                        <span class="nav-text">Tin tức</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="#" class="nav-link">
                                        <span class="nav-text">Liên hệ</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>

                        <!-- User Actions -->
                        <div class="user-actions">
                            <i data-lucide="heart" class="action-icon"></i>
                            <i data-lucide="shopping-cart" class="action-icon"></i>
                            <i data-lucide="bell" class="action-icon"></i>
                            <div class="avatar">
                                <span class="avatar-text">J</span>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <main class="main-content">
                <div class="content">
                    <!-- Course List Section -->
                    <section class="course-list">
                        <div class="content course-list-container">
                            <div class="course-info">
                                <nav class="breadcrumb">
                                    <ol>
                                        <li><a href="#">Home</a></li>
                                        <li><a href="#">Courses</a></li>
                                        <li>Web Development</li>
                                    </ol>
                                </nav>
                                <h1>Learn Web Development</h1>
                                <div class="creator-info">
                                    <img src="creator.jpg" alt="Creator" class="creator-avatar" />
                                    <span>John Doe</span>
                                </div>
                            </div>

                            <!-- Course card chuyển sang bên phải -->
                            <div class="course-card">
                                <img src="/img/403.jpg" alt="Course Image" class="course-image" />
                            </div>
                        </div> <!-- Đóng course-list-container -->
                    </section>


                    <section class="course-details">
                        <h2>Nội dung môn học</h2>
                        <p>This interactive e-learning course will introduce you to User Experience (UX) design, the art
                            of
                            creating products and services that are intuitive, enjoyable, and user-friendly. Gain a
                            solid
                            foundation in UX principles and learn to apply them in real-world scenarios through engaging
                            modules
                            and interactive exercises.</p>

                        <h2>Thời lượng môn học</h2>
                        <p>19 chương - 190 bài giảng</p>

                        <h2>Giáo trình</h2>
                        <div class="curriculum">
                            <div class="curriculum-item">
                                <div class="curriculum-item-header">
                                    <span class="curriculum-item-title">Introduction to UX Design</span>
                                    <span class="curriculum-item-meta">5 Lessons • 1 hour</span>
                                </div>
                            </div>
                            <div class="curriculum-item">
                                <div class="curriculum-item-header">
                                    <span class="curriculum-item-title">Basics of User-Centered Design</span>
                                    <span class="curriculum-item-meta">5 Lessons • 1 hour</span>
                                </div>
                            </div>
                            <div class="curriculum-item">
                                <div class="curriculum-item-header">
                                    <span class="curriculum-item-title">Elements of User Experience</span>
                                    <span class="curriculum-item-meta">5 Lessons • 1 hour</span>
                                </div>
                            </div>
                            <div class="curriculum-item">
                                <div class="curriculum-item-header">
                                    <span class="curriculum-item-title">Visual Design Principles</span>
                                    <span class="curriculum-item-meta">5 Lessons • 1 hour</span>
                                </div>
                            </div>
                        </div>
                    </section>
                    <div class="back-button">
                        <a href="javascript:history.back()">Quay lại</a>
                    </div>

                </div>
            </main>

            <footer>
                <div class="container footer-content">
                    <div class="footer-column">
                        <img src="https://c.animaapp.com/mbgr4qxtQFinSF/img/image-4.png" alt="Byway Logo"
                            style="margin-bottom: 20px;">
                        <p>Empowering learners through accessible and engaging online education. Byway is a leading
                            online
                            learning platform dedicated to providing high-quality, flexible, and affordable educational
                            experiences.</p>
                    </div>
                    <div class="footer-column">
                        <h3>Get Help</h3>
                        <ul>
                            <li><a href="#">Contact Us</a></li>
                            <li><a href="#">Latest Articles</a></li>
                            <li><a href="#">FAQ</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h3>Programs</h3>
                        <ul>
                            <li><a href="#">Art & Design</a></li>
                            <li><a href="#">Business</a></li>
                            <li><a href="#">IT & Software</a></li>
                            <li><a href="#">Languages</a></li>
                            <li><a href="#">Programming</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h3>Contact Us</h3>
                        <ul>
                            <li>Address: 123 Main Street, Anytown, CA 12345</li>
                            <li>Tel: <a href="tel:+1234567890">+(123) 456-7890</a></li>
                            <li>Mail: <a href="mailto:bywayedu@webkul.in">bywayedu@webkul.in</a></li>
                        </ul>
                        <div class="social-icons">
                            <img src="https://c.animaapp.com/mbgr4qxtQFinSF/img/image-3.png" alt="Social Media Icons">
                        </div>
                    </div>
                </div>
            </footer>
        </body>
        <script>
            // Initialize Lucide icons
            lucide.createIcons();
        </script>

        </html>