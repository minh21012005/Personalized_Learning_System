<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chi tiết giao dịch</title>
                <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                    rel="stylesheet">
                <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
                <style>
                    ul {
                        margin: 0;
                    }

                    .change-password-page .sidebar {
                        background-color: #fff;
                        border-radius: 10px;
                        padding: 20px;
                        height: fit-content;
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

                    .transaction-detail-card {
                        position: sticky;
                        top: 0;
                        background-color: #fff;
                        border-radius: 10px;
                        padding: 20px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        transition: transform 0.2s ease, box-shadow 0.2s ease;
                    }

                    .transaction-detail-card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                    }

                    .detail-item {
                        padding: 10px 0;
                        border-bottom: 1px solid #e2e8f0;
                    }

                    .detail-item:last-child {
                        border-bottom: none;
                    }

                    .detail-label {
                        font-weight: 600;
                        color: #4a5568;
                    }

                    .detail-value {
                        color: #2d3748;
                    }

                    .btn-back {
                        background-color: #343a40;
                        color: #fff;
                        transition: background-color 0.3s ease;
                    }

                    .btn-back:hover {
                        background-color: #4a5568;
                    }

                    .evidence-image {
                        cursor: pointer;
                        max-width: 300px;
                        border-radius: 5px;
                        transition: opacity 0.2s ease;
                    }

                    .evidence-image:hover {
                        opacity: 0.9;
                    }

                    a {
                        text-decoration: none !important;
                    }
                </style>
            </head>

            <body class="bg-gray-100 font-sans">
                <header>
                    <jsp:include page="../layout/header.jsp" />
                </header>
                <div class="change-password-page mt-5">
                    <div class="container py-5">
                        <div class="flex flex-col md:flex-row gap-6">
                            <!-- Sidebar -->
                            <div class="md:w-1/4">
                                <jsp:include page="../layout/sidebar.jsp" />
                            </div>
                            <!-- Main content -->
                            <div class="md:w-3/4">
                                <div class="transaction-detail-card mb-4">
                                    <h2 class="text-2xl font-bold text-gray-800 mb-6">Chi tiết giao dịch</h2>
                                    <div class="detail-item flex justify-between items-center">
                                        <span class="detail-label">Mã giao dịch</span>
                                        <span class="detail-value">${transaction.transferCode}</span>
                                    </div>
                                    <div class="detail-item flex justify-between items-center">
                                        <span class="detail-label">Trạng thái</span>
                                        <span class="detail-value">
                                            <c:choose>
                                                <c:when test="${transaction.status == 'APPROVED'}">
                                                    <span
                                                        class="inline-flex items-center px-2 py-1 bg-green-100 text-green-800 rounded-full">
                                                        <i class="fas fa-check-circle mr-1"></i> Thành công
                                                    </span>
                                                </c:when>
                                                <c:when test="${transaction.status == 'PENDING'}">
                                                    <span
                                                        class="inline-flex items-center px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full">
                                                        <i class="fas fa-hourglass-half mr-1"></i> Chờ xử lý
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span
                                                        class="inline-flex items-center px-2 py-1 bg-red-100 text-red-800 rounded-full">
                                                        <i class="fas fa-times-circle mr-1"></i> Từ chối
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="detail-item flex justify-between items-center">
                                        <span class="detail-label">Số tiền</span>
                                        <span class="detail-value">
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
                                        </span>
                                    </div>
                                    <div class="detail-item flex justify-between items-center">
                                        <span class="detail-label">Ngày thanh toán</span>
                                        <span class="detail-value">
                                            <fmt:formatDate value="${transaction.createdAtAsUtilDate}"
                                                pattern="dd/MM/yyyy HH:mm:ss" />
                                        </span>
                                    </div>
                                    <div class="detail-item flex justify-between items-center">
                                        <span class="detail-label">Ngày xử lí</span>
                                        <span class="detail-value">
                                            <c:if test="${not empty transaction.confirmedAt}">
                                                <fmt:formatDate value="${transaction.confirmedAtAsDate}"
                                                    pattern="dd/MM/yyyy HH:mm:ss" />
                                            </c:if>
                                            <c:if test="${not empty transaction.rejectedAt}">
                                                <fmt:formatDate value="${transaction.rejectedAtAsDate}"
                                                    pattern="dd/MM/yyyy HH:mm:ss" />
                                            </c:if>
                                            <c:if
                                                test="${empty transaction.confirmedAt and empty transaction.rejectedAt}">
                                                Chưa xử lí
                                            </c:if>
                                        </span>
                                    </div>
                                    <div class="detail-item flex justify-between items-center">
                                        <span class="detail-label">Học sinh</span>
                                        <span class="detail-value">${transaction.student.fullName}
                                            (${transaction.student.email})</span>
                                    </div>
                                    <div class="detail-item flex justify-between items-center">
                                        <span class="detail-label">Ghi chú</span>
                                        <span class="detail-value">
                                            <c:out value="${transaction.note}" default="Không có" />
                                        </span>
                                    </div>
                                    <c:if test="${transaction.status eq 'REJECTED'}">
                                        <div class="detail-item flex justify-between items-center">
                                            <span class="detail-label">Lý do từ chối</span>
                                            <span class="detail-value">
                                                <c:out value="${transaction.rejectionReason}" default="Không có" />
                                            </span>
                                        </div>
                                    </c:if>
                                    <div class="detail-item flex justify-between items-center">
                                        <span class="detail-label">Gói đã thanh toán</span>
                                        <span class="detail-value">
                                            <div class="flex flex-wrap gap-2">
                                                <c:forEach var="pkg" items="${transaction.packages}">
                                                    <a href="/parent/course/detail/${pkg.packageId}" target="_blank"
                                                        class="inline-block px-2 py-1 bg-gray-100 text-gray-800 rounded-full text-xs hover:bg-gray-200 transition">
                                                        ${pkg.name}
                                                    </a>
                                                </c:forEach>
                                            </div>
                                        </span>
                                    </div>
                                    <div class="detail-item flex justify-between">
                                        <span class="detail-label">Hình ảnh chuyển khoản</span>
                                        <span class="detail-value">
                                            <c:if test="${not empty transaction.evidenceImage}">
                                                <img src="/img/transaction/${transaction.evidenceImage}"
                                                    alt="Minh chứng" class="evidence-image" data-bs-toggle="modal"
                                                    data-bs-target="#imageModal">
                                            </c:if>
                                            <c:if test="${empty transaction.evidenceImage}">
                                                Không có hình ảnh
                                            </c:if>
                                        </span>
                                    </div>
                                    <div class="mt-6 text-right">
                                        <a href="/transaction/history"
                                            class="inline-flex items-center px-4 py-2 bg-gray-800 text-white rounded-lg hover:bg-gray-700 transition btn-back">
                                            <i class="fas fa-arrow-left mr-2"></i> Quay lại
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Image Modal -->
                <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="imageModalLabel">Hình ảnh minh chứng</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <img src="/img/transaction/${transaction.evidenceImage}" alt="Minh chứng"
                                    class="img-fluid w-100">
                            </div>
                        </div>
                    </div>
                </div>
                <footer>
                    <jsp:include page="../layout/footer.jsp" />
                </footer>
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
            </body>

            </html>