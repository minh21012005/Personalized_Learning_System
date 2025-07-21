document.addEventListener('DOMContentLoaded', function() {

    const contextPath = typeof window.APP_CONTEXT_PATH !== 'undefined' ? window.APP_CONTEXT_PATH : '';

    // Elements
    const notificationDropdownToggle = document.getElementById('clientNotificationDropdownToggle');
    const unreadBadge = document.getElementById('clientUnreadNotificationBadge');
    const unreadCountSpan = document.getElementById('clientUnreadNotificationCount');
    const dropdownMenu = document.getElementById('clientNotificationDropdownMenu'); // Dropdown menu container
    const dropdownContentActualEl = document.getElementById('clientNotificationDropdownContentActual'); // The div to be filled with content
    
    // State
    let currentPage = 0; 
    let isLoading = false; 

    /**
     * Lấy và cập nhật số lượng thông báo chưa đọc trên badge.
     */
    function fetchUnreadCount() {
        fetch(`${contextPath}/notification/client/unread-count`)
            .then(response => response.ok ? response.json() : { count: 0 })
            .then(data => {
                updateUnreadBadge(data.count);
                // Hiển thị/ẩn nút "Đánh dấu đã đọc"
                const markAllReadLink = document.getElementById('clientMarkAllAsReadLink');
                if (markAllReadLink) {
                    markAllReadLink.style.display = data.count > 0 ? 'inline' : 'none';
                }
            })
            .catch(error => console.error('Error fetching unread count:', error));
    }


function fetchInitialNotificationList() {
    if (isLoading) return Promise.resolve();
    isLoading = true;
    currentPage = 0;

    dropdownContentActualEl.innerHTML = '<div class="loader-container"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>';

    return fetch(`${contextPath}/notification/client/recent-list`)
        .then(response => response.ok ? response.text() : '<div class="no-notification-message text-danger">Lỗi khi tải thông báo.</div>')
        .then(html => {
            dropdownContentActualEl.innerHTML = html;
            addEventListenersToNewItems();
        })
        .catch(error => {
            console.error('Error fetching notification list:', error);
            dropdownContentActualEl.innerHTML = '<div class="no-notification-message text-danger">Lỗi khi tải thông báo.</div>';
        })
        .finally(() => {
            isLoading = false;
        });
}
    
    /**
     * Tải thêm thông báo khi nhấn nút "Tải thêm".
     */
    function loadMoreNotifications() {
        if (isLoading) return;
        isLoading = true;
        currentPage++;

        const loadMoreBtn = document.getElementById('clientLoadMoreNotifications');
        const spinner = document.getElementById('clientLoadMoreSpinner');
        if(loadMoreBtn) loadMoreBtn.style.display = 'none';
        if(spinner) spinner.style.display = 'block';

        fetch(`${contextPath}/notification/client/load-more?page=${currentPage}&size=5`)
            .then(response => response.ok ? response.text() : '')
            .then(html => {
                if(spinner) spinner.style.display = 'none';

                if (html.trim()) {
                    const itemList = document.getElementById('clientNotificationItemList');
                    itemList.insertAdjacentHTML('beforeend', html);
                    if(loadMoreBtn) loadMoreBtn.style.display = 'block'; // Hiển thị lại nút
                    addEventListenersToNewItems(); // Gắn listener cho các mục mới được tải
                } else {
                    // Nếu không còn dữ liệu, ẩn luôn nút "Tải thêm"
                    if(loadMoreBtn) loadMoreBtn.parentElement.style.display = 'none';
                }
            })
            .catch(error => {
                console.error('Error loading more notifications:', error);
                if(loadMoreBtn) loadMoreBtn.style.display = 'block';
            })
            .finally(() => {
                isLoading = false;
            });
    }

    /**
     * Cập nhật giao diện của huy hiệu (badge).
     * @param {number} count - Số lượng thông báo chưa đọc.
     */
    function updateUnreadBadge(count) {
         if (unreadBadge && unreadCountSpan) {
            if (count > 0) {
                unreadCountSpan.textContent = count > 99 ? "99+" : count;
                unreadBadge.style.display = 'inline-flex';
            } else {
                unreadBadge.style.display = 'none';
            }
        }
    }

    /**
     * Giảm số đếm trên badge đi 1.
     */
    function decrementBadgeCount() {
        if (!unreadCountSpan || !unreadBadge || unreadBadge.style.display === 'none') return;
        
        let currentCount = parseInt(unreadCountSpan.textContent.replace('+', ''), 10);
        if (isNaN(currentCount)) return;

        let newCount = currentCount - 1;
        updateUnreadBadge(newCount);
    }
    /**
     * Xử lý khi click vào MỘT thông báo.
     * @param {Event} e - Sự kiện click.
     */
    function handleNotificationItemClick(e) {
        const item = e.currentTarget;
        const notificationId = item.dataset.notificationId;

        // Chỉ xử lý khi click vào thông báo chưa đọc
        if (item.classList.contains('is-unread')) {
            e.preventDefault(); // Ngăn điều hướng ngay lập tức

            fetch(`${contextPath}/notification/client/mark-as-read/${notificationId}`, { method: 'POST' })
                .then(response => response.ok ? response.json() : Promise.reject('Failed to mark as read'))
                .then(data => {
                    if (data.success) {
                        // Cập nhật UI ngay lập tức
                        item.classList.remove('is-unread');
                        item.classList.add('is-read');
                        const dot = item.querySelector('.unread-dot');
                        if (dot) dot.style.display = 'none';
                        decrementBadgeCount();
                    }
                })
                .catch(error => console.error('Error marking notification as read:', error))
                .finally(() => {
                    // Sau khi xử lý xong, điều hướng đến link
                    if (item.href && item.href !== 'javascript:void(0);') {
                        window.location.href = item.href;
                    }
                });
        }
    }

    function handleMarkAllAsReadClick() {
        const link = document.getElementById('clientMarkAllAsReadLink');
        link.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>'; // Show spinner

        fetch(`${contextPath}/notification/client/mark-all-as-read`, { method: 'POST' })
            .then(response => response.ok ? response.json() : Promise.reject('Failed to mark all as read'))
            .then(data => {
                if (data.success) {
                    // Cập nhật UI
                    updateUnreadBadge(0);
                    document.querySelectorAll('.notification-item-card.is-unread').forEach(item => {
                        item.classList.remove('is-unread');
                        item.classList.add('is-read');
                        const dot = item.querySelector('.unread-dot');
                        if (dot) dot.style.display = 'none';
                    });
                    link.style.display = 'none'; // Ẩn nút đi
                }
            })
            .catch(error => console.error('Error marking all as read:', error))
            .finally(() => {
                link.innerHTML = 'Đánh dấu tất cả đã đọc'; // Reset text
            });
    }


    function addEventListenersToNewItems() {
        // Click vào từng item thông báo
        document.querySelectorAll('.notification-item-card').forEach(item => {
            // Xóa listener cũ để tránh gắn trùng lặp
            item.removeEventListener('click', handleNotificationItemClick);
            item.addEventListener('click', handleNotificationItemClick);
        });

        // Click vào "Tải thêm"
        const loadMoreBtn = document.getElementById('clientLoadMoreNotifications');
        if (loadMoreBtn) {
            loadMoreBtn.removeEventListener('click', loadMoreNotifications);
            loadMoreBtn.addEventListener('click', loadMoreNotifications);
        }

        // Click vào "Đánh dấu tất cả đã đọc"
        const markAllReadLink = document.getElementById('clientMarkAllAsReadLink');
        if (markAllReadLink) {
            markAllReadLink.removeEventListener('click', handleMarkAllAsReadClick);
            markAllReadLink.addEventListener('click', handleMarkAllAsReadClick);
        }
    }

    /**
     * Khởi tạo toàn bộ chức năng.
     */
    function initialize() {
        if (!notificationDropdownToggle || !dropdownContentActualEl) {
        console.warn("Notification elements not found. Aborting initialization.");
        return;
    }
    fetchUnreadCount();
    const dropdownParent = notificationDropdownToggle.closest('.dropdown');
    if (dropdownParent) {
        dropdownParent.addEventListener('show.bs.dropdown', function(){
            fetchInitialNotificationList().then(() => {
                fetchUnreadCount();
            });
        });
    } else {
        console.warn("Bootstrap dropdown parent not found. Falling back to click event.");
        notificationDropdownToggle.addEventListener('click', function() {
            fetchInitialNotificationList().then(() => {
                fetchUnreadCount();
            });
       });
     }
    }

    initialize();

});