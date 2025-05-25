<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PLS - Manage Users</title>
            <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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
                            <div class="mt-5">
                                <div class="row col-12 mx-auto">
                                    <div class="d-flex justify-content-between mb-3">
                                        <h3>Table users</h3>
                                        <a href="/admin/user/create" class="btn btn-primary">Create User</a>
                                    </div>
                                    <hr />
                                    <table class="table table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th scope="col" class="text-center">ID</th>
                                                <th scope="col" class="text-center">Email</th>
                                                <th scope="col" class="text-center">Full Name</th>
                                                <th scope="col" class="text-center">Role</th>
                                                <th scope="col" class="text-center">Action</th>
                                            </tr>

                                        </thead>
                                        <tbody>
                                            <c:forEach var="user" items="${users}">
                                                <tr>
                                                    <td class="text-center">${user.userId}</td>
                                                    <td>${user.email}</td>
                                                    <td>${user.fullName}</td>
                                                    <td>${user.role.roleName}</td>
                                                    <td class="text-center">
                                                        <div class="d-flex justify-content-center gap-2">
                                                            <a href="/admin/user/${user.userId}"
                                                                class="btn btn-success btn-sm">View</a>
                                                            <a href="/admin/user/update/${user.userId}"
                                                                class="btn btn-warning btn-sm">Update</a>
                                                        </div>
                                                    </td>

                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
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