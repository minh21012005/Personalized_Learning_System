<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
    .header {
        background-color: white;
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        border-bottom: 1px solid rgba(0, 0, 0, 0.2);
        z-index: 1030;
    }

    .container {
        max-width: 1170px;
        margin: auto;
        padding: 0 15px;
    }

    .head-container {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .logo span {
        font-size: 32px;
        font-weight: bold;
    }

    .menu .head {
        display: none;
    }

    ul {
        margin: 0;
    }

    .menu ul {
        list-style: none;
        padding-left: 0;
        margin-bottom: 0;
    }

    .menu > ul > li {
        display: inline-block;
    }

    .menu > ul > li:not(:last-child) {
        margin-right: 40px;
    }

    .menu .dropdown {
        position: relative;
    }

    .menu a {
        text-decoration: none;
        text-transform: capitalize;
        font-size: 20px;
        color: #64748B;
        line-height: 1.5;
        display: block;
        transition: color 0.3s ease, text-decoration 0.3s ease;
    }

    .menu > ul > li > a {
        padding: 24px 0;
    }

    .menu > ul > .dropdown > a {
        padding-right: 15px;
    }

    .menu a:hover {
        color: #212529;
        text-decoration: underline;
    }

    .menu i.fa-chevron-down {
        font-size: 10px;
        pointer-events: none;
        user-select: none;
        position: absolute;
        color: #64748B;
        top: calc(50% - 5px);
        right: 0;
    }

    .menu .sub-menu {
        position: absolute;
        top: 100%;
        left: 0;
        width: 230px;
        padding: 15px 0;
        background-color: #2563EB;
        box-shadow: 0 0 5px hsla(0, 0%, 0%, 0.5);
        z-index: 1000;
        transform-origin: top;
        transform: scaleY(0);
        visibility: hidden;
        opacity: 0;
        list-style: none;
    }

    .menu .sub-menu a {
        color: white;
        transition: all 0.3s ease;
    }

    .menu .sub-menu a:hover {
        color: #212529;
    }

    .menu li:hover > .sub-menu {
        opacity: 1;
        transform: none;
        visibility: visible;
        transition: all 0.5s ease;
    }

    .menu .sub-menu li a {
        padding: 6px 24px;
        display: block;
    }

    .menu .sub-menu span {
        background-image: linear-gradient(hsl(0, 0%, 100%), hsl(0, 0%, 100%));
        background-size: 0 1px;
        background-repeat: no-repeat;
        background-position: 0 100%;
        transition: background-size 0.5s ease;
    }

    .menu .sub-menu li:hover > a > span {
        background-size: 100% 1px;
    }

    .header-right {
        display: flex;
        align-items: center;
    }

    .header-right .icon-btn {
        background-color: transparent;
        border: none;
        cursor: pointer;
        color: #64748B;
        font-size: 24px;
        padding: 0;
        line-height: 1;
        transition: color 0.3s ease;
    }

    .header-right > * {
        margin-left: 25px;
    }

    .header-right > *:first-child {
        margin-left: 0;
    }

    .header-right .open-menu-btn {
        display: none;
    }

    .header-right .icon-btn:hover,
    .header-right .icon-btn:focus {
        color: #212529;
    }

    .user-dropdown {
        position: relative;
        display: inline-flex;
        align-items: center;
    }

    .user-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
        border: 1px solid #ddd;
        cursor: pointer;
    }

    .header-right .dropdown-menu {
        min-width: 180px;
        padding: 0.5rem 0;
        margin-top: 0.5rem !important;
        border: 1px solid rgba(0, 0, 0, 0.1);
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        z-index: 1021;
    }

    .header-right .dropdown-item {
        padding: 0.5rem 1rem;
        color: #333;
        font-size: 0.9rem;
        transition: background-color 0.15s ease-in-out, color 0.15s ease-in-out;
        white-space: nowrap;
    }

    .header-right .dropdown-item:hover,
    .header-right .dropdown-item:focus {
        background-color: #e9ecef;
        color: #212529;
    }

    .header-right form .dropdown-item {
        width: 100%;
        text-align: left;
        background: none;
        border: none;
    }

    .notification-dropdown-container {
        position: relative;
    }

    .notification-dropdown-menu {
        width: 360px;
        max-height: 450px;
        overflow-y: auto;
    }

    .notification-badge-custom {
        font-size: 0.65em;
        padding: 0.25em 0.45em;
    }

    @media (max-width: 991px) {
        .header {
            padding: 12px 0;
        }

        .menu {
            position: fixed;
            right: 0;
            top: 0;
            width: 320px;
            height: 100%;
            background-color: white; /* Changed to white */
            padding: 15px 30px 30px;
            overflow-y: auto;
            z-index: 1050;
            transform: translateX(100%);
            transition: transform 0.3s ease-in-out;
        }

        .menu a {
            color: #64748B;
            transition: color 0.3s ease, text-decoration 0.3s ease;
        }

        .menu a:hover {
            color: #212529;
            text-decoration: underline;
        }

        .menu.open {
            transform: none;
        }

        .menu .head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 25px;
        }

        .menu .close-menu-btn {
            border: none;
            height: 35px;
            width: 35px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background-color: transparent;
            cursor: pointer;
            color: #64748B;
        }

        .menu > ul > li {
            display: block;
        }

        .menu > ul > li:not(:last-child) {
            margin-right: 0;
        }

        .menu li {
            border-bottom: 1px solid #e0e0e0;
        }

        .menu li:first-child {
            border-top: 1px solid #e0e0e0;
        }

        .menu > ul > li > a {
            padding: 12px 0;
        }

        .menu i.fa-chevron-down {
            height: 34px;
            width: 34px;
            border: 1px solid #e0e0e0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            pointer-events: auto;
            cursor: pointer;
            top: 7px;
            color: #64748B;
        }

        .menu .dropdown.active > i.fa-chevron-down {
            background-color: #e0e0e0;
            transform: rotate(180deg);
        }

        .menu .sub-menu {
            position: static;
            opacity: 1;
            transform: none;
            visibility: visible;
            padding: 0;
            transition: none;
            box-shadow: none;
            background-color: #e0e0e0;
            display: none;
        }

        .menu .dropdown.active > .sub-menu {
            display: block;
        }

        .menu .sub-menu li:last-child {
            border: none;
        }

        .menu .sub-menu li a {
            padding: 12px 0 12px 15px;
            color: #64748B;
        }

        .menu .sub-menu span {
            background-image: none;
        }

        .header-right .open-menu-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 40px;
            width: 44px;
            cursor: pointer;
        }

        .header-right .icon-btn {
            font-size: 20px;
        }

        .header-right .notification-dropdown-menu {
            width: auto;
            max-width: calc(100vw - 30px);
        }

        .header-right .user-dropdown .dropdown-menu {
            right: 0 !important;
            left: auto !important;
        }
    }
</style>
<head>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
</head>
<div class="header">
    <div class="container head-container">
        <%-- Logo --%>
        <div class="logo">
            <a href="/" style="font-size: 32px; font-weight: bold; color: #212529; text-decoration: none;">PLS</a>
        </div>

        <%-- Menu --%>
        <div class="menu">
            <div class="head">
                <span style="font-size: 32px; font-weight: bold;">PLS</span>
                <button type="button" class="close-menu-btn" aria-label="Đóng menu">
                    <i class="fa-solid fa-x"></i>
                </button>
            </div>
            <ul>
                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                <li>
                    <a href="javascript:void(0);">Gói học</a>

                </li>
                <li><a href="/practices">Luyện tập</a></li>
                <li><a href="#">Báo cáo học tập</a></li>
            </ul>
        </div>

        <%-- Header Right --%>
        <div class="header-right">
            <%-- Notification Dropdown --%>
            <div class="nav-item dropdown icon-btn notification-dropdown-container">
                <button type="button" class="bell-btn icon-btn position-relative border-0 bg-transparent p-0"
                        id="clientNotificationDropdownToggle" data-bs-toggle="dropdown"
                        data-bs-auto-close="outside" aria-expanded="false" title="Thông báo">
                    <i class="fa-regular fa-bell" style="font-size: 22px;"></i>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger notification-badge-custom"
                          id="clientUnreadNotificationBadge" style="display: none;">
                        <span id="clientUnreadNotificationCount">0</span>
                    </span>
                </button>
                <ul class="dropdown-menu shadow border-0 mt-2 notification-dropdown-menu"
                    aria-labelledby="clientNotificationDropdownToggle" id="clientNotificationDropdownMenu">
                    <div id="clientNotificationDropdownContentLoading" class="text-center p-4" style="display: none;">
                        <div class="spinner-border text-primary spinner-border-sm" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                    <div id="clientNotificationDropdownContentActual">
                    </div>
                    <li>
                        <hr class="dropdown-divider my-0">
                    </li>
                    <li>
                        <a class="dropdown-item text-center text-primary small py-2 dropdown-footer-link"
                           href="${pageContext.request.contextPath}/notification/client/all">
                            Xem tất cả thông báo
                        </a>
                    </li>
                </ul>
            </div>

            <%-- Heart Button --%>
            <button type="button" class="heart-btn icon-btn" title="Yêu thích">
                <i class="fa-regular fa-heart"></i>
            </button>

            <%-- User Info/Login Button - Sử dụng JSTL --%>
            <c:set var="sessionFullName" value="${sessionScope.fullName}"/>
            <c:set var="sessionAvatar" value="${sessionScope.avatar}"/>

            <c:choose>
                <c:when test="${empty sessionFullName}">
                    <button type="button" class="user-btn icon-btn" title="Đăng nhập">
                        <a href="${pageContext.request.contextPath}/login"
                           style="color: inherit; text-decoration: none;">
                            <i class="fa-regular fa-user"></i>
                        </a>
                    </button>
                </c:when>
                <c:otherwise>
                    <c:set var="avatarUrl" value="${pageContext.request.contextPath}/img/avatar-default.jpg"/>
                    <c:if test="${not empty sessionAvatar}">
                        <c:if test="${fn:startsWith(sessionAvatar, 'http://') || fn:startsWith(sessionAvatar, 'https://')}">
                            <c:set var="avatarUrl" value="${sessionAvatar}"/>
                        </c:if>
                        <c:if test="${not (fn:startsWith(sessionAvatar, 'http://') || fn:startsWith(sessionAvatar, 'https://'))}">
                            <c:set var="avatarUrl"
                                   value="${pageContext.request.contextPath}/img/avatar/${sessionAvatar}"/>
                        </c:if>
                    </c:if>

                    <div class="user-dropdown icon-btn">
                        <a href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false"
                           title="Tài khoản của tôi">
                            <img width="50" height="50" src="${avatarUrl}" alt="User Avatar" class="user-avatar"
                                 onerror="this.onerror=null; this.src='<c:url value="/img/avatar-default.jpg"/>';"/>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/profile">Thông
                                tin cá nhân</a></li>
                            <li>
                                <form method="post" action="${pageContext.request.contextPath}/logout"
                                      style="margin:0;">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="dropdown-item">Logout</button>
                                </form>
                            </li>
                        </ul>
                    </div>
                </c:otherwise>
            </c:choose>

            <button type="button"  class="open-menu-btn icon-btn" aria-label="Mở menu">
                <i style="color: #212529;" class="fa-solid fa-bars"></i>
            </button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/client_notification.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const menu = document.querySelector(".menu");
        const openMenuBtn = document.querySelector(".header-right .open-menu-btn");
        const closeMenuBtn = document.querySelector(".menu .close-menu-btn");

        if (menu && openMenuBtn && closeMenuBtn) {
            // Initialize menu state
            if (window.location.pathname !== "${pageContext.request.contextPath}/") {
                menu.classList.remove("open");
            }

            [openMenuBtn, closeMenuBtn].forEach((btn) => {
                btn.addEventListener("click", () => {
                    menu.classList.toggle("open");
                });
            });

            menu.querySelectorAll(".menu .dropdown > i.fa-chevron-down").forEach((arrow) => {
                arrow.addEventListener("click", function (event) {
                    event.stopPropagation();
                    this.closest(".dropdown").classList.toggle("active");
                });
            });

            // Ensure dropdowns work on page load
            const dropdownToggles = document.querySelectorAll('[data-bs-toggle="dropdown"]');
            dropdownToggles.forEach(toggle => {
                toggle.addEventListener('click', function (e) {
                    const dropdown = document.querySelector(this.getAttribute('aria-controls') || this.nextElementSibling);
                    if (dropdown) {
                        dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
                        this.setAttribute('aria-expanded', dropdown.style.display === 'block');
                    }
                });
            });
        }
    });
</script>