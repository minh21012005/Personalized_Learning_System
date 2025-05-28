<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<div class="sidebar">
    <div class="text-center">
        <c:choose>
            <c:when test="${not empty user.avatar}">
                <img style="max-height: 250px; display: block"
                     alt="Image not found" id="avatarPreview"
                     src="/img/avatar/${user.avatar}" />
            </c:when>
            <c:otherwise>
                <img style="max-height: 250px; display: none"
                     alt="Image not found" id="avatarPreview" src="#" />
            </c:otherwise>
        </c:choose>
        <h5 class="mt-3">${user.fullName}</h5>
    </div>
    <ul class="nav flex-column mt-4">
        <li class="nav-item">
            <a href="/student/profile" class="nav-link">Hồ sơ</a>
        </li>
        <li class="nav-item">
            <a href="/profile/change-password" class="nav-link">Bảo mật</a>
        </li>
    </ul>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(() => {
        const currentPath = window.location.pathname;
        $('.nav-link').removeClass('active');

        $('.nav-link').each(function () {
            const href = $(this).attr('href');
            if (currentPath === href || (href === '/student/profile' && currentPath === '/parent/profile')) {
                $(this).addClass('active');
            }
        });
    });
</script>