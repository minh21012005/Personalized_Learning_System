<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>PLS - User Details</title>
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
                        <div style="width: 60%;">
                            <div class="mt-3">
                                <h2 class="text-center">User detail</h2>
                                <hr />
                                <div class="card">
                                    <div class="card-header">
                                        User Information
                                    </div>
                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item">Id: ${user.userId}</li>
                                        <li class="list-group-item">Email: ${user.email}</li>
                                        <li class="list-group-item">Full Name: ${user.fullName}</li>
                                        <li class="list-group-item">Phone number: ${user.phoneNumber}</li>
                                        <li class="list-group-item">Role: ${user.role.roleName}</li>
                                        <li class="list-group-item">Date of Birth: ${dobFormatted}</li>
                                        <li class="list-group-item">Status: ${user.isActive ? 'Active' : 'Inactive'}
                                        </li>
                                        <li class="list-group-item">
                                            <label for="avatarFile" class="form-label">Avatar:</label>
                                            <div class="col-12 mt-3">
                                                <img style="max-height: 250px" src="/img/avatar/${user.avatar}"
                                                    alt="Image not found" />
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                                <div class="mt-3 mb-3">
                                    <a href="/admin/user" class="btn btn-primary">Back</a>
                                </div>
                            </div>
                        </div>
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