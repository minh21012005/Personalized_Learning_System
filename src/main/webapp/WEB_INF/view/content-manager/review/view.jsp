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
                    max-width: 400px;
                    overflow: hidden;
                    text-overflow: ellipsis;
                    white-space: nowrap;
                }

                .container {
                    margin-left: 300px;
                    flex: 1;
                }

                .body {
                    margin: 0;
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                    overflow-x: hidden;
                    /* Prevent horizontal scroll from fixed elements */
                }

                .sidebar {
                    width: 250px;
                    background-color: #1a252f;
                    color: white;
                    overflow-y: auto;

                }

                .header {
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    z-index: 3;
                    /* On top */
                    background-color: #212529;
                    /* Dark background to match image */
                }

                .content {
                    margin-left: 100px;
                    /* Match sidebar width */
                    margin-top: 60px;
                    /* Space for header height */
                    padding: 800px;
                    flex: 1;
                    /* Fill available space */
                }

                .footer {
                    margin-top: 18.6%;
                    background-color: #212529;
                    color: white;
                    height: 40px;
                    text-align: center;
                    line-height: 40px;
                }
            </style>
        </head>

        <body>
            <header>
                <jsp:include page="../layout/header.jsp" />
            </header>

            <!-- Sidebar -->
            <div class="sidebar">
                <jsp:include page="../layout/sidebar.jsp" />
            </div>

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
                                <option value="" ${packageId=='all' ? 'selected' : '' }>Tất cả</option>
                                <c:forEach var="pkg" items="${packages}">
                                    <option value="${pkg.packageId}" ${packageId==pkg.packageId ? 'selected' : '' }>
                                        ${pkg.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <select name="subjectId" class="form-select" ${type !='Subject' ? 'disabled' : '' }>
                                <option value="">Chọn Subject</option>
                                <option value="" ${subjectId=='all' ? 'selected' : '' }>Tất cả</option>
                                <c:forEach var="subject" items="${subjects}">
                                    <option value="${subject.subjectId}" ${subjectId==subject.subjectId ? 'selected'
                                        : '' }>
                                        ${subject.subjectName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label>Trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="" ${param.status==null || param.status=='' ? 'selected' : '' }>Tất cả
                                </option>
                                <c:forEach var="s" items="${statuses}">
                                    <option value="${s}" ${s==param.status ? 'selected' : '' }>${s}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label>Rating</label>
                            <select name="rating" class="form-select">
                                <option value="" ${rating==null || rating=='' ? 'selected' : '' }>Tất cả</option>
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

                <c:if test="${totalPages > 1}">
                    <nav>
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                <a class="page-link"
                                    href="/admin/reviews?page=${currentPage - 1}&type=${type}&packageId=${packageId}&subjectId=${subjectId}&status=${status}&rating=${rating}&comment=${comment}">«</a>
                            </li>
                            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link"
                                        href="/admin/reviews?page=${i}&type=${type}&packageId=${packageId}&subjectId=${subjectId}&status=${status}&rating=${rating}&comment=${comment}">${i
                                        + 1}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                    href="/admin/reviews?page=${currentPage + 1}&type=${type}&packageId=${packageId}&subjectId=${subjectId}&status=${status}&rating=${rating}&comment=${comment}">»</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>


                <!-- Success/Error Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
            </div>
            <!-- Footer -->
            <footer class="footer">
                <jsp:include page="../layout/footer.jsp" />
            </footer>
        </body>


        </html>