<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="_csrf" content="${_csrf.token}"/>
    <title>Chi tiết bài học</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: 'Arial', sans-serif;
            background-color: #f0f2f5;
        }
        header {
            background: linear-gradient(90deg, #1a252f, #2c3e50);
            color: white;
            width: 100%;
            padding: 10px 0;
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
            transition: transform 0.3s ease;
        }
        .content {
            flex: 1;
            padding: 20px;
            background-color: #f8f9fa;
        }
        footer {
            background: linear-gradient(90deg, #2c3e50, #1a252f);
            color: white;
            height: 40px;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .card-header {
            background: linear-gradient(90deg, #2c3e50, #34495e);
            color: white;
            border-radius: 10px 10px 0 0;
            padding: 15px;
        }
        .card-body {
            padding: 20px;
        }
        .form-control-plaintext {
            background-color: #fff;
            padding: 8px 12px;
            border-radius: 5px;
            border: 1px solid #dee2e6;
        }
        .lesson-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 5px;
        }
        .lesson-table th, .lesson-table td {
            padding: 10px;
            background-color: #fff;
            border: none;
        }
        .lesson-table th {
            background-color: #34495e;
            color: white;
            text-align: left;
        }
        .lesson-table tr:hover {
            background-color: #f1f3f5;
        }
        .card-footer {
            position: sticky;
            bottom: 0;
            background: white;
            padding: 15px;
            border-top: 1px solid #dee2e6;
            border-radius: 0 0 10px 10px;
        }
        .btn-secondary {
            background: linear-gradient(90deg, #7b8a9a, #95a5a6);
            border: none;
            transition: background 0.3s;
        }
        .btn-secondary:hover {
            background: linear-gradient(90deg, #95a5a6, #7b8a9a);
            color: white;
        }
        .label-icon {
            margin-right: 5px;
        }
        .video-container {
            position: relative;
            overflow: hidden;
            width: 100%;
            padding-top: 56.25%; /* 16:9 Aspect Ratio */
        }
        .video-container iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
        }
        .material-link {
            display: block;
            margin: 5px 0;
            word-break: break-all;
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
            .card-header {
                padding: 10px;
            }
            .card-body {
                padding: 15px;
            }
            .lesson-table th, .lesson-table td {
                padding: 8px;
                font-size: 0.9rem;
            }
            .card-footer {
                padding: 10px;
            }
            .video-container {
                padding-top: 75%; /* Điều chỉnh tỷ lệ cho mobile */
            }
        }
        @media (max-width: 576px) {
            .content {
                padding: 10px;
            }
            .card-header h5 {
                font-size: 1.2rem;
            }
            .form-control-plaintext {
                font-size: 0.9rem;
                padding: 6px 10px;
            }
            .btn-secondary {
                font-size: 0.9rem;
                padding: 5px 10px;
            }
            .video-container {
                padding-top: 100%; /* Điều chỉnh tỷ lệ cho mobile nhỏ */
            }
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../../admin/layout/header.jsp"/>
</header>

<div class="main-container">
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../../admin/layout/sidebar.jsp"/>
    </div>
    <div class="content">
        <main>
            <div class="container px-4">
                <div class="card mt-4">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Chi tiết bài học "<span class="text-warning">${lesson.lessonName}</span>"</h5>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <div class="mt-4">
                            <div class="row mt-2">
                                <label class="col-sm-3 col-form-label"><i class="bi bi-type label-icon"></i>Tên bài học</label>
                                <div class="col-sm-9">
                                    <p class="form-control-plaintext">${lesson.lessonName}</p>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <label class="col-sm-3 col-form-label"><i class="bi bi-card-text label-icon"></i>Mô tả</label>
                                <div class="col-sm-9">
                                    <p class="form-control-plaintext">${lesson.lessonDescription}</p>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <label class="col-sm-3 col-form-label"><i class="bi bi-book label-icon"></i>Thuộc môn học</label>
                                <div class="col-sm-9">
                                    <p class="form-control-plaintext">${lesson.subjectName}</p>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <label class="col-sm-3 col-form-label"><i class="bi bi-folder label-icon"></i>Thuộc chương</label>
                                <div class="col-sm-9">
                                    <p class="form-control-plaintext">${lesson.chapterName}</p>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <label class="col-sm-3 col-form-label"><i class="bi bi-person label-icon"></i>Người tạo</label>
                                <div class="col-sm-9">
                                    <p class="form-control-plaintext">${lesson.userFullName}</p>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <label class="col-sm-3 col-form-label"><i class="bi bi-calendar-event label-icon"></i>Ngày nộp</label>
                                <div class="col-sm-9">
                                    <p class="form-control-plaintext">
                                        ${lesson.updatedAt}
                                    </p>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <label class="col-sm-3 col-form-label"><i class="bi bi-play-circle label-icon"></i>Video bài học</label>
                                <div class="col-sm-9">
                                    <c:choose>
                                        <c:when test="${not empty lesson.videoSrc}">
                                            <div class="video-container">
                                                <iframe src="${lesson != null ? lesson.videoSrc : ''}" frameborder="0" allowfullscreen></iframe>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="form-control-plaintext">Chưa có video</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <label class="col-sm-3 col-form-label"><i class="bi bi-file-earmark-text label-icon"></i>Tài liệu liên quan</label>
                                <div class="col-sm-9">
                                    <c:choose>
                                        <c:when test="${not empty lesson.materials and not empty lesson.materials}">
                                            <c:forEach var="material" items="${lesson.materials}">
                                                <a href="/files/taiLieu/${material}" class="material-link" target="_blank">${material}</a>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="form-control-plaintext">Chưa có tài liệu</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <label class="col-sm-3 col-form-label"><i class="bi bi-eye label-icon"></i>Trạng thái hiển thị</label>
                                <div class="col-sm-9">
                                    <p class="form-control-plaintext ${lesson.status ? 'text-success' : 'text-danger'}">
                                        ${lesson.status ? 'Đang hoạt động' : 'Không hoạt động'}
                                    </p>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <label class="col-sm-3 col-form-label"><i class="bi bi-check-circle label-icon"></i>Trạng thái phê duyệt</label>
                                <div class="col-sm-9">
                                    <p class="form-control-plaintext ${lesson.lessonStatus.statusCode == 'APPROVED' ? 'text-success' : lesson.lessonStatus.statusCode == 'REJECTED' ? 'text-danger' : 'text-primary'}">
                                        ${lesson.lessonStatus.description}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <div class="d-flex gap-2 justify-content-end">
                            <c:if test="${lesson.lessonStatus.statusCode == 'PENDING'}">
                                <form action="/admin/lessons/${lesson.lessonId}/update-status" method="post" style="display:inline;">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                                    <input type="hidden" name="newStatus" value="APPROVED">
                                    <input type="hidden" name="subjectId" value="${not empty param.subjectId ? fn:trim(param.subjectId) : ''}">
                                    <input type="hidden" name="chapterId" value="${not empty param.chapterId ? fn:trim(param.chapterId) : ''}">
                                    <input type="hidden" name="lessonStatus" value="${not empty param.lessonStatus ? fn:trim(param.lessonStatus) : ''}">
                                    <input type="hidden" name="status" value="${not empty param.status ? fn:trim(param.status) : ''}">
                                    <input type="hidden" name="startDate" value="${not empty param.startDate ? fn:trim(param.startDate) : ''}">
                                    <input type="hidden" name="endDate" value="${not empty param.endDate ? fn:trim(param.endDate) : ''}">
                                    <input type="hidden" name="userCreated" value="${not empty param.userCreated ? fn:trim(param.userCreated) : ''}">
                                    <input type="hidden" name="page" value="${param.page}">
                                    <button type="submit" class="btn btn-success btn-sm">Phê duyệt</button>
                                </form>
                                <form action="/admin/lessons/${lesson.lessonId}/update-status" method="post" style="display:inline;">
                                    <input type="hidden" name="_csrf" value="${_csrf.token}">
                                    <input type="hidden" name="newStatus" value="REJECTED">
                                    <input type="hidden" name="subjectId" value="${not empty param.subjectId ? fn:trim(param.subjectId) : ''}">
                                    <input type="hidden" name="chapterId" value="${not empty param.chapterId ? fn:trim(param.chapterId) : ''}">
                                    <input type="hidden" name="lessonStatus" value="${not empty param.lessonStatus ? fn:trim(param.lessonStatus) : ''}">
                                    <input type="hidden" name="status" value="${not empty param.status ? fn:trim(param.status) : ''}">
                                    <input type="hidden" name="startDate" value="${not empty param.startDate ? fn:trim(param.startDate) : ''}">
                                    <input type="hidden" name="endDate" value="${not empty param.endDate ? fn:trim(param.endDate) : ''}">
                                    <input type="hidden" name="userCreated" value="${not empty param.userCreated ? fn:trim(param.userCreated) : ''}">
                                    <input type="hidden" name="page" value="${param.page}">
                                    <button type="submit" class="btn btn-danger btn-sm">Từ chối</button>
                                </form>
                            </c:if>
                            <a href="/admin/lessons" class="btn btn-secondary">Quay lại</a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<footer>
    <jsp:include page="../../admin/layout/footer.jsp"/>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>