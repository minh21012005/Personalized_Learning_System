<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="d-flex justify-content-between align-items-center p-2 bg-dark"
        style="background-color: #1a252f;">
    <div class="d-flex align-items-center ms-3">
        <img src="/img/logo.jpg" class="ms-5" alt="Logo"
             style="width: 50px; margin-right: 10px;">
        <span class="text-white fs-3 fw-bold">PLS</span>
    </div>

    <div class="d-flex align-items-center gap-3 me-3">

        <div class="dropdown">
            <button class="btn btn-primary dropdown-toggle" type="button" id="userDropdown"
                    data-bs-toggle="dropdown" aria-expanded="false">
                <i class="bi bi-person-circle fs-5"></i>
            </button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li>
                    <hr class="dropdown-divider">
                </li>
                <li>
                    <form method="post" action="/logout">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button class="dropdown-item">Logout</button>
                    </form>
                </li>
            </ul>
        </div>
    </div>
</header>