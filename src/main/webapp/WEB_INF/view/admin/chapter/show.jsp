<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Danh sách chương học</title>
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
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

        /* Style cho danh sách bài học */
        .lesson-list {
            margin-top: 10px;
            padding: 10px;
            background-color: #fff;
            border: 1px solid #dee2e6;
            border-radius: 5px;
        }

        .lesson-list ul {
            list-style: none;
            padding: 0;
        }

        .lesson-list li {
            margin-bottom: 5px;
        }

        .lesson-list a {
            color: #007bff;
            text-decoration: none;
        }

        .lesson-list a:hover {
            text-decoration: underline;
        }

        /* Style cho nút icon mũi tên */
        .toggle-lesson-btn {
            background: none;
            border: none;
            padding: 5px;
            cursor: pointer;
            color: #007bff;
        }

        .toggle-lesson-btn:hover {
            color: #0056b3;
        }

        /* Style để quản lý hiển thị mũi tên */
        .toggle-lesson-btn .bi-chevron-down {
            display: inline;
        }

        .toggle-lesson-btn .bi-chevron-up {
            display: none;
        }

        .toggle-lesson-btn:not(.collapsed) .bi-chevron-down {
            display: none;
        }

        .toggle-lesson-btn:not(.collapsed) .bi-chevron-up {
            display: inline;
        }
    </style>
</head>
<body>
<%-- Header --%>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>
<%-- Header --%>

<%-- MAIN CONTAINER --%>
<div class="main-container">
    <!-- Sidebar -->
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../layout/sidebar.jsp"/>
    </div>
    <!-- Sidebar -->

    <!-- Main Content Area -->
    <div class="content">
        <main>
            <div class="container-fluid px-4">
                <div class="mt-4">
                    <div class="row col-12 mx-auto">

                        <div class="mb-3">
                            <div class="d-flex flex-column align-items-start">
                                <a href="/admin/subject" class="btn btn-outline-secondary btn-sm mb-3">
                                    <i class="bi bi-arrow-left"></i> Quay lại
                                </a>
                                <h3 class="mb-0">Danh sách chương học trong ${subject.subjectName}</h3>
                            </div>
                        </div>
                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-3">
                            <!-- Bộ lọc -->
                            <form action="/admin/subject/${subject.subjectId}/chapters" method="get"
                                  class="d-flex flex-column flex-md-row align-items-md-center mb-2 mb-md-0">
                                <label for="chapterName" class="mb-0 fw-bold me-md-2">Tìm chương:</label>
                                <div class="d-flex gap-2 me-md-2">
                                    <input type="text" id="chapterName" name="chapterName"
                                           class="form-control form-control-sm"
                                           value="${param.chapterName}"
                                           placeholder="Tìm theo tên chương...">
                                </div>
                                <label for="status" class="mb-0 fw-bold me-md-2">Trạng thái:</label>
                                <div class="d-flex gap-2 me-md-2">
                                    <select id="status" name="status" class="form-control form-control-sm">
                                        <option value="" ${param.status == null ? 'selected' : ''}>Tất cả</option>
                                        <option value="true" ${param.status == 'true' ? 'selected' : ''}>Đang hoạt động</option>
                                        <option value="false" ${param.status == 'false' ? 'selected' : ''}>Không hoạt động</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-outline-primary btn-sm">Lọc</button>
                            </form>
                            <!-- Bộ lọc -->

                            <!-- Nút tạo chương học mới -->
                            <a href="/admin/subject/${subject.subjectId}/chapters/save" class="btn btn-primary">Tạo
                                chương học mới</a>
                        </div>

                        <%-- SUCESS MESSAGE --%>
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                            </div>
                        </c:if>
                        <%-- SUCESS MESSAGE --%>

                        <%-- ERROR MESSAGE --%>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                            </div>
                        </c:if>
                        <%-- ERROR MESSAGE --%>

                        <%-- Nút Kích hoạt và form gửi chapterIds --%>
                        <div class="mb-3">
                            <form id="toggleStatusForm" action="/admin/subject/${subject.subjectId}/chapters/update-status" method="post" onsubmit="return toggleChapters(event)">
                                <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                <button type="submit" class="btn btn-success btn-sm">Kích hoạt/Ẩn</button>
                            </form>
                        </div>

                        <%-- TABLE --%>
                        <table class="table table-bordered table-hover table-fixed">
                            <thead>
                            <tr>
                                <th scope="col" class="text-center col-1">
                                    <input type="checkbox" id="selectAllCheckbox" onclick="toggleSelectAll(this)">
                                </th>
                                <th scope="col" class="text-center col-2">Tên chương học</th>
                                <th scope="col" class="text-center col-4">Mô tả về chương học</th>
                                <th scope="col" class="text-center col-2">Trạng thái</th>
                                <th scope="col" class="text-center col-3">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:if test="${not empty chapters}">
                                <c:forEach var="chapter" items="${chapters}">
                                    <tr>
                                        <td class="col-1 text-center checkbox-header">
                                            <input type="checkbox" name="chapterIds" form="toggleStatusForm"
                                                   value="${chapter.chapterId}" data-status="${chapter.status}"
                                                   onchange="handleCheckboxChange(this)">
                                        </td>
                                        <td class="col-2">${chapter.chapterName}</td>
                                        <td class="col-4">${chapter.chapterDescription}</td>
                                        <td class="text-center col-2">${chapter.status ? 'Đang hoạt động' : 'Không hoạt động'}</td>
                                        <td class="text-center col-3">
                                            <a href="/admin/subject/${subject.subjectId}/chapters/${chapter.chapterId}/lessons"
                                               class="btn btn-primary btn-sm mb-1 mb-lg-0">
                                                Xem chi tiết
                                            </a>
                                            <a href="/admin/subject/${subject.subjectId}/chapters/save?chapterId=${chapter.chapterId}"
                                               class="btn btn-warning btn-sm mb-1 mb-lg-0">
                                                Cập nhật
                                            </a>
                                            <!-- Nút icon với Bootstrap Collapse -->
                                            <button class="toggle-lesson-btn collapsed"
                                                    type="button"
                                                    data-bs-toggle="collapse"
                                                    data-bs-target="#collapse-lesson-${chapter.chapterId}"
                                                    aria-expanded="false"
                                                    aria-controls="collapse-lesson-${chapter.chapterId}">
                                                <i class="bi bi-chevron-down"></i>
                                                <i class="bi bi-chevron-up"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="5">
                                            <!-- Sử dụng Bootstrap Collapse -->
                                            <div id="collapse-lesson-${chapter.chapterId}" class="collapse lesson-list">
                                                <c:choose>
                                                    <c:when test="${not empty chapter.lessons}">
                                                        <ul>
                                                            <c:forEach var="lesson" items="${chapter.lessons}">
                                                                <li>
                                                                    <a href="/admin/subject/${subject.subjectId}/chapters/${chapter.chapterId}/lessons/save?lessonId=${lesson.lessonId}">
                                                                            ${lesson.lessonName}
                                                                    </a>
                                                                </li>
                                                            </c:forEach>
                                                        </ul>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p>Chưa có bài học nào.</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty chapters}">
                                <tr>
                                    <td colspan="5" class="text-center">Chưa có chương học nào.</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                        <%-- TABLE --%>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <!-- Main Content Area -->
</div>
<%-- MAIN CONTAINER --%>

<!-- Footer -->
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>
<!-- Footer -->

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%-- JavaScript để kiểm tra checkbox và trạng thái --%>
<script>
    let currentStatus = null;

    function toggleChapters() {
        const checkboxes = document.querySelectorAll('input[name="chapterIds"]:checked');
        if (checkboxes.length === 0) {
            alert('Vui lòng chọn ít nhất một chương để thay đổi trạng thái!');
            event.preventDefault();
            return false;
        }
        return true;
    }

    function toggleSelectAll(source) {
        const checkboxes = document.querySelectorAll('input[name="chapterIds"]');
        const selectAllCheckbox = document.getElementById('selectAllCheckbox');

        if (source.checked) {
            if (currentStatus === null) {
                alert('Vui lòng chọn ít nhất một chương trước khi chọn tất cả!');
                source.checked = false;
                return;
            }
            checkboxes.forEach(checkbox => {
                if (checkbox.dataset.status === currentStatus) {
                    checkbox.checked = true;
                }
            });
        } else {
            checkboxes.forEach(checkbox => {
                checkbox.checked = false;
                checkbox.disabled = false;
            });
            currentStatus = null;
            selectAllCheckbox.checked = false;
        }
    }

    function handleCheckboxChange(checkbox) {
        const checkboxes = document.querySelectorAll('input[name="chapterIds"]');
        const selectAllCheckbox = document.getElementById('selectAllCheckbox');

        if (checkbox.checked && currentStatus === null) {
            currentStatus = checkbox.dataset.status;
        }

        checkboxes.forEach(cb => {
            if (currentStatus !== null && cb.dataset.status !== currentStatus) {
                cb.checked = false;
                cb.disabled = true;
            } else {
                cb.disabled = false;
            }
        });

        const checkedCheckboxes = Array.from(checkboxes).filter(cb => cb.checked);
        if (checkedCheckboxes.length === 0) {
            currentStatus = null;
            checkboxes.forEach(cb => cb.disabled = false);
            selectAllCheckbox.checked = false;
        } else {
            const allChecked = Array.from(checkboxes).every(cb => cb.checked || cb.disabled);
            selectAllCheckbox.checked = allChecked;
        }
    }
</script>
</body>
</html>
