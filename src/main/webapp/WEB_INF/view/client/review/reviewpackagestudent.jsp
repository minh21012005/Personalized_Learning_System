<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


                <!-- Thêm Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
                    integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM"
                    crossorigin="anonymous">


                <style>
                     .star-rating {
        direction: rtl;
        display: inline-flex;
        font-size: 1rem;
        unicode-bidi: bidi-override;
    }

    .star-rating input[type="radio"] {
        display: none;
    }

    .star-rating label {
        color: #ccc;
        cursor: pointer;
    }

    .star-rating label:hover,
    .star-rating label:hover ~ label {
        color: gold;
    }

    .star-rating input[type="radio"]:checked ~ label {
        color: gold;
    }
                    
            /* Phần review-content */
#review-content {
    max-width: 650px;
    margin: 10px auto;
    padding: 10px;
    background-color: #f9f9f9;
    border-radius: 5px;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
     margin-left: 10px;
}


#review-content h2 {
    font-size: 1.2rem;
    margin-bottom: 10px;
    color: #333;
}


#review-content .review-item {
    padding: 6px;
    border-bottom: 1px solid #e5e5e5;
    margin-bottom: 6px;
}


#review-content .review-item:last-child {
    border-bottom: none;
}


#review-content .review-author {
    font-size: 0.75rem; /* Giảm kích thước chữ tên người dùng */
    font-weight: 500;
    color: #555;
}


#review-content .review-text {
    font-size: 0.75rem;
    line-height: 1.2;
    color: #666;
    margin: 3px 0;
}


#review-content .review-rating {
    font-size: 0.7rem;
    color: #f39c12;
    margin-top: 3px;
}


#review-content .review-date {
    font-size: 0.65rem;
    color: #999;
    margin-top: 3px;
}


/* Review card */
.review-card {
    display: flex;
    align-items: flex-start;
    gap: 10px; /* Giảm khoảng cách */
    margin-bottom: 12px; /* Giảm margin dưới */
    padding: 10px; /* Giảm padding để thu gọn ô bình luận */
    border: 1px solid #e5e5e5;
    border-radius: 6px; /* Giảm bo góc */
    background-color: #ffffff;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.06); /* Giảm bóng */
    transition: transform 0.2s ease;
}


.review-card:hover {
    transform: translateY(-3px);
}


.review-avatar img {
    width: 40px; /* Giảm kích thước avatar */
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    border: 1px solid #ddd;
}


.review-content {
    flex: 1;
}


/* Các lớp khác */
.section-title {
    font-size: 1.3rem;
    font-weight: 600;
    margin-bottom: 12px;
    color: #2c3e50;
}


.average-rating p {
    font-size: 1rem;
    margin-bottom: 10px;
    color: #7f8c8d;
}


.star {
    font-size: 0.9rem;
    border: none;
    text-align: center;
}


.star.filled {
    color: #f1c40f;
}


.form-control {
    border-radius: 4px;
    border-color: #ddd;
    transition: border-color 0.3s ease;
    padding: 6px;
    font-size: 0.8rem;
    max-width: 200px;
}


.form-control:focus {
    border-color: #007bff;
    box-shadow: 0 0 4px rgba(0, 123, 255, 0.3);
}


.submit-review-btn {
    background: linear-gradient(90deg, rgba(2, 6, 23, 1), rgba(2, 6, 23, 1));
    color: white;
    border: none;
    padding: 6px 12px;
    border-radius: 4px;
    transition: opacity 0.3s ease;
    margin-top: 15px;
}


.submit-review-btn:hover {
    opacity: 0.9;
}


.review-form h3 {
    font-size: 1.2rem;
    margin-bottom: 12px;
    color: #2c3e50;
}


.filter-sidebar {
    padding: 12px;
    background: linear-gradient(135deg, #ffffff, #f9fbfd);
    border-right: 1px solid #e0e0e0;
    border-radius: 6px;
    height: auto;
    min-height: 100%;
    box-shadow: 1px 0 8px rgba(0, 0, 0, 0.04);
    max-width: 200px;
}


.btn-filter {
    padding: 6px 10px;
    margin-bottom: 8px;
    border: 1px solid #e0e0e0;
    border-radius: 4px;
    background: #ffffff;
    transition: all 0.3s ease;
    font-size: 0.9rem;
    color: #34495e;
}


.btn-filter:hover {
    background: #f1f1f1;
    border-color: #007bff;
    transform: translateX(3px);
}


.btn-filter.active {
    background: linear-gradient(90deg, rgb(233, 234, 236), rgb(233, 234, 236));
    color: black;
    border-color: rgb(233, 234, 236);
    box-shadow: 0 2px 4px rgb(233, 234, 236);
}


.btn-filter .star {
    margin-right: 8px;
    font-size: 0.9rem;
    border: none;
}


.filter-label {
    font-weight: 500;
    color: #2c3e50;
    margin-bottom: 8px;
    display: block;
}


/* Responsive */
@media (max-width: 768px) {
    #review-content {
        padding: 6px;
        margin: 6px;
    }


    #review-content h2 {
        font-size: 1.1rem;
    }


    #review-content .review-author {
        font-size: 0.7rem; /* Giảm kích thước chữ tên người dùng */
    }


    #review-content .review-text {
        font-size: 0.7rem;
    }


    #review-content .review-rating {
        font-size: 0.65rem;
    }


    #review-content .review-date {
        font-size: 0.6rem;
    }


    .review-card {
        gap: 8px; /* Giảm khoảng cách */
        margin-bottom: 8px; /* Giảm margin */
        padding: 6px; /* Giảm padding */
    }


    .review-avatar img {
        width: 32px; /* Giảm kích thước avatar */
        height: 32px;
    }


    .section-title {
        font-size: 1.2rem;
    }


    .average-rating p {
        font-size: 0.9rem;
    }


    .star {
        font-size: 0.8rem;
    }


    .form-control {
        padding: 5px;
        font-size: 0.75rem;
        max-width: 150px;
    }


    .submit-review-btn {
        padding: 5px 10px;
        margin-top: 10px;
    }


    .review-form h3 {
        font-size: 1.1rem;
    }


    .filter-sidebar {
        padding: 8px;
        max-width: 150px;
    }


    .btn-filter {
        padding: 5px 8px;
        font-size: 0.8rem;
    }
  .reviews-section{
                        margin-bottom: 50px;
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
                            <form action="/student/package/${pkg.packageId}/reviews?render=true" method="get" class="row g-3"
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
                                            style="background-color: white; border-color: white; color: gray;">
                                            <i class="fas fa-magnifying-glass"></i>
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
                                            <form action="/student/package/${pkg.packageId}/review" method="post"
                                                modelAttribute="newReview" commandName="newReview">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <c:if test="${not empty subjectId}">
                                                    <input type="hidden" name="subjectId" value="${subjectId}" />
                                                </c:if>
                                             <div class="form-group">
    <label for="rating">Số sao:</label>
    <div class="star-rating">
        <input type="radio" id="star5" name="rating" value="5" required>
        <label for="star5">&#9733;</label>
        <input type="radio" id="star4" name="rating" value="4">
        <label for="star4">&#9733;</label>
        <input type="radio" id="star3" name="rating" value="3">
        <label for="star3">&#9733;</label>
        <input type="radio" id="star2" name="rating" value="2">
        <label for="star2">&#9733;</label>
        <input type="radio" id="star1" name="rating" value="1">
        <label for="star1">&#9733;</label>
    </div>
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

