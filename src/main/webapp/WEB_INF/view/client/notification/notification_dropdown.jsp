<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
    .notification-dropdown-custom-header {
        font-size: 1.1rem;
        font-weight: 600;
        padding: 0.75rem 1.25rem;
        color: #343a40;
        background-color: #f8f9fa;
        border-bottom: 1px solid #dee2e6;
    }

    .notification-item-card {
        display: flex;
        align-items: flex-start;
        padding: 0.85rem 1.25rem;
        border-bottom: 1px solid #e9ecef;
        background-color: #ffffff;
        text-decoration: none !important;
        color: inherit;
        transition: background-color 0.15s ease-in-out;
    }
    .notification-item-card:last-of-type {
        border-bottom: none;
    }
    .notification-item-card.is-read {
        background-color: #f7f9fc;
    }
    .notification-item-card.is-read .title,
    .notification-item-card.is-read .summary,
    .notification-item-card.is-read .meta-info {
        color: #6c757d;
    }
     .notification-item-card.is-read .title {
        font-weight: 500;
    }
    .notification-item-card:hover {
        background-color: #eef2f7;
    }
    .notification-item-card .thumbnail-container {
        flex-shrink: 0;
        margin-right: 1rem;
    }
    .notification-item-card .thumbnail-img,
    .notification-item-card .thumbnail-placeholder {
        width: 48px;
        height: 48px;
        object-fit: cover;
        border-radius: 8px;
    }
    .notification-item-card .thumbnail-placeholder {
        background-color: #e9ecef;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #adb5bd;
    }
     .notification-item-card .thumbnail-placeholder .fas,
     .notification-item-card .thumbnail-placeholder .bi {
        font-size: 1.4rem; 
    }
    .notification-item-card .content-container {
        flex-grow: 1;
        min-width: 0; 
    }
    .notification-item-card .title {
        font-weight: 600; 
        color: #343a40; 
        font-size: 0.9rem; 
        margin-bottom: 0.2rem;
        line-height: 1.3;
        display: block; 
        word-break: break-word; 
    }
    .notification-item-card .meta-info { 
        font-size: 0.75rem;
        color: #6c757d; 
        margin-bottom: 0.3rem;
        display: block; 
    }
    .notification-item-card .summary {
        font-size: 0.85rem; 
        color: #495057;
        margin-bottom: 0; 
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2; 
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
        word-break: break-word; 
    }
    .notification-dropdown-footer {
        padding: 0.5rem 0; 
    }
    .notification-dropdown-footer .dropdown-item {
        font-size: 0.875rem; 
        color: #007bff; 
        padding-top: 0.6rem;
        padding-bottom: 0.6rem;
    }
    .notification-dropdown-footer .dropdown-item:hover {
        background-color: #e9ecef;
        color: #0056b3;
    }
    .no-notification-message-custom {
        padding: 1.5rem 1.25rem;
        text-align: center;
        color: #6c757d;
        font-size: 0.9rem;
    }
</style>

<div class="notification-dropdown-custom-header">
    Thông báo
</div>
<hr class="dropdown-divider my-0" style="margin-top: 0 !important; margin-bottom: 0 !important;">

<c:choose>
    <c:when test="${not empty clientUserNotifications}">
        <c:forEach var="userNotif" items="${clientUserNotifications}" varStatus="loop">
            <li>
                <a class="dropdown-item notification-item-card p-0 <c:if test='${userNotif.isRead}'>is-read</c:if>" 
                   href="<c:url value='${not empty userNotif.notification.link ? userNotif.notification.link : "javascript:void(0);"}'/>"
                    <div class="thumbnail-container">
                        <c:if test="${not empty userNotif.notification.thumbnail}">
                            <img src="<c:url value='${userNotif.notification.thumbnail}'/>" alt="Thumb" class="thumbnail-img">
                        </c:if>
                        <c:if test="${empty userNotif.notification.thumbnail}">
                            <div class="thumbnail-placeholder">
                                <i class="fas fa-bell"></i>
                            </div>
                        </c:if>
                    </div>

                    <div class="content-container">
                        <span class="title"><c:out value="${userNotif.notification.title}"/></span>
                        <span class="meta-info">
                            <c:if test="${userNotif.notification.createdAtAsUtilDate != null}">
                                <fmt:formatDate value="${userNotif.notification.createdAtAsUtilDate}" pattern="dd MMM yyyy HH:mm"/>
                            </c:if>
                            <c:if test="${userNotif.notification.createdAtAsUtilDate == null}"> 
                               Ngày không xác định
                            </c:if>
                        </span>
                        <p class="summary"><c:out value="${userNotif.notification.content}"/></p>
                    </div>
                </a>
            </li>
        </c:forEach>
        <div class="notification-dropdown-footer">
            <c:set var="hasAnyUnreadInDropdown" value="${false}"/>
            <c:forEach var="userNotifCheck" items="${clientUserNotifications}">
                <c:if test="${!userNotifCheck.isRead}">
                    <c:set var="hasAnyUnreadInDropdown" value="${true}"/>
                </c:if>
            </c:forEach>
            <c:if test="${hasAnyUnreadInDropdown}">
                <li><hr class="dropdown-divider my-0"></li>
                <li><a class="dropdown-item text-center" href="#" id="clientMarkAllAsReadLinkJsAction"> 
                    <i class="fas fa-check-double me-1"></i>Đánh dấu tất cả đã đọc
                </a></li>
            </c:if>
        </div>

    </c:when>
    <c:otherwise>
        <li><p class="dropdown-item no-notification-message-custom mb-0">Bạn không có thông báo nào.</p></li>
    </c:otherwise>
</c:choose>