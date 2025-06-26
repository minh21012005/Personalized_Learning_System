<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Quản lý đánh giá</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <style>
                .status-pending {
                    color: orange;
                }

                .status-approved {
                    color: green;
                }

                .status-rejected {
                    color: red;
                }

                .comment-preview {
                    max-width: 200px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }
            </style>
        </head>

        <body>
            <div class="container mt-4">
                <h1>Quản lý đánh giá</h1>

                <!-- Filter Panel -->
                <form method="get" action="/admin/reviews" class="mb-4">
                    <div class="row">
                        <div class="col-md-3">
                            <label>Loại đánh giá</label>
                            <select name="type" class="form-select">
                                <option value="">Tất cả</option>
                                <option value="Package" ${type=='Package' ? 'selected' : '' }>Package</option>
                                <option value="Subject" ${type=='Subject' ? 'selected' : '' }>Subject</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label>Package/Subject</label>
                            <select name="packageId" class="form-select" ${type !='Package' ? 'disabled' : '' }>
                                <option value="">Chọn Package</option>
                                <c:forEach var="pkg" items="${packages}">
                                    <option value="${pkg.packageId}" ${packageId==pkg.packageId ? 'selected' : '' }>
                                        ${pkg.name}</option>
                                </c:forEach>
                            </select>
                            <select name="subjectId" class="form-select" ${type !='Subject' ? 'disabled' : '' }>
                                <option value="">Chọn Subject</option>
                                <c:forEach var="subject" items="${subjects}">
                                    <option value="${subject.subjectId}" ${subjectId==subject.subjectId ? 'selected'
                                        : '' }>${subject.subjectName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label>Trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="">Tất cả</option>
                                <c:forEach var="status" items="${statuses}">
                                    <option value="${status}" ${status==status ? 'selected' : '' }>${status}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label>Rating</label>
                            <select name="rating" class="form-select">
                                <option value="">Tất cả</option>
                                <c:forEach var="r" items="${ratings}">
                                    <option value="${r}" ${rating==r ? 'selected' : '' }>${r} sao</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label>Từ khóa bình luận</label>
                            <input type="text" name="comment" class="form-control" value="${comment}">
                        </div>
                    </div>
                    <div class="mt-2">
                        <button type="submit" class="btn btn-primary">Lọc</button>
                        <a href="/admin/reviews" class="btn btn-secondary">Xóa bộ lọc</a>
                    </div>
                </form>

                <!-- Review Table -->
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>ID</th>
                            <th>Loại nội dung</th>
                            <th>Rating</th>
                            <th>Bình luận</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="review" items="${reviews}" varStatus="loop">
                            <tr>
                                <td>${loop.index + 1 + (currentPage * size)}</td>
                                <td><a href="/admin/reviews/${review.reviewId}">${review.reviewId}</a></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${review.pkg != null}">${review.pkg.name}</c:when>
                                        <c:when test="${review.subject != null}">${review.subject.subjectName}</c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:forEach begin="1" end="${review.rating}">⭐</c:forEach>
                                </td>
                                <td class="comment-preview" title="${review.comment}">${review.comment}</td>
                                <td class="status-${review.status.toString().toLowerCase()}">${review.status}</td>
                                <td>
                                    <c:if test="${review.status == 'PENDING'}">
                                        <form action="/admin/reviews/${review.reviewId}/approve" method="post"
                                            style="display:inline;">
                                            <button type="submit" class="btn btn-success btn-sm">Approve</button>
                                        </form>
                                        <form action="/admin/reviews/${review.reviewId}/reject" method="post"
                                            style="display:inline;">
                                            <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Pagination -->
                <nav>
                    <ul class="pagination">
                        <c:if test="${currentPage > 0}">
                            <li class="page-item">
                                <a class="page-link"
                                    href="/admin/reviews?page=${currentPage - 1}&size=${size}&type=${type}&packageId=${packageId}&subjectId=${subjectId}&status=${status}&rating=${rating}&comment=${comment}">Previous</a>
                            </li>
                        </c:if>
                        <c:forEach begin="0" end="${totalPages - 1}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link"
                                    href="/admin/reviews?page=${i}&size=${size}&type=${type}&packageId=${packageId}&subjectId=${subjectId}&status=${status}&rating=${rating}&comment=${comment}">${i
                                    + 1}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages - 1}">
                            <li class="page-item">
                                <a class="page-link"
                                    href="/admin/reviews?page=${currentPage + 1}&size=${size}&type=${type}&packageId=${packageId}&subjectId=${subjectId}&status=${status}&rating=${rating}&comment=${comment}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                    <select class="form-select d-inline w-auto"
                        onchange="window.location.href='/admin/reviews?page=0&size=' + this.value + '&type=${type}&packageId=${packageId}&subjectId=${subjectId}&status=${status}&rating=${rating}&comment=${comment}'">
                        <option value="10" ${size==10 ? 'selected' : '' }>10</option>
                        <option value="20" ${size==20 ? 'selected' : '' }>20</option>
                        <option value="50" ${size==50 ? 'selected' : '' }>50</option>
                    </select>
                </nav>

                <!-- Success/Error Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
            </div>
        </body>

        </html>