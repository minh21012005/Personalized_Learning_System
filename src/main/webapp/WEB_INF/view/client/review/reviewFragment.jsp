<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!-- Thêm Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
                    integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM"
                    crossorigin="anonymous">

                <style>
                    .review-card {
                        display: flex;
                        align-items: flex-start;
                        gap: 16px;
                        margin-bottom: 20px;
                        padding: 16px;
                        border: 1px solid #e0e0e0;
                        border-radius: 12px;
                        background-color: #ffffff;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                        transition: transform 0.2s ease;
                    }

                    .review-card:hover {
                        transform: translateY(-5px);
                    }

                    .review-avatar img {
                        width: 64px;
                        height: 64px;
                        border-radius: 50%;
                        object-fit: cover;
                        border: 2px solid #ddd;
                    }

                    .review-content {
                        flex: 1;
                    }

                    .useful-btn {
                        background-color: #4CAF50;
                        color: white;
                        border: none;
                        padding: 6px 12px;
                        cursor: pointer;
                        border-radius: 5px;
                        transition: background-color 0.3s ease;
                        font-size: 0.9rem;
                    }

                    .useful-btn.liked {
                        background-color: #ff4444;
                    }

                    .useful-btn:hover {
                        opacity: 0.9;
                    }

                    .toastify-custom {
                        position: relative;
                        top: -10px;
                        margin-bottom: 10px;
                    }

                    .section-title {
                        font-size: 1.5rem;
                        font-weight: 600;
                        margin-bottom: 15px;
                        color: #2c3e50;
                    }

                    .average-rating p {
                        font-size: 1.1rem;
                        margin-bottom: 0;
                        color: #7f8c8d;
                    }

                    .star {
                        font-size: 1.3rem;
                    }

                    .star.filled {
                        color: #f1c40f;
                    }

                    .form-control {
                        border-radius: 5px;
                        border-color: #ddd;
                        transition: border-color 0.3s ease;
                    }

                    .form-control:focus {
                        border-color: #007bff;
                        box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
                    }

                    .submit-review-btn {
                        background: linear-gradient(90deg, #007bff, #00c4cc);
                        color: white;
                        border: none;
                        padding: 8px 15px;
                        border-radius: 5px;
                        transition: opacity 0.3s ease;
                    }

                    .submit-review-btn:hover {
                        opacity: 0.9;
                    }

                    .review-form h3 {
                        font-size: 1.3rem;
                        margin-bottom: 15px;
                        color: #2c3e50;
                    }

                    .filter-sidebar {
                        padding: 20px;
                        background: linear-gradient(135deg, #ffffff, #f9fbfd);
                        border-right: 1px solid #e0e0e0;
                        border-radius: 8px;
                        height: auto;
                        min-height: 100%;
                        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
                    }

                    .btn-filter {
                        display: block;
                        width: 100%;
                        text-align: left;
                        padding: 10px 15px;
                        margin-bottom: 10px;
                        border: 1px solid #e0e0e0;
                        border-radius: 5px;
                        background: #ffffff;
                        transition: all 0.3s ease;
                        font-size: 1.1rem;
                        color: #34495e;
                    }

                    .btn-filter:hover {
                        background: #f1f1f1;
                        border-color: #007bff;
                        transform: translateX(5px);
                    }

                    .btn-filter.active {
                        background: linear-gradient(90deg, #007bff, #00c4cc);
                        color: white;
                        border-color: #007bff;
                        box-shadow: 0 2px 6px rgba(0, 123, 255, 0.3);
                    }

                    .btn-filter .star {
                        margin-right: 10px;
                    }

                    .filter-label {
                        font-weight: 500;
                        color: #2c3e50;
                        margin-bottom: 10px;
                        display: block;
                    }
                </style>

                <div class="reviews-section container mt-4" th:fragment="reviews-section">
                    <c:if test="${not empty message}">
                        <script>
                            document.addEventListener('DOMContentLoaded', function () {
                                Toastify({
                                    text: "<i class='fas fa-info-circle'></i> ${fn:escapeXml(message)}",
                                    duration: 4000,
                                    close: true,
                                    gravity: "top",
                                    position: "right",
                                    style: {
                                        background: "${not empty success || message.contains('thành công') ? 'linear-gradient(to right, #28a745, #34c759)' : 'linear-gradient(to right, #ffc107, #ffca2c)'}",
                                        borderRadius: "8px",
                                        boxShadow: "0 4px 12px rgba(0, 0, 0, 0.3)",
                                        fontFamily: "'Roboto', sans-serif",
                                        fontSize: "16px",
                                        padding: "12px 20px",
                                        display: "flex",
                                        alignItems: "center",
                                        gap: "10px"
                                    },
                                    className: "toastify-custom",
                                    escapeMarkup: false
                                }).showToast();
                            });
                        </script>
                    </c:if>

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
                        <!-- Filter Sidebar (Bên trái) -->
                        <div class="col-md-3 filter-sidebar">
                            <form action="/package/${pkg.packageId}/reviews?render=true" method="get" class="row g-3"
                                id="filterForm">

                                <!-- Loại bỏ packageId khỏi form vì đã có trong @PathVariable -->
                                <div class="col-12">
                                    <label class="filter-label">Lọc theo sao:</label>
                                    <div class="btn-group-vertical" role="group" aria-label="Filter by rating">
                                        <button type="button" name="rating" value="5"
                                            class="btn btn-filter ${selectedRating == 5 ? 'active' : ''}"><span
                                                class="star filled">★★★★★</span></button>
                                        <button type="button" name="rating" value="4"
                                            class="btn btn-filter ${selectedRating == 4 ? 'active' : ''}"><span
                                                class="star filled">★★★★☆</span></button>
                                        <button type="button" name="rating" value="3"
                                            class="btn btn-filter ${selectedRating == 3 ? 'active' : ''}"><span
                                                class="star filled">★★★☆☆</span></button>
                                        <button type="button" name="rating" value="2"
                                            class="btn btn-filter ${selectedRating == 2 ? 'active' : ''}"><span
                                                class="star filled">★★☆☆☆</span></button>
                                        <button type="button" name="rating" value="1"
                                            class="btn btn-filter ${selectedRating == 1 ? 'active' : ''}"><span
                                                class="star filled">★☆☆☆☆</span></button>
                                        <button type="button" name="rating" value=""
                                            class="btn btn-filter ${selectedRating == null ? 'active' : ''}">Tất
                                            cả</button>
                                    </div>
                                    <input type="hidden" name="rating" id="selectedRating" value="${selectedRating}" />
                                </div>
                                <div class="col-12 mt-3">
                                    <label class="filter-label">Nội dung bình luận:</label>
                                    <input type="text" id="commentInput" name="comment" value="${selectedComment}"
                                        class="form-control" placeholder="Nhập nội dung..." />
                                </div>
                                <div class="col-12 mt-3">
                                    <button type="submit" class="btn btn-filter w-100"
                                        style="background: linear-gradient(90deg, #2ecc71, #27ae60); color: white; font-weight: 500;">Lọc</button>
                                </div>
                            </form>
                        </div>

                        <!-- Danh sách đánh giá (Bên phải) -->
                        <div class="col-md-9">
                            <div class="review-list">
                                <c:if test="${empty packageReviews}">
                                    <p>Không tìm thấy đánh giá nào với bộ lọc hiện tại!</p>
                                </c:if>
                                <c:forEach var="review" items="${packageReviews}">
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
                                                        style="max-height: 250px; display: block" />
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
                                            <p>${not empty review.comment ? review.comment : 'Chưa có bình luận'}</p>
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
                                        <c:if test="${canReview}">
                                            <form id="useful-form-${review.reviewId}"
                                                action="/package/${pkg.packageId}/review/${review.reviewId}/useful"
                                                method="post" style="display:inline;">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <input type="hidden" name="userId" value="${currentUserId}" />
                                                <button type="submit"
                                                    class="useful-btn ${review.usefulCount > 0 ? 'liked' : ''}">
                                                    Hữu ích (${review.usefulCount})
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                            <c:if test="${canReview}">
                                <c:choose>
                                    <c:when test="${not empty reviewStatusMessage}">
                                        <p style="color: #e67e22;">${reviewStatusMessage}</p>
                                        <div class="review-form disabled-form" style="display: none;">
                                            <h3>Viết đánh giá của bạn</h3>
                                            <form action="/package/${pkg.packageId}/review" method="post"
                                                modelAttribute="newReview" commandName="newReview" class="row g-3">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <div class="col-md-6">
                                                    <label for="rating" class="form-label">Số sao:</label>
                                                    <select name="rating" id="rating" class="form-select" required>
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                        <option value="5">5</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="comment" class="form-label">Bình luận:</label>
                                                    <textarea name="comment" id="comment" class="form-control" rows="4"
                                                        maxlength="500" placeholder="Nhập bình luận của bạn..."
                                                        required></textarea>
                                                </div>
                                                <div class="col-12">
                                                    <button type="submit" class="submit-review-btn" disabled>Gửi đánh
                                                        giá</button>
                                                </div>
                                            </form>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="review-form">
                                            <h3>Viết đánh giá của bạn</h3>
                                            <form action="/package/${pkg.packageId}/review" method="post"
                                                modelAttribute="newReview" commandName="newReview" class="row g-3">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <div class="col-md-6">
                                                    <label for="rating" class="form-label">Số sao:</label>
                                                    <select name="rating" id="rating" class="form-select" required>
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                        <option value="5">5</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="comment" class="form-label">Bình luận:</label>
                                                    <textarea name="comment" id="comment" class="form-control" rows="4"
                                                        maxlength="500" placeholder="Nhập bình luận của bạn..."
                                                        required></textarea>
                                                </div>
                                                <div class="col-12">
                                                    <button type="submit" class="submit-review-btn">Gửi đánh
                                                        giá</button>
                                                </div>
                                            </form>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </div>
                    </div>
                </div>

                <!-- Thêm Bootstrap JS và các CDN khác -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
                    integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz"
                    crossorigin="anonymous"></script>
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
                                // Xóa active khỏi tất cả button
                                buttons.forEach(btn => btn.classList.remove('active'));
                                // Đặt active cho button được chọn
                                this.classList.add('active');

                                // Cập nhật hidden input dựa trên button được chọn và submit form
                                selectedRating.value = this.value === '' ? null : this.value;
                                filterForm.submit(); // Tự động submit form khi chọn sao
                            });
                        });

                        // Submit form khi nhấn Enter trong ô comment
                        const commentInput = document.getElementById('commentInput');
                        commentInput.addEventListener('keypress', function (event) {
                            if (event.key === 'Enter') {
                                filterForm.submit();
                            }
                        });
                    });
                </script>