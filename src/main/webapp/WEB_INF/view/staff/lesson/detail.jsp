<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Chi tiết bài học</title>
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
        .video-container {
            position: relative;
            width: 100%;
            aspect-ratio: 16 / 9;
            overflow: hidden;
        }
        .video-container iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
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
            <div class="container px-4">
                <div class="card shadow-sm mt-4">
                    <div class="card-header bg-primary text-white">
                        <h3 class="mb-0">Chi tiết bài học - <c:out value="${lesson.lessonName}"/></h3>
                    </div>
                    <div class="card-body">
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

                        <div class="mb-3">
                            <label class="form-label">ID:</label>
                            <input type="text" class="form-control" value="${lesson.lessonId}" disabled/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mô tả:</label>
                            <textarea class="form-control" rows="4" disabled><c:out value="${lesson.lessonDescription}"/></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Trạng thái:</label>
                            <span class="badge bg-${lesson.status ? 'success' : 'secondary'}">
                                <c:out value="${lesson.status ? 'Hoạt động' : 'Không hoạt động'}"/>
                            </span>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Link video:</label>
                            <input type="text" class="form-control" value="${lesson.videoSrc}" disabled/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Xem video:</label>
                            <c:choose>
                                <c:when test="${not empty lesson.videoSrc}">
                                    <div class="video-container">
                                        <iframe src="<c:out value='${lesson.videoSrc}'/>"
                                                title="<c:out value='${lesson.videoTitle}'/>"
                                                frameborder="0"
                                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                                allowfullscreen></iframe>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted">Không có video</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề video:</label>
                            <input type="text" class="form-control" value="${lesson.videoTitle}" disabled/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Thời lượng video:</label>
                            <input type="text" class="form-control" value="${lesson.videoTime}" disabled/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Hình ảnh thu nhỏ:</label>
                            <c:choose>
                                <c:when test="${not empty lesson.thumbnailUrl}">
                                    <img src="<c:out value='${lesson.thumbnailUrl}'/>" alt="${lesson.lessonName}" class="img-fluid" style="max-width: 200px;"/>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted">Không có hình ảnh thu nhỏ</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Người tạo:</label>
                            <input type="text" class="form-control" value="${lesson.userFullName != null ? lesson.userFullName : 'N/A'}" disabled/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ngày tạo:</label>
                            <input type="text" class="form-control" value="${lesson.createdAt}" disabled/>
                        </div>

                        <h4>Tài liệu</h4>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>Tên tệp</th>
                                    <th>Đường dẫn</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="material" items="${lesson.lessonMaterials}">
                                    <tr>
                                        <td><c:out value="${material.fileName}"/></td>
                                        <td><a href="/files/materials/<c:out value='${material.filePath}'/>" target="_blank"><c:out value="${material.filePath}"/></a></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty lesson.lessonMaterials}">
                                    <tr>
                                        <td colspan="2" class="text-center text-muted">Không có tài liệu</td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                            <a href="<c:url value='/staff/subject/${subjectId}/chapters/${chapterId}/lessons'/>" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>