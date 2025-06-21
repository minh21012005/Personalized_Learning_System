<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Chi tiết giao dịch</title>
                <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                    rel="stylesheet" />
                <style>
                    ul {
                        margin: 0;
                    }

                    .change-password-page body {
                        background-color: #f5f5f5;
                    }

                    .change-password-page .sidebar {
                        background-color: #fff;
                        border-radius: 10px;
                        padding: 20px;
                        height: fit-content;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    }

                    .change-password-page .password-change-content {
                        background-color: #fff;
                        border-radius: 10px;
                        padding: 20px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    }

                    .change-password-page .nav-link {
                        color: #333;
                        padding: 10px 10px;
                        border-radius: 5px;
                    }

                    .change-password-page .nav-link.active {
                        background-color: #343a40;
                        color: #fff;
                    }

                    .change-password-page .password-form-section {
                        background-color: #ffffff;
                        border: #e2e8f0 1px solid;
                        border-radius: 10px;
                        padding: 20px;
                    }

                    .change-password-page .btn-save-password {
                        background-color: #343a40;
                        color: #fff;
                        border-radius: 5px;
                    }

                    .change-password-page .form-item {
                        /* Có thể thêm style nếu cần */
                    }
                </style>
            </head>

            <body>
                <header>
                    <jsp:include page="../layout/header.jsp" />
                </header>

                <div class="change-password-page mt-5">
                    <div class="container py-5">
                        <div class="row">
                            <!-- Sidebar -->
                            <div class="col-md-3">
                                <jsp:include page="../layout/sidebar.jsp" />
                            </div>

                            <!-- Main content -->
                            <div class="col-md-9">
                                <div class="password-change-content mb-4">
                                    <h4 class="mb-3">Chi tiết giao dịch</h4>

                                    <table class="table table-bordered">
                                        <tr>
                                            <th scope="row">Mã giao dịch</th>
                                            <td>${transaction.transferCode}</td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Trạng thái</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${transaction.status == 'APPROVED'}">
                                                        <span class="badge bg-success">Thành công</span>
                                                    </c:when>
                                                    <c:when test="${transaction.status == 'PENDING'}">
                                                        <span class="badge bg-warning text-dark">Chờ xử lý</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger">Từ chối</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Số tiền</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${transaction.amount % 1 == 0}">
                                                        <fmt:formatNumber value="${transaction.amount}" type="number"
                                                            groupingUsed="true" maxFractionDigits="0" /> ₫
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${transaction.amount}" type="number"
                                                            groupingUsed="true" minFractionDigits="2"
                                                            maxFractionDigits="2" /> ₫
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Ngày thanh toán</th>
                                            <td>
                                                <fmt:formatDate value="${transaction.createdAtAsUtilDate}"
                                                    pattern="dd/MM/yyyy HH:mm:ss" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Ngày xử lí</th>
                                            <td>
                                                <c:if test="${not empty transaction.confirmedAt}">
                                                    <fmt:formatDate value="${transaction.confirmedAtAsDate}"
                                                        pattern="dd/MM/yyyy HH:mm" />
                                                </c:if>
                                                <c:if test="${not empty transaction.rejectedAt}">
                                                    <fmt:formatDate value="${transaction.rejectedAtAsDate}"
                                                        pattern="dd/MM/yyyy HH:mm" />
                                                </c:if>
                                                <c:if
                                                    test="${empty transaction.confirmedAt and empty transaction.rejectedAt}">
                                                    Chưa xử lí
                                                </c:if>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Học sinh</th>
                                            <td>${transaction.student.fullName} (${transaction.student.email})</td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Ghi chú</th>
                                            <td>
                                                <c:out value="${transaction.note}" default="Không có" />
                                            </td>
                                        </tr>
                                        <c:if test="${transaction.status eq 'REJECTED'}">
                                            <tr>
                                                <th scope="row">Lý do từ chối</th>
                                                <td>
                                                    <c:out value="${transaction.rejectionReason}" default="Không có" />
                                                </td>
                                            </tr>
                                        </c:if>

                                        <tr>
                                            <th scope="row">Gói đã thanh toán</th>
                                            <td>
                                                <div class="d-flex flex-wrap gap-2">
                                                    <c:forEach var="pkg" items="${transaction.packages}">
                                                        <a href="/parent/course/detail/${pkg.packageId}" target="_blank"
                                                            class="badge bg-secondary text-decoration-none">
                                                            ${pkg.name}
                                                        </a>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Hình ảnh chuyển khoản</th>
                                            <td>
                                                <c:if test="${not empty transaction.evidenceImage}">
                                                    <img src="/img/transaction/${transaction.evidenceImage}"
                                                        alt="Minh chứng" class="img-fluid" style="max-width: 300px;">
                                                </c:if>
                                                <c:if test="${empty transaction.evidenceImage}">
                                                    Không có hình ảnh
                                                </c:if>
                                            </td>
                                        </tr>
                                    </table>

                                    <a href="/transaction/history" class="btn btn-secondary">Quay lại</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <footer>
                    <jsp:include page="../layout/footer.jsp" />
                </footer>

                <!-- Scripts -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
            </body>

            </html>