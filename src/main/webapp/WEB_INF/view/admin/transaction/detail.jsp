<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>PLS - Chi tiết giao dịch</title>
                <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                    rel="stylesheet">
                <style>
                    .table th {
                        white-space: nowrap;
                    }

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
                        display: flex;
                        justify-content: center;
                    }

                    footer {
                        background-color: #1a252f;
                        color: white;
                        height: 40px;
                        width: 100%;
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
                        <div style="width: 70%;">
                            <div class="mt-3">
                                <h2 class="text-center">Chi tiết giao dịch</h2>
                                <hr />
                                <div class="card">
                                    <div class="card-header">
                                        Thông tin giao dịch
                                    </div>
                                    <div class="card-body p-0">
                                        <table class="table table-bordered table-hover mb-0">
                                            <tbody>
                                                <tr>
                                                    <th>ID</th>
                                                    <td>${transaction.transactionId}</td>
                                                </tr>
                                                <tr>
                                                    <th>Mã giao dịch</th>
                                                    <td>${transaction.transferCode}</td>
                                                </tr>
                                                <tr>
                                                    <th>Phụ huynh</th>
                                                    <td>${transaction.user.email}</td>
                                                </tr>
                                                <tr>
                                                    <th>Học sinh</th>
                                                    <td>${transaction.student.email}</td>
                                                </tr>
                                                <tr>
                                                    <th>Khóa học</th>
                                                    <td>
                                                        <div class="d-flex flex-wrap gap-1">
                                                            <c:forEach var="pkg" items="${transaction.packages}">
                                                                <a href="/parent/course/detail/${pkg.packageId}"
                                                                    style="text-decoration: none;" target="_blank"><span
                                                                        class="badge bg-secondary text-wrap">${pkg.name}</span></a>
                                                            </c:forEach>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Số tiền</th>
                                                    <td>
                                                        <fmt:formatNumber value="${transaction.amount}" type="number"
                                                            groupingUsed="true" maxFractionDigits="2"
                                                            minFractionDigits="0" /> ₫
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Nội dung</th>
                                                    <td>${transaction.addInfo}</td>
                                                </tr>
                                                <tr>
                                                    <th>Ngày thanh toán</th>
                                                    <td>
                                                        <fmt:formatDate value="${transaction.createdAtAsUtilDate}"
                                                            pattern="dd/MM/yyyy HH:mm:ss" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Trạng thái</th>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${transaction.status.name() == 'APPROVED'}">
                                                                <span class="badge bg-success">Thành công</span>
                                                            </c:when>
                                                            <c:when test="${transaction.status.name() == 'REJECTED'}">
                                                                <span class="badge bg-danger">Từ chối</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-warning text-dark">Chờ xử
                                                                    lý</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Ghi chú</th>
                                                    <td>
                                                        <c:out value="${transaction.note}" default="Không có" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Ảnh minh chứng</th>
                                                    <td>
                                                        <c:if test="${not empty transaction.evidenceImage}">
                                                            <img src="/img/transaction/${transaction.evidenceImage}"
                                                                alt="Ảnh minh chứng" class="img-fluid border rounded"
                                                                style="max-height: 200px;" />
                                                        </c:if>
                                                        <c:if test="${empty transaction.evidenceImage}">
                                                            Không có
                                                        </c:if>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Người xử lý</th>
                                                    <td>
                                                        <c:out value="${transaction.processedBy.fullName}"
                                                            default="Chưa xử lý" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Thời điểm xử lí</th>
                                                    <td>
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
                                                    </td>
                                                </tr>
                                                <c:if test="${not empty transaction.rejectedAt}">
                                                    <tr>
                                                        <th>Lý do từ chối</th>
                                                        <td>
                                                            <c:out value="${transaction.rejectionReason}"
                                                                default="Không có" />
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="mt-3 mb-3 d-flex gap-2 flex-wrap">
                                    <c:if test="${transaction.status.name() == 'PENDING'}">
                                        <form action="/admin/transaction/confirm/${transaction.transactionId}"
                                            method="post">
                                            <button type="submit" class="btn btn-success"
                                                onclick="return confirm('Bạn có chắc muốn xác nhận giao dịch này?')">Xác
                                                nhận</button>
                                        </form>
                                        <button type="button" class="btn btn-danger" data-bs-toggle="modal"
                                            data-bs-target="#rejectModal">Từ chối</button>
                                        <div class="modal fade" id="rejectModal" tabindex="-1"
                                            aria-labelledby="rejectModalLabel" aria-hidden="true">
                                            <div class="modal-dialog">
                                                <form action="/admin/transaction/reject/${transaction.transactionId}"
                                                    method="post" id="rejectForm">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="rejectModalLabel">Nhập lý do từ
                                                                chối</h5>
                                                            <button type="button" class="btn-close"
                                                                data-bs-dismiss="modal" aria-label="Đóng"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <label for="rejectionReason" class="form-label">Lý do từ
                                                                    chối:</label>
                                                                <textarea class="form-control" id="rejectionReason"
                                                                    name="rejectionReason" rows="4" required></textarea>
                                                                <div class="invalid-feedback" id="feedback">Lý do từ
                                                                    chối phải từ 5 đến 1000 ký tự.</div>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="submit" class="btn btn-danger">Xác nhận từ
                                                                chối</button>
                                                            <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Hủy</button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </c:if>
                                    <a href="/admin/transaction" class="btn btn-primary">Quay lại</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <footer>
                    <jsp:include page="../layout/footer.jsp" />
                </footer>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const form = document.getElementById('rejectForm');
                        const textarea = document.getElementById('rejectionReason');
                        const feedback = document.getElementById('feedback');

                        form.addEventListener('submit', function (event) {
                            event.preventDefault(); // Prevent default submission
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

                        // Clear validation state when modal is closed
                        document.getElementById('rejectModal').addEventListener('hidden.bs.modal', function () {
                            textarea.classList.remove('is-invalid');
                            feedback.style.display = 'none';
                            textarea.value = ''; // Clear textarea
                        });
                    });
                </script>
            </body>

            </html>