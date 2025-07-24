<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
    .notification-dropdown-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 1rem;
        font-weight: 600;
        padding: 0.75rem 1.25rem;
        border-bottom: 1px solid #e9ecef;
    }

    .notification-dropdown-header .small {
        font-size: 0.8rem;
        color: #0d6efd;
        text-decoration: none;
        cursor: pointer;
    }
    .notification-dropdown-header .small:hover {
        text-decoration: underline;
    }

    .notification-body-scrollable {
    max-height: 150vh;
    overflow-y: auto;
    overflow-x: hidden;
    }

    .notification-item-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .notification-item-card {
        display: flex;
        align-items: center;
        padding: 0.75rem 1rem;
        border-bottom: 1px solid #e9ecef;
        text-decoration: none !important;
        color: inherit;
        transition: background-color 0.15s ease-in-out;
        position: relative;
    }
    .notification-item-card:last-of-type {
        border-bottom: none;
    }
    .notification-item-card.is-read {
        background-color: #f8f9fa;
    }
     .notification-item-card.is-read .title,
     .notification-item-card.is-read .summary,
     .notification-item-card.is-read .meta-info {
        color: #6c757d;
     }
    .notification-item-card:hover {
        background-color: #eef2f7;
    }

    /* === Phần quan trọng: Dấu chấm xanh === */
    .indicator-container {
        flex-shrink: 0;
        width: 20px; /* Dành không gian cho dấu chấm */
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .unread-dot {
        width: 8px;
        height: 8px;
        background-color: #0d6efd; /* Màu xanh bootstrap primary */
        border-radius: 50%;
    }

    .thumbnail-container {
        flex-shrink: 0;
        margin-right: 1rem;
    }
    .thumbnail-img, .thumbnail-placeholder {
        width: 48px; height: 48px; object-fit: cover; border-radius: 8px; margin-left: 0.1cm;
    }
    .thumbnail-placeholder {
        background-color: #e9ecef; display: flex; align-items: center; justify-content: center; color: #adb5bd;
    }
    .thumbnail-placeholder .fas { font-size: 1.4rem; }

    .content-container { flex-grow: 1; min-width: 0; }
    .title { font-weight: 600; color: #343a40; font-size: 0.9rem; margin-bottom: 0.2rem; line-height: 1.3; }
    .meta-info { font-size: 0.75rem; color: #6c757d; margin-bottom: 0.3rem; }
    .summary {
        font-size: 0.85rem; color: #495057; margin: 0; line-height: 1.4;
        white-space: normal; /* Cho phép ngắt dòng tự nhiên */
        word-wrap: break-word;
    }
    
    .notification-dropdown-footer {
        padding: 0.5rem 0;
        border-top: 1px solid #e9ecef;
    }
    .notification-dropdown-footer .footer-action {
        font-size: 0.875rem; color: #007bff; text-align: center;
        padding: 0.6rem; cursor: pointer;
    }
    .notification-dropdown-footer .footer-action:hover {
        background-color: #f8f9fa;
    }

    .no-notification-message {
        padding: 2rem 1.25rem; text-align: center; color: #6c757d; font-size: 0.9rem;
    }
    .loader-container {
        padding: 1rem; text-align: center;
    }


</style>

<div class="notification-dropdown-header d-flex justify-content-between align-items-center">
    <span>Thông báo</span>
    <a href="javascript:void(0);" id="clientMarkAllAsReadLink" class="small fw-normal" style="display: none;">Đánh dấu tất cả đã đọc</a>
</div>
<div class="notification-body-scrollable">
<ul class="notification-item-list" id="clientNotificationItemList" data-total="${totalNotifications}">
    <c:choose>
        <c:when test="${not empty clientUserNotifications}">
            <jsp:include page="notification_items_fragment.jsp" />
        </c:when>
        <c:otherwise>
            <li class="no-notification-message">Bạn không có thông báo nào.</li>
        </c:otherwise>
    </c:choose>
</ul>
</div>
<div class="notification-dropdown-footer">
    <c:if test="${currentSize < totalNotifications}">
        <div class="footer-action" id="clientLoadMoreNotifications">Tải thêm</div>
        <div class="footer-action loader-container" id="clientLoadMoreSpinner" style="display: none;">
            <div class="spinner-border spinner-border-sm" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>
    </c:if>
</div>