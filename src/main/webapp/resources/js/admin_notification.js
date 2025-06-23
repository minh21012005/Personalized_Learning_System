

document.addEventListener('DOMContentLoaded', function() {

    const contextPath = typeof window.APP_CONTEXT_PATH !== 'undefined' ? window.APP_CONTEXT_PATH : '';

    const notificationDropdownToggle = document.getElementById('adminNotificationDropdownToggle');
    const unreadBadge = document.getElementById('adminUnreadNotificationBadge');
    const unreadCountSpan = document.getElementById('adminUnreadNotificationCount');
    const dropdownContentActualEl = document.getElementById('adminNotificationDropdownContentActual');
    const dropdownContentLoadingEl = document.getElementById('adminNotificationDropdownContentLoading');


    const API_ADMIN_UNREAD_COUNT = `${contextPath}/api/admin/notification/unread-count`;
    const API_ADMIN_UNREAD_LIST = `${contextPath}/api/admin/notification/unread-list?limit=7`;

    function fetchUnreadCount() {
        fetch(API_ADMIN_UNREAD_COUNT)
            .then(response => {
                if (!response.ok) {
                    console.error('ADMIN: Network response was not ok for unread count. Status:', response.status, response.statusText);
                    return { count: 0 };
                }
                return response.json();
            })
            .then(data => {
                if (unreadBadge && unreadCountSpan) {
                    if (data.count > 0) {
                        unreadCountSpan.textContent = data.count > 99 ? "99+" : data.count;
                        unreadBadge.style.display = 'inline-flex';
                    } else {
                        unreadBadge.style.display = 'none';
                    }
                }
            })
            .catch(error => {
                console.error('ADMIN: Error fetching unread count:', error);
                if (unreadBadge) unreadBadge.style.display = 'none';
            });
    }

    function fetchNotificationList() {
        if (dropdownContentLoadingEl) dropdownContentLoadingEl.style.display = 'block';
        if (dropdownContentActualEl) dropdownContentActualEl.innerHTML = '';

        fetch(API_ADMIN_UNREAD_LIST)
            .then(response => {
                if (!response.ok) {
                    console.error('ADMIN: Network response was not ok for notification list. Status:', response.status, response.statusText);
                    throw new Error(`Failed to load notifications: ${response.statusText} (status: ${response.status})`);
                }
                return response.text();
            })
            .then(html => {
                if (dropdownContentActualEl) dropdownContentActualEl.innerHTML = html;
                addNotificationItemClickListeners();
            })
            .catch(error => {
                console.error('ADMIN: Error fetching notification list:', error);
                if (dropdownContentActualEl) dropdownContentActualEl.innerHTML = '<li><div class="dropdown-item text-danger small p-3 text-center">Lỗi khi tải danh sách thông báo. Vui lòng thử lại.</div></li>';
            })
            .finally(() => {
                 if (dropdownContentLoadingEl) dropdownContentLoadingEl.style.display = 'none';
            });
    }

    function addNotificationItemClickListeners() {
        const items = document.querySelectorAll('#adminNotificationDropdownMenu .notification-item-card');
        items.forEach(item => {
            item.addEventListener('click', function(e) {
                const targetLink = this.getAttribute('href');
                if (targetLink && targetLink !== 'javascript:void(0);' && targetLink !== '#') {
                    //nothing changed
                } else {
                    e.preventDefault();
                    console.log("ADMIN: Notification item clicked, but no valid link to navigate or link is void.");
                }
            });
        });
    }

    if (notificationDropdownToggle) {
        fetchUnreadCount();

        const dropdownParent = notificationDropdownToggle.closest('.dropdown');
        if (dropdownParent) {
            dropdownParent.addEventListener('show.bs.dropdown', function () {
                fetchNotificationList();
            });
        } else {
            console.warn("ADMIN: Dropdown parent element (.dropdown) not found. Fallback to click event on toggle may not work as expected with Bootstrap 5.");
            const newToggle = notificationDropdownToggle.cloneNode(true);
            notificationDropdownToggle.parentNode.replaceChild(newToggle, notificationDropdownToggle);
            newToggle.addEventListener('click', function(){
                const dropdownMenu = this.nextElementSibling;
                if (dropdownMenu && dropdownMenu.classList.contains('dropdown-menu')) {
                     setTimeout(function(){ 
                        if(dropdownMenu.classList.contains('show')) {
                             fetchNotificationList();
                        }
                    }, 50);
                }
            });
        }
    } else {
        console.warn("ADMIN: Notification dropdown toggle button (ID: adminNotificationDropdownToggle) not found.");
    }
});