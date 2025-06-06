<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Detail Package</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="/css/detailpackage.css">
                <script src="https://unpkg.com/lucide@latest"></script>
            </head>

            <body>
                <div class="detail-package">
                    <!-- Header Section -->
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
                                <p class="course-description">Master the fundamentals of modern web development with
                                    hands-on projects.</p>
                                <div class="creator-info">
                                    <img src="creator.jpg" alt="Creator" class="creator-avatar" />
                                    <span>John Doe</span>
                                </div>
                            </div>

                            <!-- Course card chuyển sang bên phải -->
                            <div class="course-card">
                                <img src="course.jpg" alt="Course Image" class="course-image" />
                                <div class="price-section">
                                    <span class="current-price">$49</span>
                                    <span class="original-price">$99</span>
                                    <span class="discount-badge">50% Off</span>
                                </div>
                                <button class="add-to-cart-btn">Add to Cart</button>
                            </div>
                        </div>
                    </section>



                    <!-- Course Overview Section -->
                    <div class="content">
                        <section class="course-overview">
                            <div class="container">
                                <h2>Các môn học của khóa</h2>
                                <div class="search-sort">
                                    <div class="search-bar">
                                        <input type="text" placeholder="Tìm môn học...">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                            xmlns="http://www.w3.org/2000/svg">
                                            <path
                                                d="M11 19C15.4183 19 19 15.4183 19 11C19 6.58172 15.4183 3 11 3C6.58172 3 3 6.58172 3 11C3 15.4183 6.58172 19 11 19Z"
                                                stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                                stroke-linejoin="round" />
                                            <path d="M21 21L16.65 16.65" stroke="currentColor" stroke-width="2"
                                                stroke-linecap="round" stroke-linejoin="round" />
                                        </svg>
                                    </div>
                                    <div class="sort-dropdown">
                                        <span>Sort By</span>
                                        <select>
                                            <option value="">Select</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="course-grid">
                                    <!-- Course card (repeated 4 times) -->
                                    <div class="course-card">
                                        <img src="https://c.animaapp.com/mbgkuigrW2kpeU/img/rectangle-1080-3.png"
                                            alt="Beginner's Guide to Design" class="course-image">
                                        <h3>Beginner's Guide to Design</h3>
                                        <p class="author">By Ronald Richards</p>
                                        <div class="rating">
                                            <div class="stars">
                                                <img src="https://c.animaapp.com/mbgkuigrW2kpeU/img/star-3.svg"
                                                    alt="Star">
                                                <img src="https://c.animaapp.com/mbgkuigrW2kpeU/img/star-3.svg"
                                                    alt="Star">
                                                <img src="https://c.animaapp.com/mbgkuigrW2kpeU/img/star-3.svg"
                                                    alt="Star">
                                                <img src="https://c.animaapp.com/mbgkuigrW2kpeU/img/star-3.svg"
                                                    alt="Star">
                                                <img src="https://c.animaapp.com/mbgkuigrW2kpeU/img/star-3.svg"
                                                    alt="Star">
                                            </div>
                                            <span>(1200 Ratings)</span>
                                        </div>
                                        <p class="course-info">22 Total Hours • 155 Lectures • Beginner</p>
                                    </div>
                                    <!-- Repeat the course card 3 more times -->
                                </div>
                                <button class="back-btn">BACK</button>
                            </div>
                        </section>
                    </div>


                    <!-- Pagination -->
                    <nav class="pagination">
                        <button class="prev-page">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path d="M15 18L9 12L15 6" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round" />
                            </svg>
                        </button>
                        <ul>
                            <li><a href="#" class="active">1</a></li>
                            <li><a href="#">2</a></li>
                            <li><a href="#">3</a></li>
                        </ul>
                        <button class="next-page">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none"
                                xmlns="http://www.w3.org/2000/svg">
                                <path d="M9 18L15 12L9 6" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                                    stroke-linejoin="round" />
                            </svg>
                        </button>
                    </nav>

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
                </div>
            </body>
            <script>
                lucide.createIcons();
            </script>

            </html>