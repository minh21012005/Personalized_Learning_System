<%@ page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Lịch sử giao dịch</title>
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

                    .filter-section {
                        transition: all 0.3s ease;
                    }

                    .transaction-card {
                        transition: transform 0.2s ease, box-shadow 0.2s ease;
                    }

                    .transaction-card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
                    }

                    .pagination .page-item.active .page-link {
                        background-color: #343a40;
                        color: white;
                        border-color: #343a40;
                    }

                    .pagination .page-link:hover {
                        background-color: #4a5568;
                        color: white;
                    }

                    .pagination .page-link {
                        padding: 0.25rem 0.75rem;
                        font-size: 1rem;
                    }

                    .side-bar {
                        margin-top: 57px;
                    }

                    a {
                        text-decoration: none !important;
                    }
                </style>
            </head>

            <body class="bg-gray-100 font-sans">
                <jsp:include page="../layout/header.jsp" />
                <div class="container py-5 mx-auto px-4 py-8 change-password-page">
                    <div class="flex flex-col md:flex-row gap-6">
                        <!-- Sidebar -->
                        <div class="side-bar md:w-1/4">
                            <jsp:include page="../layout/sidebar.jsp" />
                        </div>
                        <!-- Main Content -->
                        <div class="md:w-3/4">
                            <h2 class="text-2xl font-bold text-gray-800 mb-6">Lịch sử mua khóa học của bạn</h2>
                            <!-- Filter Section -->
                            <form action="/transaction/history" method="get"
                                class="filter-section bg-white p-4 rounded-xl shadow-md mb-6">
                                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3">
                                    <div>
                                        <label for="transferCode" class="block text-xs font-medium text-gray-700">Mã
                                            giao dịch</label>
                                        <input type="text" id="transferCode" name="transferCode"
                                            value="${param.transferCode}"
                                            class="mt-1 w-full p-1.5 text-sm border border-gray-300 rounded-lg focus:ring-gray-500 focus:border-gray-500"
                                            placeholder="Nhập mã...">
                                    </div>
                                    <div>
                                        <label for="status" class="block text-xs font-medium text-gray-700">Trạng
                                            thái</label>
                                        <select name="status" id="status"
                                            class="mt-1 w-full p-1.5 text-sm border border-gray-300 rounded-lg focus:ring-gray-500 focus:border-gray-500">
                                            <option value="">Tất cả</option>
                                            <option value="APPROVED" ${param.status=='APPROVED' ? 'selected' : '' }>
                                                Thành công</option>
                                            <option value="PENDING" ${param.status=='PENDING' ? 'selected' : '' }>Chờ xử
                                                lý</option>
                                            <option value="REJECTED" ${param.status=='REJECTED' ? 'selected' : '' }>Từ
                                                chối</option>
                                        </select>
                                    </div>
                                    <div class="w-[110px]">
                                        <label for="fromDate" class="block text-xs font-medium text-gray-700">Từ
                                            ngày</label>
                                        <input type="date" id="fromDate" name="fromDate" value="${param.fromDate}"
                                            class="mt-1 w-full p-1.5 text-sm border border-gray-300 rounded-lg focus:ring-gray-500 focus:border-gray-500">
                                    </div>
                                    <div class="w-[110px]">
                                        <label for="toDate" class="block text-xs font-medium text-gray-700">Đến
                                            ngày</label>
                                        <input type="date" id="toDate" name="toDate" value="${param.toDate}"
                                            class="mt-1 w-full p-1.5 text-sm border border-gray-300 rounded-lg focus:ring-gray-500 focus:border-gray-500">
                                    </div>
                                    <div class="w-[70px] flex items-end">
                                        <button type="submit"
                                            class="w-full p-1.5 text-sm bg-gray-800 text-white rounded-lg hover:bg-gray-700 transition">Lọc</button>
                                    </div>
                                </div>
                            </form>
                            <!-- Transaction List -->
                            <c:forEach var="transaction" items="${transactions}">
                                <div class="transaction-card bg-white p-4 rounded-xl shadow-md mb-4">
                                    <div class="flex flex-row gap-4">
                                        <!-- Left Column -->
                                        <div class="flex-1">
                                            <div class="text-lg font-semibold text-gray-800">Mã:
                                                ${transaction.transferCode}</div>
                                            <div class="mt-2 text-gray-600 text-sm">
                                                <p><strong>Số tiền:</strong>
                                                    <c:choose>
                                                        <c:when test="${transaction.amount % 1 == 0}">
                                                            <fmt:formatNumber value="${transaction.amount}"
                                                                type="number" groupingUsed="true"
                                                                maxFractionDigits="0" /> ₫
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber value="${transaction.amount}"
                                                                type="number" groupingUsed="true" minFractionDigits="2"
                                                                maxFractionDigits="2" /> ₫
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <p><strong>Ngày thanh toán:</strong>
                                                    <fmt:formatDate value="${transaction.createdAtAsUtilDate}"
                                                        pattern="dd/MM/yyyy HH:mm:ss" />
                                                </p>
                                                <p><strong>Khóa học:</strong>
                                                    <c:forEach var="pkg" items="${transaction.packages}">
                                                        <a href="/parent/course/detail/${pkg.packageId}"
                                                            class="inline-block px-2 py-1 bg-gray-100 text-gray-800 rounded-full text-xs hover:bg-gray-200 transition"
                                                            target="_blank">${pkg.name}</a>
                                                    </c:forEach>
                                                </p>
                                            </div>
                                        </div>
                                        <!-- Right Column -->
                                        <div class="flex flex-col justify-between items-end w-40">
                                            <div class="text-sm">
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
                                            </div>
                                            <a href="/transaction/history/${transaction.transactionId}"
                                                class="inline-flex items-center px-3 py-1 bg-gray-800 text-white text-sm rounded-lg hover:bg-gray-700 transition">
                                                Xem chi tiết <i class="fas fa-eye ml-2"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty transactions}">
                                <div class="text-center text-gray-600 mt-8">
                                    <i class="fas fa-box-open text-4xl mb-2"></i>
                                    <p>Không tìm thấy giao dịch nào.</p>
                                </div>
                            </c:if>
                            <!-- Pagination -->
                            <c:if test="${not empty transactions}">
                                <nav class="mt-6">
                                    <ul class="pagination flex justify-center space-x-2">
                                        <!-- Previous Page -->
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link px-3 py-1 border border-gray-300 rounded-lg"
                                                href="/transaction/history?page=${currentPage - 1}&transferCode=${param.transferCode}&status=${param.status}&fromDate=${param.fromDate}&toDate=${param.toDate}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                        <!-- Page Numbers -->
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link px-3 py-1 border border-gray-300 rounded-lg"
                                                    href="/transaction/history?page=${i}&transferCode=${param.transferCode}&status=${param.status}&fromDate=${param.fromDate}&toDate=${param.toDate}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <!-- Next Page -->
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link px-3 py-1 border border-gray-300 rounded-lg"
                                                href="/transaction/history?page=${currentPage + 1}&transferCode=${param.transferCode}&status=${param.status}&fromDate=${param.fromDate}&toDate=${param.toDate}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>
                <jsp:include page="../layout/footer.jsp" />
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
            </body>

            </html>