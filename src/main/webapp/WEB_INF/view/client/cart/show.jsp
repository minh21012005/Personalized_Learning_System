<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8" />
                    <title>Shopping Cart - Byway Education</title>
                    <meta name="viewport" content="width=device-width, initial-scale=1" />
                    <link href="https://fonts.googleapis.com/css?family=Inter:400,500,600,700|Poppins:500,600"
                        rel="stylesheet" />
                    <script src="https://unpkg.com/lucide@latest"></script>
                    <!-- Toastify CSS -->
                    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" />
                    <!-- Toastify JS -->
                    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
                    <link rel="stylesheet" href="/css/cart.css">
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
                                            <c:forEach var="cartPackage" items="${cartPackages}">
                                                <div class="course-card">
                                                    <div class="course-content">
                                                        <div class="course-info">
                                                            <img class="course-img" alt="Course thumbnail"
                                                                src="/img/package/${cartPackage.pkg.image}" />

                                                            <div class="course-details">
                                                                <div class="course-title-container">
                                                                    <a href="/parent/course/detail/${cartPackage.pkg.packageId}"
                                                                        class="course-title">${cartPackage.pkg.name}
                                                                    </a>
                                                                    <!-- <p class="course-instructor">By John Doe</p> -->
                                                                </div>

                                                                <!-- <div class="course-rating-container">
                                                                <div class="rating-group">
                                                                    <span class="rating-value">4.6</span>
                                                                    <div class="star-container">
                                                                        <i data-lucide="star"
                                                                            class="star-icon filled"></i>
                                                                        <i data-lucide="star"
                                                                            class="star-icon filled"></i>
                                                                        <i data-lucide="star"
                                                                            class="star-icon filled"></i>
                                                                        <i data-lucide="star"
                                                                            class="star-icon filled"></i>
                                                                        <i data-lucide="star"
                                                                            class="star-icon filled"></i>
                                                                    </div>
                                                                    <span class="rating-count">(250 rating)</span>
                                                                </div>

                                                                <div class="separator-vertical"></div>

                                                                <span class="course-meta">22 Total Hours • 155 Lectures
                                                                    •
                                                                    All
                                                                    levels</span>
                                                            </div> -->

                                                                <div class="course-actions">
                                                                    <div class="separator-vertical"></div>
                                                                    <form action="/parent/cart/delete/${cartPackage.id}"
                                                                        method="post">
                                                                        <input type="hidden"
                                                                            name="${_csrf.parameterName}"
                                                                            value="${_csrf.token}" />
                                                                        <button class="remove-button">Remove</button>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="course-price">
                                                            <fmt:formatNumber value="${cartPackage.pkg.price}"
                                                                type="number" groupingUsed="true" />
                                                            <span class="vnd-symbol">₫</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <!-- Right column - Checkout details -->
                                        <div class="right-column">
                                            <div class="checkout-card">
                                                <div class="checkout-content">
                                                    <h3 class="checkout-title">Order Details</h3>

                                                    <div class="order-item">
                                                        <span class="order-label">Price</span>
                                                        <span class="order-value">
                                                            <fmt:formatNumber value="${totalPrice}" type="number"
                                                                groupingUsed="true" /> ₫
                                                        </span>
                                                    </div>

                                                    <!-- <div class="order-item">
                                                    <span class="order-label">Discount</span>
                                                    <span class="order-value">-$10.00</span>
                                                </div>

                                                <div class="order-item">
                                                    <span class="order-label">Tax</span>
                                                    <span class="order-value">$10.00</span>
                                                </div> -->

                                                    <div class="separator-horizontal"></div>

                                                    <div class="order-total">
                                                        <span class="total-label">Total</span>
                                                        <span class="total-value">
                                                            <fmt:formatNumber value="${totalPrice}" type="number"
                                                                groupingUsed="true" /> ₫
                                                        </span>
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
                    <c:if test="${not empty success}">
                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                Toastify({
                                    text: "<i class='fas fa-check-circle'></i> ${fn:escapeXml(success)}",
                                    duration: 4000,
                                    close: true,
                                    gravity: "top",
                                    position: "right",
                                    style: {
                                        background: "linear-gradient(to right, #28a745, #34c759)", // Gradient xanh
                                        borderRadius: "8px",
                                        boxShadow: "0 4px 12px rgba(0, 0, 0, 0.3)",
                                        fontFamily: "'Roboto', sans-serif",
                                        fontSize: "16px",
                                        padding: "12px 20px",
                                        display: "flex",
                                        alignItems: "center",
                                        gap: "10px"
                                    },
                                    className: "toastify-success",
                                    escapeMarkup: false // Cho phép HTML trong text
                                }).showToast();
                            });
                        </script>
                    </c:if>
                </body>

                </html>