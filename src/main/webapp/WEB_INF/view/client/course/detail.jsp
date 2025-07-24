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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css"/>
    <!-- Toastify JS -->
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
</head>

<body>
<div class="detail-package">
    <!-- Header Section -->
    <jsp:include page="../layout/header.jsp"/>

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
                <img src="/img/package/${pkg.image}" alt="Course Image" class="course-image"/>
                <div class="price-section">
                                            <span class="current-price">
                                                <fmt:formatNumber value="${pkg.price}" type="number"
                                                                  groupingUsed="true"/>
                                                ₫
                                            </span>
                    <!-- <span class="original-price">$99</span>
            <span class="discount-badge">50% Off</span> -->
                </div>
                <form action="/parent/cart" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="packageId" value="${pkg.packageId}"/>
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
        <div id="review-content">
            <!-- Thêm tham số render=true để render trực tiếp -->
            <jsp:include page="/package/${pkg.packageId}/reviews?render=true"/>
        </div>
    </div>

</div>

<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

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