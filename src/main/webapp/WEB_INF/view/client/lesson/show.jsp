<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
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
            margin-top: 60px;
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
            position: sticky; /* Đảm bảo sidebar luôn ở vị trí khi cuộn */
            top: 60px; /* Điều chỉnh nếu header của bạn có chiều cao khác */
        }
        .list-group-item {
            border: none;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            transition: background-color 0.2s, color 0.2s, border-left-color 0.2s;
        }
        .list-group-item:hover {
            background-color: #f0f0f0; /* Màu nền khi hover */
            color: #0056b3;
        }
        /* Quy tắc active mạnh hơn để đảm bảo hiển thị */
        .list-group-item-action.active {
            background-color: #e7f1ff !important; /* Sử dụng !important để đảm bảo ghi đè */
            color: #0056b3 !important;
            font-weight: bold;
            border-left: 3px solid #007bff !important;
            box-shadow: 0 2px 4px rgba(0, 123, 255, 0.1);
        }
        .video-container {
            margin-bottom: 20px;
            /* display: none; will be controlled by JS */
        }
        .video-time {
            font-size: 0.85em; /* Kích thước chữ nhỏ hơn */
            color: #6c757d; /* Màu xám cho thời gian video */
            padding: 0 20px 8px; /* Padding dưới để tách khỏi item tiếp theo */
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
            font-size: 1.1em;
            color: #0d6efd;
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
            color: #212529; /* Màu chữ mặc định */
            font-weight: 600;
            width: 100%;
            text-align: left;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: color 0.2s;
            border-bottom: 1px solid #dee2e6; /* Đường viền dưới cho mỗi chương */
        }
        .toggle-chapter-btn:hover {
            color: #0056b3;
            background-color: #f8f9fa;
        }
        .toggle-chapter-btn .bi {
            font-size: 1em; /* Kích thước icon nhỏ hơn */
            transition: transform 0.2s;
        }
        .toggle-chapter-btn[aria-expanded="true"] .bi-chevron-down {
            transform: rotate(180deg); /* Xoay mũi tên khi mở */
        }
        .chapter-container {
            margin-bottom: 5px; /* Giảm khoảng cách giữa các chương */
            border: 1px solid #e9ecef;
            border-radius: .25rem;
            margin-top: 10px;
            background-color: #ffffff;
        }
        .chapter-container .list-group {
            margin-top: 5px; /* Khoảng cách từ nút mở/đóng đến danh sách bài học */
        }

        @media (max-width: 767.98px) {
            .sidebar {
                display: none;
            }
            .tab-content .chapter-container {
                padding: 0; /* Bỏ padding để điều chỉnh tốt hơn */
            }
        }
    </style>
</head>
<body>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"></script>
<script>
    $(document).ready(function() {
        // Gắn sự kiện click cho tất cả lesson
        $('.list-group-item-action').on('click', function(e) {
            e.preventDefault();
            const lessonId = $(this).data('lesson-id');
            console.log('Clicked lessonId:', lessonId); // Debug
            loadLessonDetails(lessonId);
        });

        function loadLessonDetails(lessonId) {
            console.log('Loading lesson details for lessonId:', lessonId); // Debug

            // Xóa lớp active khỏi tất cả các lesson items
            $('.list-group-item-action').removeClass('active');
            // Thêm lớp active vào lesson item được chọn
            $(`.list-group-item-action[data-lesson-id="${lessonId}"]`).addClass('active');

            $('#loading').show(); // Hiển thị trạng thái tải
            $.get(`/api/lessons/` + lessonId, function(data) {
                console.log('API response:', data); // Debug
                if (data) {
                    $('#lessonVideo').attr('src', data.videoSrc || '');
                    $('#videoContainer').toggle(!!data.videoSrc); // Ẩn/hiện video container
                    $('#lessonDescription').text(data.lessonDescription || 'Không có mô tả cho bài học này.');
                    const materialsList = $('#materialsList');
                    materialsList.empty();
                    if (data.materials && data.materials.length > 0) {
                        data.materials.forEach(material => {
                            materialsList.append(`
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <a href="/files/taiLieu/` + material + `" target="_blank">` + material + `</a>
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
                $('#loading').hide(); // Ẩn trạng thái tải
                // Chuyển sang tab "Mô tả bài học" sau khi tải xong
                new bootstrap.Tab(document.querySelector('#description-tab')).show();
            }).fail(function(xhr, status, error) {
                console.error('API error:', status, error); // Debug
                $('#lessonVideo').attr('src', '');
                $('#videoContainer').hide();
                $('#lessonDescription').text('Không thể tải chi tiết bài học. Vui lòng thử lại sau.');
                $('#materialsList').html('<li class="list-group-item text-muted">Không thể tải tài liệu.</li>');
                $('#loading').hide(); // Ẩn trạng thái tải
            });
        }

        // Tải chi tiết bài học ban đầu nếu có lesson được truyền vào
        <c:if test="${lesson != null}">
        console.log('Initial lessonId:', ${lesson.lessonId}); // Debug
        loadLessonDetails(${lesson.lessonId});
        </c:if>

        // Logic để hiển thị/ẩn video container nếu không có videoSrc ban đầu
        if ($('#lessonVideo').attr('src') === '') {
            $('#videoContainer').hide();
        } else {
            $('#videoContainer').show();
        }

        // Logic cho việc xoay icon mũi tên khi mở/đóng chapter
        $('.toggle-chapter-btn').on('click', function() {
            $(this).find('.bi-chevron-down').toggleClass('rotate-180');
        });
    });
</script>

<header>
    <jsp:include page="../layout/header.jsp" />
</header>

<div class="content">
    <h1 class="mb-4">${lesson != null ? lesson.lessonName : subject != null ? subject.subjectName : 'Không tìm thấy môn học'}</h1>

    <div class="row">
        <div class="col-md-8">
            <div class="video-container ratio ratio-16x9" id="videoContainer">
                <iframe id="lessonVideo" src="${lesson != null ? lesson.videoSrc : ''}" title="${lesson != null ? lesson.lessonName : ''}"
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
                            <p id="lessonDescription">${lesson != null ? lesson.lessonDescription : 'Không có mô tả cho bài học này.'}</p>
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
                                                                </a>
                                                                <span class="video-time"><i class="bi bi-collection-play"></i> ${lessonItem.videoTime}</span>
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
            <div class="loading" id="loading">Đang tải...</div>
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
                                                    </a>
                                                    <span class="video-time"><i class="bi bi-collection-play"></i> ${lessonItem.videoTime}</span>
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

<footer>
    <jsp:include page="../layout/footer.jsp" />
</footer>

</body>
</html>