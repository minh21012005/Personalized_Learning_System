

document.addEventListener('DOMContentLoaded', function () {


    const hubContainer = document.getElementById('hub-container');
    const paginationContainer = document.getElementById('pagination-container');
    const statsContainer = document.getElementById('stats-container');
    const statusFilter = document.getElementById('status-filter');
    const keywordSearchInput = document.getElementById('keyword-search-input');
    const keywordSearchButton = document.getElementById('keyword-search-button');
    const startDateInput = document.getElementById('start-date-input');
    const endDateInput = document.getElementById('end-date-input');
    const dateFilterButton = document.getElementById('date-filter-button');
    const dateClearButton = document.getElementById('date-clear-button');


    let currentPage = 0;
    const pageSize = 5;
    let currentStatusFilter = "";
    let currentKeyword = "";
    let currentStartDate = null;
    let currentEndDate = null;



    async function fetchAndRenderStatistics() {
        try {
            const apiUrl = window.API_URLS.stats;
            const response = await fetch(apiUrl);
            if (!response.ok) {
                statsContainer.innerHTML = '<span>Không thể tải thống kê.</span>';
                return;
            }

            const stats = await response.json();
            statsContainer.innerHTML =
                '<span><strong>Tổng:</strong> ' + stats.total + '</span>' +
                '<span class="mx-2">|</span>' +
                '<span class="text-warning"><strong>Chờ duyệt:</strong> ' + stats.pending + '</span>' +
                '<span class="mx-2">|</span>' +
                '<span class="text-success"><strong>Đã duyệt:</strong> ' + stats.approved + '</span>' +
                '<span class="mx-2">|</span>' +
                '<span class="text-danger"><strong>Đã từ chối:</strong> ' + stats.rejected + '</span>' +
                '<span class="mx-2">|</span>' +
                '<span class="text-muted"><strong>Đã ẩn:</strong> ' + stats.hidden + '</span>';
        } catch (error) {
            console.error("Lỗi tải thống kê:", error);
            statsContainer.innerHTML = '<span>Không thể tải thống kê.</span>';
        }
    }

    async function fetchAndRenderHub(pageNumber, status, keyword, startDate, endDate) {
        const pageToFetch = (typeof pageNumber === 'number' && pageNumber >= 0) ? pageNumber : 0;
        try {
            hubContainer.innerHTML = '<p>Đang tải bình luận...</p>';
            const params = new URLSearchParams({
                page: pageToFetch,
                size: pageSize
            });
            if (status) params.append('status', status);
            if (keyword) params.append('keyword', keyword);
            if (startDate) params.append('startDate', startDate);
            if (endDate) params.append('endDate', endDate);

            const apiUrl = window.API_URLS.hub + '?' + params.toString();

            const response = await fetch(apiUrl);
            if (!response.ok) throw new Error('Lỗi API: ' + response.status + ' - ' + response.statusText);

            const pagedData = await response.json();
            const comments = pagedData.content;
            hubContainer.innerHTML = '';
            if (!comments || comments.length === 0) {
                hubContainer.innerHTML = pageToFetch > 0 ? '<p>Không có bình luận nào ở trang này.</p>' : '<p>Chưa có bình luận nào.</p>';
            } else {
                comments.forEach(comment => {
                    hubContainer.appendChild(createHubEntryElement(comment));
                });
            }
            currentPage = pagedData.number;
            renderPagination(pagedData);
        } catch (error) {
            hubContainer.innerHTML = '<p style="color: red;">Tải bình luận thất bại: ' + error.message + '</p>';
            console.error('[Lỗi JavaScript]', error);
        }
    }

    async function updateStatus(commentId, newStatus) {
        try {
            const apiUrl = window.API_URLS.comment + '/' + commentId + '/status';
            const response = await fetch(apiUrl, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ commentStatus: newStatus })
            });
            if (response.ok) {
                fetchAndRenderHub(currentPage, currentStatusFilter, currentKeyword, currentStartDate, currentEndDate);
                fetchAndRenderStatistics();
            } else {
                alert('Cập nhật trạng thái thất bại.');
            }
        } catch (error) {
            console.error('Lỗi cập nhật trạng thái:', error);
            alert('Đã xảy ra lỗi khi cập nhật trạng thái.');
        }
    }

    async function postComment(content, parentId, lessonId) {
        try {
            const apiUrl = window.API_URLS.lesson + '/' + lessonId;
            const response = await fetch(apiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ content, parentId })
            });
            return response.ok ? await response.json() : null;
        } catch (error) {
            console.error('Lỗi gửi bình luận:', error);
            return null;
        }
    }

    async function deleteComment(commentId) {
        try {
            const apiUrl = window.API_URLS.comment + '/' + commentId;
            const response = await fetch(apiUrl, { method: 'DELETE' });
            return response.ok;
        } catch (error) {
            console.error('Lỗi xóa bình luận:', error);
            return false;
        }
    }


    function renderPagination(pagedData) {
        paginationContainer.innerHTML = '';
        const totalPages = pagedData.totalPages;
        if (totalPages <= 1) return;
        const currentActivePage = pagedData.number;

        const createPageItem = (pageIndex, text, isDisabled, isActive) => {
            const li = document.createElement('li');
            li.className = 'page-item' + (isDisabled ? ' disabled' : '') + (isActive ? ' active' : '');
            const button = document.createElement('button');
            button.className = 'page-link';
            button.dataset.page = pageIndex;
            button.textContent = text;
            if (isDisabled) button.setAttribute('disabled', 'disabled');
            li.appendChild(button);
            return li;
        };

        paginationContainer.appendChild(createPageItem(currentActivePage - 1, 'Trước', pagedData.first));
        for (let i = 0; i < totalPages; i++) {
            paginationContainer.appendChild(createPageItem(i, i + 1, false, i === currentActivePage));
        }
        paginationContainer.appendChild(createPageItem(currentActivePage + 1, 'Sau', pagedData.last));
    }

    function createHubEntryElement(comment) {
        const cardDiv = document.createElement('div');
        cardDiv.className = 'comment-card';
        const commentTreeHtml = createCommentRecursive(comment);
        cardDiv.innerHTML =
            '<div class="comment-header"><strong>Môn học:</strong> ' + (comment.subjectName || 'N/A') + ' | <strong>Bài giảng:</strong> ' + (comment.lessonName || 'N/A') + '</div>' +
            '<div class="comment-body">' + commentTreeHtml + '</div>';
        return cardDiv;
    }

    function createCommentRecursive(comment) {
        const author = comment.author || {};
        const authorName = author.name || 'Người dùng ẩn danh';
        const avatar = author.avatarUrl ? window.API_URLS.images + author.avatarUrl : '/img/avatar-default.jpg';
        let createdAt = 'Ngày không hợp lệ';
        if (comment.createdAt) {
            try { createdAt = new Date(comment.createdAt).toLocaleString('vi-VN'); } catch (e) { }
        }

        let repliesHtml = '';
        if (comment.replies && comment.replies.length > 0) {
            repliesHtml += '<div class="replies">';
            comment.replies.forEach(reply => { repliesHtml += createCommentRecursive(reply); });
            repliesHtml += '</div>';
        }

        let statusBadgeHtml = '';
        let actionsHtml = '';
        const status = comment.commentStatus;
        if (status) {
            const statusTextMap = { PENDING: 'Chờ duyệt', APPROVED: 'Đã duyệt', REJECTED: 'Từ chối', HIDDEN: 'Đã ẩn' };
            statusBadgeHtml = '<span class="status-badge status-' + status + '">' + (statusTextMap[status] || status) + '</span>';
        }

        switch (status) {
            case 'PENDING':
                actionsHtml += '<span class="action-link action-approve" data-action="approve" data-status="APPROVED">Duyệt</span>';
                actionsHtml += '<span class="action-link action-reject" data-action="reject" data-status="REJECTED">Từ chối</span>';
                break;
            case 'APPROVED':
                actionsHtml += '<span class="action-link action-reject" data-action="hide" data-status="HIDDEN">Ẩn</span>';
                actionsHtml += '<span class="action-link action-reply btn-reply">Trả lời</span>';
                break;
            case 'REJECTED':
                actionsHtml += '<span class="action-link action-approve" data-action="approve" data-status="APPROVED">Duyệt lại</span>';
                break;
            case 'HIDDEN':
                actionsHtml += '<span class="action-link action-show" data-action="show" data-status="APPROVED">Hiện</span>';
                break;
        }
        actionsHtml += '<span class="action-link action-delete btn-delete">Xóa</span>';


        return (
            '<div class="comment" data-id="' + comment.id + '" data-lesson-id="' + comment.lessonId + '">' +
            '<div class="author-info">' +
            '<img src="' + avatar + '" alt="' + authorName + '" class="author-avatar">' +

            '<div>' +
            '<div class="d-flex align-items-center">' +
            '<span class="author-name">' + authorName + '</span>' +
            statusBadgeHtml +
            '</div>' +
            '<div class="comment-meta"><span>' + createdAt + '</span></div>' +
            '</div>' +
            '</div>' +
            '<p class="comment-content">' + (comment.content || '') + '</p>' +
            '<div class="comment-actions">' + actionsHtml + '</div>' +
            repliesHtml +
            '</div>'
        );
    }


    statusFilter.addEventListener('change', function () {
        currentStatusFilter = this.value;
        fetchAndRenderHub(0, currentStatusFilter, currentKeyword, currentStartDate, currentEndDate);
    });

    function handleSearch() {
        currentKeyword = keywordSearchInput.value.trim();
        fetchAndRenderHub(0, currentStatusFilter, currentKeyword, currentStartDate, currentEndDate);
    }
    keywordSearchButton.addEventListener('click', handleSearch);
    keywordSearchInput.addEventListener('keypress', function (e) { if (e.key === 'Enter') handleSearch(); });

    paginationContainer.addEventListener('click', function (e) {
        e.preventDefault();
        const button = e.target.closest('button.page-link');
        if (button && !button.disabled) {
            const pageToFetch = parseInt(button.dataset.page, 10);
            if (!isNaN(pageToFetch) && pageToFetch !== currentPage) {
                fetchAndRenderHub(pageToFetch, currentStatusFilter, currentKeyword, currentStartDate, currentEndDate);
            }
        }
    });

    hubContainer.addEventListener('click', async function (e) {
        const target = e.target;
        const commentElement = target.closest('.comment');
        if (!commentElement) return;

        const commentId = parseInt(commentElement.dataset.id, 10);
        if (isNaN(commentId)) return;

        const action = target.dataset.action;
        const status = target.dataset.status;
        if (action && status) {
            e.preventDefault();
            updateStatus(commentId, status);
            return;
        }

        if (target.classList.contains('btn-reply')) {
            const lessonId = parseInt(commentElement.dataset.lessonId, 10);
            if (isNaN(lessonId)) {
                alert('Lỗi: Không thể trả lời bình luận này. Thiếu dữ liệu cần thiết.');
                return;
            }
            document.querySelectorAll('.reply-form').forEach(form => form.remove());
            const replyForm = document.createElement('form');
            replyForm.className = 'reply-form mt-2';
            replyForm.innerHTML =
                '<div class="form-group"><textarea class="form-control" rows="2" placeholder="Viết trả lời..." required></textarea></div>' +
                '<button type="submit" class="btn btn-sm btn-primary mt-1">Gửi trả lời</button>' +
                '<button type="button" class="btn btn-sm btn-secondary mt-1 cancel-reply">Hủy</button>';
            commentElement.querySelector('.comment-actions').insertAdjacentElement('afterend', replyForm);
            const textArea = replyForm.querySelector('textarea');
            textArea.focus();
            replyForm.addEventListener('submit', async function (submitEvent) {
                submitEvent.preventDefault();
                const replyContent = textArea.value.trim();
                if (replyContent) {
                    const newReplyData = await postComment(replyContent, commentId, lessonId);
                    if (newReplyData) {
                        fetchAndRenderHub(currentPage, currentStatusFilter, currentKeyword, currentStartDate, currentEndDate);
                        fetchAndRenderStatistics();
                    } else {
                        alert('Gửi trả lời thất bại.');
                    }
                }
            });
            replyForm.querySelector('.cancel-reply').addEventListener('click', () => { replyForm.remove(); });
        }
        if (target.classList.contains('btn-delete')) {
            if (!confirm('Bạn có chắc chắn muốn xóa bình luận này không?')) return;
            const success = await deleteComment(commentId);
            if (success) {
                fetchAndRenderHub(currentPage, currentStatusFilter, currentKeyword, currentStartDate, currentEndDate);
                fetchAndRenderStatistics();
            } else {
                alert('Xóa bình luận thất bại.');
            }
        }
    });

    let fpStartDate, fpEndDate;
    function applyDateFilter() {
        const startDate = fpStartDate.selectedDates[0];
        const endDate = fpEndDate.selectedDates[0];
        currentStartDate = startDate ? startDate.toISOString().split('T')[0] + 'T00:00:00' : null;
        currentEndDate = endDate ? endDate.toISOString().split('T')[0] + 'T23:59:59' : null;
        fetchAndRenderHub(0, currentStatusFilter, currentKeyword, currentStartDate, currentEndDate);
    }
    fpStartDate = flatpickr(startDateInput, { dateFormat: "d-m-Y", onChange: function (selectedDates) { if (fpEndDate) fpEndDate.set('minDate', selectedDates[0]); } });
    fpEndDate = flatpickr(endDateInput, { dateFormat: "d-m-Y" });
    dateFilterButton.addEventListener('click', applyDateFilter);
    dateClearButton.addEventListener('click', function () {
        fpStartDate.clear();
        fpEndDate.clear();
        currentStartDate = null;
        currentEndDate = null;
        fetchAndRenderHub(0, currentStatusFilter, currentKeyword, null, null);
    });


    fetchAndRenderStatistics();
    fetchAndRenderHub(0, currentStatusFilter, currentKeyword, currentStartDate, currentEndDate);
});