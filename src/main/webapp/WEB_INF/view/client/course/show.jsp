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
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
    <link rel="stylesheet" href="/css/listpackage.css">
    <script src="https://unpkg.com/lucide@latest"></script>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
    <!-- Choices.js CSS -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css"/>
    <!-- Choices.js JS -->
    <script
            src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
    <!-- Toastify CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css"/>
    <!-- Toastify JS -->
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
    <!-- Custom JS -->
    <script src="/js/script.js"></script>
</head>

<body>
<jsp:include page="../layout/header.jsp"/>

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
                              d="M4 6h16M6 12h12M10 18h4"/>
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
                        <img src="/img/package/${pkg.image}" alt="Course Image"
                             class="course-img">
                        <a href="/parent/course/detail/${pkg.packageId}">
                            <h3 class="course-title">${pkg.name}</h3>
                        </a>
                        <c:choose>
                            <c:when test="${pkg.packageType == 'FULL_COURSE'}">
                                <p class="course-author">Loại: Học và luyện tập</p>
                            </c:when>
                            <c:when test="${pkg.packageType == 'PRACTICE_ONLY'}">
                                <p class="course-author">Loại: Chỉ luyện tập</p>
                            </c:when>
                        </c:choose>
                        <p class="course-author">
                            Thời hạn gói: ${pkg.durationDays} ngày
                        </p>
                        <p class="course-author">
                            <c:choose>
                                <c:when test="${pkg.averageRating > 0}">
                                    Đánh giá:
                                    <fmt:formatNumber value="${pkg.averageRating}" type="number"
                                                      maxFractionDigits="1"/>
                                    <i class="fa fa-star text-warning"></i>
                                </c:when>
                                <c:otherwise>
                                    Chưa có đánh giá nào
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <div class="mt-auto course-bottom">
                                                    <span class="course-price">
                                                        <fmt:formatNumber value="${pkg.price}" type="number"
                                                                          groupingUsed="true"/> ₫
                                                    </span>
                            <form action="/parent/cart" method="post">
                                <input type="hidden" name="${_csrf.parameterName}"
                                       value="${_csrf.token}"/>
                                <input type="hidden" name="packageId"
                                       value="${pkg.packageId}"/>
                                <button type="submit" class="add-to-cart-btn mt-2">
                                    Thêm vào giỏ hàng
                                    <img width="18" height="18"
                                         src="https://img.icons8.com/material-outlined/24/FFFFFF/fast-cart.png"
                                         alt="fast-cart"/>
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    <div class="pagination-container">
        <c:set var="queryString" value=""/>
        <c:if test="${not empty grades}">
            <c:set var="queryString" value="${queryString}&grades=${grades}"/>
        </c:if>
        <c:if test="${not empty subjects}">
            <c:set var="queryString" value="${queryString}&subjects=${subjects}"/>
        </c:if>
        <c:if test="${not empty sort}">
            <c:set var="queryString" value="${queryString}&sort=${sort}"/>
        </c:if>
        <c:if test="${not empty paramName}">
            <c:set var="queryString" value="${queryString}&course=${paramName}"/>
        </c:if>

        <c:if test="${totalPage > 1}">
            <nav aria-label="Page navigation example">
                <ul class="pagination justify-content-center">

                    <!-- First Page -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="/parent/course?page=1${queryString}"
                           aria-label="First">
                            <span aria-hidden="true">««</span>
                        </a>
                    </li>

                    <!-- Previous Page -->
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="/parent/course?page=${currentPage - 1}${queryString}"
                           aria-label="Previous">
                            <span aria-hidden="true">«</span>
                        </a>
                    </li>

                    <!-- Page Numbers (current page ± 2) -->
                    <c:set var="startPage" value="${currentPage - 2}"/>
                    <c:set var="endPage" value="${currentPage + 2}"/>
                    <c:if test="${startPage < 1}">
                        <c:set var="startPage" value="1"/>
                        <c:set var="endPage" value="${startPage + 4}"/>
                    </c:if>
                    <c:if test="${endPage > totalPage}">
                        <c:set var="endPage" value="${totalPage}"/>
                        <c:set var="startPage" value="${endPage - 4 > 0 ? endPage - 4 : 1}"/>
                    </c:if>

                    <c:forEach begin="${startPage}" end="${endPage}" varStatus="loop">
                        <li class="page-item ${loop.index == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="/parent/course?page=${loop.index}${queryString}">${loop.index}</a>
                        </li>
                    </c:forEach>

                    <!-- Next Page -->
                    <li class="page-item ${currentPage == totalPage ? 'disabled' : ''}">
                        <a class="page-link"
                           href="/parent/course?page=${currentPage + 1}${queryString}"
                           aria-label="Next">
                            <span aria-hidden="true">»</span>
                        </a>
                    </li>

                    <!-- Last Page -->
                    <li class="page-item ${currentPage == totalPage ? 'disabled' : ''}">
                        <a class="page-link"
                           href="/parent/course?page=${totalPage}${queryString}"
                           aria-label="Last">
                            <span aria-hidden="true">»»</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>

</main>
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>
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
</body>
<script>
    lucide.createIcons();
</script>

</html>