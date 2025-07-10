<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!-- Thêm Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
                    integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM"
                    crossorigin="anonymous">

                <style>
                      .reviews-section{
                        margin-bottom: 50px;
                    }
                    /* Ghi đè style của btn-outline-success */
.btn-outline-success {
    border-color: white !important; /* Viền trắng */
    color: #6c757d !important; /* Màu biểu tượng kính lúp (xám để nổi trên nền trắng) */
    background-color: white !important; /* Nền trắng, thay thế inline style */
}
.btn-outline-success:hover {
    background-color: #f8f9fa !important; /* Nền xám nhạt khi hover */
    border-color: white !important; /* Giữ viền trắng khi hover */
    color: #6c757d !important;
}
.btn-outline-success:focus, .btn-outline-success.focus {
    box-shadow: 0 0 0 0.2rem rgba(255, 255, 255, 0.5) !important; /* Hiệu ứng focus trắng nhẹ */
}
                   .review-card {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    margin-bottom: 14px;
    padding: 10px;
    border: 1px solid #e0e0e0;
    border-radius: 6px;
    background-color: #ffffff;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
    transition: transform 0.2s ease;
}
.review-card:hover {
    transform: translateY(-2px);
}
.review-avatar img {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    object-fit: cover;
    border: 1px solid #ddd;
}
.review-content {
    flex: 1;
     margin-left: 10px;
}
.review-content h4 {
    font-size: 0.95rem;
    margin-bottom: 3px;
    color: #2c3e50;
}
.useful-btn {
    background-color: #4CAF50;
    color: white;
    border: none;
    padding: 4px 8px;
    cursor: pointer;
    border-radius: 3px;
    transition: background-color 0.3s ease;
    font-size: 0.8rem;
}
.useful-btn.liked {
    background-color: #ff4444;
}
.useful-btn:hover {
    opacity: 0.9;
}
.toastify-custom {
    position: relative;
    top: -8px;
    margin-bottom: 8px;
}
.section-title {
    font-size: 1.3rem;
    font-weight: 600;
    margin-bottom: 10px;
    color: #2c3e50;
}
.average-rating p {
    font-size: 0.95rem;
    margin-bottom: 10px;
    color: #7f8c8d;
}
.star {
    font-size: 1.1rem;
}
.star.filled {
    color: #f1c40f;
}
.form-control {
    border-radius: 3px;
    border-color: #ddd;
    transition: border-color 0.3s ease;
}
.form-control:focus {
    border-color: #007bff;
    box-shadow: 0 0 4px rgba(0, 123, 255, 0.3);
}
.submit-review-btn {
    background: linear-gradient(90deg, rgba(0, 0, 0, 0.669), rgba(0, 0, 0, 0.669));
    color: white;
    border: none;
    padding: 6px 12px;
    border-radius: 4px;
    transition: opacity 0.3s ease;
    margin-top: 12px;
}
.submit-review-btn:hover {
    opacity: 0.9;
}
.review-form h3 {
    font-size: 1.1rem;
    margin-bottom: 10px;
    color: #2c3e50;
}
.filter-sidebar {
    padding: 12px;
    background: linear-gradient(135deg, #ffffff, #f9fbfd);
    border-right: 1px solid #e0e0e0;
    border-radius: 5px;
    height: auto;
    min-height: 100%;
    box-shadow: 1px 0 6px rgba(0, 0, 0, 0.05);
}
.btn-filter {
    display: block;
    width: 100%;
    text-align: left;
    padding: 6px 10px;
    margin-bottom: 5px;
    border: 1px solid #e0e0e0;
    border-radius: 3px;
    background: #ffffff;
    transition: all 0.2s ease;
    font-size: 0.9rem;
    color: #34495e;
}
.btn-filter:hover {
    background: #f1f1f1;
    border-color: #007bff;
    transform: translateX(2px);
}
.btn-filter.active {
    background: linear-gradient(90deg, rgb(233, 234, 236), rgb(233, 234, 236));
    color: black;
    border-color: rgb(233, 234, 236);
    box-shadow: 0 1px 3px rgb(233, 234, 236);
}
.btn-filter .star {
    margin-right: 6px;
}
.filter-label {
    font-weight: 500;
    color: #2c3e50;
    margin-bottom: 5px;
    display: block;
}
                </style>

                <div class="reviews-section container mt-4">


                    <h2 class="section-title">Đánh giá từ học viên (${reviewCount})</h2>
                    <div class="average-rating">
                        <p>Đánh giá trung bình:
                            <c:forEach begin="1" end="${averageRating.intValue()}">
                                <span class="star filled">★</span>
                            </c:forEach>
                            <c:forEach begin="${averageRating.intValue() + 1}" end="5">
                                <span class="star">☆</span>
                            </c:forEach>
                            (${reviewCount} đánh giá)
                        </p>
                    </div>

                    <div class="row">
                        <!-- Filter Sidebar -->
                        <div class="col-md-3 filter-sidebar">
                            <form action="/subject/${subject.subjectId}/reviews?render=true" method="get"
                                class="row g-3" id="filterForm">
                                <div class="col-12">
                                    <label class="filter-label">Lọc theo sao:</label>
                                    <div class="btn-group-vertical" role="group" aria-label="Filter by rating">
                                        <button type="button" name="rating" value="5"
                                            class="btn btn-filter ${selectedRating == 5 ? 'active' : ''}">
                                            <span class="star filled">★★★★★</span>
                                        </button>
                                        <button type="button" name="rating" value="4"
                                            class="btn btn-filter ${selectedRating == 4 ? 'active' : ''}">
                                            <span class="star filled">★★★★☆</span>
                                        </button>
                                        <button type="button" name="rating" value="3"
                                            class="btn btn-filter ${selectedRating == 3 ? 'active' : ''}">
                                            <span class="star filled">★★★☆☆</span>
                                        </button>
                                        <button type="button" name="rating" value="2"
                                            class="btn btn-filter ${selectedRating == 2 ? 'active' : ''}">
                                            <span class="star filled">★★☆☆☆</span>
                                        </button>
                                        <button type="button" name="rating" value="1"
                                            class="btn btn-filter ${selectedRating == 1 ? 'active' : ''}">
                                            <span class="star filled">★☆☆☆☆</span>
                                        </button>
                                        <button type="button" name="rating" value=""
                                            class="btn btn-filter ${selectedRating == null ? 'active' : ''}">Tất
                                            cả</button>
                                    </div>
                                    <input type="hidden" name="rating" id="selectedRating" value="${selectedRating}" />
                                </div>
                                <div class="col-12 mt-3">
                                    <label for="commentInput">Nội dung đánh giá:</label>
                                    <div class="d-flex align-items-center">
                                        <input type="text" id="commentInput" name="comment" value="${selectedComment}"
                                            class="form-control me-2" placeholder="Nhập nội dung..." />
                                        <button type="submit" class="btn btn-outline-success px-3 py-2"
                                            style="background-color: white;">
                                            <i class="fas fa-magnifying-glass"></i>
                                        </button>
                                    </div>
                                </div>

                            </form>
                        </div>

                        <!-- Danh sách đánh giá -->
                        <div class="col-md-9">
                            <div class="review-list">
                                <c:if test="${empty subjectReviews}">
                                    <p>Không tìm thấy đánh giá nào với bộ lọc hiện tại!</p>
                                </c:if>
                                <c:forEach var="review" items="${subjectReviews}">
                                    <div class="review-card">
                                        <div class="review-avatar">
                                            <c:choose>
                                                <c:when test="${not empty review.user.avatar}">
                                                    <img src="/img/avatar/${review.user.avatar}"
                                                        alt="${not empty review.user.fullName ? review.user.fullName : 'Người dùng ẩn danh'}"
                                                        style="max-height: 250px; display: block"
                                                        onerror="this.src='/img/default-avatar.png'" />
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="/img/default-avatar.png" alt="Người dùng ẩn danh"
                                                        style="max-height: 250px; display: block;" />
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="review-content">
                                            <h4>${not empty review.user.fullName ? review.user.fullName : 'Người dùng ẩn
                                                danh'}</h4>
                                            <div class="rating">
                                                <c:forEach begin="1" end="${review.rating}">
                                                    <span class="star filled">★</span>
                                                </c:forEach>
                                                <c:forEach begin="${review.rating + 1}" end="5">
                                                    <span class="star">☆</span>
                                                </c:forEach>
                                            </div>
                                            <p>${not empty review.comment ? review.comment : 'Chưa có đánh giá'}</p>
                                            <small>Đăng ngày:
                                                <c:choose>
                                                    <c:when test="${review.createdAt != null}">
                                                        <fmt:formatDate value="${review.getCreatedAtAsUtilDate()}"
                                                            pattern="dd/MM/yyyy" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </small>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                     
                        </div>
                    </div>
                </div>

                <!-- Thêm Bootstrap JS và các CDN khác -->
              
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" />
                <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const buttons = document.querySelectorAll('.btn-filter');
                        const selectedRating = document.getElementById('selectedRating');
                        const filterForm = document.getElementById('filterForm');

                        buttons.forEach(button => {
                            button.addEventListener('click', function () {
                                buttons.forEach(btn => btn.classList.remove('active'));
                                this.classList.add('active');
                                selectedRating.value = this.value === '' ? null : this.value;
                                filterForm.submit();
                            });
                        });

                        const commentInput = document.getElementById('commentInput');
                        commentInput.addEventListener('keypress', function (event) {
                            if (event.key === 'Enter') {
                                filterForm.submit();
                            }
                        });
                    });
                </script>