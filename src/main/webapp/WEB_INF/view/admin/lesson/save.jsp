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
        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
        }
        .card-footer {
            position: sticky;
            bottom: 0;
            background: white;
            padding: 10px;
            border-top: 1px solid #dee2e6;
        }
        .custom-file-input {
            position: relative;
            display: block;
            margin-bottom: 10px;
        }
        .custom-file-input input[type="file"] {
            opacity: 0;
            position: absolute;
            width: 100%;
            height: 100%;
            cursor: pointer;
            z-index: 2;
        }
        .custom-file-input-label {
            display: block;
            background-color: #007bff;
            color: white;
            padding: 8px 16px;
            border-radius: 4px;
            text-align: center;
            cursor: pointer;
            transition: background-color 0.3s;
            z-index: 1;
        }
        .custom-file-input-label:hover {
            background-color: #0056b3;
        }
        .file-name {
            margin-top: 8px;
            color: #6c757d;
            font-size: 0.9em;
        }
        .material-list, .selected-files-list {
            margin-top: 10px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 4px;
        }
        .material-item, .selected-file-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 5px 0;
            border-bottom: 1px solid #dee2e6;
        }
        .material-item:last-child, .selected-file-item:last-child {
            border-bottom: none;
        }
        .material-item a, .selected-file-item button {
            z-index: 3;
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
                <div class="card mt-4">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">${isEdit ? 'Chỉnh sửa bài học' : 'Thêm bài học'} trong ${chapter.chapterName}</h5>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form:form method="post" action="/admin/subject/${subjectId}/chapters/${chapterId}/lessons/save"
                                   modelAttribute="lesson" enctype="multipart/form-data" class="mt-4" id="lessonForm">
                            <form:hidden path="lessonId"/>
                            <div class="row mb-3">
                                <label for="lessonNameInput" class="col-sm-3 col-form-label">Tên bài học</label>
                                <div class="col-sm-9">
                                    <c:set var="errorLessonName"><form:errors path="lessonName" cssClass="invalid-feedback"/></c:set>
                                    <form:input type="text" id="lessonNameInput" path="lessonName"
                                                class="form-control ${not empty errorLessonName ? 'is-invalid' : ''}"
                                                placeholder="Nhập tên bài học"/>
                                        ${errorLessonName}
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label for="lessonDescriptionInput" class="col-sm-3 col-form-label">Mô tả bài học</label>
                                <div class="col-sm-9">
                                    <c:set var="errorLessonDescription"><form:errors path="lessonDescription" cssClass="invalid-feedback"/></c:set>
                                    <form:textarea id="lessonDescriptionInput" path="lessonDescription"
                                                   class="form-control ${not empty errorLessonDescription ? 'is-invalid' : ''}"
                                                   rows="6" maxlength="1000" placeholder="Nhập mô tả (tối đa 1000 ký tự)"/>
                                        ${errorLessonDescription}
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label for="videoSrcInput" class="col-sm-3 col-form-label">Link nhúng YouTube
                                    <i class="bi bi-info-circle" data-bs-toggle="tooltip" title="Nhập link nhúng YouTube (e.g., https://www.youtube.com/embed/VIDEO_ID)"></i>
                                </label>
                                <div class="col-sm-9">
                                    <c:set var="errorVideoSrc"><form:errors path="videoSrc" cssClass="invalid-feedback"/></c:set>
                                    <form:input type="text" id="videoSrcInput" path="videoSrc"
                                                class="form-control ${not empty errorVideoSrc ? 'is-invalid' : ''}"
                                                placeholder="https://www.youtube.com/embed/VIDEO_ID"/>
                                        ${errorVideoSrc}
                                    <div id="videoSrcError" class="invalid-feedback" style="display: none;">
                                        Vui lòng nhập link nhúng YouTube hợp lệ.
                                    </div>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label">Trạng thái</label>
                                <div class="col-sm-9">
                                    <div class="d-flex gap-3">
                                        <div class="form-check">
                                            <form:radiobutton path="status" value="true" id="statusActive"
                                                              cssClass="form-check-input" checked="${isEdit && lesson.status ? 'checked' : !isEdit ? 'checked' : ''}"/>
                                            <label class="form-check-label" for="statusActive">Hoạt động</label>
                                        </div>
                                        <div class="form-check">
                                            <form:radiobutton path="status" value="false" id="statusInactive"
                                                              cssClass="form-check-input" checked="${isEdit && !lesson.status ? 'checked' : ''}"/>
                                            <label class="form-check-label" for="statusInactive">Không hoạt động</label>
                                        </div>
                                    </div>
                                    <form:errors path="status" cssClass="invalid-feedback d-block"/>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label for="materialsInput" class="col-sm-3 col-form-label">Tài liệu tham khảo (PDF, Word)</label>
                                <div class="col-sm-9">
                                    <div class="custom-file-input">
                                        <input type="file" id="materialsInput" name="materialFiles" multiple
                                               accept=".pdf,.doc,.docx" class="form-control"/>
                                        <label for="materialsInput" class="custom-file-input-label">Chọn tệp tài liệu</label>
                                        <div class="file-name" id="fileNames">Chưa chọn tệp nào</div>
                                        <div class="selected-files-list" id="selectedFilesList"></div>
                                    </div>
                                    <c:if test="${not empty materialsTemp}">
                                        <div class="material-list mt-3">
                                            <h6>Tài liệu hiện có:</h6>
                                            <c:forEach var="material" items="${materialsTemp}" varStatus="status">
                                                <div class="material-item" data-index="${status.index}">
                                                    <a href="/files/taiLieu/${material}" target="_blank">${material.substring(material.lastIndexOf('/') + 1)}</a>
                                                    <button type="button" class="btn btn-link text-danger p-0"
                                                            onclick="removeMaterial(this, ${status.index})">Xóa</button>
                                                    <input type="hidden" name="materialsTemp" value="${material}"/>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="d-flex gap-2 justify-content-end">
                                    <button type="submit" class="btn btn-primary">${isEdit ? 'Cập nhật' : 'Lưu'}</button>
                                    <a href="/admin/subject/${subjectId}/chapters/${chapterId}/lessons" class="btn btn-secondary">Hủy</a>
                                </div>
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
    // Initialize Bootstrap tooltips
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));

    // Quản lý danh sách tệp đã chọn
    const materialsInput = document.getElementById('materialsInput');
    const selectedFilesList = document.getElementById('selectedFilesList');
    const fileNames = document.getElementById('fileNames');
    let selectedFiles = [];

    materialsInput.addEventListener('change', function () {
        // Cập nhật danh sách tệp đã chọn
        const newFiles = Array.from(this.files);
        selectedFiles = [...selectedFiles, ...newFiles];
        updateFileList();
    });

    function updateFileList() {
        // Cập nhật giao diện danh sách tệp
        selectedFilesList.innerHTML = '';
        if (selectedFiles.length > 0) {
            const displayText = selectedFiles.length + ' tệp đã chọn';
            fileNames.textContent = displayText;
            selectedFiles.forEach((file, index) => {
                const fileItem = document.createElement('div');
                fileItem.className = 'selected-file-item';
                fileItem.innerHTML =
                    '<span>' + (file.name || 'Tên tệp không xác định') + '</span>' +
                    '<button type="button" class="text-danger btn btn-link p-0" onclick="removeSelectedFile(' + index + ')">Xóa</button>';
                selectedFilesList.appendChild(fileItem);
            });
        } else {
            fileNames.textContent = 'Chưa chọn tệp nào';
        }
        // Cập nhật input file để giữ các tệp còn lại
        const dataTransfer = new DataTransfer();
        selectedFiles.forEach(file => dataTransfer.items.add(file));
        materialsInput.files = dataTransfer.files;
    }

    window.removeSelectedFile = function (index) {
        if (confirm('Bạn có chắc muốn xóa tệp này khỏi danh sách chọn?')) {
            selectedFiles.splice(index, 1);
            updateFileList();
        }
    };

    // Xóa tài liệu hiện có
    function removeMaterial(button, index) {
        if (confirm('Bạn có chắc muốn xóa tài liệu này?')) {
            const materialItem = button.closest('.material-item');
            materialItem.remove();
        }
    }

    // // Validate YouTube embed link
    // document.getElementById('videoSrcInput').addEventListener('input', function () {
    //     const value = this.value;
    //     const regex = /^https:\/\/www\.youtube\.com\/embed\/[a-zA-Z0-9_-]+$/;
    //     const errorDiv = document.getElementById('videoSrcError');
    //     if (value && !regex.test(value)) {
    //         this.classList.add('is-invalid');
    //         errorDiv.style.display = 'block';
    //     } else {
    //         this.classList.remove('is-invalid');
    //         errorDiv.style.display = 'none';
    //     }
    // });
</script>
</body>
</html>