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
                        background: linear-gradient(90deg, rgba(2, 6, 23, 1), rgba(2, 6, 23, 1));
                        color: white;
                        border: none;
                        padding: 8px 15px;
                        border-radius: 5px;
                        transition: opacity 0.3s ease;
                        margin-top: 20px;
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
                        background: linear-gradient(90deg, rgb(233, 234, 236), rgb(233, 234, 236));
                        color: black;
                        border-color: rgb(233, 234, 236);
                        box-shadow: 0 2px 6px rgb(233, 234, 236);
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
                                    <div class="d-flex align-items-center">
                                        <input type="text" id="commentInput" name="comment" value="${selectedComment}"
                                            class="form-control me-2" placeholder="Nhập nội dung..." />
                                        <button type="submit" class="btn btn-outline-secondary px-3 py-2"
                                            style="background-color: white;">
                                            🔍
                                        </button>
                                    </div>
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

                                    </div>
                                </c:forEach>
                            </div>
                            <c:if test="${canReview}">
                                <c:choose>
                                    <c:when test="${not empty reviewStatusMessage}">
                                        <p style="color: orange;">${reviewStatusMessage}</p>
                                        <!-- SỬA: Hiển thị form khi trạng thái là REJECTED -->
                                        <c:if test="${latestReviewStatus == 'REJECTED'}">
                                            <div class="review-form">
                                                <h3>Gửi lại đánh giá của bạn</h3>
                                                <form action="/package/${pkg.packageId}/review" method="post"
                                                    modelAttribute="newReview" commandName="newReview">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                    <!-- SỬA: Giữ input subjectId -->
                                                    <c:if test="${not empty subjectId}">
                                                        <input type="hidden" name="subjectId" value="${subjectId}" />
                                                    </c:if>
                                                    <div class="form-group">
                                                        <label for="rating">Số sao:</label>
                                                        <select name="rating" id="rating" class="form-control" required>
                                                            <option value="1">1</option>
                                                            <option value="2">2</option>
                                                            <option value="3">3</option>
                                                            <option value="4">4</option>
                                                            <option value="5">5</option>
                                                        </select>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="comment">Bình luận:</label>
                                                        <textarea name="comment" id="comment" class="form-control"
                                                            rows="4" maxlength="500"
                                                            placeholder="Nhập bình luận của bạn..." required></textarea>
                                                    </div>
                                                    <button type="submit" class="submit-review-btn">Gửi lại đánh
                                                        giá</button>
                                                </form>
                                            </div>
                                        </c:if>
                                        <!-- SỬA: Ẩn form khi trạng thái là APPROVED hoặc PENDING -->
                                        <c:if
                                            test="${latestReviewStatus == 'APPROVED' || latestReviewStatus == 'PENDING'}">
                                            <div class="review-form disabled-form" style="display: none;">
                                                <h3>Viết đánh giá của bạn</h3>
                                                <form action="/package/${pkg.packageId}/review" method="post"
                                                    modelAttribute="newReview" commandName="newReview">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                    <c:if test="${not empty subjectId}">
                                                        <input type="hidden" name="subjectId" value="${subjectId}" />
                                                    </c:if>
                                                    <div class="form-group">
                                                        <label for="rating">Số sao:</label>
                                                        <select name="rating" id="rating" class="form-control" required>
                                                            <option value="1">1</option>
                                                            <option value="2">2</option>
                                                            <option value="3">3</option>
                                                            <option value="4">4</option>
                                                            <option value="5">5</option>
                                                        </select>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="comment">Bình luận:</label>
                                                        <textarea name="comment" id="comment" class="form-control"
                                                            rows="4" maxlength="500"
                                                            placeholder="Nhập bình luận của bạn..." required></textarea>
                                                    </div>
                                                    <button type="submit" class="submit-review-btn" disabled>Gửi đánh
                                                        giá</button>
                                                </form>
                                            </div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="review-form">
                                            <h3>Viết đánh giá của bạn</h3>
                                            <form action="/package/${pkg.packageId}/review" method="post"
                                                modelAttribute="newReview" commandName="newReview">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <c:if test="${not empty subjectId}">
                                                    <input type="hidden" name="subjectId" value="${subjectId}" />
                                                </c:if>
                                                <div class="form-group">
                                                    <label for="rating">Số sao:</label>
                                                    <select name="rating" id="rating" class="form-control" required>
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                        <option value="5">5</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="comment">Bình luận:</label>
                                                    <textarea name="comment" id="comment" class="form-control" rows="4"
                                                        maxlength="500" placeholder="Nhập bình luận của bạn..."
                                                        required></textarea>
                                                </div>
                                                <button type="submit" class="submit-review-btn">Gửi đánh giá</button>
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