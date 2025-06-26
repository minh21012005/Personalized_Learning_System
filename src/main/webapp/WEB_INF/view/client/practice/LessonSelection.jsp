<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Luyện tập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: Arial, sans-serif;
        }

        .main-container {
            display: flex;
            flex: 1;
        }

        .content {
            margin-top: 70px;
            flex: 1;
            padding: 20px;
            background-color: #f8f9fa;
            display: flex;
        }

        .sidebar {
            width: 300px;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-right: 20px;
            max-height: calc(100vh - 150px); /* Adjust based on header/footer height */
            overflow-y: auto; /* Add scrollbar */
        }

        .sidebar h4 {
            color: #212529;
            margin-bottom: 15px;
        }

        .select-all {
            margin-bottom: 15px;
        }

        .chapter-item {
            margin-bottom: 10px;
        }

        .chapter-item .chapter-header {
            display: flex;
            align-items: center;
            padding: 10px;
            background: #f1f1f1;
            border-radius: 5px;
            cursor: pointer;
        }

        .chapter-item .chapter-header input[type="checkbox"] {
            margin-right: 10px;
        }

        .chapter-item .chapter-header span {
            flex-grow: 1;
        }

        .chapter-item.completed .chapter-header {
            background: #d4edda;
        }

        .lesson-list {
            margin-left: 20px;
            margin-top: 5px;
            display: none; /* Hidden by default */
        }

        .lesson-list.active {
            display: block; /* Show when active */
        }

        .lesson-list input[type="checkbox"] {
            margin-right: 10px;
        }

        .lesson-list label {
            display: block;
            padding: 5px 10px;
            background: #fff;
            border-radius: 3px;
        }

        .lesson-list label.completed {
            background: #d4edda;
        }

        .main-content {
            flex: 1;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .main-content h1 {
            color: #212529;
            margin-bottom: 20px;
        }

        .main-content h3 {
            color: #212529;
            margin-bottom: 10px;
        }

        .main-content p {
            color: #6c757d;
            margin-bottom: 20px;
        }

        .main-content img {
            width: 100%;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .settings-form {
            display: none; /* Hidden by default */
            margin-bottom: 20px;
        }

        .settings-form label {
            margin-right: 10px;
        }

        .btn-start {
            background-color: #007bff;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn-start:hover {
            background-color: #0056b3;
        }

        .option-buttons {
            display: none; /* Hidden by default */
            margin-top: 10px;
        }

        .option-buttons button {
            background-color: #007bff;
            color: #fff;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            margin-right: 10px;
        }

        .option-buttons button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>
<div class="main-container">
    <div class="content">
        <div class="sidebar">
            <h4>Nội Dung Khóa Học</h4>
            <div class="select-all">
                <input type="checkbox" id="selectAll" onchange="selectAllChapters()">
                <label for="selectAll">Chọn tất cả</label>
            </div>
            <c:forEach var="chapter" items="${chapters}" varStatus="chapterLoop">
                <div class="chapter-item">
                    <div class="chapter-header" onclick="toggleLessonList('lessonIds_${chapter.chapterId}')">
                        <input type="checkbox" name="chapterIds" value="${chapter.chapterId}"
                               onchange="toggleChapter(this, 'lessonIds_${chapter.chapterId}')">
                        <span>${chapter.chapterName}</span>
                    </div>
                    <div class="lesson-list" id="lessonIds_${chapter.chapterId}">
                        <c:forEach var="lesson" items="${chapter.listLesson}" varStatus="lessonLoop">
                            <label class="">
                                <input type="checkbox" name="lessonIds" value="${lesson.lessonId}">
                                    ${lesson.lessonName}
                            </label>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="main-content">
            <h1>Luyện tập</h1>
            <div class="row">
                <div class="col-md-8">
                    <h3>${subject.subjectName}</h3>
                    <p>${subject.subjectDescription}</p>
                    <button type="button" class="btn-start">Bắt đầu luyện tập</button>
                    <form action="/practices/start-practice" method="post" id="practiceForm" style="display: none;">
                        <input type="hidden" name="allLessonIds" id="hiddenAllLessonIds">
                    </form>
                </div>
                <div class="col-md-4">
                    <img src="/img/subjectImg/${subject.subjectImage != null ? subject.subjectImage : '/img/default-subject.jpg'}"
                         alt="Lesson Image" class="w-full h-full object-cover">
                </div>
            </div>
        </div>
    </div>
</div>
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
        crossorigin="anonymous"></script>
<script>
    function toggleLessonList(lessonGroupId) {
        var lessonList = document.getElementById(lessonGroupId);
        lessonList.classList.toggle('active');
    }

    function toggleChapter(checkbox, lessonGroupId) {
        var lessons = document.querySelectorAll('#' + lessonGroupId + ' input[type="checkbox"]');
        lessons.forEach(function (lesson) {
            lesson.checked = checkbox.checked;
        });
    }

    function selectAllChapters() {
        var selectAllCheckbox = document.getElementById('selectAll');
        var chapterCheckboxes = document.querySelectorAll('input[name="chapterIds"]');
        chapterCheckboxes.forEach(function (checkbox) {
            checkbox.checked = selectAllCheckbox.checked;
            var lessonGroupId = 'lessonIds_' + checkbox.value;
            toggleChapter(checkbox, lessonGroupId);
        });
    }

    $(document).ready(function () {
        $('.btn-start').on('click', function (e) {
            var checkedLessons = $('input[name="lessonIds"]:checked');
            if (checkedLessons.length === 0) {
                e.preventDefault();
                alert('Vui lòng chọn ít nhất một bài học.');
            } else {
                var form = $('#practiceForm');
                var allLessonIds = [];

                // Thu thập tất cả lessonIds từ các lesson được chọn
                checkedLessons.each(function () {
                    allLessonIds.push($(this).val());
                });

                $('#hiddenAllLessonIds').val(allLessonIds.join(','));
                form.attr('action', '/practices/start-practice');
                form.submit();
            }
        });
    });
</script>
</body>
</html>