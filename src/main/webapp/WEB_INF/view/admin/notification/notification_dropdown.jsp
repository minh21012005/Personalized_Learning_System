<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
        .notification-dropdown-header {
        display: flex; /* Bật flexbox để căn chỉnh */
        justify-content: space-between; /* Đẩy các item ra hai bên */
        align-items: center; /* Căn giữa theo chiều dọc */
        font-size: 1rem;
        font-weight: 600;
        padding: 0.85rem 1.25rem;
        border-bottom: 1px solid #e9ecef;
    }
    /* Thêm style cho link để nó nhỏ và không quá nổi bật */
    .notification-dropdown-header .mark-all-read-link {
        font-size: 0.8rem;
        font-weight: 500;
        color: #0d6efd;
        text-decoration: none;
        cursor: pointer;
    }
    .notification-dropdown-header .mark-all-read-link:hover {
        text-decoration: underline;
    }

    .notification-item-list {
        list-style: none; padding: 0; margin: 0; max-height: 450px; overflow-y: auto;
    }
    .notification-item-card {
        display: flex; align-items: flex-start; padding: 0.85rem 1.25rem;
        border-bottom: 1px solid #e9ecef; text-decoration: none !important; color: inherit;
        transition: background-color 0.15s ease-in-out;
    }
    .notification-item-card:last-of-type { border-bottom: none; }
    .notification-item-card:hover { background-color: #f8f9fa; }
    .notification-item-card.is-unread { background-color: #eef2f7; }
    .thumbnail-container {
        flex-shrink: 0; margin-right: 1rem;
    }
    .thumbnail-img, .thumbnail-placeholder {
        width: 48px; height: 48px; object-fit: cover; border-radius: 8px;
    }
    .thumbnail-placeholder {
        background-color: #e9ecef; display: flex; align-items: center; justify-content: center; color: #adb5bd;
    }
    .thumbnail-placeholder .fas { font-size: 1.4rem; }
    .content-container {
        flex-grow: 1; min-width: 0;
    }
    .title {
        font-weight: 600; color: #343a40; font-size: 0.9rem; margin-bottom: 0.2rem;
        line-height: 1.4; word-break: break-word;
    }
    .summary {
        font-size: 0.85rem; color: #495057; margin-bottom: 0.3rem; line-height: 1.4;
        display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
        overflow: hidden; text-overflow: ellipsis;
    }
    .meta-info {
        font-size: 0.75rem; color: #6c757d;
    }
    .indicator-container {
        flex-shrink: 0; width: 24px; padding-left: 12px;
        display: flex; justify-content: center; padding-top: 5px;
    }
    .unread-dot {
        width: 8px; height: 8px; background-color: #0d6efd; border-radius: 50%;
    }
    .notification-dropdown-footer { padding: 0.5rem 0; border-top: 1px solid #e9ecef; }
    .footer-action { font-size: 0.875rem; color: #007bff; text-align: center; padding: 0.6rem; cursor: pointer; }
    .footer-action:hover { background-color: #f8f9fa; }
    .no-notification-message, .loader-container { padding: 2rem 1.25rem; text-align: center; color: #6c757d; font-size: 0.9rem; }
</style>

<div class="notification-dropdown-header">
    <span>Thông báo</span>
    <a href="javascript:void(0);" id="clientMarkAllAsReadLink" class="mark-all-read-link" style="display: none;">
        Đánh dấu tất cả đã đọc
    </a>
</div>

<c:choose>
    <c:when test="${not empty adminUserNotifications}">
        <c:forEach var="adminUserNotif" items="${adminUserNotifications}">
            <li>
                <a class="dropdown-item notification-item-card p-0 <c:if test='${adminUserNotif.isRead}'>is-read</c:if>"
                   href="<c:url value='${not empty adminUserNotif.notification.link ? adminUserNotif.notification.link : "javascript:void(0);"}'/>">

                    <div class="thumbnail-container">
                        <c:if test="${not empty adminUserNotif.notification.thumbnail}">
                            <img src="<c:url value='${adminUserNotif.notification.thumbnail}'/>" alt="Thumb" class="thumbnail-img">
                        </c:if>
                        <c:if test="${empty adminUserNotif.notification.thumbnail}">
                            <div class="thumbnail-placeholder"><i class="fas fa-bell"></i></div>
                        </c:if>
                    </div>

                    <div class="content-container">
                        <span class="title"><c:out value="${adminUserNotif.notification.title}"/></span>
                        <span class="meta-info">
                            <c:if test="${adminUserNotif.notification.createdAt != null}">
                                <fmt:formatDate value="${adminUserNotif.notification.createdAt}" pattern="dd MMM yyyy HH:mm"/>
                            </c:if>
                            <c:if test="${adminUserNotif.notification.createdAt == null}">
                               Ngày không xác định
                            </c:if>
                        </span>
                        <p class="summary"><c:out value="${adminUserNotif.notification.content}"/></p>
                    </div>
                </a>
            </li>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <li><p class="dropdown-item no-notification-message-custom mb-0">Bạn không có thông báo nào.</p></li>
    </c:otherwise>
</c:choose>