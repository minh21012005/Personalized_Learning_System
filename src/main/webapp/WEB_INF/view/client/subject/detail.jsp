<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Detail Subject</title>
            <script src="https://unpkg.com/lucide@latest"></script>
            <link rel="stylesheet" href="/css/subjectDetail.css">
        </head>

        <body>
            <jsp:include page="../layout/head.jsp" />

            <main class="main-content">
                <div class="content">
                    <!-- Course List Section -->
                    <section class="course-list">
                        <div class="content course-list-container">
                            <div class="course-info">
                                <h1>${subject.subjectName}</h1>
                                <h2>Nội dung môn học</h2>
                                <p class="subject-description">${subject.subjectDescription}</p>
                                <div class="creator-info">
                                    <span></span>
                                </div>
                            </div>

                            <!-- Course card chuyển sang bên phải -->
                            <div class="course-card">
                                <img src="/img/subjectImg/${subject.subjectImage}" alt="Image not found"
                                    class="course-image" />
                            </div>
                        </div> <!-- Đóng course-list-container -->
                    </section>


                    <section class="course-details">
                        <h2>Số chương học</h2>
                        <p>${totalChapter} chương</p>

                        <h2>Lộ trình học</h2>
                        <div class="curriculum">
                            <c:forEach var="chapter" items="${chapters}">
                                <div class="curriculum-item">
                                    <div class="curriculum-item-header" onclick="toggleDescription(this)">
                                        <span class="curriculum-item-title">${chapter.chapterName}</span>
                                        <span class="curriculum-item-meta"></span>
                                    </div>
                                    <div class="curriculum-item-description" style="display: none;">
                                        <p>${chapter.chapterDescription}</p>

                                        <!-- Danh sách bài học -->
                                        <ul class="lesson-list">
                                            <c:forEach var="lesson" items="${chapter.lessons}">
                                                <div class="lesson-item">
                                                    📘 ${lesson.lessonName}
                                                </div>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                </div>
                            </c:forEach>
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
        <script>
            function toggleDescription(header) {
                const description = header.nextElementSibling;
                if (description.style.display === "none") {
                    description.style.display = "block";
                } else {
                    description.style.display = "none";
                }
            }
        </script>

        </html>