<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Communication Hub</title>
                <link rel="stylesheet" href="<c:url value='/lib/bootstrap/css/bootstrap.css'/>">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                    rel="stylesheet">
                <style>
                    body {
                        margin: 0;
                        min-height: 100vh;
                        display: flex;
                        flex-direction: column;
                        overflow-x: hidden;
                        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
                        background-color: #f8f9fa;
                        font-size: 1rem;
                    }

                    header {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        z-index: 1030;
                        height: 55px;
                        background-color: #1a252f;
                    }

                    .main-container {
                        display: flex;
                        flex: 1;
                        margin-top: 55px;
                    }

                    .sidebar {
                        width: 250px;
                        background-color: #1a252f;
                        color: white;
                        overflow-y: auto;
                    }

                    .content {
                        flex: 1;
                        padding: 20px;
                        background-color: #f8f9fa;
                        overflow-y: auto;
                    }

                    footer {
                        background-color: #1a252f;
                        color: white;
                        height: 40px;
                        width: 100%;
                    }

                    .comment-card {
                        border: 1px solid #e0e0e0;
                        border-radius: 8px;
                        margin-bottom: 20px;
                        background-color: #fff;
                    }

                    .comment-header {
                        padding: 15px;
                        border-bottom: 1px solid #e0e0e0;
                        font-weight: bold;
                        background-color: #f8f9fa;
                    }

                    .comment-body {
                        padding: 15px;
                    }

                    .comment {
                        border-left: 2px solid #eee;
                        padding-left: 15px;
                        margin-top: 15px;
                    }

                    .comment .author-info {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .comment .author-avatar {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        object-fit: cover;
                    }

                    .comment .author-name {
                        font-weight: bold;
                    }

                    .comment .comment-meta {
                        color: #888;
                        font-size: 0.9em;
                    }

                    .comment-content {
                        margin-top: 5px;
                    }

                    .replies {
                        margin-left: 20px;
                        border-left: 2px solid #f0f0f0;
                    }

                    .reply-form {
                        margin-top: 10px;
                    }

                    .btn-reply,
                    .btn-delete {
                        cursor: pointer;
                        font-size: 0.9em;
                        user-select: none;
                        font-weight: 500;
                    }

                    .btn-reply {
                        color: #007bff;
                    }

                    .btn-delete {
                        color: #dc3545;
                    }


                    .status-badge {
                        display: inline-block;
                        padding: 0.25em 0.6em;
                        font-size: 75%;
                        font-weight: 700;
                        line-height: 1;
                        text-align: center;
                        white-space: nowrap;
                        vertical-align: baseline;
                        border-radius: 0.375rem;
                        color: #fff;
                        margin-left: 10px;
                    }

                    .status-PENDING {
                        background-color: #ffc107;
                        color: #000;
                    }

                    /* Trạng thái chờ duyệt */
                    .status-APPROVED {
                        background-color: #198754;
                    }

                    /* Trạng thái đã duyệt */
                    .status-REJECTED {
                        background-color: #dc3545;
                    }

                    /* Trạng thái từ chối */

                    .comment-actions {
                        margin-top: 8px;
                        /* Tăng khoảng cách một chút */
                    }

                    /* Định dạng chung cho các link hành động */
                    .action-link {
                        cursor: pointer;
                        font-size: 0.9em;
                        user-select: none;
                        font-weight: 500;
                        margin-right: 15px;
                        text-decoration: none;
                        transition: opacity 0.2s;
                    }

                    .action-link:hover {
                        opacity: 0.7;
                    }

                    .action-approve {
                        color: #198754;
                    }

                    .action-reject {
                        color: #dc3545;
                    }

                    .action-reply {
                        color: #007bff;
                    }

                    .action-delete {
                        color: #6c757d;
                    }

                    .action-show { color: #0dcaf0; }

                    .filter-bar {
    background-color: #fff;
    padding: 15px;
    border: 1px solid #dee2e6;
    border-radius: 8px;
    margin-bottom: 20px;
    display: flex;
    gap: 20px;
    align-items: center;
}
.stats-summary span {
    margin-right: 15px;
    font-size: 0.9em;
}
.stats-summary strong {
    font-size: 1.1em;
}
                </style>
            </head>

            <body>
                <header>
                    <jsp:include page="../layout/header.jsp" />
                </header>

                <div class="main-container">
                    <div class="sidebar">
                        <jsp:include page="../layout/sidebar.jsp" />
                    </div>

                    <div class="content">
                        <main>
                            <div class="container-fluid px-4">
                                <h3>Communication Hub</h3>
                                <p class="text-muted">All questions from users across all subjects and lessons.</p>
                                <hr>
                                <div class="filter-bar">
    <!-- Khu vực thống kê -->
    <div id="stats-container" class="stats-summary">
        <span>Loading stats...</span>
    </div>
    
    <!-- Dropdown bộ lọc -->
    <div class="ms-auto"> <!-- Đẩy sang phải -->
        <select class="form-select" id="status-filter">
            <option value="">All Statuses</option>
            <option value="PENDING">Pending</option>
            <option value="APPROVED">Approved</option>
            <option value="REJECTED">Rejected</option>
            <option value="HIDDEN">Hidden</option>
        </select>
    </div>
</div>
                                <div id="hub-container">
                                    <p>Loading communications...</p>
                                </div>
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center" id="pagination-container">
                                    </ul>
                                </nav>
                            </div>
                        </main>
                    </div>
                </div>

                <footer>
                    <jsp:include page="../layout/footer.jsp" />
                </footer>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        console.log('DOM fully loaded and parsed.');

                        const hubContainer = document.getElementById('hub-container');
                        const paginationContainer = document.getElementById('pagination-container');
                        const statsContainer = document.getElementById('stats-container');
const statusFilter = document.getElementById('status-filter');

                        let currentPage = 0;
                        const pageSize = 5;
                        let currentStatusFilter = "";

                        async function fetchAndRenderStatistics() {
    try {
        const apiUrl = '<c:url value="/api/communications/hub/statistics"/>';
        const response = await fetch(apiUrl);
        if (!response.ok) {
            statsContainer.innerHTML = '<span>Could not load stats.</span>';
            return;}

        const stats = await response.json();
        statsContainer.innerHTML =
            '<span>Total: <strong>' + stats.total + '</strong></span>' +
            '<span class="text-warning">Pending: <strong>' + stats.pending + '</strong></span>' +
            '<span class="text-success">Approved: <strong>' + stats.approved + '</strong></span>' +
            '<span class="text-danger">Rejected: <strong>' + stats.rejected + '</strong></span>' +
            '<span class="text-muted">Hidden: <strong>' + stats.hidden + '</strong></span>';
    } catch (error) {
        console.error("Failed to load statistics:", error);
        statsContainer.innerHTML = '<span>Could not load stats.</span>';
    }
}

                        async function fetchAndRenderHub(pageNumber, status) {
                            // DEBUG: Sửa lại cú pháp console.log để không bị lỗi JSP
                            console.log('[fetchAndRenderHub] Function called with pageNumber:', pageNumber, '(type: ' + (typeof pageNumber) + ')');

                            const pageToFetch = (typeof pageNumber === 'number' && pageNumber >= 0) ? pageNumber : 0;

                            console.log('[fetchAndRenderHub] Will fetch for page: ' + pageToFetch + ', size: ' + pageSize);

                            try {
                                hubContainer.innerHTML = '<p>Loading communications...</p>';

                                const params = new URLSearchParams({
                                    page: pageToFetch,
                                    size: pageSize
                                });

                                if (status) {
            params.append('status', status);
        }
                                const apiUrl = '<c:url value="/api/communications/hub"/>?' + params.toString();
                                console.log('[fetchAndRenderHub] Request URL:', apiUrl);

                                const response = await fetch(apiUrl);
                                if (!response.ok) {
                                    throw new Error('API Error: ' + response.status + ' - ' + response.statusText);
                                }

                                const pagedData = await response.json();
                                console.log('[fetchAndRenderHub] Received pagedData:', pagedData);

                                const comments = pagedData.content;

                                hubContainer.innerHTML = '';
                                if (!comments || comments.length === 0) {
                                    hubContainer.innerHTML = pagedData.number > 0 ? '<p>No comments on this page.</p>' : '<p>No communications yet.</p>';
                                } else {
                                    comments.forEach(comment => {
                                        hubContainer.appendChild(createHubEntryElement(comment));
                                    });
                                }

                                currentPage = pagedData.number;
                                console.log('[fetchAndRenderHub] currentPage state updated to: ' + currentPage);
                                renderPagination(pagedData);

                            } catch (error) {
                                hubContainer.innerHTML = '<p style="color: red;">Failed to load communications: ' + error.message + '</p>';
                                console.error('[JAVASCRIPT ERROR]', error);
                            }
                        }

                        function renderPagination(pagedData) {
                            paginationContainer.innerHTML = '';
                            const totalPages = pagedData.totalPages;
                            const currentActivePage = pagedData.number;

                            if (totalPages <= 1) return;

                            const createPageItem = (pageIndex, text, isDisabled, isActive) => {
                                const li = document.createElement('li');
                                li.className = 'page-item' + (isDisabled ? ' disabled' : '') + (isActive ? ' active' : '');

                                const button = document.createElement('button');
                                button.className = 'page-link';
                                button.dataset.page = pageIndex;
                                button.textContent = text;
                                if (isDisabled) {
                                    button.setAttribute('disabled', 'disabled');
                                }
                                if (text === 'Previous' || text === 'Next') {
                                    button.setAttribute('aria-label', text);
                                }

                                li.appendChild(button);
                                return li;
                            };

                            paginationContainer.appendChild(createPageItem(currentActivePage - 1, 'Previous', pagedData.first));
                            for (let i = 0; i < totalPages; i++) {
                                paginationContainer.appendChild(createPageItem(i, i + 1, false, i === currentActivePage));
                            }
                            paginationContainer.appendChild(createPageItem(currentActivePage + 1, 'Next', pagedData.last));
                        }

                        function createHubEntryElement(comment) {
                            const cardDiv = document.createElement('div');
                            cardDiv.className = 'comment-card';
                            const commentTreeHtml = createCommentRecursive(comment);
                            cardDiv.innerHTML =
                                '<div class="comment-header">Subject: ' + (comment.subjectName || 'N/A') + ' | Lesson: ' + (comment.lessonName || 'N/A') + '</div>' +
                                '<div class="comment-body">' + commentTreeHtml + '</div>';
                            return cardDiv;
                        }



function createCommentRecursive(comment) {
    const author = comment.author || {};
    const authorName = author.name || 'Anonymous User';
    const avatarUrlBase = '<c:url value="/images/"/>';
    const avatar = author.avatarUrl ? avatarUrlBase + author.avatarUrl : 'https://via.placeholder.com/40';
    let createdAt = 'Invalid Date';
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
        const formattedStatus = status.charAt(0).toUpperCase() + status.slice(1).toLowerCase();
        statusBadgeHtml = '<span class="status-badge status-' + status + '">' + formattedStatus + '</span>';
    }


    switch (status) {
        case 'PENDING':
            actionsHtml += '<span class="action-link action-approve" data-action="approve" data-status="APPROVED">Approve</span>';
            actionsHtml += '<span class="action-link action-reject" data-action="reject" data-status="REJECTED">Reject</span>';
            break;

        case 'APPROVED':
            actionsHtml += '<span class="action-link action-reject" data-action="hide" data-status="HIDDEN">Hide</span>';
            // CHỈ THÊM NÚT REPLY KHI TRẠNG THÁI LÀ APPROVED
            actionsHtml += '<span class="action-link action-reply btn-reply">Reply</span>';
            break;

        case 'REJECTED':
            actionsHtml += '<span class="action-link action-approve" data-action="approve" data-status="APPROVED">Approve</span>';
            break;

        case 'HIDDEN':
            actionsHtml += '<span class="action-link action-show" data-action="show" data-status="APPROVED">Show</span>';
            break;
    }

    actionsHtml += '<span class="action-link action-delete btn-delete">Delete</span>';

    return (
        '<div class="comment" data-id="' + comment.id + '" data-lesson-id="' + comment.lessonId + '">' +
            '<div class="author-info">' +
                '<img src="' + avatar + '" alt="' + authorName + '" class="author-avatar">' +
                '<div>' +
                    '<span class="author-name">' + authorName + '</span>' +
                    statusBadgeHtml +
                    '<div class="comment-meta"><span>' + createdAt + '</span></div>' +
                '</div>' +
            '</div>' +
            '<p class="comment-content">' + (comment.content || '') + '</p>' +
            '<div class="comment-actions">' + actionsHtml + '</div>' +
            repliesHtml +
        '</div>'
    );
}

                        async function postComment(content, parentId, lessonId) {
                            if (!lessonId) {
                                console.error('postComment failed: lessonId is missing.');
                                return null;
                            }
                            try {
                                const apiUrl = '<c:url value="/api/communications/lesson"/>/' + lessonId;
                                const response = await fetch(apiUrl, {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json' },
                                    body: JSON.stringify({ content, parentId })
                                });
                                return response.ok ? await response.json() : null;
                            } catch (error) {
                                console.error('Error posting comment:', error);
                                return null;
                            }
                        }

                        async function deleteComment(commentId) {
                            if (!commentId) {
                                console.error('deleteComment failed: commentId is missing.');
                                return false;
                            }
                            try {
                                const apiUrl = '<c:url value="/api/communications"/>/' + commentId;
                                const response = await fetch(apiUrl, { method: 'DELETE' });
                                return response.ok;
                            } catch (error) {
                                console.error('Error deleting comment:', error);
                                return false;
                            }
                        }


                        async function updateStatus(commentId, newStatus) {
                            try {
                                const apiUrl = '<c:url value="/api/communications/"/>' + commentId + '/status';
                                const response = await fetch(apiUrl, {
                                    method: 'PUT',
                                    headers: { 'Content-Type': 'application/json' },
                                    // Gửi đúng cấu trúc JSON mà UpdateStatusRequest mong đợi
                                    body: JSON.stringify({ commentStatus: newStatus })
                                });

                                if (response.ok) {
                                    // Tải lại trang hiện tại để cập nhật giao diện
                                    fetchAndRenderHub(currentPage,currentStatusFilter);
                                    fetchAndRenderStatistics();
                                } else {
                                    const errorData = await response.text();
                                    alert('Failed to update status. Server responded with: ' + errorData);
                                }
                            } catch (error) {
                                console.error('Error updating status:', error);
                                alert('An error occurred while updating status.');
                            }
                        }

                        paginationContainer.addEventListener('click', function (e) {
                            console.log('[Pagination Click] Event triggered.');
                            e.preventDefault();

                            const button = e.target.closest('button.page-link');
                            console.log('[Pagination Click] Clicked element:', e.target);
                            console.log('[Pagination Click] Closest button.page-link:', button);

                            if (button && !button.disabled) {
                                const pageValueFromDataset = button.dataset.page;
                                console.log('[Pagination Click] Button is valid. data-page attribute value:', pageValueFromDataset, '(type: ' + (typeof pageValueFromDataset) + ')');

                                const pageToFetch = parseInt(pageValueFromDataset, 10);
                                console.log('[Pagination Click] Parsed page number:', pageToFetch, '(type: ' + (typeof pageToFetch) + ')');

                                if (!isNaN(pageToFetch) && pageToFetch !== currentPage) {
                                    console.log('[Pagination Click] Page is different from current (' + currentPage + '). Calling fetchAndRenderHub.');
                                    fetchAndRenderHub(pageToFetch,currentStatusFilter);
                                } else {
                                    console.log('[Pagination Click] Page is same as current or NaN. Not fetching. isNaN: ' + isNaN(pageToFetch) + ', pageToFetch: ' + pageToFetch + ', currentPage: ' + currentPage);
                                }
                            } else {
                                console.log('[Pagination Click] Click was not on a valid, enabled page-link button.');
                            }
                        });

                        statusFilter.addEventListener('change', function() {
    // Cập nhật trạng thái filter toàn cục
    currentStatusFilter = this.value; 
    // Khi thay đổi bộ lọc, luôn fetch lại từ trang đầu tiên (trang 0)
    fetchAndRenderHub(0, currentStatusFilter);
});



                        hubContainer.addEventListener('click', async function (e) {
                            const target = e.target;
                            const commentElement = target.closest('.comment');

                            if (!commentElement) {
                                return;
                            }

                            const commentId = parseInt(commentElement.dataset.id, 10);
                            if (isNaN(commentId)) {
                                console.error('Could not find a valid comment ID.');
                                return;
                            }

                            const action = target.dataset.action;
                            const status = target.dataset.status;
                            if (action && status) {
                                e.preventDefault();
                                updateStatus(commentId, status);
                                return;
                            }

                            if (target.classList.contains('btn-reply')) {
                                // const commentElement = target.closest('.comment');
                                // const parentId = parseInt(commentElement.dataset.id, 10);
                                const lessonId = parseInt(commentElement.dataset.lessonId, 10);
                                if (isNaN(lessonId)) {
                                    alert('Error: Cannot reply to this comment. Missing required data.');
                                    return;
                                }
                                document.querySelectorAll('.reply-form').forEach(form => form.remove());

                                const replyForm = document.createElement('form');
                                replyForm.className = 'reply-form';
                                replyForm.innerHTML =
                                    '<div class="form-group"><textarea class="form-control" rows="2" placeholder="Write a reply..." required></textarea></div>' +
                                    '<button type="submit" class="btn btn-sm btn-primary mt-1">Submit Reply</button>' +
                                    '<button type="button" class="btn btn-sm btn-secondary mt-1 cancel-reply">Cancel</button>';

                                commentElement.appendChild(replyForm);
                                const textArea = replyForm.querySelector('textarea');
                                textArea.focus();
                                replyForm.addEventListener('submit', async function (submitEvent) {
                                    submitEvent.preventDefault();
                                    const replyContent = textArea.value.trim();
                                    if (replyContent) {
                                        const newReplyData = await postComment(replyContent, commentId, lessonId);
                                        if (newReplyData) {
                                            fetchAndRenderHub(currentPage,currentStatusFilter);
                                            fetchAndRenderStatistics();
                                        } else {
                                            alert('Failed to post reply.');
                                        }
                                    }
                                });
                                replyForm.querySelector('.cancel-reply').addEventListener('click', () => { replyForm.remove(); });
                            }
                            if (target.classList.contains('btn-delete')) {
                                const success = await deleteComment(commentId);
                                if (success) {
                                    fetchAndRenderHub(currentPage,currentStatusFilter);
                                    fetchAndRenderStatistics();
                                } else {
                                    alert('Failed to delete comment.');
                                }
                            }
                        });

                        console.log('Initial load: calling fetchAndRenderHub(0)');
                        fetchAndRenderStatistics();
                        fetchAndRenderHub(0,currentStatusFilter);
                    });
                </script>
            </body>

            </html>