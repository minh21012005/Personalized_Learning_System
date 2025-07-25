<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>PLS - Quản lí giao dịch</title>
                    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/choices.js/public/assets/styles/choices.min.css" />
                    <script src="https://cdn.jsdelivr.net/npm/choices.js/public/assets/scripts/choices.min.js"></script>
                    <style>
                        body {
                            margin: 0;
                            min-height: 100vh;
                            display: flex;
                            flex-direction: column;
                            overflow-x: hidden;
                            font-family: Arial, sans-serif;
                        }

                        header {
                            background-color: #1a252f;
                            color: white;
                            width: 100%;
                        }

                        .main-container {
                            display: flex;
                            flex: 1;
                        }

                        .sidebar {
                            width: 250px;
                            background-color: #1a252f;
                            color: white;
                            overflow-y: auto;
                        }

                        .content {
                            flex: 1;
                            padding: 20px;
                            background-color: #f8f9fa;
                            padding-bottom: 80px;
                        }

                        footer {
                            background-color: #1a252f;
                            color: white;
                            height: 40px;
                            width: 100%;
                        }

                        .table-fixed {
                            table-layout: fixed;
                            width: 100%;
                        }

                        .table-fixed th,
                        .table-fixed td {
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap;
                        }

                        .col-id {
                            width: 4%;
                            min-width: 50px;
                        }

                        .col-transfer-code {
                            width: 15%;
                            min-width: 120px;
                            word-break: break-word;
                        }

                        .col-customer {
                            width: 17.5%;
                            min-width: 150px;
                            word-break: break-word;
                        }

                        .col-package {
                            width: 17%;
                            min-width: 180px;
                            word-break: break-word;
                        }

                        .col-amount {
                            width: 10%;
                            min-width: 100px;
                            text-align: right;
                        }

                        .col-created-at {
                            width: 16%;
                            min-width: 140px;
                            white-space: nowrap;
                        }

                        .col-status {
                            width: 10%;
                            min-width: 100px;
                            text-align: center;
                        }

                        .col-action {
                            width: 10%;
                            min-width: 100px;
                            text-align: center;
                        }

                        .pagination-container {
                            margin-top: 20px;
                            margin-bottom: -30px;
                            width: 100%;
                            background-color: #f8f9fa;
                            padding: 10px 20px;
                            z-index: 1000;
                            display: flex;
                            justify-content: center;
                        }

                        .pagination .page-link {
                            color: black;
                            border: 1px solid #dee2e6;
                        }

                        .pagination .page-link:hover {
                            background-color: #e9ecef;
                            color: black;
                        }

                        .pagination .page-item.active .page-link {
                            background-color: #d3d3d3;
                            border-color: #d3d3d3;
                            color: black;
                        }

                        .pagination .page-item.disabled .page-link {
                            color: #6c757d;
                            pointer-events: none;
                            background-color: #fff;
                            border-color: #dee2e6;
                        }
                    </style>
                </head>

                <body>
                    <header>
                        <jsp:include page="../layout/header.jsp" />
                    </header>
                    <div class="main-container">
                        <div class="sidebar d-flex flex-column">
                            <jsp:include page="../layout/sidebar.jsp" />
                        </div>
                        <div class="content">
                            <main>
                                <div class="container-fluid">
                                    <div class="mt-4">
                                        <div class="row col-12 mx-auto">
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <form action="/admin/transaction" method="get">
                                                    <div class="d-flex gap-2 flex-wrap mb-3">
                                                        <label for="transferCode" style="margin-top: 3px;"
                                                            class="mb-0 fw-bold me-1">Mã GD:</label>
                                                        <input type="text" id="transferCode" name="transferCode"
                                                            class="form-control form-control-sm w-auto"
                                                            value="${param.transferCode}" placeholder="Nhập mã...">
                                                        <label for="email" style="margin-top: 3px;"
                                                            class="mb-0 fw-bold me-1">Email PH:</label>
                                                        <input type="text" id="email" name="email"
                                                            class="form-control form-control-sm w-auto"
                                                            value="${param.email}" placeholder="Nhập email...">
                                                        <button class="btn btn-outline-secondary btn-sm" type="button"
                                                            data-bs-toggle="offcanvas"
                                                            data-bs-target="#advancedFilter">Lọc nâng cao <i
                                                                class="bi bi-filter ms-1"></i></button>
                                                        <button type="submit"
                                                            class="btn btn-outline-primary btn-sm">Lọc</button>
                                                    </div>
                                                    <div class="offcanvas offcanvas-end" tabindex="-1"
                                                        id="advancedFilter" aria-labelledby="advancedFilterLabel">
                                                        <div class="offcanvas-header">
                                                            <h5 class="offcanvas-title" id="advancedFilterLabel">Lọc
                                                                nâng cao</h5>
                                                            <button type="button" class="btn-close"
                                                                data-bs-dismiss="offcanvas" aria-label="Close"></button>
                                                        </div>
                                                        <div class="offcanvas-body d-flex flex-column gap-3">
                                                            <div>
                                                                <label for="studentEmail" class="fw-bold">Email
                                                                    HS:</label>
                                                                <input type="text" id="studentEmail" name="studentEmail"
                                                                    class="form-control" value="${param.studentEmail}"
                                                                    placeholder="Nhập email...">
                                                            </div>
                                                            <div>
                                                                <label for="packageSelect" class="fw-bold">Khóa
                                                                    học:</label>
                                                                <select name="packages" id="packageSelect" multiple
                                                                    class="form-select">
                                                                    <c:forEach var="p" items="${packageList}">
                                                                        <c:set var="isSelected" value="false" />
                                                                        <c:if test="${not empty paramValues.packages}">
                                                                            <c:forEach var="selectedPkg"
                                                                                items="${paramValues.packages}">
                                                                                <c:if
                                                                                    test="${selectedPkg eq p.packageId}">
                                                                                    <c:set var="isSelected"
                                                                                        value="true" />
                                                                                </c:if>
                                                                            </c:forEach>
                                                                        </c:if>
                                                                        <option value="${p.packageId}" ${isSelected
                                                                            ? 'selected' : '' }>${p.name}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div>
                                                                <label for="status" class="fw-bold">Trạng
                                                                    thái:</label>
                                                                <select name="status" id="status" class="form-select">
                                                                    <option value="">Tất cả</option>
                                                                    <option value="APPROVED" ${param.status=='APPROVED'
                                                                        ? 'selected' : '' }>Thành công</option>
                                                                    <option value="REJECTED" ${param.status=='REJECTED'
                                                                        ? 'selected' : '' }>Từ chối</option>
                                                                    <option value="PENDING" ${param.status=='PENDING'
                                                                        ? 'selected' : '' }>Chờ xử lý</option>
                                                                </select>
                                                            </div>
                                                            <div>
                                                                <label for="sort" class="fw-bold">Sắp xếp
                                                                    theo:</label>
                                                                <select name="sort" id="sort" class="form-select">
                                                                    <option value="">Mặc định</option>
                                                                    <option value="createdAtDesc"
                                                                        ${param.sort=='createdAtDesc' ? 'selected' : ''
                                                                        }>Mới nhất</option>
                                                                    <option value="createdAtAsc"
                                                                        ${param.sort=='createdAtAsc' ? 'selected' : ''
                                                                        }>Cũ nhất</option>
                                                                    <option value="priceAsc" ${param.sort=='priceAsc'
                                                                        ? 'selected' : '' }>Giá tăng dần</option>
                                                                    <option value="priceDesc" ${param.sort=='priceDesc'
                                                                        ? 'selected' : '' }>Giá giảm dần</option>
                                                                </select>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col-md-6">
                                                                    <label for="fromDate" class="fw-bold">Từ
                                                                        ngày:</label>
                                                                    <input type="date" id="fromDate" name="fromDate"
                                                                        class="form-control"
                                                                        value="${param.fromDate}" />
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label for="toDate" class="fw-bold">Đến
                                                                        ngày:</label>
                                                                    <input type="date" id="toDate" name="toDate"
                                                                        class="form-control" value="${param.toDate}" />
                                                                </div>
                                                            </div>
                                                            <button type="submit" class="btn btn-outline-primary">Áp
                                                                dụng lọc</button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                            <hr />
                                            <table class="table table-bordered table-hover table-fixed">
                                                <thead>
                                                    <tr>
                                                        <th scope="col" class="text-center col-id">ID</th>
                                                        <th scope="col" class="text-center col-transfer-code">Mã giao
                                                            dịch</th>
                                                        <th scope="col" class="text-center col-customer">Phụ huynh</th>
                                                        <th scope="col" class="text-center col-customer">Học sinh</th>
                                                        <th scope="col" class="text-center col-package">Khóa học</th>
                                                        <th scope="col" class="text-center col-amount">Giá tiền</th>
                                                        <th scope="col" class="text-center col-created-at">Ngày thanh
                                                            toán</th>
                                                        <th scope="col" class="text-center col-status">Trạng thái</th>
                                                        <th scope="col" class="text-center col-action">Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="transaction" items="${transactions}">
                                                        <tr>
                                                            <td class="text-center col-id">${transaction.transactionId}
                                                            </td>
                                                            <td class="col-transfer-code">${transaction.transferCode}
                                                            </td>
                                                            <td class="col-customer">${transaction.user.email}</td>
                                                            <td class="col-customer">${transaction.student.email}</td>
                                                            <td class="col-package">
                                                                <div class="d-flex flex-wrap gap-1">
                                                                    <c:forEach var="pkg"
                                                                        items="${transaction.packages}">
                                                                        <a href="/parent/course/detail/${pkg.packageId}"
                                                                            style="text-decoration: none;"
                                                                            target="_blank">
                                                                            <span
                                                                                class="badge bg-secondary d-inline-block">${pkg.name}</span>
                                                                        </a>
                                                                    </c:forEach>
                                                                </div>
                                                            </td>
                                                            <td class="col-amount text-center">
                                                                <fmt:formatNumber value="${transaction.amount}"
                                                                    type="number" groupingUsed="true"
                                                                    maxFractionDigits="2" minFractionDigits="0" /> ₫
                                                            </td>
                                                            <td class="col-created-at text-center">
                                                                <fmt:formatDate
                                                                    value="${transaction.createdAtAsUtilDate}"
                                                                    pattern="dd/MM/yyyy HH:mm:ss" />
                                                            </td>
                                                            <td class="col-status text-center">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${transaction.status.name() == 'APPROVED'}">
                                                                        <span class="badge bg-success">Thành công</span>
                                                                    </c:when>
                                                                    <c:when
                                                                        test="${transaction.status.name() == 'REJECTED'}">
                                                                        <span class="badge bg-danger">Từ chối</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-warning text-dark">Chờ xử
                                                                            lý</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="col-action text-center">
                                                                <div class="d-grid gap-2">
                                                                    <a href="/admin/transaction/${transaction.transactionId}"
                                                                        class="btn btn-success btn-sm w-100">Chi
                                                                        tiết</a>
                                                                    <c:if
                                                                        test="${transaction.status.name() == 'PENDING'}">
                                                                        <form
                                                                            action="/admin/transaction/confirm/${transaction.transactionId}"
                                                                            method="post"
                                                                            onsubmit="return confirm('Bạn có chắc muốn xác nhận giao dịch này?')"
                                                                            style="display:inline;">
                                                                            <input type="hidden"
                                                                                name="${_csrf.parameterName}"
                                                                                value="${_csrf.token}" />
                                                                            <button type="submit"
                                                                                class="btn btn-primary btn-sm w-100">Xác
                                                                                nhận</button>
                                                                        </form>
                                                                        <button type="button"
                                                                            class="btn btn-danger btn-sm w-100"
                                                                            data-bs-toggle="modal"
                                                                            data-bs-target="#rejectModal${transaction.transactionId}">Từ
                                                                            chối</button>
                                                                    </c:if>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <c:if test="${transaction.status eq 'PENDING'}">
                                                            <div class="modal fade"
                                                                id="rejectModal${transaction.transactionId}"
                                                                tabindex="-1"
                                                                aria-labelledby="rejectModalLabel${transaction.transactionId}"
                                                                aria-hidden="true">
                                                                <div class="modal-dialog">
                                                                    <form
                                                                        action="/admin/transaction/reject/${transaction.transactionId}"
                                                                        method="post" class="reject-form"
                                                                        id="rejectForm${transaction.transactionId}">
                                                                        <div class="modal-content">
                                                                            <div class="modal-header">
                                                                                <h5 class="modal-title"
                                                                                    id="rejectModalLabel${transaction.transactionId}">
                                                                                    Từ chối giao dịch</h5>
                                                                                <button type="button" class="btn-close"
                                                                                    data-bs-dismiss="modal"
                                                                                    aria-label="Đóng"></button>
                                                                            </div>
                                                                            <div class="modal-body">
                                                                                <div class="mb-3">
                                                                                    <label
                                                                                        for="reason${transaction.transactionId}"
                                                                                        class="form-label">Lý do từ
                                                                                        chối</label>
                                                                                    <textarea class="form-control"
                                                                                        id="reason${transaction.transactionId}"
                                                                                        name="rejectionReason" rows="4"
                                                                                        required></textarea>
                                                                                    <div class="invalid-feedback"
                                                                                        id="feedback${transaction.transactionId}">
                                                                                        Lý do từ chối phải từ 5 đến 1000
                                                                                        ký tự.
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="modal-footer">
                                                                                <button type="submit"
                                                                                    class="btn btn-danger">Xác nhận từ
                                                                                    chối</button>
                                                                                <button type="button"
                                                                                    class="btn btn-secondary"
                                                                                    data-bs-dismiss="modal">Hủy</button>
                                                                            </div>
                                                                        </div>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                            <div class="pagination-container">
                                                <c:set var="queryString" value="" />
                                                <c:if test="${not empty param.transferCode}">
                                                    <c:set var="queryString"
                                                        value="${queryString}&transferCode=${param.transferCode}" />
                                                </c:if>
                                                <c:if test="${not empty param.email}">
                                                    <c:set var="queryString"
                                                        value="${queryString}&email=${param.email}" />
                                                </c:if>
                                                <c:if test="${not empty param.studentEmail}">
                                                    <c:set var="queryString"
                                                        value="${queryString}&studentEmail=${param.studentEmail}" />
                                                </c:if>
                                                <c:if test="${not empty param.packages}">
                                                    <c:forEach var="pkg" items="${param.packages}">
                                                        <c:set var="queryString"
                                                            value="${queryString}&packages=${pkg}" />
                                                    </c:forEach>
                                                </c:if>
                                                <c:if test="${not empty param.status}">
                                                    <c:set var="queryString"
                                                        value="${queryString}&status=${param.status}" />
                                                </c:if>
                                                <c:if test="${not empty param.sort}">
                                                    <c:set var="queryString"
                                                        value="${queryString}&sort=${param.sort}" />
                                                </c:if>
                                                <c:if test="${not empty param.fromDate}">
                                                    <c:set var="queryString"
                                                        value="${queryString}&fromDate=${param.fromDate}" />
                                                </c:if>
                                                <c:if test="${not empty param.toDate}">
                                                    <c:set var="queryString"
                                                        value="${queryString}&toDate=${param.toDate}" />
                                                </c:if>
                                                <c:if test="${totalPage > 1}">
                                                    <nav aria-label="Page navigation example">
                                                        <ul class="pagination justify-content-center">
                                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                                <a class="page-link"
                                                                    href="/admin/transaction?page=1${queryString}"
                                                                    aria-label="First">
                                                                    <span aria-hidden="true">««</span>
                                                                </a>
                                                            </li>
                                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                                <a class="page-link"
                                                                    href="/admin/transaction?page=${currentPage - 1}${queryString}"
                                                                    aria-label="Previous">
                                                                    <span aria-hidden="true">«</span>
                                                                </a>
                                                            </li>
                                                            <c:set var="startPage" value="${currentPage - 2}" />
                                                            <c:set var="endPage" value="${currentPage + 2}" />
                                                            <c:if test="${startPage < 1}">
                                                                <c:set var="startPage" value="1" />
                                                                <c:set var="endPage" value="${startPage + 4}" />
                                                            </c:if>
                                                            <c:if test="${endPage > totalPage}">
                                                                <c:set var="endPage" value="${totalPage}" />
                                                                <c:set var="startPage"
                                                                    value="${endPage - 4 > 0 ? endPage - 4 : 1}" />
                                                            </c:if>
                                                            <c:forEach begin="${startPage}" end="${endPage}"
                                                                varStatus="loop">
                                                                <li
                                                                    class="page-item ${loop.index == currentPage ? 'active' : ''}">
                                                                    <a class="page-link"
                                                                        href="/admin/transaction?page=${loop.index}${queryString}">${loop.index}</a>
                                                                </li>
                                                            </c:forEach>
                                                            <li
                                                                class="page-item ${currentPage == totalPage ? 'disabled' : ''}">
                                                                <a class="page-link"
                                                                    href="/admin/transaction?page=${currentPage + 1}${queryString}"
                                                                    aria-label="Next">
                                                                    <span aria-hidden="true">»</span>
                                                                </a>
                                                            </li>
                                                            <li
                                                                class="page-item ${currentPage == totalPage ? 'disabled' : ''}">
                                                                <a class="page-link"
                                                                    href="/admin/transaction?page=${totalPage}${queryString}"
                                                                    aria-label="Last">
                                                                    <span aria-hidden="true">»»</span>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </nav>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                            </main>
                        </div>
                    </div>
                    <footer>
                        <jsp:include page="../layout/footer.jsp" />
                    </footer>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            const packageSelect = document.getElementById('packageSelect');
                            if (packageSelect) {
                                new Choices(packageSelect, {
                                    removeItemButton: true,
                                    placeholder: true,
                                    placeholderValue: 'Chọn khóa học...',
                                    searchEnabled: true,
                                    searchPlaceholderValue: 'Tìm kiếm...',
                                    noResultsText: 'Không tìm thấy',
                                    itemSelectText: '',
                                });
                            }

                            // Validate all reject forms
                            document.querySelectorAll('.reject-form').forEach(function (form) {
                                form.addEventListener('submit', function (event) {
                                    event.preventDefault(); // Prevent default submission
                                    const transactionId = form.id.replace('rejectForm', '');
                                    const textarea = document.getElementById('reason' + transactionId);
                                    const feedback = document.getElementById('feedback' + transactionId);
                                    const value = textarea.value.trim();
                                    const isValid = value.length >= 5 && value.length <= 1000;

                                    if (!isValid) {
                                        textarea.classList.add('is-invalid');
                                        feedback.style.display = 'block';
                                    } else {
                                        textarea.classList.remove('is-invalid');
                                        feedback.style.display = 'none';
                                        form.submit(); // Proceed with form submission
                                    }
                                });
                            });

                            // Clear validation state for all modals when they are closed
                            document.querySelectorAll('.modal.fade').forEach(function (modal) {
                                modal.addEventListener('hidden.bs.modal', function () {
                                    const transactionId = modal.id.replace('rejectModal', '');
                                    const textarea = document.getElementById('reason' + transactionId);
                                    const feedback = document.getElementById('feedback' + transactionId);
                                    if (textarea && feedback) {
                                        textarea.classList.remove('is-invalid');
                                        feedback.style.display = 'none';
                                        textarea.value = ''; // Clear textarea
                                    }
                                });
                            });
                        });
                    </script>
                </body>

                </html>