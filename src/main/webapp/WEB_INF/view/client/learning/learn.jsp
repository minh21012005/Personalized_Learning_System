<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${lesson != null ? lesson.lessonName : subject != null ? subject.subjectName : 'Không tìm thấy môn học'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .content {
            width: 96%;
            margin: 0 auto;
            flex: 1;
            padding: 20px;
            background-color: #f8f9fa;
        }
        .sidebar {
            background-color: #ffffff;
            border-left: 1px solid #dee2e6;
            height: 100%;
            padding: 20px;
            max-height: 100vh;
            overflow-y: auto;
            position: sticky;
            top: 60px;
        }
        .list-group-item {
            border: none;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            transition: background-color 0.2s, color 0.2s, border-left-color 0.2s;
        }
        .list-group-item:hover {
            background-color: #f0f0f0;
            color: #0056b3;
        }
        .list-group-item-action.active {
            background-color: #e7f1ff !important;
            color: #0056b3 !important;
            font-weight: bold;
            border-left: 3px solid #007bff !important;
            box-shadow: 0 2px 4px rgba(0, 123, 255, 0.1);
        }
        .video-container {
            margin-bottom: 20px;
        }
        .video-time {
            font-size: 0.85em;
            color: #6c757d;
            padding: 0 20px 8px;
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
        header, footer {
            background-color: #1a252f;
            color: white;
            width: 100%;
        }
        .toggle-chapter-btn {
            background: none;
            border: none;
            padding: 12px 20px;
            cursor: pointer;
            color: #212529;
            font-weight: 600;
            width: 100%;
            text-align: left;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: color 0.2s;
            border-bottom: 1px solid #dee2e6;
        }
        .toggle-chapter-btn:hover {
            color: #0056b3;
            background-color: #f8f9fa;
        }
        .toggle-chapter-btn .bi {
            font-size: 1em;
            transition: transform 0.2s;
        }
        .toggle-chapter-btn[aria-expanded="true"] .bi-chevron-down {
            transform: rotate(180deg);
        }
        .chapter-container {
            margin-bottom: 5px;
            border: 1px solid #e9ecef;
            border-radius: .25rem;
            margin-top: 10px;
            background-color: #ffffff;
        }
        .chapter-container .list-group {
            margin-top: 5px;
        }
        @media (max-width: 767.98px) {
            .sidebar {
                display: none;
            }
            .tab-content .chapter-container {
                padding: 0;
            }
        }
    </style>
</head>
<body>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"></script>
<script>
    // Tải YouTube API nếu chưa có
    if (!window.YT) {
        var tag = document.createElement('script');
        tag.src = "https://www.youtube.com/iframe_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    }
</script>
<script>
    // Dữ liệu lessons được truyền từ server
    const lessonsData = {
        <c:forEach var="chapterItem" items="${chapters}" varStatus="chapterStatus">
        <c:forEach var="lessonItem" items="${chapterItem.listLesson}" varStatus="lessonStatus">
        "${lessonItem.lessonId}": {
            lessonId: ${lessonItem.lessonId},
            lessonName: "${fn:escapeXml(lessonItem.lessonName)}",
            videoSrc: "${fn:escapeXml(lessonItem.videoSrc != null ? lessonItem.videoSrc : '')}",
            lessonDescription: "${fn:escapeXml(lessonItem.lessonDescription != null ? lessonItem.lessonDescription : '')}",
            materials: [
                <c:forEach var="material" items="${lessonItem.materials}" varStatus="materialStatus">
                "${fn:escapeXml(material)}"${materialStatus.last ? '' : ','}
                </c:forEach>
            ],
            videoTime: "${fn:escapeXml(lessonItem.videoTime != null ? lessonItem.videoTime : '')}",
            isCompleted: ${lessonItem.isCompleted}
        }${lessonStatus.last && chapterStatus.last ? '' : ','}
        </c:forEach>
        </c:forEach>
    };

    // Lấy userId từ server
    const userId = ${sessionScope.id != null ? sessionScope.id : 'null'};
    if (!userId) {
        console.error('Thiếu userId. Không thể theo dõi tiến trình.');
    }

    let player = null;
    let currentLessonId = null;
    let lastWatchedTime = 0;
    let isYouTubeAPIReady = false;
    let pendingLessonId = null;

    // Hàm được gọi khi YouTube API sẵn sàng
    window.onYouTubeIframeAPIReady = function() {
        console.log('YouTube API is ready');
        isYouTubeAPIReady = true;
        if (pendingLessonId) {
            console.log('Initializing player for pending lesson:', pendingLessonId);
            initializeYouTubePlayer(pendingLessonId);
            pendingLessonId = null;
        }
    };

    // Lưu tiến trình vào localStorage
    function saveToLocalStorage(lessonId, watchedTime, isCompleted) {
        if (!userId || !lessonId) return;
        const storageKey = `lesson_progress_`+userId+`_`+lessonId;
        const progress = { watchedTime: Math.floor(watchedTime), isCompleted, timestamp: Date.now() };
        localStorage.setItem(storageKey, JSON.stringify(progress));
    }

    // Đồng bộ tiến trình với backend
    async function syncProgressToBackend(lessonId) {
        if (!userId || !lessonId) {
            console.error('Thiếu userId hoặc lessonId');
            return;
        }
        const storageKey = `lesson_progress_`+userId+`_`+lessonId;

        const progress = JSON.parse(localStorage.getItem(storageKey));
        if (progress) {
            const data = {
                userId: userId,
                lessonId: parseInt(lessonId),
                watchedTime: progress.watchedTime || 0,
                isCompleted: progress.isCompleted || false
            };
            try {
                const response = await fetch('/api/lesson-progress/save', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ' + localStorage.getItem('jwtToken')
                    },
                    body: JSON.stringify(data)
                });
                if (response.ok) {
                    localStorage.removeItem(storageKey);
                } else {
                    console.error('Lỗi khi lưu tiến trình:', response.statusText);
                }
            } catch (error) {
                console.error('Lỗi đồng bộ tiến trình:', error);
            }
        }
    }

    // Tải tiến trình khi chuyển bài học
    async function loadProgress(lessonId) {
        if (!userId || !lessonId) return;
        const storageKey = `lesson_progress_`+userId+`_`+lessonId;

        const localProgress = JSON.parse(localStorage.getItem(storageKey));
        if (localProgress && localProgress.watchedTime) {
            lastWatchedTime = localProgress.watchedTime;
            if (player && player.seekTo && isYouTubeAPIReady) {
                player.seekTo(lastWatchedTime, true);
            }
            return;
        }

        try {
            const response = await fetch(`/api/lesson-progress?userId=`+userId+`&lessonId=`+lessonId, {
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('jwtToken')
                }
            });
            if (response.ok) {
                const progress = await response.json();
                if (progress && progress.watchedTime) {
                    lastWatchedTime = progress.watchedTime;
                    if (player && player.seekTo && isYouTubeAPIReady) {
                        player.seekTo(lastWatchedTime, true);
                    }
                    saveToLocalStorage(lessonId, progress.watchedTime, progress.isCompleted);
                }
            }
        } catch (error) {
            console.error('Lỗi khi tải tiến trình:', error);
        }
    }

    // Hàm chuyển đổi videoTime (HH:MM:SS) sang giây
    function parseVideoTime(timeStr) {
        if (!timeStr) return 0;
        const [hours, minutes, seconds] = timeStr.split(':').map(Number);
        return (hours || 0) * 3600 + (minutes || 0) * 60 + (seconds || 0);
    }

    // Trích xuất YouTube video ID từ URL nhúng
    function extractYouTubeVideoId(url) {
        console.log('Extracting video ID from URL:', url);
        const regex = /(?:youtube\.com\/(?:embed\/|watch\?v=)|youtu\.be\/)([^?&\s]+)/;
        const match = url.match(regex);
        const videoId = match ? match[1] : null;
        console.log('Extracted video ID:', videoId);
        return videoId;
    }

    // Khởi tạo YouTube Player
    function initializeYouTubePlayer(lessonId) {
        console.log('Initializing YouTube Player for lesson:', lessonId);
        if (!isYouTubeAPIReady) {
            console.log('YouTube API not ready, storing pending lesson:', lessonId);
            pendingLessonId = lessonId;
            return;
        }
        const lesson = lessonsData[lessonId];
        if (!lesson || !lesson.videoSrc) {
            console.log('No lesson or video source found for lesson:', lessonId);
            $('#videoContainer').hide();
            return;
        }

        const videoId = extractYouTubeVideoId(lesson.videoSrc);
        if (!videoId) {
            console.error('Invalid YouTube URL:', lesson.videoSrc);
            $('#videoContainer').hide();
            return;
        }

        // Hủy player cũ
        if (player) {
            console.log('Destroying old player');
            player.destroy();
            player = null;
        }

        // Xóa và tạo lại iframe
        $('#videoContainer').empty().append(`
            <iframe id="lessonVideo" frameborder="0"
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                    allowfullscreen></iframe>
        `);

        // Cập nhật iframe src
        const videoSrc = lesson.videoSrc + (lesson.videoSrc.includes('?') ? '&' : '?') + 'enablejsapi=1';
        console.log('Setting iframe src:', videoSrc);
        $('#lessonVideo').attr('src', videoSrc);
        $('#videoContainer').show();

        // Tạo player mới
        console.log('Creating new YouTube Player with videoId:', videoId);
        player = new YT.Player('lessonVideo', {
            height: '100%',
            width: '100%',
            videoId: videoId,
            playerVars: {
                'playsinline': 1,
                'enablejsapi': 1
            },
            events: {
                'onReady': (event) => {
                    console.log('Player is ready for lesson:', lessonId);
                    loadProgress(lessonId);
                },
                'onStateChange': (event) => {
                    console.log('Player state changed:', event.data);
                    if (event.data === YT.PlayerState.PLAYING) {
                        const timeUpdateInterval = setInterval(() => {
                            if (player && player.getCurrentTime) {
                                lastWatchedTime = player.getCurrentTime();
                                saveToLocalStorage(lessonId, lastWatchedTime, false);
                            }
                        }, 5000);
                        player.timeUpdateInterval = timeUpdateInterval;
                    } else if (event.data === YT.PlayerState.PAUSED) {
                        clearInterval(player.timeUpdateInterval);
                        saveToLocalStorage(lessonId, lastWatchedTime, false);
                        syncProgressToBackend(lessonId);
                    } else if (event.data === YT.PlayerState.ENDED) {
                        clearInterval(player.timeUpdateInterval);
                        const lesson = lessonsData[lessonId];
                        const totalTime = lesson.videoTime ? parseVideoTime(lesson.videoTime) : player.getDuration();
                        saveToLocalStorage(lessonId, totalTime, true);
                        syncProgressToBackend(lessonId);
                    }
                }
            }
        });
    }

    $(document).ready(function() {
        // Gắn sự kiện click cho tất cả lesson
        $('.list-group-item-action').on('click', function(e) {
            e.preventDefault();
            const lessonId = $(this).data('lesson-id');
            console.log('Clicked lessonId:', lessonId);
            loadLessonDetails(lessonId);
        });

        function loadLessonDetails(lessonId) {
            console.log('Loading lesson details for lessonId:', lessonId);
            const lesson = lessonsData[lessonId];
            console.log('Lesson data:', lesson);

            if (currentLessonId && currentLessonId != lessonId) {
                console.log('Syncing progress for previous lesson:', currentLessonId);
                syncProgressToBackend(currentLessonId);
            }

            currentLessonId = lessonId;

            $('.list-group-item-action').removeClass('active');
            $(`.list-group-item-action[data-lesson-id="${lessonId}"]`).addClass('active');

            if (lesson) {
                $('#lessonDescription').text(lesson.lessonDescription || 'Không có mô tả cho bài học này.');
                const materialsList = $('#materialsList');
                materialsList.empty();
                if (lesson.materials && lesson.materials.length > 0) {
                    lesson.materials.forEach(material => {
                        materialsList.append(`
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <a href="/files/taiLieu/${material}" target="_blank">${material}</a>
                            </li>
                        `);
                    });
                } else {
                    materialsList.append('<li class="list-group-item text-muted">Không tìm thấy tài liệu.</li>');
                }

                // Cập nhật video
                if (lesson.videoSrc && extractYouTubeVideoId(lesson.videoSrc)) {
                    console.log('Valid video source, initializing player for lesson:', lessonId);
                    initializeYouTubePlayer(lessonId);
                } else {
                    console.log('Invalid or missing video source for lesson:', lessonId);
                    $('#lessonVideo').attr('src', '');
                    $('#videoContainer').hide();
                }
            } else {
                console.log('Lesson not found for lessonId:', lessonId);
                $('#lessonVideo').attr('src', '');
                $('#videoContainer').hide();
                $('#lessonDescription').text('Không tìm thấy bài học.');
                $('#materialsList').html('<li class="list-group-item text-muted">Không tìm thấy tài liệu.</li>');
            }

            new bootstrap.Tab(document.querySelector('#description-tab')).show();
        }

        window.addEventListener('beforeunload', () => {
            if (currentLessonId) {
                syncProgressToBackend(currentLessonId);
            }
        });

        <c:if test="${lesson != null}">
        loadLessonDetails(${lesson.lessonId});
        </c:if>

        $('.toggle-chapter-btn').on('click', function() {
            $(this).find('.bi-chevron-down').toggleClass('rotate-180');
        });
    });
</script>

<div class="content">
    <h1 class="mb-4">${lesson != null ? lesson.lessonName : subject != null ? subject.subjectName : 'Không tìm thấy môn học'}</h1>

    <div class="row">
        <div class="col-md-8">
            <div class="video-container ratio ratio-16x9" id="videoContainer">
                <iframe id="lessonVideo" src="${lesson != null && lesson.videoSrc != null ? lesson.videoSrc : ''}"
                        title="${lesson != null ? lesson.lessonName : ''}" frameborder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowfullscreen></iframe>
            </div>

            <ul class="nav nav-tabs mb-4" id="lessonTabs" role="tablist">
                <li class="nav-item d-block d-md-none" role="presentation">
                    <button class="nav-link" id="chapters-tab" data-bs-toggle="tab" data-bs-target="#chapters"
                            type="button" role="tab" aria-controls="chapters" aria-selected="false">Nội dung môn học</button>
                </li>
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
                            <p id="lessonDescription">${lesson != null && lesson.lessonDescription != null ? lesson.lessonDescription : 'Không có mô tả cho bài học này.'}</p>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="materials" role="tabpanel" aria-labelledby="materials-tab">
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title">Tài liệu môn học</h2>
                            <ul class="list-group" id="materialsList">
                                <c:choose>
                                    <c:when test="${not empty lesson.materials}">
                                        <c:forEach var="material" items="${lesson.materials}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                                <a href="/files/taiLieu/${material}" target="_blank">${material}</a>
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
                <div class="tab-pane fade d-block d-md-none" id="chapters" role="tabpanel" aria-labelledby="chapters-tab">
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title">Nội dung môn học</h2>
                            <div>
                                <c:set var="stt" value="0" />
                                <c:forEach var="chapterItem" items="${chapters}">
                                    <div class="chapter-container">
                                        <button class="toggle-chapter-btn ${chapterItem.chapterId == (chapter != null ? chapter.chapterId : 0) ? '' : 'collapsed'}"
                                                type="button"
                                                data-bs-toggle="collapse"
                                                data-bs-target="#chapterCollapseMobile${chapterItem.chapterId}"
                                                aria-expanded="${chapterItem.chapterId == (chapter != null ? chapter.chapterId : 0) ? 'true' : 'false'}"
                                                aria-controls="chapterCollapseMobile${chapterItem.chapterId}">
                                            <span>${chapterItem.chapterName}</span>
                                            <i class="bi bi-chevron-down"></i>
                                        </button>
                                        <div id="chapterCollapseMobile${chapterItem.chapterId}"
                                             class="collapse ${chapterItem.chapterId == (chapter != null ? chapter.chapterId : 0) ? 'show' : ''}">
                                            <div class="list-group">
                                                <c:choose>
                                                    <c:when test="${not empty chapterItem.listLesson}">
                                                        <c:forEach var="lessonItem" items="${chapterItem.listLesson}">
                                                            <c:set var="stt" value="${stt + 1}" />
                                                            <div class="d-flex flex-column">
                                                                <a href="#" class="list-group-item list-group-item-action ${lessonItem.lessonId == (lesson != null ? lesson.lessonId : 0) ? 'active' : ''}"
                                                                   data-lesson-id="${lessonItem.lessonId}">
                                                                        ${stt}. ${lessonItem.lessonName}
                                                                    <c:if test="${lessonItem.isCompleted}">
                                                                        <i class="bi bi-check-circle-fill text-success ms-2"></i>
                                                                    </c:if>
                                                                </a>
                                                                <span class="video-time"><i class="bi bi-collection-play"></i> ${lessonItem.videoTime != null ? lessonItem.videoTime : 'N/A'}</span>
                                                            </div>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="text-muted p-3">Chưa có bài học nào.</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4 d-none d-md-block">
            <div class="sidebar">
                <h4 class="mb-3">Nội dung môn học</h4>
                <div>
                    <c:set var="stt" value="0" />
                    <c:forEach var="chapterItem" items="${chapters}">
                        <div class="chapter-container">
                            <button class="toggle-chapter-btn ${chapterItem.chapterId == (chapter != null ? chapter.chapterId : 0) ? '' : 'collapsed'}"
                                    type="button"
                                    data-bs-toggle="collapse"
                                    data-bs-target="#chapterCollapse${chapterItem.chapterId}"
                                    aria-expanded="${chapterItem.chapterId == (chapter != null ? chapter.chapterId : 0) ? 'true' : 'false'}"
                                    aria-controls="chapterCollapse${chapterItem.chapterId}">
                                <span>${chapterItem.chapterName}</span>
                                <i class="bi bi-chevron-down"></i>
                            </button>
                            <div id="chapterCollapse${chapterItem.chapterId}"
                                 class="collapse ${chapterItem.chapterId == (chapter != null ? chapter.chapterId : 0) ? 'show' : ''}">
                                <div class="list-group">
                                    <c:choose>
                                        <c:when test="${not empty chapterItem.listLesson}">
                                            <c:forEach var="lessonItem" items="${chapterItem.listLesson}">
                                                <c:set var="stt" value="${stt + 1}" />
                                                <div class="d-flex flex-column">
                                                    <a href="#" class="list-group-item list-group-item-action ${lessonItem.lessonId == (lesson != null ? lesson.lessonId : 0) ? 'active' : ''}"
                                                       data-lesson-id="${lessonItem.lessonId}">
                                                            ${stt}. ${lessonItem.lessonName}
                                                        <c:if test="${lessonItem.isCompleted}">
                                                            <i class="bi bi-check-circle-fill text-success ms-2"></i>
                                                        </c:if>
                                                    </a>
                                                    <span class="video-time"><i class="bi bi-collection-play"></i> ${lessonItem.videoTime != null ? lessonItem.videoTime : 'N/A'}</span>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted p-3">Chưa có bài học nào.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>