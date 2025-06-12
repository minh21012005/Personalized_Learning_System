document.addEventListener('DOMContentLoaded', function() {
    
    const contextPath = typeof window.APP_CONTEXT_PATH !== 'undefined' ? window.APP_CONTEXT_PATH : '';

    const notificationDropdownToggle = document.getElementById('clientNotificationDropdownToggle');
    const unreadBadge = document.getElementById('clientUnreadNotificationBadge');
    const unreadCountSpan = document.getElementById('clientUnreadNotificationCount');
    const dropdownContentActualEl = document.getElementById('clientNotificationDropdownContentActual');
    const dropdownContentLoadingEl = document.getElementById('clientNotificationDropdownContentLoading');

    // Hàm getCsrfHeaders() không còn cần thiết nếu không có request POST nào từ file JS này nữa.
    // Bạn có thể xóa nó nếu không dùng ở đâu khác.
    /*
    function getCsrfHeaders() {
        const headers = {}; 
        const csrfHeaderName = typeof window.CSRF_HEADER_NAME === 'string' ? window.CSRF_HEADER_NAME.trim() : null;
        const csrfToken = typeof window.CSRF_TOKEN === 'string' ? window.CSRF_TOKEN.trim() : null;

        if (csrfHeaderName && csrfHeaderName !== "" && csrfToken && csrfToken !== "") {
            headers[csrfHeaderName] = csrfToken;
        } else {
            console.warn('CSRF token or header name not found or empty for client_notification.js.');
        }
        return headers;
    }
    */

    function fetchUnreadCount() {
        fetch(`${contextPath}/notification/client/unread-count`)
            .then(response => {
                if (!response.ok) {
                    console.error('Network response was not ok for unread count. Status:', response.status, response.statusText);
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
                console.error('Error fetching unread count:', error);
                if (unreadBadge) unreadBadge.style.display = 'none'; 
            });
    }

    function fetchNotificationList() {
        if (dropdownContentLoadingEl) dropdownContentLoadingEl.style.display = 'block';
        if (dropdownContentActualEl) dropdownContentActualEl.innerHTML = '';

        fetch(`${contextPath}/notification/client/unread-list?limit=7`)
            .then(response => {
                if (!response.ok) {
                    console.error('Network response was not ok for notification list. Status:', response.status, response.statusText);
                    throw new Error(`Failed to load notifications: ${response.statusText} (status: ${response.status})`);
                }
                return response.text();
            })
            .then(html => {
                if (dropdownContentActualEl) dropdownContentActualEl.innerHTML = html;
                addNotificationItemClickListeners(); // Vẫn giữ để xử lý click điều hướng
                
                // Xóa hoặc comment out lời gọi đến addMarkAllAsReadClickListener nếu không muốn chức năng này nữa
                // addMarkAllAsReadClickListener(); 
            })
            .catch(error => {
                console.error('Error fetching notification list:', error);
                if (dropdownContentActualEl) dropdownContentActualEl.innerHTML = '<li><div class="dropdown-item text-danger small p-3 text-center">Lỗi khi tải danh sách thông báo. Vui lòng thử lại.</div></li>';
            })
            .finally(() => {
                 if (dropdownContentLoadingEl) dropdownContentLoadingEl.style.display = 'none';
            });
    }

    function addNotificationItemClickListeners() {
        const items = document.querySelectorAll('#clientNotificationDropdownMenu .notification-item-card');
        items.forEach(item => {
            // Gỡ bỏ listener cũ nếu có và gắn lại (nếu bạn sử dụng reAttachEventListener)
            // Hoặc đơn giản là để thẻ <a> tự xử lý việc điều hướng
            item.addEventListener('click', function(e) {
                const targetLink = this.getAttribute('href');
                if (targetLink && targetLink !== 'javascript:void(0);' && targetLink !== '#') {
                    // Cho phép điều hướng mặc định của thẻ <a>
                } else {
                    // Nếu link không hợp lệ hoặc là javascript:void(0), ngăn hành động mặc định
                    e.preventDefault();
                    console.log("Notification item clicked, but no valid link to navigate or link is void.");
                }
            });
        });
    }
    
    // Xóa hoặc comment out hàm addMarkAllAsReadClickListener nếu không dùng nữa
    /*
    function addMarkAllAsReadClickListener() {
        const markAllReadLink = document.getElementById('clientMarkAllAsReadLinkJsAction') || document.getElementById('clientMarkAllAsReadLinkJs');
        if (markAllReadLink) {
            const newLink = markAllReadLink.cloneNode(true);
            markAllReadLink.parentNode.replaceChild(newLink, markAllReadLink);

            newLink.addEventListener('click', function(e) {
                e.preventDefault();
                console.log("Mark all as read clicked - API call temporarily disabled.");
                // Tạm thời không gọi API:
                // fetch(`${contextPath}/notification/client/mark-all-as-read`, { 
                //     method: 'POST',
                //     headers: getCsrfHeaders() // Sẽ báo lỗi nếu getCsrfHeaders() bị xóa
                // }) 
                // .then(response => { ... })
                // .catch(error => { ... });
            });
        }
    }
    */

    // Khởi tạo khi DOM đã sẵn sàng
    if (notificationDropdownToggle) {
        fetchUnreadCount(); // Lấy số lượng khi trang tải lần đầu
        
        const dropdownParent = notificationDropdownToggle.closest('.dropdown');
        if (dropdownParent) {
            dropdownParent.addEventListener('show.bs.dropdown', function () {
                fetchNotificationList(); // Tải danh sách khi dropdown được hiển thị
            });
        } else {
            console.warn("Dropdown parent element (.dropdown) not found. Fallback to click event on toggle may not work as expected with Bootstrap 5.");
            // Fallback này có thể không cần thiết nếu cấu trúc HTML Bootstrap đúng
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
        console.warn("Notification dropdown toggle button (ID: clientNotificationDropdownToggle) not found.");
    }
});