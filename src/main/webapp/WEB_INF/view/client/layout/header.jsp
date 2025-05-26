<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<header class="site-header">
    <nav class="navbar navbar-expand-lg navbar-light bg-white">
        <div class="container-fluid px-4">
            <!-- Logo -->
            <a class="navbar-brand d-flex align-items-center" href="#">
                <div class="logo" style="width: 31px; height: 40px; background: url('https://c.animaapp.com/mb5881k9TTFl8D/img/logo-1.png') no-repeat center/cover;"></div>
                <span class="brand-name ms-2">Byway</span>
            </a>
            <!-- Toggle button for mobile -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <!-- Navbar content -->
            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="#">Categories</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Teach on Byway</a>
                    </li>
                </ul>
                <!-- Search bar -->
                <form class="d-flex mx-auto search-bar">
                    <div class="input-group">
                        <span class="input-group-text bg-white border-end-0">
                            <img src="https://c.animaapp.com/mb5881k9TTFl8D/img/heroicons-magnifying-glass-20-solid.svg" alt="Search" style="width: 20px; height: 20px;">
                        </span>
                        <input type="text" class="form-control border-start-0 search-placeholder" placeholder="Search courses" aria-label="Search courses">
                    </div>
                </form>
                <!-- Auth nav -->
                <div class="d-flex align-items-center auth-nav">
                    <a href="#" class="icon-cart-wrapper me-3">
                        <img src="https://c.animaapp.com/mb5881k9TTFl8D/img/icon-cart.svg" alt="Cart" class="icon-img" style="width: 24px; height: 24px;">
                    </a>
                    <a href="/login" class="btn login-button me-2">Log In</a>
                    <a href="#" class="btn signup-button">Sign Up</a>
                </div>
            </div>
        </div>
    </nav>
    <div class="header-divider"></div>
</header>