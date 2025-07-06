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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { margin: 0; min-height: 100vh; display: flex; flex-direction: column; overflow-x: hidden; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif; background-color: #f8f9fa; font-size: 1rem; }
        header { position: fixed; top: 0; left: 0; right: 0; z-index: 1030; height: 55px; background-color: #1a252f; }
        .main-container { display: flex; flex: 1; margin-top: 55px; }
        .sidebar { width: 250px; background-color: #1a252f; color: white; overflow-y: auto; }
        .content { flex: 1; padding: 20px; background-color: #f8f9fa; overflow-y: auto; }
        footer { background-color: #1a252f; color: white; height: 40px; width: 100%; }
        .comment-card { border: 1px solid #e0e0e0; border-radius: 8px; margin-bottom: 20px; background-color: #fff; }
        .comment-header { padding: 15px; border-bottom: 1px solid #e0e0e0; font-weight: bold; background-color: #f8f9fa; }
        .comment-body { padding: 15px; }
        .comment { border-left: 2px solid #eee; padding-left: 15px; margin-top: 15px; }
        .comment .author-info { display: flex; align-items: center; gap: 10px; }
        .comment .author-avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; }
        .comment .author-name { font-weight: bold; }
        .comment .comment-meta { color: #888; font-size: 0.9em; }
        .comment-content { margin-top: 5px; }
        .replies { margin-left: 20px; }
        .reply-form { margin-top: 10px; }
        .btn-reply { cursor: pointer; color: #007bff; font-size: 0.9em; user-select: none; }
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
                <div id="hub-container">
                    <p>Loading communications...</p>
                </div>
            </div>
        </main>
    </div>
</div>

<footer>
    <jsp:include page="../layout/footer.jsp" />
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', async function() {
    const hubContainer = document.getElementById('hub-container');

    async function fetchAndRenderHub() {
        try {
            const response = await fetch('<c:url value="/api/communications/hub"/>');
            if (!response.ok) throw new Error('Failed to fetch API');
            const comments = await response.json();
            hubContainer.innerHTML = '';
            if (comments.length === 0) {
                hubContainer.innerHTML = '<p>No communications yet.</p>';
            } else {
                comments.forEach(comment => {
                    const commentElement = createHubEntryElement(comment);
                    hubContainer.appendChild(commentElement);
                });
            }
        } catch (error) {
            hubContainer.innerHTML = '<p style="color: red;">Failed to load communications.</p>';
            console.error('JAVASCRIPT ERROR:', error);
        }
    }

    function createHubEntryElement(comment) {
        const cardDiv = document.createElement('div');
        cardDiv.className = 'comment-card';
        const commentTreeHtml = createCommentRecursive(comment);
        cardDiv.innerHTML =
            '<div class="comment-header">' +
                'Subject: ' + comment.subjectName + ' | Lesson: ' + comment.lessonName +
            '</div>' +
            '<div class="comment-body">' +
                commentTreeHtml +
            '</div>';
        return cardDiv;
    }

    function createCommentRecursive(comment) {
        const avatar = comment.author.avatarUrl || 'https://via.placeholder.com/40';
        const createdAt = new Date(comment.createdAt).toLocaleString();
        let repliesHtml = '';
        if (comment.replies && comment.replies.length > 0) {
            repliesHtml += '<div class="replies">';
            comment.replies.forEach(reply => {
                repliesHtml += createCommentRecursive(reply);
            });
            repliesHtml += '</div>';
        }

        const deleteButtonHtml = '<span class="btn-delete ms-2" style="cursor:pointer; color: #dc3545; font-size: 0.9em;">Delete</span>';

        return (
            '<div class="comment" data-id="' + comment.id + '" data-lesson-id="' + comment.lessonId + '">' +
                 '<div class="author-info">' +
                    '<img src="' + avatar + '" alt="' + comment.author.name + '" class="author-avatar">' +
                    '<div>' +
                        '<span class="author-name">' + comment.author.name + '</span>' +
                        '<div class="comment-meta">' +
                            '<span>' + createdAt + '</span>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
                '<p class="comment-content">' + comment.content + '</p>' +
                '<span class="btn-reply">Reply</span>' + deleteButtonHtml +
                repliesHtml +
            '</div>'
        );
    }

    async function postComment(content, parentId, lessonId) {
        try {
            const apiUrl = '<c:url value="/api/communications/lesson/"/>' + lessonId;
            const response = await fetch(apiUrl, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ content: content, parentId: parentId })
            });
            if(response.ok){
                return await response.json();
            } else {
                return null;
            }
        } catch (error) {
            console.error('Error posting comment:', error);
            return false;
        }
    }

    async function deleteComment(commentId) {
        try {
            const apiUrl = `<c:url value="/api/communications/"/>` + commentId;
            const response = await fetch(apiUrl, {
                method: 'DELETE'
            });
            return response.ok;
        } catch (error) {
            console.error('Error deleting comment:', error);
            return false;
        }
    }

    hubContainer.addEventListener('click', async function(e) {
        if (e.target.classList.contains('btn-reply')) {
            const commentElement = e.target.closest('.comment');
            const parentId = commentElement.dataset.id;
            const lessonId = commentElement.dataset.lessonId;

            document.querySelectorAll('.reply-form').forEach(form => form.remove());

            const replyForm = document.createElement('form');
            replyForm.className = 'reply-form';
            replyForm.innerHTML = 
                '<div class="form-group">' +
                    '<textarea class="form-control" rows="2" placeholder="Write a reply..." required></textarea>' +
                '</div>' +
                '<button type="submit" class="btn btn-sm btn-primary mt-1">Submit Reply</button>' +
                '<button type="button" class="btn btn-sm btn-secondary mt-1 cancel-reply">Cancel</button>';

            commentElement.appendChild(replyForm);
            const textArea = replyForm.querySelector('textarea');
            textArea.focus();

            replyForm.addEventListener('submit', async function(submitEvent) {
                submitEvent.preventDefault();
                const replyContent = textArea.value.trim();

                if (replyContent) {
                    replyForm.querySelector('button[type="submit"]').disabled = true;

                    const newReplyData = await postComment(replyContent, parentId, lessonId);

                    if (newReplyData) {
                        const newReplyElementHtml = createCommentRecursive(newReplyData);
                        let repliesContainer = commentElement.querySelector('.replies');
                        if (!repliesContainer) {
                            repliesContainer = document.createElement('div');
                            repliesContainer.className = 'replies';
                            commentElement.appendChild(repliesContainer);
                        }
                        repliesContainer.insertAdjacentHTML('beforeend', newReplyElementHtml);
                        replyForm.remove();
                    } else {
                        alert('Failed to post reply.');
                        replyForm.querySelector('button[type="submit"]').disabled = false;
                    }
                }
            });

            replyForm.querySelector('.cancel-reply').addEventListener('click', () => {
                replyForm.remove();
            });
        }

        if (e.target.classList.contains('btn-delete')) {
            if (!confirm('Are you sure you want to delete this comment and all its replies?')) return;
            const commentElement = e.target.closest('.comment');
            const commentId = commentElement.dataset.id;
            const success = await deleteComment(commentId);

            if (success) {
                commentElement.style.transition = 'opacity 0.5s';
                commentElement.style.opacity = '0';
                setTimeout(() => commentElement.remove(), 500);
            } else {
                alert('Failed to delete the comment.');
            }
        }
    });

    fetchAndRenderHub();
});
</script>
</body>
</html>
