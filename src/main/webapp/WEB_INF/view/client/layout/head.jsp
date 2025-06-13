<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <script src="https://unpkg.com/lucide@latest"></script>
            <link rel="stylesheet" href="/css/head.css">
        </head>

        <body>
            <header class="header">
                <div class="header-container">
                    <div class="header-content">
                        <!-- Logo -->
                        <div class="logo">
                            <img class="logo-img" alt="Logo" src="https://c.animaapp.com/mbgux5dcnDKIHL/img/logo.svg" />
                        </div>

                        <!-- Navigation Menu -->
                        <nav class="nav-menu">
                            <ul class="nav-list">
                                <li class="nav-item">
                                    <a href="#" class="nav-link">
                                        <span class="nav-text">Trang chủ</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="#" class="nav-link">
                                        <span class="nav-text">Khóa học</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="#" class="nav-link">
                                        <span class="nav-text">Dịch vụ</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="#" class="nav-link">
                                        <span class="nav-text">Tin tức</span>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a href="#" class="nav-link">
                                        <span class="nav-text">Liên hệ</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>

                        <!-- User Actions -->
                        <div class="user-actions">
                            <i data-lucide="bell" class="action-icon"></i>
                            <a href="/parent/cart"><i data-lucide="shopping-cart" class="action-icon"></i></a>
                            <c:if test="${sessionScope.role eq 'PARENT'}">
                                <a href="/invite/create"><i data-lucide="user-plus" class="action-icon"></i></a>
                            </c:if>
                            <div class="avatar">
                                <span class="avatar-text">J</span>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <script>
                // Initialize Lucide icons
                lucide.createIcons();
            </script>
        </body>

        </html>