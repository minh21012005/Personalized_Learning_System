<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Danh sách bài học</title>
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .main-container {
            display: flex;
            flex: 1;
        }
        .sidebar {
            width: 250px;
            background-color: #1a252f;
            color: white;
            height: 100vh;
            position: fixed;
            top: 0;
            left: -250px;
            transition: left 0.3s ease;
        }
        .sidebar.active {
            left: 0;
        }
        .content {
            margin-left: 0;
            padding: 20px;
            flex: 1;
            background-color: #f8f9fa;
        }
        @media (min-width: 767.98px) {
            .sidebar {
                left: 0;
            }
            .content {
                margin-left: 250px;
            }
        }
        header, footer {
            background-color: #1a252f;
            color: white;
            padding: 10px;
        }
        footer {
            height: 40px;
        }
        .toggle-lesson-btn {
            cursor: pointer;
        }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"/>
<div class="main-container">
    <jsp:include page="../layout/sidebar.jsp"/>
    <div class="content">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <a href="/admin/subject/${subject.subjectId}/chapters" class="btn btn-secondary"><i class="bi bi-arrow-left"></i> Quay lại</a>
            <h2>Danh sách bài học trong ${chapter.chapterName}</h2>
            <a href="/admin/subject/${subject.subjectId}/chapters/${chapter.chapterId}/lessons/save" class="btn btn-primary">Tạo bài học mới</a>
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

        <form action="/admin/subject/${subject.subjectId}/chapters/${chapter.chapterId}/lessons/update-status" method="post" id="toggleStatusForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button type="submit" class="btn btn-warning mb-3">Kích hoạt/Ẩn</button>
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-striped">
                    <thead>
                    <tr>
                        <th><input type="checkbox" id="selectAllLessons"/></th>
                        <th>Tên bài học</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${empty lessons}">
                        <tr>
                            <td colspan="4" class="text-center">Chưa có bài học nào</td>
                        </tr>
                    </c:if>
                    <c:forEach var="lesson" items="${lessons}">
                        <tr>
                            <td><input type="checkbox" name="lessonIds" value="${lesson.lessonId}" class="lesson-checkbox"/></td>
                            <td>${lesson.lessonName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${lesson.status}">
                                        <span class="badge bg-success">Đang hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">Không hoạt động</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="/admin/subject/${subject.subjectId}/chapters/${chapter.chapterId}/lessons/save?lessonId=${lesson.lessonId}" class="btn btn-primary btn-sm">Cập nhật</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </form>
    </div>
</div>
<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('toggleStatusForm').addEventListener('submit', function(e) {
        const checkboxes = document.querySelectorAll('.lesson-checkbox:checked');
        if (checkboxes.length === 0) {
            e.preventDefault();
            alert('Vui lòng chọn ít nhất một bài học để thay đổi trạng thái.');
        }
    });

    document.getElementById('selectAllLessons').addEventListener('change', function() {
        const checkboxes = document.querySelectorAll('.lesson-checkbox');
        checkboxes.forEach(checkbox => {
            checkbox.checked = this.checked;
        });
    });
</script>
</body>
</html>