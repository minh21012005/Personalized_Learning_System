<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta charset="utf-8"/>
    <title>Thanh toán - PLS</title>
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
    <link rel="stylesheet" href="/css/checkout.css">
</head>

<body>
<div class="checkout-minhnb">
    <div class="container">
        <jsp:include page="../layout/header.jsp"/>
        <main class="main-content">
            <div class="payment-info">
                <section class="qr-section">
                    <h2 class="section-title">Quét QR để thanh toán</h2>
                    <img src="${qrUrl}" alt="QR Code for payment" class="qr-code"/>
                    <div class="total-amount">
                        <span class="amount-label">Tổng tiền</span>
                        <span class="amount-value">
                                                <fmt:formatNumber value="${amount}" type="number" groupingUsed="true"/>
                                                VND
                                            </span>
                    </div>
                </section>
                <section class="payment-form">
                    <form:form modelAttribute="transaction" method="post"
                               enctype="multipart/form-data" action="/parent/checkout">
                        <input type="hidden" name="qrUrl" value="${qrUrl}"/>
                        <!-- Số tiền -->
                        <form:input type="hidden" path="amount" name="amount" value="${amount}"/>

                        <!-- Danh sách gói -->
                        <c:forEach var="pkgId" items="${packageIds}">
                            <input type="hidden" name="packageIds" value="${pkgId}"/>
                        </c:forEach>

                        <!-- Mã giao dịch -->
                        <div class="form-group">
                            <c:set var="errorTransferCode">
                                <form:errors path="transferCode" cssClass="invalid-feedback"/>
                            </c:set>
                            <label for="transaction-id">Mã giao dịch</label>
                            <form:input path="transferCode" id="transaction-id"
                                        placeholder="Nhập mã giao dịch"
                                        cssClass="form-control ${not empty errorTransferCode?'is-invalid':''}"
                                        required="true"/>
                                ${errorTransferCode}
                        </div>

                        <!-- Ghi chú -->
                        <div class="form-group">
                            <c:set var="errorNote">
                                <form:errors path="note" cssClass="invalid-feedback"/>
                            </c:set>
                            <label for="notes">Ghi chú (nếu có)</label>
                            <form:textarea path="note" id="notes" rows="3"
                                           cssClass="form-control ${not empty errorNote?'is-invalid':''}"/>
                                ${errorNote}
                        </div>

                        <!-- Nội dung chuyển khoản -->
                        <div class="form-group">
                            <label for="transfer-content">Nội dung chuyển khoản</label>
                            <form:input path="addInfo" id="transfer-content" readonly="true"
                                        cssClass="form-control" value="${addInfo}"/>
                        </div>

                        <!-- Chọn học sinh -->
                        <div class="form-group">
                            <label for="studentId">Chọn học sinh</label>
                            <select name="studentId" id="studentId"
                                    class="form-control ${not empty studentIdError?'is-invalid':''}">
                                <option value="">-- Vui lòng chọn --</option>
                                <c:forEach var="s" items="${students}">
                                    <option value="${s.userId}" ${param.studentId==s.userId
                                            ? 'selected' : '' }>
                                            ${s.fullName}
                                    </option>
                                </c:forEach>
                            </select>
                            <c:if test="${not empty studentIdError}">
                                <div class="invalid-feedback d-block">${studentIdError}</div>
                            </c:if>
                        </div>


                        <!-- Ảnh biên lai -->
                        <div class="form-group">
                            <label for="receipt-upload">Ảnh biên lai</label>
                            <div class="file-upload-container">
                                <div class="file-upload">
                                    <input type="file" id="receipt-upload" name="image"
                                           accept="image/*"/>
                                </div>
                                <img id="image-preview" class="image-preview" alt="Image Preview"/>
                            </div>
                            <c:if test="${not empty fileError}">
                                <div class="invalid-feedback d-block">${fileError}</div>
                            </c:if>
                        </div>

                        <!-- Nút submit -->
                        <div class="button-container">
                            <button type="submit" class="confirm-button">Xác nhận thanh toán thành
                                công
                            </button>
                        </div>
                    </form:form>

                </section>
            </div>
        </main>

    </div>

</div>
<footer style="margin-top: 100px;">
    <jsp:include page="../layout/footer.jsp"/>
</footer>
<script>
    document.getElementById('receipt-upload').addEventListener('change', function (event) {
        const file = event.target.files[0];
        const preview = document.getElementById('image-preview');
        if (file) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            preview.src = '';
            preview.style.display = 'none';
        }
    });
</script>
</body>

</html>