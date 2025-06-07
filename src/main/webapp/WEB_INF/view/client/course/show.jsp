<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                    <!DOCTYPE html>
                    <html lang="vi">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Course Listing Page</title>
                        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap"
                            rel="stylesheet">
                        <link rel="stylesheet" href="/css/listpackage.css">
                        <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
                        <script src="https://unpkg.com/lucide@latest"></script>
                        <!-- Choices.js CSS -->
                        <link rel="stylesheet"
                            href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css" />
                        <!-- Choices.js JS -->
                        <script
                            src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
                        <!-- Custom JS -->
                        <script src="/js/script.js"></script>
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
                                            <li class="nav-item"><a href="#" class="nav-link"><span
                                                        class="nav-text">Trang chủ</span></a></li>
                                            <li class="nav-item"><a href="#" class="nav-link"><span
                                                        class="nav-text">Khóa học</span></a></li>
                                            <li class="nav-item"><a href="#" class="nav-link"><span
                                                        class="nav-text">Dịch vụ</span></a></li>
                                            <li class="nav-item"><a href="#" class="nav-link"><span class="nav-text">Tin
                                                        tức</span></a></li>
                                            <li class="nav-item"><a href="#" class="nav-link"><span
                                                        class="nav-text">Liên hệ</span></a></li>
                                        </ul>
                                    </nav>
                                    <!-- User Actions -->
                                    <div class="user-actions">
                                        <i data-lucide="heart" class="action-icon"></i>
                                        <i data-lucide="shopping-cart" class="action-icon"></i>
                                        <i data-lucide="bell" class="action-icon"></i>
                                        <div class="avatar"><span class="avatar-text">J</span></div>
                                    </div>
                                </div>
                            </div>
                        </header>

                        <main class="main-content">
                            <div class="container">
                                <h1 class="page-title">Tất cả khóa học</h1>
                                <div class="search-filter-bar">
                                    <form action="/parent/course" method="get" class="filter-form">
                                        <input type="hidden" name="course" value="${param.course}">
                                        <input type="hidden" value="${param.grades}" name="grades" id="grades">
                                        <input type="hidden" value="${param.subjects}" name="subjects" id="subjects">
                                        <input type="hidden" value="${param.sort}" name="sort" id="sort">
                                        <button type="submit" class="filter-button">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"
                                                viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M4 6h16M6 12h12M10 18h4" />
                                            </svg>
                                            Filter
                                        </button>
                                    </form>
                                    <div class="search-wrapper">
                                        <form action="/parent/course" method="get" class="search-form">
                                            <div class="search-container">
                                                <div class="search-bar">
                                                    <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="25"
                                                        height="25" viewBox="0 0 24 24">
                                                        <path
                                                            d="M 9 2 C 5.1458514 2 2 5.1458514 2 9 C 2 12.854149 5.1458514 16 9 16 C 10.747998 16 12.345009 15.348024 13.574219 14.28125 L 14 14.707031 L 14 16 L 20 22 L 22 20 L 16 14 L 14.707031 14 L 14.28125 13.574219 C 15.348024 12.345009 16 10.747998 16 9 C 16 5.1458514 12.854149 2 9 2 z M 9 4 C 11.773268 4 14 6.2267316 14 9 C 14 11.773268 11.773268 14 9 14 C 6.2267316 14 4 11.773268 4 9 C 4 6.2267316 6.2267316 4 9 4 z">
                                                        </path>
                                                    </svg>
                                                    <input type="text" name="course" value="${param.course}"
                                                        placeholder="Tìm theo khóa học...">
                                                    <input type="hidden" name="grades" value="${param.grades}">
                                                    <input type="hidden" name="subjects" value="${param.subjects}">
                                                    <input type="hidden" name="sort" value="${param.sort}">
                                                </div>
                                                <button type="submit" class="search-button">Tìm</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                                <div class="content-wrapper">
                                    <aside class="sidebar">
                                        <div class="filter-section">
                                            <h3>Khối lớp</h3>
                                            <select class="grade-select grade-select-class" multiple>
                                                <c:forEach var="grade" items="${gradeList}">
                                                    <option value="${grade.gradeId}">
                                                        ${grade.gradeName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="filter-section">
                                            <h3>Môn học</h3>
                                            <select class="grade-select grade-select-subject" multiple>
                                                <c:forEach var="subject" items="${subjectList}">
                                                    <option value="${subject.subjectId}">
                                                        ${subject.subjectName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="sort-dropdown">
                                            <div class="sort-label">Sắp xếp theo</div>
                                            <div class="sort-options">
                                                <label class="sort-option">
                                                    <input type="radio" name="sort" value="" ${sort==null || sort==''
                                                        ? 'checked' : '' }> Không sắp xếp
                                                </label>
                                                <label class="sort-option">
                                                    <input type="radio" name="sort" value="increase" ${sort=='increase'
                                                        ? 'checked' : '' }> Giá tăng dần
                                                </label>
                                                <label class="sort-option">
                                                    <input type="radio" name="sort" value="decrease" ${sort=='decrease'
                                                        ? 'checked' : '' }> Giá giảm dần
                                                </label>
                                            </div>
                                        </div>
                                    </aside>
                                    <div class="course-grid">
                                        <c:forEach var="pkg" items="${packages}">
                                            <div class="course-card">
                                                <img src="hinh-khoa-hoc.jpg" alt="Course Image" class="course-img">
                                                <a href="/parent/course/detail/${pkg.packageId}">
                                                    <h3 class="course-title">${pkg.name}</h3>
                                                </a>
                                                <p class="course-author">Tác giả: </p>
                                                <!-- <p class="course-info">Khối: ${pkg.grade.gradeName} </p> -->
                                                <div class="mt-auto course-bottom">
                                                    <span class="course-price">
                                                        <fmt:formatNumber value="${pkg.price}" type="number"
                                                            groupingUsed="true" /> ₫
                                                    </span>
                                                    <button class="add-to-cart-btn mt-2">
                                                        Thêm vào giỏ hàng
                                                        <img width="18" height="18"
                                                            src="https://img.icons8.com/material-outlined/24/FFFFFF/fast-cart.png"
                                                            alt="fast-cart" />
                                                    </button>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                            <div class="pagination-container">
                                <c:set var="queryString" value="" />
                                <c:if test="${not empty grades}">
                                    <c:set var="queryString" value="${queryString}&grades=${grades}" />
                                </c:if>
                                <c:if test="${not empty subjects}">
                                    <c:set var="queryString" value="${queryString}&subjects=${subjects}" />
                                </c:if>
                                <c:if test="${not empty sort}">
                                    <c:set var="queryString" value="${queryString}&sort=${sort}" />
                                </c:if>
                                <c:if test="${not empty paramName}">
                                    <c:set var="queryString" value="${queryString}&course=${paramName}" />
                                </c:if>
                                <c:if test="${totalPage > 1}">
                                    <nav aria-label="Page navigation example">
                                        <ul class="pagination justify-content-center">
                                            <li class="page-item ${currentPage eq 1 ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="/parent/course?page=${currentPage - 1}${queryString}"
                                                    aria-label="Previous">
                                                    <span aria-hidden="true">
                                                        < </span>
                                                </a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPage}" varStatus="loop">
                                                <li class="page-item ${loop.index eq currentPage ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="/parent/course?page=${loop.index}${queryString}">${loop.index}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage eq totalPage ? 'disabled' : ''}">
                                                <a class="page-link"
                                                    href="/parent/course?page=${currentPage + 1}${queryString}"
                                                    aria-label="Next">
                                                    <span aria-hidden="true">></span>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </c:if>
                            </div>
                        </main>
                        <!-- Footer Section -->
                        <footer class="footer">
                            <div class="container">
                                <div class="footer-content">
                                    <div class="company-info">
                                        <img src="https://c.animaapp.com/mbgkuigrW2kpeU/img/image-4.png"
                                            alt="Byway Logo" class="footer-logo">
                                        <p>Empowering learners through accessible and engaging online education. Byway
                                            is a leading online learning platform dedicated to providing high-quality,
                                            flexible, and affordable educational experiences.</p>
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
                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    </body>
                    <script>
                        lucide.createIcons();
                    </script>

                    </html>