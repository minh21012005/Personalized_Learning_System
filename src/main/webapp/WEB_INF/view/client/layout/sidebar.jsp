<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
            <style>
                .sidebar-image {
                    box-sizing: border-box;
                    width: 100%;
                }

                #avatarSideBar {
                    width: 100%;
                    max-width: 100%;
                    height: auto;
                    max-height: 250px;
                    object-fit: contain;
                }
            </style>
            <div class="sidebar">
                <div class="text-center sidebar-image">
                    <c:choose>
                        <c:when test="${not empty user.avatar}">
                            <img style="max-height: 250px; display: block; width: 100%" alt="Image not found"
                                id="avatarSideBar" src="/img/avatar/${user.avatar}" />
                        </c:when>
                        <c:otherwise>
                            <img style="max-height: 250px; display: none" alt="Image not found" src="#" />
                        </c:otherwise>
                    </c:choose>
                    <h5 class="mt-3">${user.fullName}</h5>
                </div>
                <ul class="nav flex-column mt-4">
                    <li class="nav-item">
                        <a href="/account/profile" class="nav-link">Hồ sơ</a>
                    </li>
                    <li class="nav-item">
                        <a href="/account/profile/change-password" class="nav-link">Thay đổi mật khẩu</a>
                    </li>
                    <c:if test="${sessionScope.role eq 'PARENT'}">
                        <li class="nav-item">
                            <a href="/transaction/history" class="nav-link">Lịch sử giao dịch</a>
                        </li>
                    </c:if>
                </ul>
            </div>

            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script>
                $(document).ready(() => {
                    const currentPath = window.location.pathname;
                    $('.nav-link').removeClass('active');

                    $('.nav-link').each(function () {
                        const href = $(this).attr('href');
                        if (
                            currentPath === href ||
                            (href === '/student/profile' && currentPath === '/parent/profile') ||
                            (href === '/transaction/history' && currentPath.startsWith('/transaction/history'))
                        ) {
                            $(this).addClass('active');
                        }
                    });
                });
            </script>