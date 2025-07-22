<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <header class="d-flex justify-content-between align-items-center p-2 bg-dark"
            style="background-color: #1a252f;">
            <div class="d-flex align-items-center ms-3">
                <img src="/img/favicon.ico" class="ms-5" alt="Logo"
                    style="width: 30px; height: 30px; margin-right: 10px;">
                <span class="text-white fs-3 fw-bold">PLS</span>
            </div>

            <div class="d-flex align-items-center gap-3 me-3">

        <div class="nav-item dropdown notification-dropdown-container">
            <button type="button" class="btn btn-dark position-relative"
                    id="adminNotificationDropdownToggle"
                    data-bs-toggle="dropdown"
                    data-bs-auto-close="outside" aria-expanded="false" title="Thông báo">
                <i class="bi bi-bell-fill fs-5"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
                      id="adminUnreadNotificationBadge"
                      style="display: none; font-size: 0.6em;">
                    <span id="adminUnreadNotificationCount">0</span>
                </span>
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2"
                style="width: 360px; max-height: 450px; overflow-y: auto;"
                id="adminNotificationDropdownMenu"
                aria-labelledby="adminNotificationDropdownToggle">
                <div id="adminNotificationDropdownContentLoading" class="text-center p-4" style="display: none;">
                    <div class="spinner-border text-primary spinner-border-sm" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
                <div id="adminNotificationDropdownContentActual">
                </div>
                <li>
                    <hr class="dropdown-divider my-0">
                </li>
            </ul>
        </div>

        <div class="dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button" id="userDropdown"
                data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-person-circle fs-5"></i>
            </button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><a class="dropdown-item" href="#">View Profile</a></li>
                <li><a class="dropdown-item" href="#">Edit Profile</a></li>
                <li>
                    <hr class="dropdown-divider">
                </li>
                <li>
                    <form method="post" action="/logout">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button class="dropdown-item">Logout</button>
                    </form>
                </li>
            </ul>
        </div>
    </div>
        </header>