<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo tài khoản cho con</title>
    <jsp:include page="../layout/header.jsp" />
    <style>
        .form-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        .form-title {
            margin-bottom: 30px;
            color: #333;
        }

        .form-error {
            color: #dc3545;
            font-size: 0.875em;
        }
    </style>
</head>

<body>
    <div class="main-content" style="padding-top: 100px;">
        <div class="container">
            <div class="form-container">
                <h2 class="text-center form-title">Tạo tài khoản cho con</h2>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${successMessage}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger" role="alert">${errorMessage}</div>
                </c:if>
                <c:if test="${not empty fileError}">
                    <div class="alert alert-danger">${fileError}</div>
                </c:if>

                <form:form modelAttribute="studentRequest" method="post"
                    action="${pageContext.request.contextPath}/parent/create-student"
                    enctype="multipart/form-data">
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="fullName" class="form-label">Họ và tên</label>
                            <form:input path="fullName" cssClass="form-control" id="fullName" placeholder="Nguyễn Văn A" />
                            <form:errors path="fullName" cssClass="form-error" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="dob" class="form-label">Ngày sinh</label>
                            <form:input type="date" path="dob" cssClass="form-control" id="dob" />
                            <form:errors path="dob" cssClass="form-error" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">Email</label>
                            <form:input path="email" cssClass="form-control" id="email" placeholder="student@example.com" />
                            <form:errors path="email" cssClass="form-error" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="phoneNumber" class="form-label">Số điện thoại</label>
                            <form:input path="phoneNumber" cssClass="form-control" id="phoneNumber" placeholder="0912345678" />
                            <form:errors path="phoneNumber" cssClass="form-error" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-12 mb-3">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <form:password path="password" cssClass="form-control" id="password" />
                            <form:errors path="password" cssClass="form-error" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Trạng thái</label>
                            <div class="d-flex align-items-center" style="height: 38px;">
                                <div class="form-check me-4">
                                    <form:radiobutton path="isActive" id="active" value="true" cssClass="form-check-input" />
                                    <label class="form-check-label" for="active">Active</label>
                                </div>
                                <div class="form-check">
                                    <form:radiobutton path="isActive" id="inactive" value="false" cssClass="form-check-input" />
                                    <label class="form-check-label" for="inactive">Inactive</label>
                                </div>
                            </div>
                            <form:errors path="isActive" cssClass="form-error" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="avatarFile" class="form-label">Avatar</label>
                            <input type="file" class="form-control" name="avatarFile" id="avatarFile">
                        </div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <button type="submit" class="btn btn-primary px-4">Tạo tài khoản</button>
                        <a href="${pageContext.request.contextPath}/parent/homepage/show" class="btn btn-secondary px-4">Hủy</a>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</body>
</html>