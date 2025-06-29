<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8" />
    <title>Byway Homescreen</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    
    <c:if test="${_csrf != null}">
        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.parameterName}"/>
    </c:if>
    
    <style>
        /* Import Inter font */
        @import url("https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap");

        /* Reset styles */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            -webkit-font-smoothing: antialiased;
        }

        html, body {
            font-family: "Inter", sans-serif;
            overflow-x: hidden;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        button:focus-visible {
            outline: 2px solid #4a90e2;
        }

        /* Homescreen styles */
        .homescreen {
            background-color: #ffffff;
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            margin-top: 80px; /* Adjust based on header height */
        }

        .main-frame {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 60px;
            max-width: 1280px;
            width: 100%;
            padding: 0 20px;
        }

        /* Hero Section */
        .hero-section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            min-height: 600px;
            background-color: #ffffff;
            padding: 40px 0;
        }

        .hero-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 24px;
            max-width: 600px;
        }

        .hero-title {
            font-size: 40px;
            font-weight: 700;
            color: #0f172a;
            line-height: 1.2;
        }

        .hero-description {
            font-size: 16px;
            font-weight: 400;
            color: #334155;
            line-height: 1.6;
        }

        .cta-button {
            background-color: #3b82f6;
            color: #ffffff;
            padding: 10px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .cta-button:hover {
            background-color: #2563eb;
        }

        .hero-graphic {
            flex: 1;
            position: relative;
            max-width: 513px;
            height: 536px;
        }

        .graphic-overlap {
            position: relative;
            width: 100%;
            height: 100%;
        }

        .graphic-circle {
            position: absolute;
            width: 217px;
            height: 217px;
            top: 45px;
            right: 50px;
            background-color: #60a5fa;
            border-radius: 50%;
            background-image: url(https://c.animaapp.com/mb5881k9TTFl8D/img/image-8-1.png);
            background-size: cover;
        }

        .main-image {
            position: absolute;
            width: 184px;
            height: 205px;
            top: 163px;
            left: 50px;
        }

        .secondary-image {
            position: absolute;
            width: 184px;
            height: 142px;
            top: 107px;
            left: 50px;
        }

        .ellipse-1 {
            position: absolute;
            width: 237px;
            height: 114px;
            top: 268px;
            left: 33px;
        }

        .ellipse-2 {
            position: absolute;
            width: 153px;
            height: 249px;
            top: 25px;
            right: 0;
        }

        .additional-image {
            position: absolute;
            width: 174px;
            height: 165px;
            top: 0;
            right: 50px;
        }

        .small-circle {
            position: absolute;
            width: 35px;
            height: 35px;
            top: 261px;
            right: 50px;
            background-color: #0f172a;
            border-radius: 50%;
        }

        .polygon {
            position: absolute;
            width: 19px;
            height: 19px;
            top: 269px;
            right: 42px;
        }

        .dot-pattern-1, .dot-pattern-2 {
            position: absolute;
            display: grid;
            grid-template-columns: repeat(7, 12px);
            gap: 7px;
        }

        .dot-pattern-1 {
            top: 38px;
            left: 233px;
        }

        .dot-pattern-2 {
            top: 176px;
            left: 16px;
            transform: rotate(-81.92deg);
        }

        .dot {
            width: 4px;
            height: 4px;
            background-color: #e2e8f0;
            border-radius: 50%;
        }

        .community-section {
            position: absolute;
            bottom: 0;
            right: 0;
            width: 311px;
            height: 239px;
        }

        .community-image {
            position: absolute;
            width: 222px;
            height: 222px;
            top: 0;
            left: 72px;
            background-color: #facc15;
            border-radius: 50%;
            overflow: hidden;
        }

        .community-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .community-info {
            position: absolute;
            top: 102px;
            left: 0;
            background-color: #ffffff;
            border-radius: 8px;
            padding: 12px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
            width: 167px;
            text-align: center;
        }

        .avatar-group {
            display: flex;
            justify-content: center;
            margin-bottom: 8px;
        }

        .avatar {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            margin-left: -15px;
            border: 2px solid #ffffff;
        }

        .avatar:first-child {
            margin-left: 0;
        }

        .community-text {
            font-size: 12px;
            color: #0f172a;
        }

        .ellipse-3 {
            position: absolute;
            width: 150px;
            height: 213px;
            top: 26px;
            right: 0;
        }

        /* Stats Section */
        .stats-section {
            display: flex;
            justify-content: space-between;
            width: 100%;
            padding: 40px 20px;
            background-color: #f8fafc;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
        }

        .stat-number {
            font-size: 32px;
            font-weight: 400;
            color: #0f172a;
        }

        .stat-description {
            font-size: 14px;
            color: #0f172a;
            text-align: center;
        }

        .divider {
            width: 4px;
            height: 55px;
        }

        /* Category Section */
        .category-section {
            display: flex;
            flex-direction: column;
            gap: 24px;
            width: 100%;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
        }

        .section-title {
            font-size: 24px;
            font-weight: 400;
            color: #0f172a;
        }

        .see-all-button {
            background: none;
            border: none;
            color: #3b82f6;
            font-size: 14px;
            cursor: pointer;
        }

        .category-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            width: 100%;
        }

        .category-card {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 24px;
            text-align: center;
            box-shadow: 0 0 8px rgba(59, 130, 246, 0.12);
            transition: transform 0.3s;
        }

        .category-card:hover {
            transform: translateY(-5px);
        }

        .category-icon {
            width: 80px;
            height: 80px;
            background-color: #e0f2fe;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
        }

        .category-icon img {
            width: 40px;
            height: 40px;
        }

        .category-name {
            font-size: 20px;
            font-weight: 400;
            color: #0f172a;
        }

        .course-count {
            font-size: 16px;
            color: #334155;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hero-section {
                flex-direction: column;
                text-align: center;
            }

            .hero-content {
                max-width: 100%;
                margin-bottom: 40px;
            }

            .hero-graphic {
                max-width: 100%;
                height: 400px;
            }

            .graphic-circle, .main-image, .secondary-image, .additional-image {
                width: 150px;
                height: 150px;
            }

            .ellipse-1, .ellipse-2, .ellipse-3 {
                display: none; /* Hide decorative ellipses on mobile */
            }

            .community-section {
                width: 250px;
                height: 200px;
            }

            .community-image {
                width: 150px;
                height: 150px;
                left: 50px;
            }

            .stats-section {
                flex-direction: column;
                gap: 20px;
            }

            .divider {
                display: none;
            }
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>

<main class="homescreen">
    <div class="main-frame">
        <!-- Hero Section -->
        <section class="hero-section">
            <div class="hero-content">
                <h1 class="hero-title">Unlock Your Potential with Byway</h1>
                <p class="hero-description">
                    Welcome to Byway, where learning knows no bounds. We believe that education is the key to personal
                    and professional growth, and we're here to guide you on your journey to success.
                </p>
                <button class="cta-button">Start your instructor journey</button>
            </div>
            <div class="hero-graphic">
                <div class="graphic-overlap">
                    <div class="dot-pattern-1">
                        <!-- 49 dots for a 7x7 grid -->
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                    </div>
                    <div class="dot-pattern-2">
                        <!-- 49 dots for a 7x7 grid -->
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                        <div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div><div class="dot"></div>
                    </div>
                    <div class="graphic-circle"></div>
                    <div class="image-container">
                        <img class="main-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-6-1.png" alt="Hero Image" />
                    </div>
                    <img class="secondary-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-6.png" alt="Secondary Image" />
                    <img class="ellipse-1" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-55.svg" alt="Ellipse 1" />
                    <img class="ellipse-2" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-54.svg" alt="Ellipse 2" />
                    <img class="additional-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-8.png" alt="Additional Image" />
                    <div class="small-circle"></div>
                    <img class="polygon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/polygon-1.svg" alt="Polygon" />
                    <div class="community-section">
                        <div class="community-image">
                            <img class="community-img" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-7.png" alt="Community Image" />
                        </div>
                        <div class="community-info">
                            <div class="avatar-group">
                                <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-65.png" alt="Avatar" />
                                <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-62.png" alt="Avatar" />
                                <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-64.png" alt="Avatar" />
                                <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-63.png" alt="Avatar" />
                                <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-66.png" alt="Avatar" />
                            </div>
                            <p class="community-text">Join our community of 1200+ Students</p>
                        </div>
                        <img class="ellipse-3" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-57.svg" alt="Ellipse 3" />
                    </div>
                </div>
            </div>
        </section>

        <!-- Stats Section -->
        <section class="stats-section">
            <div class="stat-item">
                <div class="stat-number">250+</div>
                <p class="stat-description">Courses by our best mentors</p>
            </div>
            <img class="divider" src="https://c.animaapp.com/mb5881k9TTFl8D/img/line-1.svg" alt="Divider" />
            <div class="stat-item">
                <div class="stat-number">1000+</div>
                <p class="stat-description">Active students</p>
            </div>
            <img class="divider" src="https://c.animaapp.com/mb5881k9TTFl8D/img/line-1.svg" alt="Divider" />
            <div class="stat-item">
                <div class="stat-number">15+</div>
                <p class="stat-description">Categories available</p>
            </div>
            <img class="divider" src="https://c.animaapp.com/mb5881k9TTFl8D/img/line-1.svg" alt="Divider" />
            <div class="stat-item">
                <div class="stat-number">2400+</div>
                <p class="stat-description">Hours of content</p>
            </div>
        </section>

        <!-- Category Section -->
        <section class="category-section">
            <div class="section-header">
                <h2 class="section-title">Top Categories</h2>
                <button class="see-all-button">See All</button>
            </div>
            <div class="category-list">
                <div class="category-card">
                    <div class="category-icon">
                        <img src="https://c.animaapp.com/mb5881k9TTFl8D/img/telescope.svg" alt="Astrology Icon" />
                    </div>
                    <h3 class="category-name">Astrology</h3>
                    <p class="course-count">11 Courses</p>
                </div>
                <div class="category-card">
                    <div class="category-icon">
                        <i class="bi bi-code-slash" style="font-size: 40px; color: #334155;"></i>
                    </div>
                    <h3 class="category-name">Development</h3>
                    <p class="course-count">12 Courses</p>
                </div>
                <div class="category-card">
                    <div class="category-icon">
                        <i class="bi bi-briefcase" style="font-size: 40px; color: #334155;"></i>
                    </div>
                    <h3 class="category-name">Marketing</h3>
                    <p class="course-count">12 Courses</p>
                </div>
                <div class="category-card">
                    <div class="category-icon">
                        <i class="bi bi-lightning" style="font-size: 40px; color: #334155;"></i>
                    </div>
                    <h3 class="category-name">Physics</h3>
                    <p class="course-count">14 Courses</p>
                </div>
            </div>
        </section>
    </div>
</main>

<footer>
    <jsp:include page="../layout/footer.jsp" />
</footer>
</body>
</html>