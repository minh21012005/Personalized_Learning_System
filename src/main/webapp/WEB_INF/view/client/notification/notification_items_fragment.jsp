<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:forEach var="userNotif" items="${clientUserNotifications}">
    <li class="notification-item-wrapper">
        <a class="dropdown-item notification-item-card p-0 ${!userNotif.isRead ? 'is-unread' : ''}"
           href="<c:url value='${not empty userNotif.notification.link ? userNotif.notification.link : "javascript:void(0);"}'/>"
           data-notification-id="${userNotif.notification.notificationId}">

            <%-- 1. Thumbnail (Bên trái) --%>
            <div class="thumbnail-container">
                <c:choose>
                    <c:when test="${not empty userNotif.notification.thumbnail}">
                        <img src="<c:url value='${userNotif.notification.thumbnail}'/>" alt="Thumb" class="thumbnail-img">
                    </c:when>
                    <c:otherwise>
                        <div class="thumbnail-placeholder">
                            <i class="fas fa-bell"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- 2. Nội dung chính (Ở giữa) --%>
            <div class="content-container">
                <div class="title"><c:out value="${userNotif.notification.title}"/></div>
                <div class="summary"><c:out value="${userNotif.notification.content}"/></div>
                <div class="meta-info">
                    <fmt:formatDate value="${userNotif.notification.createdAtAsUtilDate}" pattern="dd MMM yyyy HH:mm"/>
                </div>
            </div>

            <%-- 3. Dấu chấm (Bên phải) --%>
            <div class="indicator-container">
                <c:if test="${!userNotif.isRead}">
                    <div class="unread-dot"></div>
                </c:if>
            </div>
        </a>
    </li>
</c:forEach>