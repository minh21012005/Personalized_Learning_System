<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <title>Shopping Cart - Byway Education</title>
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <link href="https://fonts.googleapis.com/css?family=Inter:400,500,600,700|Poppins:500,600"
                rel="stylesheet" />
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

                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                    font-family: 'Inter', sans-serif;
                }

                body {
                    background-color: var(--white);
                    color: var(--grey-900);
                }

                /* Container styles */
                .shopping-cart-container {
                    display: flex;
                    flex-direction: row;
                    justify-content: center;
                    width: 100%;
                }

                .max-width-container {
                    width: 100%;
                    max-width: 1440px;
                }

                .container {
                    max-width: 1280px;
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

                /* Cart header styles */
                .cart-header {
                    display: flex;
                    flex-direction: column;
                    gap: 16px;
                    margin-bottom: 32px;
                    margin-top: 24px;
                }

                .cart-title {
                    font-size: 32px;
                    line-height: 130%;
                    font-weight: 400;
                    color: var(--grey-900);
                }

                /* Breadcrumb styles */
                .breadcrumb {
                    margin-top: 8px;
                }

                .breadcrumb-list {
                    display: flex;
                    flex-wrap: wrap;
                    align-items: center;
                    gap: 6px;
                    list-style: none;
                }

                .breadcrumb-item {
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                }

                .breadcrumb-link {
                    font-size: 14px;
                    font-weight: 400;
                    color: var(--grey-900);
                    text-decoration: none;
                    transition: color 0.2s;
                }

                .breadcrumb-link.current {
                    color: var(--primary-600);
                }

                .breadcrumb-separator {
                    display: flex;
                    align-items: center;
                }

                .breadcrumb-separator svg {
                    width: 24px;
                    height: 24px;
                }

                /* Two column layout */
                .two-column-layout {
                    display: flex;
                    flex-direction: row;
                    gap: 24px;
                    margin-top: 24px;
                }

                .left-column {
                    width: 66.666%;
                }

                .right-column {
                    width: 33.333%;
                }

                /* Course card styles */
                .course-card {
                    width: 100%;
                    border: 1px solid var(--greyborder);
                    border-radius: 8px;
                    margin-bottom: 16px;
                    background-color: var(--white);
                }

                .course-content {
                    padding: 16px;
                    display: flex;
                    align-items: flex-start;
                    justify-content: space-between;
                }

                .course-info {
                    display: flex;
                    align-items: flex-start;
                    gap: 8px;
                }

                .course-img {
                    width: 192px;
                    height: 108px;
                    object-fit: cover;
                    border-radius: 4px;
                }

                .course-details {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }

                .course-title-container {
                    margin-bottom: 4px;
                }

                .course-title {
                    font-size: 18px;
                    line-height: 160%;
                    font-weight: 400;
                    color: var(--black);
                }

                .course-instructor {
                    font-size: 14px;
                    line-height: 150%;
                    color: var(--grey-700);
                }

                .course-rating-container {
                    display: flex;
                    align-items: center;
                    gap: 6px;
                }

                .rating-group {
                    display: flex;
                    align-items: center;
                    gap: 4px;
                }

                .rating-value {
                    font-size: 16px;
                    font-weight: 500;
                    color: var(--warning-300);
                }

                .star-container {
                    display: flex;
                    align-items: center;
                }

                .star-icon {
                    width: 19.2px;
                    height: 19.2px;
                    color: var(--warning-300);
                }

                .star-icon.filled {
                    fill: var(--warning-300);
                }

                .rating-count {
                    font-size: 14px;
                    color: var(--grey);
                }

                .course-meta {
                    font-size: 14px;
                    color: var(--black);
                }

                .course-actions {
                    display: flex;
                    align-items: center;
                    gap: 6px;
                }

                .remove-button {
                    font-size: 14px;
                    color: var(--error-600);
                    background: none;
                    border: none;
                    cursor: pointer;
                    padding: 0;
                }

                .remove-button:hover {
                    text-decoration: underline;
                }

                .course-price {
                    font-family: 'Poppins', sans-serif;
                    font-weight: 600;
                    font-size: 24px;
                    color: var(--black);
                }

                /* Checkout card styles */
                .checkout-card {
                    width: 100%;
                    border: 1px solid var(--greyborder);
                    border-radius: 8px;
                    background-color: var(--white);
                    position: sticky;
                    top: 16px;
                }

                .checkout-content {
                    padding: 24px;
                    display: flex;
                    flex-direction: column;
                    gap: 16px;
                }

                .checkout-title {
                    font-size: 20px;
                    line-height: 150%;
                    font-weight: 400;
                    color: var(--grey-900);
                }

                .order-item {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .order-label {
                    font-size: 16px;
                    line-height: 160%;
                    color: var(--grey-700);
                }

                .order-value {
                    font-size: 16px;
                    line-height: 160%;
                    color: var(--grey-900);
                }

                .separator-horizontal {
                    height: 1px;
                    width: 100%;
                    background-color: var(--greyborder);
                    margin: 8px 0;
                }

                .separator-vertical {
                    height: 13px;
                    width: 1px;
                    background-color: var(--greyborder);
                }

                .order-total {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .total-label {
                    font-size: 18px;
                    line-height: 160%;
                    font-weight: 400;
                    color: var(--grey-900);
                }

                .total-value {
                    font-size: 18px;
                    line-height: 160%;
                    font-weight: 400;
                    color: var(--grey-900);
                }

                .checkout-button {
                    width: 100%;
                    background-color: var(--primary-600);
                    color: var(--white);
                    border: none;
                    border-radius: 4px;
                    padding: 24px 0;
                    font-size: 16px;
                    font-weight: 500;
                    cursor: pointer;
                    margin-top: 16px;
                    transition: background-color 0.2s;
                }

                .checkout-button:hover {
                    background-color: rgba(37, 99, 235, 0.9);
                }

                /* Footer styles */
                .footer {
                    width: 100%;
                    background-color: var(--grey-800);
                    padding: 80px 0;
                    margin-top: 60px;
                }

                .footer-container {
                    max-width: none;
                    /* hoặc có thể giữ 1280px nếu muốn giới hạn chiều rộng */
                    width: 100%;
                    margin: 0 auto;
                    padding: 0 60px;
                    /* giảm từ 20px còn 40px (hoặc 0 nếu muốn sát hẳn) */
                    display: flex;
                    flex-wrap: wrap;
                    justify-content: space-between;
                    gap: 32px;
                }


                .company-info {
                    display: flex;
                    flex-direction: column;
                    gap: 16px;
                    max-width: 400px;
                }

                .company-logo {
                    width: 111px;
                    height: 40px;
                    object-fit: cover;
                }

                .company-description {
                    color: var(--grey-300);
                    font-size: 14px;
                    line-height: 150%;
                }

                .footer-links {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }

                .footer-heading {
                    color: var(--grey-100);
                    font-size: 18px;
                    line-height: 160%;
                    font-weight: 400;
                    margin-bottom: 4px;
                }

                .footer-nav {
                    display: flex;
                    flex-direction: column;
                    gap: 8px;
                }

                .footer-link {
                    color: var(--grey-300);
                    font-size: 14px;
                    line-height: 160%;
                    text-decoration: none;
                    transition: color 0.2s;
                }

                .footer-link:hover {
                    color: var(--grey-100);
                }

                .contact-info {
                    display: flex;
                    flex-direction: column;
                    gap: 24px;
                }

                .contact-text {
                    color: var(--grey-300);
                    font-size: 14px;
                    line-height: 160%;
                }

                .social-icons {
                    width: 296px;
                    height: 40px;
                    object-fit: cover;
                }

                /* Responsive adjustments */
                @media (max-width: 1024px) {
                    .two-column-layout {
                        flex-direction: column;
                    }

                    .left-column,
                    .right-column {
                        width: 100%;
                    }

                    .checkout-card {
                        position: static;
                    }
                }

                @media (max-width: 768px) {
                    .course-content {
                        flex-direction: column;
                    }

                    .course-price {
                        margin-top: 16px;
                        align-self: flex-end;
                    }

                    .course-info {
                        width: 100%;
                    }

                    .course-img {
                        width: 120px;
                        height: 80px;
                    }

                    .footer-container {
                        flex-direction: column;
                        gap: 40px;
                    }
                }

                @media (max-width: 640px) {
                    .course-info {
                        flex-direction: column;
                    }

                    .course-img {
                        width: 100%;
                        height: auto;
                        max-height: 200px;
                        margin-bottom: 16px;
                    }

                    .nav-list {
                        display: none;
                    }
                }
            </style>
        </head>

        <body>
            <div class="shopping-cart-container">
                <div class="max-width-container">
                    <div class="bg-white">
                        <!-- Shopping Cart Header -->
                        <header class="header">
                            <div class="header-container">
                                <div class="header-content">
                                    <!-- Logo -->
                                    <div class="logo">
                                        <img class="logo-img" alt="Logo"
                                            src="https://c.animaapp.com/mbgux5dcnDKIHL/img/logo.svg" />
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

                        <div class="container">
                            <!-- Cart Header Section -->
                            <section class="cart-header">
                                <h1 class="cart-title">Shopping Cart</h1>

                                <div class="breadcrumb">
                                    <ul class="breadcrumb-list">
                                        <li class="breadcrumb-item">
                                            <a href="#" class="breadcrumb-link">Categories</a>
                                        </li>
                                        <li class="breadcrumb-separator">
                                            <i data-lucide="chevron-right"></i>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <a href="#" class="breadcrumb-link">Details</a>
                                        </li>
                                        <li class="breadcrumb-separator">
                                            <i data-lucide="chevron-right"></i>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <a href="#" class="breadcrumb-link current">Shopping Cart</a>
                                        </li>
                                    </ul>
                                </div>
                            </section>

                            <div class="two-column-layout">
                                <!-- Left column - Course items -->
                                <div class="left-column">
                                    <!-- Course Item 1 -->
                                    <div class="course-card">
                                        <div class="course-content">
                                            <div class="course-info">
                                                <img class="course-img" alt="Course thumbnail"
                                                    src="https://c.animaapp.com/mbgux5dcnDKIHL/img/image-3-3.png" />

                                                <div class="course-details">
                                                    <div class="course-title-container">
                                                        <h3 class="course-title">Introduction to User Experience Design
                                                        </h3>
                                                        <p class="course-instructor">By John Doe</p>
                                                    </div>

                                                    <div class="course-rating-container">
                                                        <div class="rating-group">
                                                            <span class="rating-value">4.6</span>
                                                            <div class="star-container">
                                                                <i data-lucide="star" class="star-icon filled"></i>
                                                                <i data-lucide="star" class="star-icon filled"></i>
                                                                <i data-lucide="star" class="star-icon filled"></i>
                                                                <i data-lucide="star" class="star-icon filled"></i>
                                                                <i data-lucide="star" class="star-icon filled"></i>
                                                            </div>
                                                            <span class="rating-count">(250 rating)</span>
                                                        </div>

                                                        <div class="separator-vertical"></div>

                                                        <span class="course-meta">22 Total Hours • 155 Lectures • All
                                                            levels</span>
                                                    </div>

                                                    <div class="course-actions">
                                                        <div class="separator-vertical"></div>
                                                        <button class="remove-button">Remove</button>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="course-price">$45.00</div>
                                        </div>
                                    </div>

                                    <!-- Course Item 2 -->
                                    <div class="course-card">
                                        <div class="course-content">
                                            <div class="course-info">
                                                <img class="course-img" alt="Course thumbnail"
                                                    src="https://c.animaapp.com/mbgux5dcnDKIHL/img/image-3-3.png" />

                                                <div class="course-details">
                                                    <div class="course-title-container">
                                                        <h3 class="course-title">Advanced JavaScript: From Fundamentals
                                                            to
                                                            Functional JS</h3>
                                                        <p class="course-instructor">By Jane Smith</p>
                                                    </div>

                                                    <div class="course-rating-container">
                                                        <div class="rating-group">
                                                            <span class="rating-value">4.8</span>
                                                            <div class="star-container">
                                                                <i data-lucide="star" class="star-icon filled"></i>
                                                                <i data-lucide="star" class="star-icon filled"></i>
                                                                <i data-lucide="star" class="star-icon filled"></i>
                                                                <i data-lucide="star" class="star-icon filled"></i>
                                                                <i data-lucide="star" class="star-icon filled"></i>
                                                            </div>
                                                            <span class="rating-count">(320 rating)</span>
                                                        </div>

                                                        <div class="separator-vertical"></div>

                                                        <span class="course-meta">30 Total Hours • 200 Lectures •
                                                            Intermediate</span>
                                                    </div>

                                                    <div class="course-actions">
                                                        <div class="separator-vertical"></div>
                                                        <button class="remove-button">Remove</button>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="course-price">$65.00</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right column - Checkout details -->
                                <div class="right-column">
                                    <div class="checkout-card">
                                        <div class="checkout-content">
                                            <h3 class="checkout-title">Order Details</h3>

                                            <div class="order-item">
                                                <span class="order-label">Price</span>
                                                <span class="order-value">$110.00</span>
                                            </div>

                                            <div class="order-item">
                                                <span class="order-label">Discount</span>
                                                <span class="order-value">-$10.00</span>
                                            </div>

                                            <div class="order-item">
                                                <span class="order-label">Tax</span>
                                                <span class="order-value">$10.00</span>
                                            </div>

                                            <div class="separator-horizontal"></div>

                                            <div class="order-total">
                                                <span class="total-label">Total</span>
                                                <span class="total-value">$110.00</span>
                                            </div>

                                            <button class="checkout-button">Checkout</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>


                    </div>
                </div>
            </div>
            <!-- Footer Section -->
            <footer class="footer">
                <div class="footer-container">
                    <!-- Company Info -->
                    <div class="company-info">
                        <img class="company-logo" alt="Byway Logo"
                            src="https://c.animaapp.com/mbgux5dcnDKIHL/img/image-4.png" />
                        <p class="company-description">
                            Empowering learners through accessible and engaging online education. Byway is a
                            leading
                            online learning platform dedicated to providing high-quality, flexible, and
                            affordable
                            educational experiences.
                        </p>
                    </div>

                    <!-- Get Help Links -->
                    <div class="footer-links">
                        <h3 class="footer-heading">Get Help</h3>
                        <nav class="footer-nav">
                            <a href="#" class="footer-link">Contact Us</a>
                            <a href="#" class="footer-link">Latest Articles</a>
                            <a href="#" class="footer-link">FAQ</a>
                        </nav>
                    </div>

                    <!-- Programs Links -->
                    <div class="footer-links">
                        <h3 class="footer-heading">Programs</h3>
                        <nav class="footer-nav">
                            <a href="#" class="footer-link">Art & Design</a>
                            <a href="#" class="footer-link">Business</a>
                            <a href="#" class="footer-link">IT & Software</a>
                            <a href="#" class="footer-link">Languages</a>
                            <a href="#" class="footer-link">Programming</a>
                        </nav>
                    </div>

                    <!-- Contact Info -->
                    <div class="contact-info">
                        <h3 class="footer-heading">Contact Us</h3>
                        <p class="contact-text">Address: 123 Main Street, Anytown, CA 12345</p>
                        <p class="contact-text">Tel: +(123) 456-7890</p>
                        <p class="contact-text">Mail: bywayedu@webkul.in</p>
                        <img class="social-icons" alt="Social Media Icons"
                            src="https://c.animaapp.com/mbgux5dcnDKIHL/img/image-3.png" />
                    </div>
                </div>
            </footer>
            <script>
                // Initialize Lucide icons
                lucide.createIcons();
            </script>
        </body>

        </html>