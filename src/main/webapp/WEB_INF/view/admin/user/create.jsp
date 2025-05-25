<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>PLS - Create User</title>
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
                            $("#avatarPreview").css({ "display": "block" });
                        });
                    });
                </script>
            </head>

            <body>
                <!-- Header -->
                <header>
                    <jsp:include page="../layout/header.jsp" />
                </header>

                <!-- Main Container for Sidebar and Content -->
                <div class="main-container">
                    <!-- Sidebar -->
                    <div class="sidebar d-flex flex-column">
                        <jsp:include page="../layout/sidebar.jsp" />
                    </div>

                    <!-- Main Content Area -->
                    <div class="content">
                        <main>
                            <div class="container-fluid px-4">
                                <div class="row mt-2">
                                    <div class="col-md-6 col-12 mx-auto">
                                        <h1>Create a user</h1>
                                        <hr />
                                        <form:form method="post" action="/admin/user/create" modelAttribute="newUser"
                                            enctype="multipart/form-data">
                                            <div class="mb-3">
                                                <c:set var="errorEmail">
                                                    <form:errors path="email" cssClass="invalid-feedback" />
                                                </c:set>
                                                <label for="exampleInputEmail1" class="form-label">Email</label>
                                                <form:input type="email"
                                                    class="form-control ${not empty errorEmail?'is-invalid':''}"
                                                    id="exampleInputEmail1" path="email" />
                                                ${errorEmail}
                                            </div>
                                            <div class="mb-3">
                                                <c:set var="errorPassword">
                                                    <form:errors path="password" cssClass="invalid-feedback" />
                                                </c:set>
                                                <label for="exampleInputPassword1" class="form-label">Password</label>
                                                <form:input type="password"
                                                    class="form-control ${not empty errorPassword?'is-invalid':''}"
                                                    id="exampleInputPassword1" path="password" />
                                                ${errorPassword}
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-12 mb-3">
                                                    <c:set var="errorFullName">
                                                        <form:errors path="fullName" cssClass="invalid-feedback" />
                                                    </c:set>
                                                    <label for="exampleInputName" class="form-label">Full name</label>
                                                    <form:input type="text"
                                                        class="form-control ${not empty errorFullName?'is-invalid':''}"
                                                        id="exampleInputName" path="fullName" />
                                                    ${errorFullName}
                                                </div>
                                                <div class="col-md-6 col-12 mb-3">
                                                    <c:set var="errorPhone">
                                                        <form:errors path="phoneNumber" cssClass="invalid-feedback" />
                                                    </c:set>
                                                    <label for="exampleInputPhoneNumber" class="form-label">Phone
                                                        number</label>
                                                    <form:input type="text"
                                                        class="form-control ${not empty errorPhone?'is-invalid':''}"
                                                        id="exampleInputPhoneNumber" path="phoneNumber" />
                                                    ${errorPhone}
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-12 mb-3">
                                                    <c:set var="errorDob">
                                                        <form:errors path="dob" cssClass="invalid-feedback" />
                                                    </c:set>
                                                    <label for="dob" class="form-label">Date of birth</label>
                                                    <form:input type="date"
                                                        class="form-control ${not empty errorDob?'is-invalid':''}"
                                                        id="dob" path="dob" />
                                                    ${errorDob}
                                                </div>
                                                <div class="col-md-6 col-12 mb-3">
                                                    <label class="form-label d-block">Status</label>
                                                    <div class="form-check form-check-inline">
                                                        <form:radiobutton checked="true" path="isActive" value="true"
                                                            cssClass="form-check-input" id="activeTrue" />
                                                        <label class="form-check-label" for="activeTrue">Active</label>
                                                    </div>
                                                    <div class="form-check form-check-inline">
                                                        <form:radiobutton path="isActive" value="false"
                                                            cssClass="form-check-input" id="activeFalse" />
                                                        <label class="form-check-label"
                                                            for="activeFalse">Inactive</label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 col-12">
                                                    <label for="select" class="form-lable mb-2">Role</label>
                                                    <form:select class="form-select" aria-label="Default select example"
                                                        id="select" path="role.roleName">
                                                        <form:option value="ADMIN">ADMIN</form:option>
                                                        <form:option value="CONTENT_MANAGER">CONTENT MANAGER
                                                        </form:option>
                                                    </form:select>
                                                </div>
                                                <div class="col-md-6 col-12">
                                                    <label for="avatarFile" class="form-label">Avatar:</label>
                                                    <input class="form-control" type="file" id="avatarFile" name="file"
                                                        accept=".png, .jpg, .jpeg" />
                                                    <c:if test="${not empty fileError}">
                                                        <div class="invalid-feedback d-block">${fileError}</div>
                                                    </c:if>
                                                </div>
                                                <div class="col-12 mt-3">
                                                    <img style="max-height: 250px; display: none;" alt="Image not found"
                                                        id="avatarPreview" />
                                                </div>
                                            </div>
                                            <div class="mt-3 d-flex gap-2 mb-3">
                                                <button type="submit" class="btn btn-primary">Create</button>
                                                <a href="/admin/user" class="btn btn-secondary">Cancel</a>
                                            </div>
                                        </form:form>
                                    </div>
                                </div>
                        </main>
                    </div>
                </div>

                <!-- Footer -->
                <footer>
                    <jsp:include page="../layout/footer.jsp" />
                </footer>

                <!-- Bootstrap JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>