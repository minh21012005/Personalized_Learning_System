<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${lesson.lessonName} - ${subject.subjectName}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="/css/lessonpage.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .sidebar {
            background-color: #ffffff;
            border-left: 1px solid #dee2e6;
            height: 100%;
            padding: 20px;
            max-height: 100vh;
            overflow-y: auto;
        }
        .accordion-button {
            font-weight: 500;
        }
        .list-group-item {
            border: none;
            padding: 10px 15px;
        }
        .list-group-item.active {
            background-color: #e9ecef;
            font-weight: bold;
        }
        .list-group {
            max-height: 200px;
            overflow-y: auto;
        }
        .video-container {
            margin-bottom: 20px;
        }
        .card {
            border: none;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .nav-tabs .nav-link {
            color: #495057;
        }
        .nav-tabs .nav-link.active {
            color: #0d6efd;
            font-weight: bold;
        }
    </style>
</head>
<body>
<!-- Main Content -->
<div class="container my-5">
    <div class="row">
        <!-- Left Column: Lesson Content -->
        <div class="col-md-8">
            <h1 class="mb-4">${lesson.lessonName}</h1>
            <div class="video-container ratio ratio-16x9">
                <iframe src="${lesson.videoSrc}" title="${lesson.lessonName}" frameborder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                        referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>

            <!-- Nav Tabs for Description and Materials -->
            <ul class="nav nav-tabs mb-4" id="lessonTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="description-tab" data-bs-toggle="tab" data-bs-target="#description"
                            type="button" role="tab" aria-controls="description" aria-selected="true">Mô tả bài học</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="materials-tab" data-bs-toggle="tab" data-bs-target="#materials"
                            type="button" role="tab" aria-controls="materials" aria-selected="false">Tài liệu môn học</button>
                </li>
            </ul>
            <div class="tab-content" id="lessonTabsContent">
                <div class="tab-pane fade show active" id="description" role="tabpanel" aria-labelledby="description-tab">
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title">Mô tả bài học</h2>
                            <p>${lesson.lessonDescription}</p>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="materials" role="tabpanel" aria-labelledby="materials-tab">
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title">Tài liệu môn học</h2>
                            <c:choose>
                                <c:when test="${not empty materials}">
                                    <ul class="list-group">
                                        <c:forEach var="material" items="${materials}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                                <a href="/files/taiLieu/${material}" target="_blank">${material}</a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted">Chưa có tài liệu nào.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column: Chapters and Lessons -->
        <div class="col-md-4">
            <div class="sidebar">
                <h4 class="mb-3">${subject.subjectName}</h4>
                <div class="accordion" id="chapterAccordion">
                    <c:forEach var="chapterItem" items="${chapters}" varStatus="chapterStatus">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="chapterHeading${chapterStatus.index}">
                                <button class="accordion-button ${chapterItem.chapterId == chapter.chapterId ? '' : 'collapsed'}"
                                        type="button" data-bs-toggle="collapse"
                                        data-bs-target="#chapterCollapse${chapterStatus.index}"
                                        aria-expanded="${chapterItem.chapterId == chapter.chapterId ? 'true' : 'false'}"
                                        aria-controls="chapterCollapse${chapterStatus.index}">
                                        ${chapterItem.chapterName}
                                </button>
                            </h2>
                            <div id="chapterCollapse${chapterStatus.index}"
                                 class="accordion-collapse collapse ${chapterItem.chapterId == chapter.chapterId ? 'show' : ''}"
                                 aria-labelledby="chapterHeading${chapterStatus.index}"
                                 data-bs-parent="#chapterAccordion">
                                <div class="accordion-body">
                                    <div class="list-group">
                                        <c:forEach var="lessonItem" items="${chapterItem.lessons}">
                                            <a href="/subject/${subject.subjectId}/chapters/${chapterItem.chapterId}/lessons/${lessonItem.lessonId}"
                                               class="list-group-item list-group-item-action d-flex justify-content">
                                                <div class="content-between">
                                                    <div>
                                                        <span class="badge bg-primary rounded-pill me-2">${lessonItem.lessonId}</span>
                                                            ${lessonItem.lessonName}
                                                    </div>
                                                    <span>4min</span>
                                                </div>
                                            </a>
                                        </c:forEach>
                                        <c:if test="${empty chapterItem.lessons}">
                                            <p class="text-muted">Chưa có bài học nào.</p>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"></script>
</body>
</html>