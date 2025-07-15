<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${fn:escapeXml(learningData.subjectName != null ? learningData.subjectName : 'Không tìm thấy môn học')}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #0d6efd;
            --secondary-color: #6c757d;
            --bg-color: #f8fafc;
            --card-bg: #ffffff;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --gradient: linear-gradient(135deg, #0d6efd, #6610f2);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-color);
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .content {
            width: 96%;
            max-width: 1400px;
            margin: 0 auto;
            flex: 1;
            padding: 24px;
        }

        .sidebar {
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--shadow);
            padding: 24px;
            max-height: 80vh;
            overflow-y: auto;
        }

        .sidebar h4 {
            font-weight: 600;
            color: #1a252f;
            margin-bottom: 20px;
        }

        .list-group-item {
            border: none;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 8px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .list-group-item:hover {
            background-color: #f1f5f9;
            transform: translateX(4px);
        }

        .list-group-item-action.active {
            background: var(--gradient) !important;
            color: white !important;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(13, 110, 253, 0.2);
        }

        .lesson-completed, .test-completed {
            background-color: #28a745;
            color: white;
            font-size: 0.75rem;
            padding: 2px 8px;
            border-radius: 12px;
            margin-left: 8px;
        }

        .video-container {
            background-color: #e9ecef;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow);
            position: relative;
            margin-bottom: 24px;
        }

        .video-time {
            font-size: 0.9rem;
            color: var(--secondary-color);
            padding: 0 16px 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .card {
            border: none;
            border-radius: 12px;
            background-color: var(--card-bg);
            box-shadow: var(--shadow);
            transition: transform 0.2s ease;
        }

        .card:hover {
            transform: translateY(-4px);
        }

        .card-body {
            padding: 24px;
        }

        .nav-tabs {
            border-bottom: 2px solid #e9ecef;
            margin-bottom: 24px;
        }

        .nav-tabs .nav-link {
            color: var(--secondary-color);
            padding: 12px 24px;
            font-weight: 500;
            border: none;
            border-radius: 8px 8px 0 0;
            transition: all 0.3s ease;
        }

        .nav-tabs .nav-link:hover {
            background-color: #f1f5f9;
            color: var(--primary-color);
        }

        .nav-tabs .nav-link.active {
            color: var(--primary-color);
            font-weight: 600;
            background-color: var(--card-bg);
            border-bottom: 3px solid var(--primary-color);
        }

        .toggle-chapter-btn {
            background: none;
            border: none;
            padding: 16px 20px;
            cursor: pointer;
            color: #1a252f;
            font-weight: 600;
            width: 100%;
            text-align: left;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
            border-bottom: 1px solid #e9ecef;
        }

        .toggle-chapter-btn:hover {
            color: var(--primary-color);
            background-color: #f8f9fa;
        }

        .toggle-chapter-btn .bi {
            font-size: 1rem;
            transition: transform 0.3s ease;
        }

        .toggle-chapter-btn[aria-expanded="true"] .bi-chevron-down {
            transform: rotate(180deg);
        }

        .chapter-container .collapse {
            transition: height 0.3s ease;
        }

        .chapter-container {
            margin-bottom: 12px;
            border-radius: 8px;
            background-color: var(--card-bg);
            overflow: hidden;
        }

        .btn-back, .btn-test, .btn-detail {
            font-weight: 500;
            border-radius: 8px;
            padding: 10px 20px;
            transition: all 0.3s ease;
        }

        .btn-back:hover, .btn-test:hover, .btn-detail:hover {
            background-color: var(--primary-color);
            color: white;
            transform: translateX(-4px);
        }

        .test-section {
            margin-top: 20px;
        }

        @media (max-width: 991.98px) {
            .sidebar {
                display: none;
            }

            .nav-tabs .nav-link {
                padding: 10px 16px;
                font-size: 0.95rem;
            }

            .content {
                padding: 16px;
            }
        }
    </style>
</head>
<body>
<!-- Thư viện JavaScript -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"></script>
<script src="/js/learn.js"></script>

<!-- Khởi tạo YouTube IFrame API -->
<script>
    if (!window.YT) {
        const tag = document.createElement('script');
        tag.src = "https://www.youtube.com/iframe_api";
        const firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    }
</script>

<!-- Dữ liệu lessons và tests từ server -->
<script>
    const lessonsData = {};
    <c:forEach var="chapterItem" items="${learningData.chapters}">
    <c:forEach var="lessonItem" items="${chapterItem.listLesson}">
    lessonsData["${lessonItem.lessonId}"] = {
        lessonId: ${lessonItem.lessonId},
        lessonName: "${fn:escapeXml(lessonItem.lessonName)}",
        videoSrc: "${fn:escapeXml(lessonItem.videoSrc != null ? lessonItem.videoSrc : '')}",
        lessonDescription: "${fn:escapeXml(lessonItem.lessonDescription != null ? lessonItem.lessonDescription : '')}",
        materials: [
            <c:forEach var="material" items="${lessonItem.materials}" varStatus="materialStatus">
            {
                "fileName": "${fn:escapeXml(material.fileName)}",
                "filePath": "${fn:escapeXml(material.filePath)}"
            }${materialStatus.last ? '' : ','}
            </c:forEach>
        ],
        videoTime: "${fn:escapeXml(lessonItem.videoTime != null ? lessonItem.videoTime : '')}",
        isCompleted: ${lessonItem.isCompleted},
        lessonTest: <c:if test="${lessonItem.lessonTest != null}">
            {
                testId: ${lessonItem.lessonTest.testId},
                testName: "${fn:escapeXml(lessonItem.lessonTest.testName)}",
                durationTime: ${lessonItem.lessonTest.durationTime},
                testCategoryName: "${fn:escapeXml(lessonItem.lessonTest.testCategoryName)}",
                isCompleted: ${lessonItem.lessonTest.isCompleted}
            },
        </c:if><c:if test="${lessonItem.lessonTest == null}">null</c:if>
    };
    </c:forEach>
    </c:forEach>

    const learningConfig = {
        userId: ${learningData.userId != null ? learningData.userId : 'null'},
        subjectId: ${learningData.subjectId != null ? learningData.subjectId : 'null'},
        packageId: ${learningData.packageId != null ? learningData.packageId : 'null'},
        defaultLessonId: ${learningData.defaultLesson != null ? learningData.defaultLesson.lessonId : 'null'}
    };

    $(document).ready(function() {
        if (typeof LearningApp !== 'undefined') {
            LearningApp.init(learningConfig, lessonsData);
        } else {
            console.error('Không thể khởi tạo LearningApp. Vui lòng kiểm tra file learn.js.');
        }
    });
</script>

<div class="content">
    <div class="mb-4">
        <a href="/packages/detail?packageId=${learningData.packageId}" class="btn btn-outline-primary btn-back">
            <i class="bi bi-arrow-left me-2"></i>Quay lại gói khóa học
        </a>
    </div>
    <h1 id="lessonTitle" class="mb-4 fw-bold">${fn:escapeXml(learningData.defaultLesson != null ? learningData.defaultLesson.lessonName : (learningData.subjectName != null ? learningData.subjectName : 'Không tìm thấy môn học'))}</h1>

    <div class="row">
        <div class="col-lg-8">
            <div class="video-container ratio ratio-16x9" id="videoContainer">
                <iframe id="lessonVideo" frameborder="0" allow="autoplay" allowfullscreen></iframe>
            </div>

            <ul class="nav nav-tabs" id="lessonTabs" role="tablist">
                <li class="nav-item d-block d-lg-none" role="presentation">
                    <button class="nav-link" id="chapters-tab" data-bs-toggle="tab" data-bs-target="#chapters"
                            type="button" role="tab" aria-controls="chapters">Nội dung môn học</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="description-tab" data-bs-toggle="tab" data-bs-target="#description"
                            type="button" role="tab" aria-controls="description" aria-selected="true">Mô tả bài học</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="materials-tab" data-bs-toggle="tab" data-bs-target="#materials"
                            type="button" role="tab" aria-controls="materials">Tài liệu môn học</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="test-tab" data-bs-toggle="tab" data-bs-target="#test"
                            type="button" role="tab" aria-controls="test">Bài kiểm tra cuối bài</button>
                </li>
            </ul>
            <div class="tab-content" id="lessonTabsContent">
                <div class="tab-pane fade show active" id="description" role="tabpanel" aria-labelledby="description-tab">
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title h4 fw-semibold">Mô tả bài học</h2>
                            <p id="lessonDescription">${fn:escapeXml(learningData.defaultLesson != null && learningData.defaultLesson.lessonDescription != null ? learningData.defaultLesson.lessonDescription : 'Không có mô tả cho bài học này.')}</p>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="materials" role="tabpanel" aria-labelledby="materials-tab">
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title h4 fw-semibold">Tài liệu môn học</h2>
                            <ul class="list-group" id="materialsList">
                                <c:choose>
                                    <c:when test="${not empty learningData.defaultLesson.materials}">
                                        <c:forEach var="material" items="${learningData.defaultLesson.materials}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                                <a href="/files/materials/${fn:escapeXml(material.filePath)}" target="_blank">${fn:escapeXml(material.fileName)}</a>
                                                <a href="/files/materials/${fn:escapeXml(material.filePath)}" download="${fn:escapeXml(material.fileName)}" class="text-primary">
                                                    <i class="bi bi-download"></i>
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="list-group-item text-muted">Chưa có tài liệu nào.</li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="test" role="tabpanel" aria-labelledby="test-tab">
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title h4 fw-semibold">Bài kiểm tra cuối bài</h2>
                            <div id="test-section" class="test-section">
                                <!-- Nội dung bài kiểm tra sẽ được cập nhật động bởi JavaScript -->
                                <p id="no-test-message" class="text-muted">Không có bài kiểm tra cuối bài.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade d-block d-lg-none" id="chapters" role="tabpanel" aria-labelledby="chapters-tab">
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title h4 fw-semibold">Nội dung môn học</h2>
                            <c:set var="stt" value="0" />
                            <c:forEach var="chapterItem" items="${learningData.chapters}">
                                <div class="chapter-container">
                                    <button class="toggle-chapter-btn ${chapterItem.chapterId == (learningData.defaultChapter != null ? learningData.defaultChapter.chapterId : 0) ? '' : 'collapsed'}"
                                            type="button"
                                            data-bs-toggle="collapse"
                                            data-bs-target="#chapterCollapseMobile${chapterItem.chapterId}"
                                            aria-expanded="${chapterItem.chapterId == (learningData.defaultChapter != null ? learningData.defaultChapter.chapterId : 0) ? 'true' : 'false'}">
                                        <span>${fn:escapeXml(chapterItem.chapterName)}</span>
                                        <i class="bi bi-chevron-down"></i>
                                    </button>
                                    <div id="chapterCollapseMobile${chapterItem.chapterId}"
                                         class="collapse ${chapterItem.chapterId == (learningData.defaultChapter != null ? learningData.defaultChapter.chapterId : 0) ? 'show' : ''}">
                                        <div class="list-group">
                                            <c:forEach var="lessonItem" items="${chapterItem.listLesson}">
                                                <c:set var="stt" value="${stt + 1}" />
                                                <div class="d-flex flex-column">
                                                    <a href="#" class="list-group-item list-group-item-action ${lessonItem.lessonId == (learningData.defaultLesson != null ? learningData.defaultLesson.lessonId : 0) ? 'active' : ''}"
                                                       data-lesson-id="${lessonItem.lessonId}">
                                                            ${stt}. ${fn:escapeXml(lessonItem.lessonName)}
                                                        <c:if test="${lessonItem.isCompleted}">
                                                            <span class="lesson-completed">Hoàn thành</span>
                                                        </c:if>
                                                    </a>
                                                    <span class="video-time">
                                                        <i class="bi bi-collection-play"></i>
                                                        ${fn:escapeXml(lessonItem.videoTime != null ? lessonItem.videoTime : '')}
                                                    </span>
                                                </div>
                                            </c:forEach>
                                            <c:if test="${not empty chapterItem.chapterTests}">
                                                <div class="test-section">
                                                    <h3 class="h5 fw-semibold">Bài kiểm tra chương</h3>
                                                    <c:forEach var="chapterTest" items="${chapterItem.chapterTests}">
                                                        <div class="list-group-item">
                                                            <a href="/tests/${chapterTest.testId}/${learningData.packageId}" class="text-decoration-none" target="_blank">
                                                                    ${fn:escapeXml(chapterTest.testName)} (${fn:escapeXml(chapterTest.testCategoryName)})
                                                                <c:if test="${chapterTest.isCompleted}">
                                                                    <span class="test-completed">Hoàn thành</span>
                                                                </c:if>
                                                            </a>
                                                            <c:if test="${chapterTest.isCompleted}">
                                                                <a href="/tests/history/${chapterTest.testId}" class="btn btn-outline-primary btn-detail" target="_blank">
                                                                    Chi tiết
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                            <c:if test="${empty chapterItem.chapterTests}">
                                                <div class="test-section">
                                                    <p class="text-muted">Không có bài kiểm tra chương.</p>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4 d-none d-lg-block">
            <div class="sidebar">
                <h4 class="mb-3">Nội dung môn học</h4>
                <c:set var="stt" value="0" />
                <c:forEach var="chapterItem" items="${learningData.chapters}">
                    <div class="chapter-container">
                        <button class="toggle-chapter-btn ${chapterItem.chapterId == (learningData.defaultChapter != null ? learningData.defaultChapter.chapterId : 0) ? '' : 'collapsed'}"
                                type="button"
                                data-bs-toggle="collapse"
                                data-bs-target="#chapterCollapse${chapterItem.chapterId}"
                                aria-expanded="${chapterItem.chapterId == (learningData.defaultChapter != null ? learningData.defaultChapter.chapterId : 0) ? 'true' : 'false'}">
                            <span>${fn:escapeXml(chapterItem.chapterName)}</span>
                            <i class="bi bi-chevron-down"></i>
                        </button>
                        <div id="chapterCollapse${chapterItem.chapterId}"
                             class="collapse ${chapterItem.chapterId == (learningData.defaultChapter != null ? learningData.defaultChapter.chapterId : 0) ? 'show' : ''}">
                            <div class="list-group">
                                <c:forEach var="lessonItem" items="${chapterItem.listLesson}">
                                    <c:set var="stt" value="${stt + 1}" />
                                    <div class="d-flex flex-column">
                                        <a href="#" class="list-group-item list-group-item-action ${lessonItem.lessonId == (learningData.defaultLesson != null ? learningData.defaultLesson.lessonId : 0) ? 'active' : ''}"
                                           data-lesson-id="${lessonItem.lessonId}">
                                                ${stt}. ${fn:escapeXml(lessonItem.lessonName)}
                                            <c:if test="${lessonItem.isCompleted}">
                                                <span class="lesson-completed">Hoàn thành</span>
                                            </c:if>
                                        </a>
                                        <span class="video-time">
                                            <i class="bi bi-collection-play"></i>
                                            ${fn:escapeXml(lessonItem.videoTime != null ? lessonItem.videoTime : '')}
                                        </span>
                                    </div>
                                </c:forEach>
                                <c:if test="${not empty chapterItem.chapterTests}">
                                    <div class="test-section">
                                        <h3 class="h5 fw-semibold">Bài kiểm tra chương</h3>
                                        <c:forEach var="chapterTest" items="${chapterItem.chapterTests}">
                                            <div class="list-group-item">
                                                <a href="/tests/${chapterTest.testId}/${learningData.packageId}" class="text-decoration-none" target="_blank">
                                                        ${fn:escapeXml(chapterTest.testName)} (${fn:escapeXml(chapterTest.testCategoryName)})
                                                    <c:if test="${chapterTest.isCompleted}">
                                                        <span class="test-completed">Hoàn thành</span>
                                                    </c:if>
                                                </a>
                                                <c:if test="${chapterTest.isCompleted}">
                                                    <a href="/tests/history/${chapterTest.testId}" class="btn btn-outline-primary btn-detail" target="_blank">
                                                        Chi tiết
                                                    </a>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:if>
                                <c:if test="${empty chapterItem.chapterTests}">
                                    <div class="test-section">
                                        <p class="text-muted">Không có bài kiểm tra chương.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${not empty learningData.subjectTests}">
                    <div class="test-section">
                        <h3 class="h5 fw-semibold">Bài kiểm tra môn học</h3>
                        <c:forEach var="subjectTest" items="${learningData.subjectTests}">
                            <div class="list-group-item">
                                <a href="/tests/${subjectTest.testId}/${learningData.packageId}" class="text-decoration-none" target="_blank">
                                        ${fn:escapeXml(subjectTest.testName)} (${fn:escapeXml(subjectTest.testCategoryName)})
                                    <c:if test="${subjectTest.isCompleted}">
                                        <span class="test-completed">Hoàn thành</span>
                                    </c:if>
                                </a>
                                <c:if test="${subjectTest.isCompleted}">
                                    <a href="/tests/history/${subjectTest.testId}" class="btn btn-outline-primary btn-detail" target="_blank">
                                        Chi tiết
                                    </a>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
                <c:if test="${empty learningData.subjectTests}">
                    <div class="test-section">
                        <p class="text-muted">Không có bài kiểm tra môn học.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>
</body>
</html>