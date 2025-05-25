<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
            <style>
                body {
                    margin: 0;
                    min-height: 100vh;
                    display: flex;
                    flex-direction: column;
                    overflow-x: hidden;
                }

                .sidebar {
                    position: fixed;
                    top: 55px;
                    left: 0;
                    width: 250px;
                    height: calc(100vh - 55px);
                    z-index: 1;
                    background-color: #212529;
                    overflow-y: auto;
                }

                header {
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    z-index: 3;
                    background-color: #212529;
                }

                .content {
                    margin-left: 250px;
                    margin-top: 60px;
                    padding: 20px;
                    flex: 1;
                    min-height: calc(100vh - 60px);
                    /* Ensure content pushes footer down */
                }

                footer {
                    background-color: #212529;
                    height: 40px;
                    width: 100%;
                }
            </style>
        </head>

        <body>
            <!-- Include Header -->
            <header>
                <jsp:include page="../layout/header.jsp" />
            </header>

            <!-- Include Sidebar -->
            <div class="sidebar">
                <jsp:include page="../layout/sidebar.jsp" />
            </div>

            <!-- Main Content Area -->
            <div class="content">
                <main>
                    <div class="container-fluid px-4">
                        <h1 class="mt-4">Manage users</h1>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item active"><a href="/admin">Dashboard</a></li>
                            <li class="breadcrumb-item active">Users</li>
                        </ol>
                        <div class="mt-5">
                            <div class="row col-12 mx-auto">
                                <div class="d-flex justify-content-between mb-3">
                                    <h3>Table users</h3>
                                    <a href="/admin/user/create" class="btn btn-primary">Create a content manager</a>
                                </div>
                                <hr />
                                <table class="table table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th scope="col">ID</th>
                                            <th scope="col">Email</th>
                                            <th scope="col">Full Name</th>
                                            <th scope="col">Role</th>
                                            <th scope="col">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>${user.userId}</td>
                                                <td>${user.email}</td>
                                                <td>${user.fullName}</td>
                                                <td>${user.role.roleName}</td>
                                                <td>
                                                    <a href="/admin/user/${user.userId}"
                                                        class="btn btn-success">view</a>
                                                    <a href="/admin/user/update/${user.userId}"
                                                        class="btn btn-warning mx-2">update</a>
                                                    <a href="/admin/user/delete/${user.userId}"
                                                        class="btn btn-danger">delete</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </main>
            </div>

            <!-- Include Footer -->
            <footer>
                <jsp:include page="../layout/footer.jsp" />
            </footer>

            <!-- Bootstrap 5 JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>