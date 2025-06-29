<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - ${subject.subjectName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"
          integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: 'Inter', system-ui, sans-serif;
            background-color: #f8f9fa;
        }

        .main-container {
            flex: 1;
            width: 96%;
            margin: 0 auto;
            padding: 1.5rem;
        }

        .content {
            margin-top: 5rem;
        }

        /* Left Column (9 col): Description and Content */
        .left-column {
            background: #ffffff;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
        }

        .left-column h2 {
            font-size: 1.8rem;
            font-weight: 600;
            color: #212529;
            margin-bottom: 1.5rem;
        }

        .chapter-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 0.5rem;
        }

        .chapter-row {
            background: #f8f9fa;
            border-radius: 0.5rem;
            transition: all 0.3s ease;
        }

        .chapter-row:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }

        .chapter-header {
            padding: 1rem 1.5rem;
            cursor: pointer;
            font-weight: 500;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
        }

        .chapter-header i {
            margin-left: auto;
            color: #0d6efd;
            transition: transform 0.3s ease;
        }

        .chapter-header i.active {
            transform: rotate(180deg);
        }

        .lesson-list {
            display: none;
            background: #fff;
            border-radius: 0 0 0.5rem 0.5rem;
        }

        .lesson-list.active {
            display: table-row;
        }

        .lesson-list td {
            padding: 1rem 3rem;
        }

        .lesson-item {
            padding: 0.75rem 0;
            font-size: 1rem;
            color: #495057;
            border-bottom: 1px solid #e9ecef;
        }

        .lesson-item:last-child {
            border-bottom: none;
        }

        /* Right Column (3 col): Image, Name, Button */
        .right-column {
            background: #ffffff;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        .subject-image img {
            width: 100%;
            height: auto;
            border-radius: 0.75rem;
            object-fit: cover;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            margin-bottom: 1.5rem;
        }

        .right-column h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #212529;
            margin-bottom: 1.5rem;
        }

        .btn-start {
            display: inline-block;
            background: #0d6efd;
            color: #fff;
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 500;
            text-decoration: none;
            transition: background 0.3s ease;
            width: 100%;
        }

        .btn-start:hover {
            background: #0056b3;
            color: #fff;
        }

        @media (max-width: 992px) {
            .right-column {
                margin-top: 1.5rem;
            }

            .right-column h1 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>
<div class="main-container">
    <div class="content">
        <div class="row">
            <!-- Left Column: Description and Content (9 col) -->
            <div class="col-lg-9 mb-3">
                <div class="left-column">
                    <h2>Mô tả khóa học</h2>
                    <p class="mb-4">${subject.subjectDescription}</p>

                    <h2>Nội dung khóa học</h2>
                    <table class="chapter-table">
                        <tbody>
                        <c:forEach var="chapter" items="${chapters}">
                            <tr class="chapter-row">
                                <td class="chapter-header" onclick="toggleLessonList('lessonIds_${chapter.chapterId}')">
                                    <span>${chapter.chapterName}</span>
                                    <i class="fas fa-chevron-down"></i>
                                </td>
                            </tr>
                            <tr class="lesson-list" id="lessonIds_${chapter.chapterId}">
                                <td>
                                    <c:forEach var="lesson" items="${chapter.listLesson}">
                                        <div class="lesson-item">${lesson.lessonName}</div>
                                    </c:forEach>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Right Column: Image, Name, Button (3 col) -->
            <div class="col-lg-3 mb-3">
                <div class="right-column">
                    <div class="subject-image">
                        <img src="/img/subjectImg/${subject.subjectImage != null ? subject.subjectImage : 'default-subject.jpg'}"
                             alt="${subject.subjectName}">
                    </div>
                    <h1>${subject.subjectName}</h1>
                    <a href="/packages/detail/subject/learn?subjectId=${subject.subjectId}" class="btn-start">Học ngay</a>
                </div>
            </div>
        </div>
    </div>
</div>
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
        crossorigin="anonymous"></script>
<script>
    function toggleLessonList(lessonGroupId) {
        const lessonList = document.getElementById(lessonGroupId);
        const icon = lessonList.previousElementSibling.querySelector('i');
        lessonList.classList.toggle('active');
        icon.classList.toggle('active');
        icon.classList.toggle('fa-chevron-down');
        icon.classList.toggle('fa-chevron-up');
    }
</script>
</body>
</html>