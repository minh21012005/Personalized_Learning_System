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
        gap: 8px; /* Giảm khoảng cách */
        margin-bottom: 12px; /* Giảm margin dưới */
        padding: 8px; /* Giảm padding */
        border: 1px solid #e0e0e0;
        border-radius: 6px; /* Giảm bo góc */
        background-color: #ffffff;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05); /* Giảm bóng */
        transition: transform 0.2s ease;
    }

    .review-card:hover {
        transform: translateY(-3px); /* Giảm hiệu ứng hover */
    }

    .review-avatar img {
        width: 32px; /* Thu nhỏ avatar */
        height: 32px;
        border-radius: 50%;
        object-fit: cover;
        border: 1px solid #ddd; /* Giảm viền */
    }

    .review-content {
        flex: 1;
        margin-left: 50px;
    }

    .review-content h4 {
        font-size: 0.9rem; /* Thu nhỏ tên người dùng */
        margin-bottom: 5px; /* Giảm margin dưới */
    }

    .toastify-custom {
        position: relative;
        top: -5px; /* Giảm khoảng cách top */
        margin-bottom: 5px; /* Giảm margin dưới */
    }

    .section-title {
        font-size: 1.2rem; /* Thu nhỏ tiêu đề */
        font-weight: 600;
        margin-bottom: 10px; /* Giảm margin dưới */
        color: #2c3e50;
    }

    .average-rating p {
        font-size: 0.9rem; /* Thu nhỏ font */
        margin-bottom: 10px;
        color: #7f8c8d;
    }

    .star {
        font-size: 0.9rem; /* Thu nhỏ sao */
    }

    .star.filled {
        color: #f1c40f;
    }

    .form-control {
        border-radius: 4px; /* Giảm bo góc */
        border-color: #ddd;
        transition: border-color 0.3s ease;
        padding: 4px; /* Giảm padding */
        font-size: 0.8rem; /* Thu nhỏ font */
        max-width: 180px; /* Tăng chiều rộng để hiển thị placeholder */
    }

    .form-control:focus {
        border-color: #007bff;
        box-shadow: 0 0 3px rgba(0, 123, 255, 0.2); /* Giảm bóng */
    }

    .submit-review-btn {
        background: linear-gradient(90deg, rgba(2, 6, 23, 1), rgba(2, 6, 23, 1));
        color: white;
        border: none;
        padding: 4px 10px; /* Giảm padding */
        border-radius: 4px;
        transition: opacity 0.3s ease;
        margin-top: 10px; /* Giảm margin trên */
    }

    .submit-review-btn:hover {
        opacity: 0.9;
    }

    .review-form h3 {
        font-size: 1.1rem; /* Thu nhỏ tiêu đề form */
        margin-bottom: 10px; /* Giảm margin dưới */
        color: #2c3e50;
    }

    .filter-sidebar {
        padding: 10px; /* Giảm padding */
        background: linear-gradient(135deg, #ffffff, #f9fbfd);
        border-right: 1px solid #e0e0e0;
        border-radius: 6px; /* Giảm bo góc */
        height: auto;
        min-height: 100%;
        box-shadow: 1px 0 5px rgba(0, 0, 0, 0.03); /* Giảm bóng */
        max-width: 180px; /* Tăng chiều rộng từ 120px lên 180px */
        min-height: 200px; /* Giảm độ dài */
    }

    .btn-filter {
        display: block;
        width: 100%;
        text-align: left;
        padding: 6px 8px; /* Giảm padding */
        margin-bottom: 4px; /* Giảm margin dưới */
        border: 1px solid #e0e0e0;
        border-radius: 4px; /* Giảm bo góc */
        background: #ffffff;
        transition: all 0.3s ease;
        font-size: 0.9rem; /* Thu nhỏ font */
        color: #34495e;
    }

    .btn-filter:hover {
        background: #f1f1f1;
        border-color: #007bff;
        transform: translateX(2px); /* Giảm hiệu ứng hover */
    }

    .btn-filter.active {
        background: linear-gradient(90deg, rgb(233, 234, 236), rgb(233, 234, 236));
        color: black;
        border-color: rgb(233, 234, 236);
        box-shadow: 0 1px 3px rgb(233, 234, 236); /* Giảm bóng */
    }

    .btn-filter .star {
        margin-right: 5px; /* Giảm khoảng cách giữa sao và text */
        font-size: 0.9rem; /* Thu nhỏ sao trong filter */
    }

    .filter-label {
        font-weight: 500;
        color: #2c3e50;
        margin-bottom: 6px; /* Giảm margin dưới */
        display: block;
        font-size: 0.9rem; /* Thu nhỏ font */
    }

    .btn-outline-secondary {
        background-color: #e9ecef; /* Màu xám nhạt */
        border: none; /* Loại bỏ viền */
        padding: 2px 6px; /* Giảm padding */
        font-size: 0.8rem; /* Thu nhỏ font */
    }

    .btn-outline-secondary:hover {
        background-color: #dee2e6; /* Màu xám nhạt hơn khi hover */
    }

    /* Responsive */
    @media (max-width: 768px) {
        .review-card {
            gap: 6px; /* Giảm khoảng cách thêm */
            margin-bottom: 8px; /* Giảm margin */
            padding: 6px; /* Giảm padding */
        }

        .review-avatar img {
            width: 24px; /* Thu nhỏ avatar thêm */
            height: 24px;
        }

        .section-title {
            font-size: 1.1rem; /* Thu nhỏ thêm */
        }

        .average-rating p {
            font-size: 0.8rem; /* Thu nhỏ thêm */
        }

        .star {
            font-size: 0.8rem; /* Thu nhỏ sao thêm */
        }

        .filter-sidebar {
            max-width: 150px; /* Tăng chiều rộng trên mobile từ 100px lên 150px */
            min-height: 180px; /* Giảm độ dài thêm */
        }

        .btn-filter {
            padding: 4px 6px; /* Giảm padding thêm */
            font-size: 0.8rem; /* Thu nhỏ font thêm */
        }

        .btn-outline-secondary {
            padding: 2px 4px; /* Giảm padding thêm */
        }
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
                                    <label class="filter-label">Nội dung đánh giá:</label>
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
                            <c:if test="${canReview}">
                                <c:choose>
                                    <c:when test="${not empty reviewStatusMessage}">
                                        <p style="color: orange;">${reviewStatusMessage}</p>
                                      
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
                                                    <label for="comment">Đánh giá:</label>
                                                    <textarea name="comment" id="comment" class="form-control" rows="4"
                                                        maxlength="500" placeholder="Nhập đánh giá của bạn..."
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