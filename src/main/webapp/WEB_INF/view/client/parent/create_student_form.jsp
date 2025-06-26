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
        body {
            background-color: #f8f9fa;
        }
        .form-container {
            max-width: 700px;
            margin: 50px auto;
            padding: 40px;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 6px 25px rgba(0, 0, 0, 0.07);
        }

        .form-title {
            margin-bottom: 35px;
            font-weight: 600;
            color: #212529;
        }

        .form-label {
            font-weight: 500;
            color: #495057;
        }
        
        .form-control:focus {
            border-color: #86b7fe;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }

        .form-error {
            color: #dc3545;
            font-size: 0.875em;
            margin-top: 0.25rem;
        }
        
        .btn-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        
        .main-content {
            padding-top: 80px;
            padding-bottom: 50px;
        }
    </style>
</head>

<body>
    <div class="main-content">
        <div class="container">
            <div class="form-container">
                <h2 class="text-center form-title">Tạo tài khoản mới cho con</h2>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                         <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty fileError}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${fileError}
                         <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form:form modelAttribute="studentRequest" method="post"
                    action="${pageContext.request.contextPath}/parent/create-student"
                    enctype="multipart/form-data">

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="fullName" class="form-label">Họ và tên</label>
                            <form:input path="fullName" cssClass="form-control" id="fullName" placeholder="Nguyễn Văn An" />
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
                            <form:input path="email" cssClass="form-control" id="email" placeholder="emailcuacon@example.com" />
                            <form:errors path="email" cssClass="form-error" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="phoneNumber" class="form-label">Số điện thoại</label>
                            <form:input path="phoneNumber" cssClass="form-control" id="phoneNumber" placeholder="0912345678" />
                            <form:errors path="phoneNumber" cssClass="form-error" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <form:password path="password" cssClass="form-control" id="password" placeholder="Tối thiểu 8 ký tự"/>
                        <form:errors path="password" cssClass="form-error" />
                    </div>
                    
                    <div class="mb-4">
                        <label for="avatarFile" class="form-label">Ảnh đại diện (Không bắt buộc)</label>
                        <input type="file" class="form-control" name="avatarFile" id="avatarFile" accept="image/png, image/jpeg, image/jpg">
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <a href="${pageContext.request.contextPath}/parent/homepage/show" class="btn btn-outline-secondary px-4">Hủy</a>
                        <button type="submit" class="btn btn-primary px-4">Tạo tài khoản</button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</body>
</html>