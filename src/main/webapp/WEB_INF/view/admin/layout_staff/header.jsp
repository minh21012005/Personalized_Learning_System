<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <header class="d-flex justify-content-between align-items-center p-2 bg-dark"
            style="background-color: #1a252f;">
            <div class="d-flex align-items-center ms-3">
                <img src="/img/favicon.ico" class="ms-5" alt="Logo"
                    style="width: 30px; height: 30px; margin-right: 10px;">
                <span class="text-white fs-3 fw-bold">PLS</span>
            </div>
            <div class="dropdown">
                <button class="btn btn-primary dropdown-toggle" type="button" id="userDropdown"
                    data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-person-circle"></i>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                    <li><a class="dropdown-item" href="#">View Profile</a></li>
                    <li><a class="dropdown-item" href="#">Edit Profile</a></li>
                    <li>
                        <hr class="dropdown-divider">
                    </li>
                    <li><form method="post" action="/logout">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button class="dropdown-item">Logout</button>
                    </form></li>
                </ul>
            </div>
        </header>