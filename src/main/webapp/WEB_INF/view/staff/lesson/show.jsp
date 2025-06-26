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
    <title>Danh sách bài học</title>
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

        .pagination .page-link {
            color: black;
            border: 1px solid #dee2e6;
        }

        .pagination .page-link:hover {
            background-color: #e9ecef;
            color: black;
        }

        .pagination .page-item.active .page-link {
            background-color: #d3d3d3;
            border-color: #d3d3d3;
            color: black;
        }

        .pagination .page-item.disabled .page-link {
            color: #6c757d;
            pointer-events: none;
            background-color: #fff;
            border-color: #dee2e6;
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
    <jsp:include page="../layout_staff/header.jsp"/>
</header>

<div class="main-container">
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../layout_staff/sidebar.jsp"/>
    </div>

    <div class="content">
        <main>
            <div class="container-fluid px-4">
                <div class="card mt-4">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <a href="/staff/subject/${subject.subjectId}/chapters" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-arrow-left"></i> Quay lại
                            </a>
                            <h5 class="mb-0">Danh sách bài học trong ${chapter.chapterName}</h5>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-3">
                            <form action="/staff/subject/${subject.subjectId}/chapters/${chapter.chapterId}/lessons" method="get"
                                  class="d-flex flex-column flex-md-row align-items-md-center mb-2 mb-md-0">
                                <label for="lessonName" class="mb-0 fw-bold me-md-2">Tìm bài học:</label>
                                <div class="d-flex gap-2 me-md-2">
                                    <input type="text" id="lessonName" name="lessonName"
                                           class="form-control form-control-sm"
                                           value="${param.lessonName}"
                                           placeholder="Tìm theo tên bài học...">
                                </div>
                                <label for="status" class="mb-0 fw-bold me-md-2">Hiển thị:</label>
                                <div class="d-flex gap-2 me-md-2">
                                    <select id="status" name="status" class="form-control form-control-sm">
                                        <option value="" ${param.status == null ? 'selected' : ''}>Tất cả</option>
                                        <option value="true" ${param.status == 'true' ? 'selected' : ''}>Đang hiển thị</option>
                                        <option value="false" ${param.status == 'false' ? 'selected' : ''}>Không hiển thị</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-outline-primary btn-sm">Lọc</button>
                                <a href="/staff/subject/${subject.subjectId}/chapters/${chapter.chapterId}/lessons"
                                   class="btn btn-outline-secondary btn-sm ms-2">Xóa lọc</a>
                            </form>
                            <div class="d-flex align-items-center gap-2 mt-2 mt-md-0">
                                <form id="toggleStatusForm" action="/staff/subject/${subject.subjectId}/chapters/${chapter.chapterId}/lessons/update-status" method="post">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-success btn-sm">Kích hoạt/Ẩn</button>
                                </form>
                                <a href="/staff/subject/${subject.subjectId}/chapters/${chapter.chapterId}/lessons/new" class="btn btn-primary btn-sm">Tạo bài học mới</a>
                            </div>
                        </div>

                        <c:if test="${not empty message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    ${message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <div class="table-responsive">
                            <table class="table table-bordered table-hover table-striped">
                                <thead>
                                <tr>
                                    <th scope="col" class="text-center col-1">
                                        <input type="checkbox" id="selectAllCheckbox" onclick="toggleSelectAll(this)">
                                    </th>
                                    <th scope="col" class="text-center col-2">Tên bài học</th>
                                    <th scope="col" class="text-center col-2">Link video</th>
                                    <th scope="col" class="text-center col-2">Thời lượng</th>
                                    <th scope="col" class="text-center col-1">Trạng thái</th>
                                    <th scope="col" class="text-center col-2">Hiển thị</th>
                                    <th scope="col" class="text-center col-2">Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:if test="${not empty lessons}">
                                    <c:forEach var="lesson" items="${lessons}">
                                        <tr>
                                            <td class="text-center col-1">
                                                <input type="checkbox" name="lessonIds" form="toggleStatusForm"
                                                       value="${lesson.lessonId}" data-status="${lesson.status}"
                                                       onchange="handleCheckboxChange(this)">
                                            </td>
                                            <td class="col-2">${lesson.lessonName}</td>
                                            <td class="text-center col-2">
                                                <a href="${lesson.videoSrc}" class="" title="Video">
                                                    Xem video
                                                </a>
                                            </td>
                                            <td class="col-2 text-center">${lesson.videoTime}</td>
                                            <td class="col-1 text-center">
                                                <c:if test="${lesson.lessonStatus.statusCode == 'DRAFT'}">
                                                    <span class="badge bg-warning">${lesson.lessonStatus.description}</span>
                                                </c:if>
                                                <c:if test="${lesson.lessonStatus.statusCode == 'PENDING'}">
                                                    <span class="badge bg-primary">${lesson.lessonStatus.description}</span>
                                                </c:if>
                                                <c:if test="${lesson.lessonStatus.statusCode == 'APPROVED'}">
                                                    <span class="badge bg-success">${lesson.lessonStatus.description}</span>
                                                </c:if>
                                                <c:if test="${lesson.lessonStatus.statusCode == 'REJECTED'}">
                                                    <span class="badge bg-danger">${lesson.lessonStatus.description}</span>
                                                </c:if>
                                            </td>
                                            <td class="text-center col-2">
                                                <c:choose>
                                                    <c:when test="${lesson.status}">
                                                        <span class="badge bg-success">Đang hiển thị</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger">Không hiển thị</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center col-2">
                                                <a href="/staff/subject/${subject.subjectId}/chapters/${chapter.chapterId}/lessons/${lesson.lessonId}/edit"
                                                   class="btn btn-warning btn-sm" title="Cập nhật">
                                                    Cập nhật
                                                </a>
                                                <c:if test="${lesson.lessonStatus.statusCode == 'DRAFT'}">
                                                    <form action="/staff/subject/${subject.subjectId}/chapters/${chapter.chapterId}/lessons/${lesson.lessonId}/submit" method="post" style="display: inline;">
                                                        <input type="hidden" name="_csrf" value="${_csrf.token}"/>
                                                        <button type="submit" class="btn btn-primary btn-sm" title="Nộp">Nộp</button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                <c:if test="${empty lessons}">
                                    <tr>
                                        <td colspan="6" class="text-center">Chưa có bài học nào.</td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<footer>
    <jsp:include page="../layout_staff/footer.jsp"/>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let currentStatus = null;

    function toggleSelectAll(source) {
        const checkboxes = document.querySelectorAll('input[name="lessonIds"]');
        const selectAllCheckbox = document.getElementById('selectAllCheckbox');

        if (source.checked) {
            if (currentStatus === null) {
                alert('Vui lòng chọn ít nhất một bài học trước khi chọn tất cả!');
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
        const checkboxes = document.querySelectorAll('input[name="lessonIds"]');
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

    document.getElementById('toggleStatusForm').addEventListener('submit', function(event) {
        event.preventDefault();
        const checkboxes = document.querySelectorAll('input[name="lessonIds"]:checked');
        if (checkboxes.length === 0) {
            alert('Vui lòng chọn ít nhất một bài học để thay đổi trạng thái!');
            return;
        }
        this.submit();
    });
</script>
</body>
</html>