<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Course Listing Page</title>
                <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="/css/listpackage.css">
                <script src="https://unpkg.com/lucide@latest"></script>
            </head>

            <body>
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

                <main class="main-content">
                    <div class="container">
                        <h1 class="page-title">Tất cả khóa học</h1>

                        <div class="search-filter-bar">
                            <button class="filter-button">
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"
                                    viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M4 6h16M6 12h12M10 18h4" />
                                </svg>
                                Filter
                            </button>

                            <div class="search-bar">
                                <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="25" height="25"
                                    viewBox="0 0 24 24">
                                    <path
                                        d="M 9 2 C 5.1458514 2 2 5.1458514 2 9 C 2 12.854149 5.1458514 16 9 16 C 10.747998 16 12.345009 15.348024 13.574219 14.28125 L 14 14.707031 L 14 16 L 20 22 L 22 20 L 16 14 L 14.707031 14 L 14.28125 13.574219 C 15.348024 12.345009 16 10.747998 16 9 C 16 5.1458514 12.854149 2 9 2 z M 9 4 C 11.773268 4 14 6.2267316 14 9 C 14 11.773268 11.773268 14 9 14 C 6.2267316 14 4 11.773268 4 9 C 4 6.2267316 6.2267316 4 9 4 z">
                                    </path>
                                </svg>
                                <input type="text" placeholder="Tìm kiếm khóa học...">
                            </div>

                            <div class="sort-dropdown">
                                <span>Sắp xếp theo</span>
                                <select>
                                    <option>Giá</option>
                                    <option>Phổ biến</option>
                                    <option>Đánh giá</option>
                                </select>
                            </div>
                        </div>


                        <div class="content-wrapper">
                            <aside class="sidebar">
                                <div class="filter-section">
                                    <h3>Number of Subjects</h3>
                                    <ul>
                                        <li><label><input type="checkbox"> 1</label></li>
                                        <li><label><input type="checkbox"> 2</label></li>
                                        <li><label><input type="checkbox" checked> 3</label></li>
                                        <li><label><input type="checkbox"> More than 3</label></li>
                                    </ul>
                                </div>
                                <div class="filter-section">
                                    <h3>Price</h3>
                                    <!-- Add price filter content here -->
                                </div>
                                <div class="filter-section">
                                    <h3>Grade</h3>
                                    <!-- Add grade filter content here -->
                                </div>
                            </aside>

                            <section class="course-grid">
                                <div class="course-card">
                                    <img src="hinh-khoa-hoc.jpg" alt="Course Image" class="course-img">
                                    <h3 class="course-title">Beginner’s Guide to Design</h3>
                                    <p class="course-author">Tác giả: Ronald Richards</p>
                                    <p class="course-info">22 giờ • 155 bài giảng • Trình độ: Người mới</p>
                                    <div class="course-bottom">
                                        <span class="course-price">$149.9</span>
                                        <button class="add-to-cart-btn">
                                            ADD TO CART
                                            <img width="18" height="18"
                                                src="https://img.icons8.com/material-outlined/24/FFFFFF/fast-cart.png"
                                                alt="fast-cart" />
                                        </button>
                                    </div>
                                </div>

                            </section>
                        </div>

                        <div class="pagination">
                            <button class="prev-page">← Previous</button>
                            <button class="page-number active">1</button>
                            <button class="page-number">2</button>
                            <button class="page-number">3</button>
                            <button class="next-page">Next →</button>
                        </div>
                    </div>
                </main>

                <!-- Footer Section -->
                <footer class="footer">
                    <div class="container">
                        <div class="footer-content">
                            <div class="company-info">
                                <img src="https://c.animaapp.com/mbgkuigrW2kpeU/img/image-4.png" alt="Byway Logo"
                                    class="footer-logo">
                                <p>Empowering learners through accessible and engaging online education. Byway is a
                                    leading online learning platform dedicated to providing high-quality, flexible,
                                    and affordable educational experiences.</p>
                            </div>
                            <div class="footer-links">
                                <div class="link-column">
                                    <h3>Get Help</h3>
                                    <ul>
                                        <li><a href="#">Contact Us</a></li>
                                        <li><a href="#">Latest Articles</a></li>
                                        <li><a href="#">FAQ</a></li>
                                    </ul>
                                </div>
                                <div class="link-column">
                                    <h3>Programs</h3>
                                    <ul>
                                        <li><a href="#">Art & Design</a></li>
                                        <li><a href="#">Business</a></li>
                                        <li><a href="#">IT & Software</a></li>
                                        <li><a href="#">Languages</a></li>
                                        <li><a href="#">Programming</a></li>
                                    </ul>
                                </div>
                                <div class="link-column">
                                    <h3>Contact Us</h3>
                                    <p>Address: 123 Main Street, Anytown, CA 12345</p>
                                    <p>Tel: +(123) 456-7890</p>
                                    <p>Mail: bywayedu@webkul.in</p>
                                    <img src="https://c.animaapp.com/mbgkuigrW2kpeU/img/image-3.png"
                                        alt="Social Media Icons" class="social-icons">
                                </div>
                            </div>
                        </div>
                    </div>
                </footer>

                <script>
                    lucide.createIcons();
                </script>
            </body>

            </html>