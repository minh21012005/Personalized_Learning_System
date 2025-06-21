<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <title>PLS - Lịch sử giao dịch</title>
                    <!-- Bootstrap CSS -->
                    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
                    <!-- Bootstrap Icons -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                        rel="stylesheet" />
                    <!-- Custom CSS -->
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

                                <!-- Main Content -->
                                <div class="col-md-9">
                                    <!-- Nội dung: Danh sách giao dịch -->
                                    <div class="password-change-content mb-4">
                                        <h4 class="mb-3">Lịch sử giao dịch</h4>

                                        <!-- Bộ lọc -->
                                        <form action="/transaction/history" method="get" class="mb-3">
                                            <div class="row g-2 align-items-end">
                                                <div class="col-md-4">
                                                    <label for="transferCode" class="form-label">Mã giao dịch</label>
                                                    <input type="text" id="transferCode" name="transferCode"
                                                        value="${param.transferCode}"
                                                        class="form-control form-control-sm" placeholder="Nhập mã...">
                                                </div>
                                                <div class="col-md-4">
                                                    <label for="status" class="form-label">Trạng thái</label>
                                                    <select name="status" id="status"
                                                        class="form-select form-select-sm">
                                                        <option value="">Tất cả</option>
                                                        <option value="APPROVED" ${param.status=='APPROVED' ? 'selected'
                                                            : '' }>Thành công</option>
                                                        <option value="PENDING" ${param.status=='PENDING' ? 'selected'
                                                            : '' }>Chờ xử lý</option>
                                                        <option value="REJECTED" ${param.status=='REJECTED' ? 'selected'
                                                            : '' }>Từ chối</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <button type="submit" class="btn btn-dark btn-sm w-100">Lọc</button>
                                                </div>
                                            </div>
                                        </form>

                                        <!-- Bảng giao dịch -->
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-hover align-middle">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th scope="col">#</th>
                                                        <th scope="col">Mã GD</th>
                                                        <th scope="col">Gói</th>
                                                        <th scope="col">Số tiền</th>
                                                        <th scope="col">Ngày tạo</th>
                                                        <th scope="col">Trạng thái</th>
                                                        <th scope="col">Xem</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="transaction" items="${transactions}"
                                                        varStatus="loop">
                                                        <tr>
                                                            <td>${loop.index + 1}</td>
                                                            <td>${transaction.transferCode}</td>
                                                            <td>
                                                                <div class="d-flex flex-wrap gap-1">
                                                                    <c:forEach var="pkg"
                                                                        items="${transaction.packages}">
                                                                        <a href="/package/${pkg.packageId}"
                                                                            target="_blank"
                                                                            style="text-decoration: none;">
                                                                            <span
                                                                                class="badge bg-secondary">${pkg.name}</span>
                                                                        </a>
                                                                    </c:forEach>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${transaction.amount % 1 == 0}">
                                                                        <fmt:formatNumber value="${transaction.amount}"
                                                                            type="number" groupingUsed="true"
                                                                            maxFractionDigits="0" /> ₫
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <fmt:formatNumber value="${transaction.amount}"
                                                                            type="number" groupingUsed="true"
                                                                            minFractionDigits="2"
                                                                            maxFractionDigits="2" /> ₫
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <fmt:formatDate
                                                                    value="${transaction.createdAtAsUtilDate}"
                                                                    pattern="dd/MM/yyyy HH:mm:ss" />
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${transaction.status == 'APPROVED'}">
                                                                        <span class="badge bg-success">Thành công</span>
                                                                    </c:when>
                                                                    <c:when test="${transaction.status == 'PENDING'}">
                                                                        <span class="badge bg-warning text-dark">Chờ xử
                                                                            lý</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-danger">Từ chối</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <a href="/user/transaction/${transaction.transactionId}"
                                                                    class="btn btn-sm btn-outline-primary">
                                                                    <i class="bi bi-eye"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>

                                                    <c:if test="${empty transactions}">
                                                        <tr>
                                                            <td colspan="6" class="text-center text-muted">Không có giao
                                                                dịch nào.</td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <footer>
                        <jsp:include page="../layout/footer.jsp" />
                    </footer>

                    <!-- jQuery -->
                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <!-- Bootstrap JS and Popper.js -->
                    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
                </body>

                </html>