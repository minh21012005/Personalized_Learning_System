<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>${isEdit ? 'Chỉnh sửa bài học' : 'Thêm bài học'}</title>
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: Arial, sans-serif;
        }
        header {
            background-color: #1a252f;
            color: white;
            width: 100%;
        }
        .main-container {
            display: flex;
            flex: 1;
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
        }
        .container {
            width: 80%;
            margin: 0 auto;
        }
        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
        }
        .custom-file-input {
            position: relative;
            overflow: hidden;
            display: inline-block;
            width: 100%;
        }
        .custom-file-input input[type="file"] {
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }
        .custom-file-input-label {
            display: inline-block;
            background-color: #007bff;
            color: white;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
            width: 100%;
            text-align: center;
        }
        .custom-file-input-label:hover {
            background-color: #0056b3;
        }
        .file-name {
            margin-top: 8px;
            color: #6c757d;
            font-size: 0.9em;
        }
        .material-list {
            margin-top: 10px;
        }
        .material-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 5px 0;
        }
        @media (max-width: 767.98px) {
            .sidebar {
                width: 200px;
                position: fixed;
                top: 0;
                left: 0;
                height: 100%;
                transform: translateX(-100%);
                z-index: 1000;
            }
            .sidebar.active {
                transform: translateX(0);
            }
            .content {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>

<div class="main-container">
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../layout/sidebar.jsp"/>
    </div>
    <div class="content">
        <main>
            <div class="container px-4">
                <div class="mt-4">
                    <div class="row col-8 mx-auto">
                        <h3>${isEdit ? 'Chỉnh sửa bài học' : 'Thêm bài học'} trong ${chapter.chapterName}</h3>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form:form method="post" action="/admin/subject/${subjectId}/chapters/${chapterId}/lessons/save"
                                   modelAttribute="lesson" enctype="multipart/form-data" class="mt-4" id="lessonForm">
                            <form:hidden path="lessonId"/>
                            <div class="mb-3">
                                <c:set var="errorLessonName">
                                    <form:errors path="lessonName" cssClass="invalid-feedback"/>
                                </c:set>
                                <label for="lessonNameInput" class="form-label">Tên bài học</label>
                                <form:input type="text" id="lessonNameInput" path="lessonName"
                                            class="form-control ${not empty errorLessonName?'is-invalid':''}"
                                            placeholder="Nhập tên bài học"/>
                                    ${errorLessonName}
                            </div>
                            <div class="mb-3">
                                <c:set var="errorLessonDescription">
                                    <form:errors path="lessonDescription" cssClass="invalid-feedback"/>
                                </c:set>
                                <label for="lessonDescriptionInput" class="form-label">Mô tả về bài học</label>
                                <form:textarea id="lessonDescriptionInput" path="lessonDescription"
                                               class="form-control ${not empty errorLessonDescription?'is-invalid':''}"
                                               rows="5" maxlength="255"
                                               placeholder="Nhập nội dung không quá 255 kí tự"/>
                                    ${errorLessonDescription}
                            </div>
                            <div class="mb-3">
                                <c:set var="errorVideoSrc">
                                    <form:errors path="videoSrc" cssClass="invalid-feedback"/>
                                </c:set>
                                <label for="videoSrcInput" class="form-label">Link nhúng YouTube</label>
                                <form:input type="text" id="videoSrcInput" path="videoSrc"
                                            class="form-control ${not empty errorVideoSrc?'is-invalid':''}"
                                            placeholder="Nhập link nhúng YouTube (e.g., https://www.youtube.com/embed/VIDEO_ID)"/>
                                    ${errorVideoSrc}
                                <div id="videoSrcError" class="invalid-feedback" style="display: none;">
                                    Vui lòng nhập link nhúng YouTube hợp lệ (e.g., https://www.youtube.com/embed/VIDEO_ID).
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="materialsInput" class="form-label">Tài liệu tham khảo (PDF, Word)</label>
                                <div class="custom-file-input">
                                    <input type="file" id="materialsInput" name="materialFiles" multiple
                                           accept=".pdf,.doc,.docx" class="form-control"/>
                                    <label for="materialsInput" class="custom-file-input-label">
                                        Chọn tệp tài liệu
                                    </label>
                                    <div class="file-name" id="fileNames">Chưa chọn tệp nào</div>
                                </div>
                                <c:if test="${not empty lesson.materials}">
                                    <div class="material-list mt-2">
                                        <h6>Tài liệu hiện có:</h6>
                                        <c:forEach var="material" items="${lesson.materials}" varStatus="status">
                                            <div class="material-item">
                                                <a href="${material}" target="_blank">${material.substring(material.lastIndexOf('/') + 1)}</a>
                                                <button type="button" class="text-danger btn btn-link p-0"
                                                        onclick="removeMaterial(${status.index}, ${lesson.lessonId})">Xóa</button>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">${isEdit ? 'Cập nhật' : 'Lưu'}</button>
                                <a href="/admin/subject/${subjectId}/chapters/${chapterId}/lessons" class="btn btn-secondary">Hủy</a>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Xác thực URL nhúng YouTube
    document.getElementById('lessonForm').addEventListener('submit', function (e) {
        const videoSrcInput = document.getElementById('videoSrcInput');
        const videoSrcError = document.getElementById('videoSrcError');
        const youtubeRegex = /^https:\/\/www\.youtube\.com\/embed\/[A-Za-z0-9_-]+$/;

        if (videoSrcInput.value && !youtubeRegex.test(videoSrcInput.value)) {
            e.preventDefault();
            videoSrcInput.classList.add('is-invalid');
            videoSrcError.style.display = 'block';
        } else {
            videoSrcInput.classList.remove('is-invalid');
            videoSrcError.style.display = 'none';
        }
    });

    // Cập nhật danh sách tên file được chọn
    document.getElementById('materialsInput').addEventListener('change', function () {
        const files = this.files;
        const fileNames = files.length > 0 ? Array.from(files).map(file => file.name).join(', ') : 'Chưa chọn tệp nào';
        document.getElementById('fileNames').textContent = fileNames;
    });

    // Xóa tài liệu (gửi yêu cầu đến server)
    function removeMaterial(index, lessonId) {
        if (confirm('Bạn có chắc muốn xóa tài liệu này?')) {
            fetch(`/admin/subject/${subjectId}/chapters/${chapterId}/lessons/removeMaterial/${lessonId}/${index}`, {
                method: 'POST'
            }).then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert('Lỗi khi xóa tài liệu.');
                }
            });
        }
    }
</script>
</body>
</html>