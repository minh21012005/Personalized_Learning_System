<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${lesson != null ? lesson.lessonName : subject != null ? subject.subjectName : 'Không tìm thấy môn học'}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
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
            margin-top: 60px;
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
            color: #0d6efd;
        }
        .list-group {
            max-height: 200px;
            overflow-y: auto;
        }
        .video-container {
            margin-bottom: 20px;
            display: none;
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
        .loading {
            display: none;
            text-align: center;
            padding: 20px;
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
    </style>
</head>
<body>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"></script>
<script>
    $(document).ready(function() {

        $('#chapterAccordion').on('click', '.accordion-button', function() {
            const chapterId = $(this).data('chapter-id');
            const subjectId = ${subject != null ? subject.subjectId : 0};
            const collapseId = $(this).attr('data-bs-target').substring(1);
            const lessonListId = collapseId.replace('chapterCollapse', 'lessonList');
            if ($(`#`+collapseId).hasClass('show')) {
                return;
            }

            $('#loading').show();
            $.get(`/api/chapters/`+chapterId+`?subjectId=`+subjectId, function(data) {
                const lessonList = $(`#`+lessonListId);
                lessonList.empty();
                if (data && data.listLesson && data.listLesson.length > 0) {

                    try {
                        data.listLesson.forEach(newLesson => {

                            lessonList.append(`
                            <a href="#" class="list-group-item list-group-item-action" data-lesson-id="`+newLesson.lessonId+`" onclick="loadLessonDetails(`+ newLesson.lessonId +`)">
                                <div class="d-flex flex-column g-2 justify-content-between">
                                    <div><span class="badge bg-primary rounded-pill me-2">`+newLesson.lessonId+`</span>`+newLesson.lessonName+`</div>
                                     <span  style="font-size: 12px">`+newLesson.videoTime+`</span>
                                </div>
                            </a>
                        `);
                        });
                    } catch (e) {
                        lessonList.append('<p class="text-muted">Lỗi khi hiển thị bài học.</p>');
                    }
                } else {
                    lessonList.append('<p class="text-muted">Không tìm thấy bài học.</p>');
                }
                $('#loading').hide();
            }).fail(function(xhr, status, error) {
                $(`#`+lessonListId).html('<p class="text-muted">Không thể tải danh sách bài học.</p>');
                $('#loading').hide();
            });
        });

        // Event delegation for lesson links
        $('#chapterAccordion').on('click', '.list-group-item-action', function(e) {
            e.preventDefault();
            const lessonId = $(this).data('lesson-id');
            loadLessonDetails(lessonId);
        });

        // Load chi tiết lesson
        function loadLessonDetails(lessonId) {
            console.log("lessonId: ", lessonId)
            // Remove active class from all lesson items
            $('#chapterAccordion .list-group-item-action').removeClass('active');
            // Add active class to the clicked lesson
            $(`#chapterAccordion .list-group-item-action[data-lesson-id="${lessonId}"]`).addClass('active');

            $('#loading').show();
            $.get(`/api/lessons/`+lessonId, function(data) {
                if (data) {
                    console.log("data: ",data)
                    $('#lessonVideo').attr('src', data.videoSrc || '');
                    $('#videoContainer').toggle(!!data.videoSrc);
                    $('#lessonDescription').text(data.lessonDescription || '');
                    const materialsList = $('#materialsList');
                    materialsList.empty();
                    if (data.materials && data.materials.length > 0) {
                        data.materials.forEach(material => {
                            materialsList.append(`
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <a href="/files/taiLieu/`+material+`" target="_blank">`+material+`</a>
                                    </li>
                                `);
                        });
                    } else {
                        materialsList.append('<li class="list-group-item text-muted">Không tìm thấy tài liệu.</li>');
                    }
                } else {
                    $('#lessonVideo').attr('src', '');
                    $('#videoContainer').hide();
                    $('#lessonDescription').text('Không tìm thấy bài học.');
                    $('#materialsList').html('<li class="list-group-item text-muted">Không tìm thấy tài liệu.</li>');
                }
                $('#loading').hide();
                new bootstrap.Tab(document.querySelector('#description-tab')).show();
            }).fail(function(xhr, status, error) {
                $('#lessonVideo').attr('src', '');
                $('#videoContainer').hide();
                $('#lessonDescription').text('Không thể tải chi tiết bài học.');
                $('#materialsList').html('<li class="list-group-item text-muted">Không thể tải tài liệu.</li>');
                $('#loading').hide();
            });
        }

        // Load lesson đầu tiên nếu có
        <c:if test="${lesson != null}">
        loadLessonDetails(${lesson.lessonId});
        </c:if>
    });
</script>


<!-- Header -->
<header>
    <jsp:include page="../layout/header.jsp" />
</header>

<!-- Main Content -->
<div class="content">
    <div class="row">
        <!-- Left Column: Lesson Content -->
        <div class="col-md-8">
            <h1 class="mb-4">${lesson != null ? lesson.lessonName : subject != null ? subject.subjectName : 'Không tìm thấy môn học'}</h1>
            <div class="video-container ratio ratio-16x9" id="videoContainer">
                <iframe id="lessonVideo" src="${lesson != null ? lesson.videoSrc : ''}" title="${lesson != null ? lesson.lessonName : ''}"
                        allowfullscreen></iframe>
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
                            <p id="lessonDescription">${lesson != null ? lesson.lessonDescription : ''}</p>
                        </div>
                    </div>
                </div>
                <div class="tab-pane fade" id="materials" role="tabpanel" aria-labelledby="materials-tab">
                    <div class="card">
                        <div class="card-body">
                            <h2 class="card-title">Tài liệu môn học</h2>
                            <ul class="list-group" id="materialsList">
                                <c:if test="${empty lesson.materials}">
                                    <li class="list-group-item text-muted">Chưa có tài liệu nào.</li>
                                </c:if>
                                <c:forEach var="material" items="${lesson.materials}">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <a href="/files/taiLieu/${material}" target="_blank">${material}</a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="loading" id="loading">Đang tải...</div>
        </div>

        <!-- Right Column: Chapters and Lessons -->
        <div class="col-md-4">
            <div class="sidebar">
                <h4 class="mb-3">${subject != null ? subject.subjectName : 'Không tìm thấy môn học'}</h4>
                <div class="accordion" id="chapterAccordion">
                    <c:forEach var="chapterItem" items="${chapters}" varStatus="chapterStatus">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="chapterHeading${chapterStatus.index}">
                                <button class="accordion-button ${chapterItem.chapterId == (chapter != null ? chapter.chapterId : 0) ? '' : 'collapsed'}"
                                        type="button" data-bs-toggle="collapse" data-chapter-id="${chapterItem.chapterId}"
                                        data-bs-target="#chapterCollapse${chapterStatus.index}"
                                        aria-expanded="${chapterItem.chapterId == (chapter != null ? chapter.chapterId : 0) ? 'true' : 'false'}"
                                        aria-controls="chapterCollapse${chapterStatus.index}">
                                        ${chapterItem.chapterName}
                                </button>
                            </h2>
                            <div id="chapterCollapse${chapterStatus.index}"
                                 class="accordion-collapse collapse ${chapterItem.chapterId == (chapter != null ? chapter.chapterId : 0) ? 'show' : ''}"
                                 aria-labelledby="chapterHeading${chapterStatus.index}"
                                 data-bs-parent="#chapterAccordion">
                                <div class="accordion-body">
                                    <div class="list-group" id="lessonList${chapterStatus.index}">
                                        <c:if test="${chapter != null && chapterItem.chapterId == chapter.chapterId}">
                                            <c:forEach var="lessonItem" items="${chapter.listLesson}">
                                                <a href="#" class="list-group-item list-group-item-action ${lessonItem.lessonId == (lesson != null ? lesson.lessonId : 0) ? 'active' : ''}"
                                                   data-lesson-id="${lessonItem.lessonId}">
                                                    <div class="d-flex flex-column justify-content-between gap-2">
                                                        <div>
                                                            <span class="badge bg-primary rounded-pill me-2">${lessonItem.lessonId}</span>
                                                                ${lessonItem.lessonName}
                                                        </div>
                                                        <span  style="font-size: 12px">${lessonItem.videoTime}</span>
                                                    </div>
                                                </a>
                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${chapter == null || chapterItem.chapterId != chapter.chapterId}">
                                            <p class="text-muted">Nhấn để tải danh sách bài học.</p>
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



<!-- Footer -->
<footer>
    <jsp:include page="../layout/footer.jsp" />
</footer>

<div class="loading" id="loading">Đang tải...</div>
</body>
</html>