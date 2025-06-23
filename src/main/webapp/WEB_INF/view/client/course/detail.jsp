<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
                        <!-- Toastify CSS -->
                        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" />
                        <!-- Toastify JS -->
                        <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
                    </head>

                    <body>
                        <div class="detail-package">
                            <!-- Header Section -->
                            <jsp:include page="../layout/head.jsp" />

                            <!-- Course List Section -->
                            <section class="course-list">
                                <div class="content course-list-container">
                                    <div class="course-info">
                                        <h1>${pkg.name}</h1>
                                        <p class="course-description">${pkg.description}</p>
                                        <div class="creator-info">
                                            <span></span>
                                        </div>
                                    </div>

                                    <!-- Course card chuyển sang bên phải -->
                                    <div class="course-card">
                                        <img src="/img/package/${pkg.image}" alt="Course Image" class="course-image" />
                                        <div class="price-section">
                                            <span class="current-price">
                                                <fmt:formatNumber value="${pkg.price}" type="number"
                                                    groupingUsed="true" />
                                                ₫
                                            </span>
                                            <!-- <span class="original-price">$99</span>
                                    <span class="discount-badge">50% Off</span> -->
                                        </div>
                                        <form action="/parent/cart" method="post">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <input type="hidden" name="packageId" value="${pkg.packageId}" />
                                            <button class="add-to-cart-btn">Thêm vào giỏ hàng</button>
                                        </form>
                                    </div>
                                </div>
                            </section>



                            <!-- Course Overview Section -->
                            <div class="content">
                                <section class="course-overview">
                                    <div class="container">
                                        <h2>Các môn học của khóa</h2>
                                        <div class="course-grid">
                                            <c:forEach var="subject" items="${subjects}">
                                                <div class="course-card">
                                                    <img src="/img/subjectImg/${subject.subjectImage}"
                                                        alt="Image not found" class="course-image">
                                                    <a href="/subject/detail/${subject.subjectId}">
                                                        <h3>${subject.subjectName}</h3>
                                                    </a>
                                                    <p class="author">Tác giả: </p>
                                                    <p class="course-info">22 Total Hours • 155 Lectures • Beginner</p>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </section>
                                <!-- Pagination -->
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
                            </div>

                            <div id="review-content">
                                <!-- Thêm tham số render=true để render trực tiếp -->
                                <jsp:include page="/package/${pkg.packageId}/reviews?render=true" />
                            </div>
                        </div>
                        <!-- Footer Section -->
                        <footer class="footer">
                            <div class="container">
                                <div class="footer-content">
                                    <div class="company-info">
                                        <img src="https://c.animaapp.com/mbgkuigrW2kpeU/img/image-4.png"
                                            alt="Byway Logo" class="footer-logo">
                                        <p>Empowering learners through accessible and engaging online education.
                                            Byway
                                            is a
                                            leading online learning platform dedicated to providing high-quality,
                                            flexible,
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
                    <c:if test="${not empty fail}">
                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                Toastify({
                                    text: "<i class='fas fa-exclamation-triangle'></i> ${fn:escapeXml(fail)}",
                                    duration: 4000,
                                    close: true,
                                    gravity: "top",
                                    position: "right",
                                    style: {
                                        background: "linear-gradient(to right, #ffc107, #ffca2c)", // Gradient vàng
                                        borderRadius: "8px",
                                        boxShadow: "0 4px 12px rgba(0, 0, 0, 0.3)",
                                        fontFamily: "'Roboto', sans-serif",
                                        fontSize: "16px",
                                        padding: "12px 20px",
                                        display: "flex",
                                        alignItems: "center",
                                        gap: "10px"
                                    },
                                    className: "toastify-fail",
                                    escapeMarkup: false // Cho phép HTML trong text
                                }).showToast();
                            });
                        </script>
                    </c:if>

                    </html>