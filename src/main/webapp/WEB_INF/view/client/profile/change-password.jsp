<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đổi mật khẩu</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
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
    <jsp:include page="../layout/header.jsp"/>
</header>

<div class="change-password-page mt-5">
    <div class="container py-5">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3">
                <jsp:include page="../layout/sidebar.jsp"/>
            </div>

            <!-- Main Content -->
            <div class="col-md-9">
                <div class="password-change-content">
                    <h3>Đổi mật khẩu</h3>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger mt-3 alert-dismissible fade show" role="alert">
                                ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success mt-3 alert-dismissible fade show" role="alert" id="successAlert">
                                ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <form:form action="/account/profile/change-password" method="post" modelAttribute="passwordChangeRequest" id="changePasswordForm">
                        <div class="password-form-section">
                            <div class="row d-flex justify-content-lg-start" style="width: 80%">
                                <div class="col-md-7 mb-3">
                                    <label for="oldPassword" class="form-label">Mật khẩu cũ</label>
                                    <form:input type="password" class="form-control form-item" id="oldPassword" path="oldPassword"  required="true" />
                                    <c:set var="errorOldPassword">
                                        <form:errors path="oldPassword" cssClass="text-danger" />
                                    </c:set>
                                        ${errorOldPassword}
                                </div>
                                <div class="col-md-7  mb-3">
                                    <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                    <form:input type="password" class="form-control form-item" id="newPassword" path="newPassword"  required="true" />
                                    <c:set var="errorNewPassword">
                                        <form:errors path="newPassword" cssClass="text-danger" />
                                    </c:set>
                                        ${errorNewPassword}
                                </div>
                                <div class="col-md-7  mb-3">
                                    <label for="confirmNewPassword" class="form-label">Nhập lại mật khẩu mới</label>
                                    <input type="password" class="form-control form-item" id="confirmNewPassword" name="confirmNewPassword" required="true" />
                                    <div id="confirmPasswordError" class="text-danger" style="display: none;">Mật khẩu nhập lại không khớp!</div>
                                </div>
                            </div>
                            <div class="col-md-2 mt-2 d-flex justify-content-center">
                                <button type="submit" class="btn btn-save-password">Lưu thay đổi</button>
                            </div>
                        </div>
                    </form:form>
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
<script>
    $(document).ready(() => {
        $("#changePasswordForm").submit(function (event) {
            const newPassword = $("#newPassword").val();
            const confirmNewPassword = $("#confirmNewPassword").val();
            const confirmPasswordError = $("#confirmPasswordError");

            if (newPassword !== confirmNewPassword) {
                confirmPasswordError.show();
                event.preventDefault();
            } else {
                confirmPasswordError.hide();
            }
        });

        // Xóa thông báo lỗi khi người dùng nhập lại
        $("#newPassword, #confirmNewPassword").on("input", function () {
            $("#confirmPasswordError").hide();
        });
    });
</script>
</body>
</html>