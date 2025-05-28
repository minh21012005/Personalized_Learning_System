<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>PLS - Admin - Dashboard</title>
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