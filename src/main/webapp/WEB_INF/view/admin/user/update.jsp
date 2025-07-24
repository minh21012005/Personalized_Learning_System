<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Cập nhật tài khoản</title>
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
          rel="stylesheet">
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
        }

        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
        }
    </style>
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        $(document).ready(() => {
            const avatarFile = $("#avatarFile");
            avatarFile.change(function (e) {
                const imgURL = URL.createObjectURL(e.target.files[0]);
                $("#avatarPreview").attr("src", imgURL);
                $("#avatarPreview").css({"display": "block"});
            });
        });
    </script>
</head>

<body>
<!-- Header -->
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>

<!-- Main Container for Sidebar and Content -->
<div class="main-container">
    <!-- Sidebar -->
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../layout-admin/sidebar.jsp"/>
    </div>

    <!-- Main Content Area -->
    <div class="content">
        <main>
            <div class="container-fluid px-4">
                <div class="row mt-3">
                    <div class="col-md-6 col-12 mx-auto">
                        <h1>Cập nhật tài khoản</h1>
                        <hr/>
                        <form:form method="post" action="/super-admin/user/update" modelAttribute="user"
                                   enctype="multipart/form-data">
                            <form:input type="hidden" path="userId"/>
                            <div class="mb-3">
                                <c:set var="errorEmail">
                                    <form:errors path="email" cssClass="invalid-feedback"/>
                                </c:set>
                                <label for="exampleInputEmail1" class="form-label">Email</label>
                                <form:input type="email" readonly="true"
                                            class="form-control ${not empty errorEmail?'is-invalid':''}"
                                            id="exampleInputEmail1" path="email"/>
                                    ${errorEmail}
                            </div>
                            <form:input type="hidden" path="password"/>
                            <form:input type="hidden" path="emailVerify"/>
                            <div class="row">
                                <div class="col-md-6 col-12 mb-3">
                                    <c:set var="errorFullName">
                                        <form:errors path="fullName" cssClass="invalid-feedback"/>
                                    </c:set>
                                    <label for="exampleInputName" class="form-label">Họ và tên</label>
                                    <form:input type="text"
                                                class="form-control ${not empty errorFullName?'is-invalid':''}"
                                                id="exampleInputName" path="fullName"/>
                                        ${errorFullName}
                                </div>
                                <div class="col-md-6 col-12 mb-3">
                                    <c:set var="errorPhone">
                                        <form:errors path="phoneNumber" cssClass="invalid-feedback"/>
                                    </c:set>
                                    <label for="exampleInputPhoneNumber" class="form-label">Số điện
                                        thoại</label>
                                    <form:input type="text"
                                                class="form-control ${not empty errorPhone?'is-invalid':''}"
                                                id="exampleInputPhoneNumber" path="phoneNumber"/>
                                        ${errorPhone}
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 col-12 mb-3">
                                    <c:set var="errorDob">
                                        <form:errors path="dob" cssClass="invalid-feedback"/>
                                    </c:set>
                                    <label for="dob" class="form-label">Ngày sinh</label>
                                    <form:input type="date"
                                                class="form-control ${not empty errorDob?'is-invalid':''}"
                                                id="dob" path="dob"/>
                                        ${errorDob}
                                </div>
                                <div class="col-md-6 col-12 mb-3">
                                    <label class="form-label d-block">Trạng thái</label>
                                    <div class="form-check form-check-inline">
                                        <form:radiobutton checked="true" path="isActive" value="true"
                                                          cssClass="form-check-input" id="activeTrue"/>
                                        <label class="form-check-label" for="activeTrue">Active</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <form:radiobutton path="isActive" value="false"
                                                          cssClass="form-check-input" id="activeFalse"/>
                                        <label class="form-check-label"
                                               for="activeFalse">Inactive</label>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 col-12">
                                    <label for="select" class="form-label mb-2">Vai trò</label>
                                    <form:select class="form-select" aria-label="Default select example"
                                                 id="select" path="role.roleName">
                                        <form:options items="${roles}" itemValue="roleName"
                                                      itemLabel="roleDescription"/>
                                    </form:select>
                                </div>
                                <div class="col-md-6 col-12">
                                    <label for="avatarFile" class="form-label">Avatar:</label>
                                    <input class="form-control" type="file" id="avatarFile" name="file"
                                           accept=".png, .jpg, .jpeg"/>
                                    <c:if test="${not empty fileError}">
                                        <div class="invalid-feedback d-block">${fileError}</div>
                                    </c:if>
                                </div>
                                <div class="col-12 mt-3">
                                    <c:choose>
                                        <c:when test="${not empty user.avatar}">
                                            <img style="max-height: 250px; display: block"
                                                 alt="Image not found" id="avatarPreview"
                                                 src="/img/avatar/${user.avatar}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img style="max-height: 250px; display: none"
                                                 alt="Image not found" id="avatarPreview" src="#"/>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <form:input type="hidden" path="avatar"/>
                            </div>
                            <div class="mt-3 d-flex gap-2 mb-3">
                                <button type="submit" class="btn btn-primary">Cập nhật</button>
                                <a href="/super-admin/user" class="btn btn-secondary">Hủy</a>
                            </div>
                        </form:form>
                    </div>
                </div>
        </main>
    </div>
</div>

<!-- Footer -->
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>