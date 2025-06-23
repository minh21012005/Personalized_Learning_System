<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <style>
                    .review-card {
                        display: flex;
                        align-items: flex-start;
                        gap: 16px;
                        margin-bottom: 20px;
                        padding: 16px;
                        border: 1px solid #ddd;
                        border-radius: 12px;
                        background-color: #fff;
                    }

                    .review-avatar img {
                        width: 64px;
                        height: 64px;
                        border-radius: 50%;
                        object-fit: cover;
                        border: 2px solid #ccc;
                    }

                    .review-content {
                        flex: 1;
                    }

                    .useful-btn {
                        background-color: #4CAF50;
                        color: white;
                        border: none;
                        padding: 5px 10px;
                        cursor: pointer;
                        border-radius: 5px;
                    }

                    .toastify-custom {
                        position: relative;
                        top: -10px;
                        margin-bottom: 10px;
                    }

                    .filter-section {
                        margin-bottom: 20px;
                    }

                    .disabled-form {
                        opacity: 0.6;
                        pointer-events: none;
                    }
                </style>

                <div class="reviews-section">
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
                                        background: "linear-gradient(to right, #28a745, #34c759)",
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
                                        background: "linear-gradient(to right, #ffc107, #ffca2c)",
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
                    <div class="filter-section">
                        <form action="/package/${pkg.packageId}/reviews" method="get">
                            <input type="hidden" name="packageId" value="${pkg.packageId}" />
                            <div>
                                <label for="comment">Nội dung bình luận:</label>
                                <input type="text" id="comment" name="comment" value="${selectedComment}"
                                    placeholder="Nhập nội dung..." />
                            </div>
                            <div>
                                <label for="rating">Số sao:</label>
                                <select id="rating" name="rating">
                                    <option value="">Tất cả</option>
                                    <option value="1" ${selectedRating==1 ? 'selected' : '' }>1</option>
                                    <option value="2" ${selectedRating==2 ? 'selected' : '' }>2</option>
                                    <option value="3" ${selectedRating==3 ? 'selected' : '' }>3</option>
                                    <option value="4" ${selectedRating==4 ? 'selected' : '' }>4</option>
                                    <option value="5" ${selectedRating==5 ? 'selected' : '' }>5</option>
                                </select>
                            </div>
                            <button type="submit">Lọc</button>
                        </form>
                    </div>
                    <div class="review-list">
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
                                    <h4>${not empty review.user.fullName ? review.user.fullName : 'Người dùng ẩn danh'}
                                    </h4>
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
                                    <form action="/package/${pkg.packageId}/review/${review.reviewId}/useful"
                                        method="post" style="display:inline;">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="useful-btn">Hữu ích
                                            (${review.usefulCount})</button>
                                    </form>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                    <c:if test="${canReview}">
                        <c:choose>
                            <c:when test="${not empty reviewStatusMessage}">
                                <p style="color: orange;">${reviewStatusMessage}</p>
                                <!-- Ẩn form khi có reviewStatusMessage (PENDING hoặc APPROVED) -->
                                <div class="review-form disabled-form" style="display: none;">
                                    <h3>Viết đánh giá của bạn</h3>
                                    <form action="/package/${pkg.packageId}/review" method="post"
                                        modelAttribute="newReview" commandName="newReview">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
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
                                        <button type="submit" class="submit-review-btn" disabled>Gửi đánh giá</button>
                                    </form>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="review-form">
                                    <h3>Viết đánh giá của bạn</h3>
                                    <form action="/package/${pkg.packageId}/review" method="post"
                                        modelAttribute="newReview" commandName="newReview">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
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

                <!-- Thêm Toastify và Font Awesome CDN -->
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" />
                <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />