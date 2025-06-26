<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="nav-item dropdown notification-dropdown-container">
    <button type="button" class="btn btn-dark position-relative"
            id="adminNotificationDropdownToggle"
            data-bs-toggle="dropdown"
            data-bs-auto-close="outside" aria-expanded="false" title="Thông báo">
        <i class="bi bi-bell-fill fs-5"></i>
        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
              id="adminUnreadNotificationBadge"
              style="display: none; font-size: 0.6em;">
            <span id="adminUnreadNotificationCount">0</span>
        </span>
    </button>
    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2"
        style="width: 360px; max-height: 450px; overflow-y: auto;"
        id="adminNotificationDropdownMenu"
        aria-labelledby="adminNotificationDropdownToggle">
        <div id="adminNotificationDropdownContentLoading" class="text-center p-4" style="display: none;">
            <div class="spinner-border text-primary spinner-border-sm" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>
        <div id="adminNotificationDropdownContentActual">
        </div>
        <li>
            <hr class="dropdown-divider my-0">
        </li>
        <li>
            <a class="dropdown-item text-center text-primary small py-2"
               href="${pageContext.request.contextPath}/admin/notification/all">
                Xem tất cả thông báo
            </a>
        </li>
    </ul>
</div>

