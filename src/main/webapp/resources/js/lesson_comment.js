// Bọc toàn bộ code trong một IIFE (Immediately Invoked Function Expression) để tránh xung đột biến
(function () {
    // Chờ cho toàn bộ cấu trúc HTML của trang được tải xong rồi mới chạy code
    document.addEventListener('DOMContentLoaded', function () {

        // --- KIỂM TRA CÁC ĐIỀU KIỆN CẦN THIẾT ---

        // 1. Kiểm tra xem đối tượng learningConfig có tồn tại không
        if (typeof window.learningConfig === 'undefined' || !window.learningConfig) {
            console.error('Lỗi nghiêm trọng: Đối tượng window.learningConfig không được tìm thấy. Script bình luận không thể hoạt động.');
            return;
        }

        // 2. Tìm các phần tử DOM và kiểm tra sự tồn tại của chúng
        const commentsContainer = document.getElementById('comments-list-container');
        const newCommentForm = document.getElementById('new-comment-form');
        const commentContentInput = document.getElementById('comment-content-input');

        if (!commentsContainer || !newCommentForm || !commentContentInput) {
            console.error('Lỗi nghiêm trọng: Một hoặc nhiều phần tử DOM cho chức năng bình luận không được tìm thấy. Hãy kiểm tra lại các ID.');
            return; // Dừng script nếu thiếu phần tử
        }


        async function loadCommentsForLesson(lessonId) {
            if (!lessonId) {
                commentsContainer.innerHTML = '<p class="text-muted">Vui lòng chọn một bài học để xem bình luận.</p>';
                return;
            }
            commentsContainer.innerHTML = '<p class="text-muted">Đang tải bình luận...</p>';
            try {
                const response = await fetch(`/api/comments/lesson/${lessonId}`);
                if (!response.ok) throw new Error('Lỗi tải dữ liệu bình luận từ server');

                const comments = await response.json();

                renderComments(comments);
            } catch (error) {
                commentsContainer.innerHTML = '<p class="text-danger">Không thể tải bình luận. Vui lòng thử lại.</p>';
                console.error(error);
            }
        }

        function renderComments(comments) {
    commentsContainer.innerHTML = '';

    comments.forEach(parent => {
        const parentElement = createCommentElement(parent);
        commentsContainer.appendChild(parentElement);

        if (Array.isArray(parent.replies)) {
            parent.replies.forEach(reply => {
                const replyElement = createCommentElement(reply);
                replyElement.classList.add('ms-5'); // thụt lề cho reply
                commentsContainer.appendChild(replyElement);
            });
        }
    });
}

function createPendingCommentElement(content) {
    const div = document.createElement('div');
    div.innerHTML = `
        <div class="d-flex mb-3 text-muted">
            <img src="https://via.placeholder.com/40"
                class="rounded-circle me-3" style="width: 40px; height: 40px; object-fit: cover;">
            <div>
                <strong>Bạn (chờ duyệt)</strong>
                <p class="mb-1 fst-italic">${content}</p>
                <small class="text-muted">${new Date().toLocaleString('vi-VN')}</small>
            </div>
        </div>
    `;
    return div;
}



        function createCommentElement(comment) {
            const div = document.createElement('div');
            div.innerHTML = `
        <div class="d-flex mb-3">
            <img src="${comment.author?.avatar || 'https://via.placeholder.com/40'}"
                class="rounded-circle me-3" style="width: 40px; height: 40px; object-fit: cover;">
            <div>
                <strong>${comment.author?.name || 'Người dùng ẩn danh'}</strong>
                <p class="mb-1">${comment.content}</p>
                <small class="text-muted">
                    <span>${new Date(comment.createdAt).toLocaleString('vi-VN')}</span>
                    <a href="#" class="ms-2 reply-link" data-comment-id="${comment.id}">Trả lời</a>
                </small>
                <div class="reply-form-container mt-2" style="display:none;">
                    <textarea class="form-control mb-2 reply-input" rows="2" placeholder="Nhập phản hồi..."></textarea>
                    <button class="btn btn-sm btn-success submit-reply">Gửi</button>
                </div>
            </div>
        </div>
    `;
    const replyLink = div.querySelector('.reply-link');
    const replyFormContainer = div.querySelector('.reply-form-container');
    const replyInput = div.querySelector('.reply-input');
    const submitReplyButton = div.querySelector('.submit-reply');

    replyLink.addEventListener('click', function (e) {
        e.preventDefault();
        replyFormContainer.style.display = replyFormContainer.style.display === 'none' ? 'block' : 'none';
    });

    submitReplyButton.addEventListener('click', async function () {
        const content = replyInput.value.trim();
        if (!content) {
            alert("Vui lòng nhập nội dung phản hồi.");
            return;
        }

        const lessonId = window.learningConfig.currentLessonId || window.learningConfig.defaultLessonId;
        const subjectId = window.learningConfig.subjectId;
        const packageId = window.learningConfig.packageId;
        const parentId = replyLink.dataset.commentId;

        const replyData = {
            content: content,
            lessonId: lessonId,
            subjectId: subjectId,
            packageId: packageId,
            parentId: parentId
        };

        try {
            const response = await fetch('/api/comments/add', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(replyData)
            });

            if (response.ok) {
            replyInput.value = '';
            replyFormContainer.style.display = 'none';
            const pendingReplyElement = createPendingReplyElement(content);
            replyFormContainer.insertAdjacentElement('afterend', pendingReplyElement);
            } else {
                const errorText = await response.text();
                alert("Không gửi được phản hồi: " + errorText);
            }
        } catch (err) {
            console.error("Lỗi gửi phản hồi:", err);
            alert("Đã xảy ra lỗi khi gửi phản hồi.");
        }
    });
            return div;
        }

        function createPendingReplyElement(content) {
    const div = document.createElement('div');
    div.classList.add('ms-5', 'mt-2', 'border', 'p-2', 'bg-light', 'rounded');

    div.innerHTML = `
        <div class="d-flex">
            <img src="https://via.placeholder.com/40"
                class="rounded-circle me-3" style="width: 40px; height: 40px; object-fit: cover;">
            <div>
                <strong>Bạn</strong>
                <p class="mb-1">${content}</p>
                <small class="text-muted">Phản hồi của bạn đang chờ duyệt</small>
            </div>
        </div>
    `;
    return div;
}


        newCommentForm.addEventListener('submit', async function (e) {
            e.preventDefault();

            const content = commentContentInput.value.trim();
            if (!content) {
                alert('Vui lòng nhập nội dung bình luận.');
                return;
            }

            const button = newCommentForm.querySelector('button[type="submit"]');
            button.disabled = true;
            button.innerHTML = 'Đang gửi...';

            const currentLessonId = window.learningConfig.currentLessonId || window.learningConfig.defaultLessonId;
            const subjectId = window.learningConfig.subjectId;
            const packageId = window.learningConfig.packageId;

            if (!currentLessonId || !subjectId || !packageId) {
                alert('Lỗi: Thiếu thông tin (bài học, môn học, hoặc gói học) để gửi bình luận. Vui lòng tải lại trang.');
                button.disabled = false;
                button.innerHTML = 'Gửi bình luận';
                return;
            }

            const commentData = {
                content: content,
                lessonId: currentLessonId,
                subjectId: subjectId,
                packageId: packageId,
                parentId: null
            };

            try {
                const response = await fetch('/api/comments/add', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(commentData)
                });

                if (response.ok) {
                    commentContentInput.value = '';
                    const pendingDiv = createPendingCommentElement(content);
                    commentsContainer.prepend(pendingDiv);
                } else {
                    const errorText = await response.text();
                    alert(`Gửi bình luận thất bại. Lỗi từ server: ${errorText}`);
                }
            } catch (error) {
                console.error('Lỗi mạng khi gửi bình luận:', error);
                alert('Đã xảy ra lỗi kết nối. Vui lòng thử lại.');
            } finally {
                button.disabled = false;
                button.innerHTML = 'Gửi bình luận';
            }
        });

        document.addEventListener('lessonChanged', function (event) {
            const newLessonId = event.detail.lessonId;
            console.log('Nhận được sự kiện lessonChanged, tải bình luận cho lessonId:', newLessonId);
            loadCommentsForLesson(newLessonId);
        });

        const initialLessonId = window.learningConfig.defaultLessonId;
        loadCommentsForLesson(initialLessonId);

    });
})();
