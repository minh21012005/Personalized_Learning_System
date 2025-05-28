<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
<style>
    .header-nav {
        color: #64748B;
        border-bottom: 1px solid #E2E8F0
    }
    a:hover {
        text-decoration: none;
    }
    .user-circle {
        width: 40px;
        height: 40px;
        background-color: #6c757d;
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
    }
    .user-avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        object-fit: cover;
        border: 1px solid #ddd;
    }
    .header-icon {
        padding: 0.5rem; /* Adjust padding for the link */
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .header-icon i {
        font-size: 1.5rem; /* Icon size */
        line-height: 1; /* Ensure proper alignment */
        transition: background-color 0.3s ease, color 0.3s ease; /* Smooth transition for background and color */
        padding: 0.5rem; /* Add padding to create space for the background */
        border-radius: 50%; /* Make the background circular */
        display: inline-flex; /* Ensure the icon takes up only its own space */
        align-items: center;
        justify-content: center;
    }
    .header-icon:hover i {
        background-color: #334155; /* Background color on hover */
        color: white; /* Change icon color to white for better contrast */
    }
    .dropdown-item {
        transition: background-color 0.3s ease, color 0.3s ease; /* Smooth transition for dropdown items */
    }
    .dropdown-item:hover {
        background-color: #343a40; /* Background color on hover */
        color: white; /* Text color on hover */
        transition: background-color 0.3s ease, color 0.3s ease;
    }
</style>
<nav class="navbar navbar-expand-md navbar bg-white color header-nav">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <img
                    src="/img/logo.jpg"
                    alt="PLS logo"
                    width="50"
                    height="50"

            />
        </a>
        <button
                class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent"
                aria-expanded="false"
                aria-label="Toggle navigation"
        >
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-md-0">
                <li class="nav-item me-4">
                    <a class="nav-link active" aria-current="page" href="/">Home</a>
                </li>
                <li class="nav-item me-4">
                    <a class="nav-link" href="#">Link</a>
                </li>
                <li class="nav-item dropdown me-4">
                    <a
                            class="nav-link dropdown-toggle"
                            href="#"
                            id="navbarDropdown"
                            role="button"
                            data-bs-toggle="dropdown"
                            aria-expanded="false"
                    >
                        Học thử miễn phí
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="#">Lớp 1</a></li>
                        <li><a class="dropdown-item" href="#">Lớp 2</a></li>
                        <li><a class="dropdown-item" href="#">Lớp 3</a></li>
                        <li><a class="dropdown-item" href="#">Lớp 4</a></li>
                        <li><a class="dropdown-item" href="#">Lớp 5</a></li>
                        <li><a class="dropdown-item" href="#">Lớp 6</a></li>
                        <li><a class="dropdown-item" href="#">Lớp 7</a></li>
                        <li><a class="dropdown-item" href="#">Lớp 8</a></li>
                        <li><a class="dropdown-item" href="#">Lớp 9</a></li>
                        <li><a class="dropdown-item" href="#">Lớp 10</a></li>
                        <li><a class="dropdown-item" href="#">Lớp 11</a></li>
                        <li><a class="dropdown-item" href="#">Lớp 12</a></li>
                    </ul>
                </li>
            </ul>

            <!-- Conditional rendering based on login status -->
            <%
                // Check if user session attributes exist
                String fullName = (String) session.getAttribute("fullName");
                String avatar = (String) session.getAttribute("avatar");
                String role = (String) session.getAttribute("role");
                if (fullName == null) {
            %>
            <!-- Show login button if user is not logged in -->
            <button type="button" class="btn btn-primary button__login">
                <a href="/login" style="color: white; text-decoration: none;">Đăng nhập</a>
            </button>
            <%
            } else {
                // Get the first letter of the fullName for fallback
                String initial = fullName != null && !fullName.isEmpty() ? fullName.substring(0, 1).toUpperCase() : "U";
            %>
            <!-- Icons and user profile -->
            <ul class="navbar-nav ms-auto d-flex align-items-center">
                <li class="nav-item">
                    <a class="nav-link header-icon" href="#" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Danh sách yêu thích">
                        <i class="bi bi-heart"></i>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link header-icon" href="#" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Giỏ hàng">
                        <i class="bi bi-cart"></i>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link header-icon" href="#" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Thông báo">
                        <i class="bi bi-bell"></i>
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <% if (avatar != null && !avatar.isEmpty()) { %>
                        <img src="/img/avatar/<%= avatar %>" alt="User Avatar" class="user-avatar" />
                        <% } else { %>
                        <span class="user-circle"><%= initial %></span>
                        <% } %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <%if (role != null && !role.isEmpty()){ %>
                            <%if (role.equals("STUDENT")){%>
                                <li><a class="dropdown-item" href="/student/profile">Thông tin cá nhân</a></li>
                            <% } else { %>
                                <li><a class="dropdown-item" href="/parent/profile">Thông tin cá nhân</a></li>
                            <% } %>
                        <% } %>
                        <li><a class="dropdown-item" href="/logout">Đăng xuất</a></li>
                    </ul>
                </li>
            </ul>
            <%
                }
            %>
        </div>
    </div>
</nav>

<!-- JavaScript to initialize Bootstrap tooltips -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    });
</script>