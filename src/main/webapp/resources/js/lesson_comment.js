(function () {
    document.addEventListener('DOMContentLoaded', function () {

        if (typeof window.learningConfig === 'undefined' || !window.learningConfig) {
            console.error('Lỗi nghiêm trọng: Đối tượng window.learningConfig không được tìm thấy. Script bình luận không thể hoạt động.');
            return;
        }

        const commentsContainer = document.getElementById('comments-list-container');
        const newCommentForm = document.getElementById('new-comment-form');
        const commentContentInput = document.getElementById('comment-content-input');
        if (!commentsContainer || !newCommentForm || !commentContentInput) {
            console.error('Lỗi nghiêm trọng: Một hoặc nhiều phần tử DOM cho chức năng bình luận không được tìm thấy. Hãy kiểm tra lại các ID.');
            return;
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
            if (!comments || comments.length === 0) {
                commentsContainer.innerHTML = '<p class="text-muted">Chưa có bình luận nào cho bài học này.</p>';
                return;
            }
            comments.forEach(comment => {
                commentsContainer.appendChild(createCommentElement(comment));
            });
        }

        function createCommentElement(comment) {
            // 1. Tạo thẻ div bao ngoài cho bình luận hiện tại
            const div = document.createElement('div');
            // Giữ lại cấu trúc HTML gốc của bạn
            div.innerHTML = `
                <div class="d-flex mb-3">
                    <img src="${comment.author?.avatarUrl ? "/img/avatar/" + comment.author.avatarUrl : '/img/avatar-default.jpg'}"
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

            // 2. Tìm vị trí để chèn các trả lời con (ngay sau thẻ div.d-flex)
            const repliesInsertionPoint = div.querySelector('.d-flex');

            // 3. XỬ LÝ ĐỆ QUY
            if (Array.isArray(comment.replies) && comment.replies.length > 0 && repliesInsertionPoint) {
                const repliesContainer = document.createElement('div');
                repliesContainer.classList.add('ms-5'); // Thụt lề cho cả khối

                comment.replies.forEach(reply => {
                    // Gọi lại chính nó để tạo element cho reply
                    const replyElement = createCommentElement(reply); 
                    repliesContainer.appendChild(replyElement);
                });

                // Chèn khối replies vào sau thẻ div.d-flex của cha
                repliesInsertionPoint.insertAdjacentElement('afterend', repliesContainer);
            }
            
            // Gắn sự kiện cho nút trả lời (giữ nguyên logic gốc của bạn)
            const replyLink = div.querySelector('.reply-link');
            const replyFormContainer = div.querySelector('.reply-form-container');
            replyLink.addEventListener('click', (e) => handleReplyLinkClick(e, replyFormContainer));
            const submitReplyButton = div.querySelector('.submit-reply');
            submitReplyButton.addEventListener('click', (e) => handleSubmitReplyClick(e, comment.id));

            return div;
        }

        function handleReplyLinkClick(e, replyFormContainer) {
            e.preventDefault();
            replyFormContainer.style.display = replyFormContainer.style.display === 'none' ? 'block' : 'none';
        }

        async function handleSubmitReplyClick(e, parentId) {
            const replyFormContainer = e.target.closest('.reply-form-container');
            const replyInput = replyFormContainer.querySelector('.reply-input');
            const content = replyInput.value.trim();
            if (!content) {
                alert("Vui lòng nhập nội dung phản hồi.");
                return;
            }

            const cfg = window.learningConfig;
            const replyData = {
                content,
                lessonId: cfg.currentLessonId || cfg.defaultLessonId,
                subjectId: cfg.subjectId,
                packageId: cfg.packageId,
                parentId
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
        }

        // Hàm tạo bình luận chờ duyệt (có 2 hàm trùng tên, tôi giữ lại hàm dưới)
        function createPendingCommentElement(content) {
            const div = document.createElement('div');
            div.classList.add('d-flex', 'mb-3', 'opacity-75');
            div.innerHTML = `
                    <img src="${window.learningConfig?.currentUser?.avatarUrl ? '/img/avatar/' + window.learningConfig.currentUser.avatarUrl : '/img/avatar-default.jpg'}"
                class="rounded-circle me-3" style="width: 40px; height: 40px; object-fit: cover;">
                    <div>
                        <strong>Bạn</strong>
                        <p class="mb-1">${content}</p>
                        <small class="text-muted">Phản hồi của bạn đang chờ duyệt</small>
                    </div>
            `;
            return div;
        }

        function createPendingReplyElement(content) {
    const div = document.createElement('div');
    div.classList.add('ms-5', 'mt-2', 'border', 'p-2', 'bg-light', 'rounded');
    div.innerHTML = `
        <div class="d-flex">
            <img src="/img/avatar-default.jpg" class="rounded-circle me-3" style="width: 40px; height: 40px; object-fit: cover;">
            <div>
                <strong>Bạn</strong>
                <p class="mb-1">${content}</p>
                <small class="text-muted">Phản hồi của bạn đang chờ duyệt</small>
            </div>
        </div>
    `;
    return div;
}

        // Hàm submit form chính
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

            const cfg = window.learningConfig;
            const commentData = {
                content: content,
                lessonId: cfg.currentLessonId || cfg.defaultLessonId,
                subjectId: cfg.subjectId,
                packageId: cfg.packageId,
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
                    const noCommentsMessage = commentsContainer.querySelector('.text-muted');
            if (noCommentsMessage && noCommentsMessage.textContent.includes('Chưa có bình luận nào')) {
                commentsContainer.innerHTML = '';
            }
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
        
        // Lắng nghe sự kiện chuyển bài
        document.addEventListener('lessonChanged', function (event) {
            if(event.detail && event.detail.lessonId) {
                const newLessonId = event.detail.lessonId;
                console.log('Nhận được sự kiện lessonChanged, tải bình luận cho lessonId:', newLessonId);
                loadCommentsForLesson(newLessonId);
                // Cập nhật lại currentLessonId để form submit dùng
                if(window.learningConfig) {
                    window.learningConfig.currentLessonId = newLessonId;
                }
            }
        });

        // Khởi chạy lần đầu
        const initialLessonId = window.learningConfig.defaultLessonId;
        window.learningConfig.currentLessonId = initialLessonId;
        loadCommentsForLesson(initialLessonId);

    });
})();