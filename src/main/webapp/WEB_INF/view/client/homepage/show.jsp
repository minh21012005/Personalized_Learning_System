<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8" />
    <title>PLS</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <c:if test="${_csrf != null}">
        <meta name="_csrf" content="${_csrf.token}"/>
        <meta name="_csrf_header" content="${_csrf.parameterName}"/>
    </c:if>
    <style>
        /* Import Poppins font for a modern look */
        @import url("https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap");

        /* Reset styles */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        html, body {
            font-family: "Poppins", sans-serif;
            overflow-x: hidden;
            margin: 0;
            height: 100%;
            background-color: #f9fafb;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        button:focus-visible {
            outline: 2px solid #1e40af;
            outline-offset: 2px;
        }

        /* Homescreen styles */
        .homescreen {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            min-height: 100vh;
            background: linear-gradient(180deg, #f9fafb 0%, #dbeafe 100%);
        }

        .main-frame {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            max-width: 1600px;
            padding: 0 32px;
        }

        /* Slider Section */
        .slider-section {
            width: 100%;
            height: 85vh;
            position: relative;
            margin-top: 100px;
            display: flex;
            flex-direction: row;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
        }

        .content-section {
            width: 50%;
            padding: 48px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: linear-gradient(135deg, #ffffff 0%, #f1f5f9 100%);
        }

        .carousel-container {
            width: 50%;
            height: 100%;
            position: relative;
        }

        .carousel {
            width: 100%;
            height: 100%;
        }

        .carousel-inner {
            width: 100%;
            height: 100%;
        }

        .carousel-inner .carousel-item {
            width: 100%;
            height: 85vh;
            transition: transform 0.6s ease-in-out;
        }

        .carousel-inner .carousel-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            filter: brightness(0.75) contrast(1.1);
            transition: transform 0.4s ease;
        }

        .carousel-inner .carousel-item img:hover {
            transform: scale(1.03);
        }

        .content-section .content-item {
            display: none;
            animation: slideUp 0.8s ease-out;
        }

        .content-section .content-item.active {
            display: block;
        }

        .content-section h5 {
            font-size: 36px;
            font-weight: 700;
            color: #1e3a8a;
            margin-bottom: 20px;
            line-height: 1.3;
        }

        .content-section p {
            font-size: 18px;
            font-weight: 400;
            color: #4b5563;
            margin-bottom: 28px;
            line-height: 1.6;
        }

        .cta-button {
            background: linear-gradient(90deg, #3b82f6 0%, #1e40af 100%);
            color: #ffffff;
            padding: 14px 40px;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .cta-button:hover {
            background: linear-gradient(90deg, #2563eb 0%, #1e3a8a 100%);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
        }

        /* Carousel Controls */
        .carousel-control-prev,
        .carousel-control-next {
            width: 10%;
            background: rgba(0, 0, 0, 0.4);
            transition: background 0.3s ease;
            border-radius: 0 24px 24px 0;
        }

        .carousel-control-prev {
            border-radius: 24px 0 0 24px;
        }

        .carousel-control-prev:hover,
        .carousel-control-next:hover {
            background: rgba(0, 0, 0, 0.6);
        }

        .carousel-control-prev-icon,
        .carousel-control-next-icon {
            font-size: 28px;
            filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
        }

        /* Animation Keyframes */
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .slider-section {
                height: 75vh;
                flex-direction: column;
            }

            .content-section,
            .carousel-container {
                width: 100%;
                height: 50%;
            }

            .content-section {
                padding: 24px;
            }

            .carousel-inner .carousel-item {
                height: 37.5vh;
            }

            .content-section h5 {
                font-size: 28px;
            }

            .content-section p {
                font-size: 16px;
            }

            .cta-button {
                padding: 12px 32px;
                font-size: 16px;
            }
        }

        @media (max-width: 576px) {
            .slider-section {
                height: 65vh;
                margin-top: 16px;
                border-radius: 16px;
            }

            .carousel-inner .carousel-item {
                height: 32.5vh;
            }

            .content-section {
                padding: 16px;
            }

            .content-section h5 {
                font-size: 22px;
            }

            .content-section p {
                font-size: 14px;
            }

            .cta-button {
                padding: 10px 24px;
                font-size: 14px;
            }

            .carousel-control-prev,
            .carousel-control-next {
                width: 15%;
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
        <!-- Slider Section for Latest Packages -->
        <section class="slider-section">
            <div class="content-section">
                <c:choose>
                    <c:when test="${empty latestPackages}">
                        <div class="content-item active">
                            <h5>No Courses Available</h5>
                            <p>Discover our upcoming courses and start your journey!</p>
                            <a href="/courses" class="btn cta-button">Explore Courses</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="pkg" items="${latestPackages}" varStatus="status">
                            <div class="content-item ${status.first ? 'active' : ''}">
                                <h5>${fn:escapeXml(pkg.name)}</h5>
                                <p>${fn:escapeXml(pkg.description != null && not empty pkg.description ? pkg.description : 'Embark on an exciting learning adventure!')}</p>
<%--                                <a href="#" class="btn cta-button">Start Learning</a>--%>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="carousel-container">
                <div id="latestCoursesCarousel" class="carousel slide" data-bs-ride="carousel">
                    <div class="carousel-inner">
                        <c:choose>
                            <c:when test="${empty latestPackages}">
                                <div class="carousel-item active">
                                    <img src="https://via.placeholder.com/1920x1080?text=Explore+Our+Courses" class="d-block w-100" alt="No Courses Available">
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="pkg" items="${latestPackages}" varStatus="status">
                                    <div class="carousel-item ${status.first ? 'active' : ''}">
                                        <img src="/img/package/${fn:escapeXml(pkg.imageUrl != null && not empty pkg.imageUrl ? pkg.imageUrl : 'https://via.placeholder.com/1920x1080')}" class="d-block w-100" alt="${fn:escapeXml(pkg.name)}">
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${not empty latestPackages}">
                        <button class="carousel-control-prev" type="button" data-bs-target="#latestCoursesCarousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Previous</span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#latestCoursesCarousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Next</span>
                        </button>
                    </c:if>
                </div>
            </div>
        </section>
    </div>
</main>

<footer>
    <jsp:include page="../layout/footer.jsp" />
</footer>

<script>
    // Sync content with carousel slides
    document.addEventListener('DOMContentLoaded', function () {
        const carousel = document.getElementById('latestCoursesCarousel');
        const contentItems = document.querySelectorAll('.content-item');

        carousel.addEventListener('slid.bs.carousel', function (event) {
            // Remove active class from all content items
            contentItems.forEach(item => item.classList.remove('active'));
            // Add active class to the corresponding content item
            contentItems[event.to].classList.add('active');
        });
    });
</script>
</body>
</html>