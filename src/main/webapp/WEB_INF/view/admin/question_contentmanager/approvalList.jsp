<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Phê duyệt câu hỏi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
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
            padding-bottom: 100px;
        }

        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
        }

        .table-fixed {
            table-layout: fixed;
            width: 100%;
        }

        .table-fixed th,
        .table-fixed td {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .col-id {
            width: 10%;
        }

        .col-content {
            width: 25%;
        }

        .col-grade {
            width: 10%;
        }

        .col-subject {
            width: 15%;
        }

        .col-chapter {
            width: 15%;
        }

        .col-lesson {
            width: 15%;
        }

        .col-level {
            width: 10%;
        }

        .col-status {
            width: 10%;
        }

        .col-action {
            width: 15%;
        }

        .pagination .page-item {
            margin: 0 2px;
        }

        .pagination .page-link {
            color: #212529;
            border: 1px solid #dee2e6;
            padding: 6px 12px;
            font-size: 0.875rem;
            border-radius: 0.25rem;
        }

        .pagination .page-link:hover {
            background-color: #e9ecef;
            color: #212529;
            border-color: #dee2e6;
        }

        .pagination .page-item.active .page-link {
            background-color: #6c757d;
            border-color: #6c757d;
            color: white;
        }

        .pagination .page-item.disabled .page-link {
            color: #6c757d;
            background-color: #fff;
            border-color: #dee2e6;
            cursor: not-allowed;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
    <script>
        $(document).ready(function () {
            $("#gradeId").change(function () {
                var gradeId = $(this).val();
                var subjectSelect = $("#subjectId");
                var chapterSelect = $("#chapterId");
                var lessonSelect = $("#lessonId");
                subjectSelect.empty().append('<option value="">-- Chọn --</option>');
                chapterSelect.empty().append('<option value="">-- Chọn --</option>');
                lessonSelect.empty().append('<option value="">-- Chọn --</option>');
                if (gradeId) {
                    $.get("/api/subjects-by-grade/" + gradeId)
                        .done(function (data) {
                            data.forEach(function (subject) {
                                subjectSelect.append('<option value="' + (subject ? subject.subjectId : '') + '">' + (subject ? subject.subjectName : '') + '</option>');
                            });
                        })
                        .fail(function () {
                            alert('Không thể tải danh sách môn học. Vui lòng thử lại.');
                        });
                }
            });

            $("#subjectId").change(function () {
                var subjectId = $(this).val();
                var chapterSelect = $("#chapterId");
                var lessonSelect = $("#lessonId");
                chapterSelect.empty().append('<option value="">-- Chọn --</option>');
                lessonSelect.empty().append('<option value="">-- Chọn --</option>');
                if (subjectId) {
                    $.get("/api/chapters-by-subject/" + subjectId)
                        .done(function (data) {
                            data.forEach(function (chapter) {
                                chapterSelect.append('<option value="' + chapter.chapterId + '">' + chapter.chapterName + '</option>');
                            });
                        })
                        .fail(function () {
                            alert('Không thể tải danh sách chương. Vui lòng thử lại.');
                        });
                }
            });

            $("#chapterId").change(function () {
                var chapterId = $(this).val();
                var lessonSelect = $("#lessonId");
                lessonSelect.empty().append('<option value="">-- Chọn --</option>');
                if (chapterId) {
                    $.get("/api/lessons-by-chapter/" + chapterId)
                        .done(function (data) {
                            data.forEach(function (lesson) {
                                lessonSelect.append('<option value="' + lesson.lessonId + '">' + lesson.lessonName + '</option>');
                            });
                        })
                        .fail(function () {
                            alert('Không thể tải danh sách bài học. Vui lòng thử lại.');
                        });
                }
            });

            MathJax.typeset();

            // Confirm approve/reject actions
            $('.approve-btn, .reject-btn').click(function (e) {
                var action = $(this).hasClass('approve-btn') ? 'phê duyệt' : 'từ chối';
                if (!confirm('Bạn có chắc muốn ' + action + ' câu hỏi này?')) {
                    e.preventDefault();
                }
            });
        });
    </script>
</head>
<body>
<!-- Header -->
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>

<!-- Main Container for Sidebar and Content -->
<div class="main-container">
    <!-- Sidebar -->
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../layout/sidebar.jsp"/>
    </div>

    <!-- Main Content Area -->
    <div class="content">
        <main>
            <div class="container-fluid">
                <div class="mt-4">
                    <h2>Phê duyệt câu hỏi</h2>
                    <div class="row col-12 mx-auto mt-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <!-- Filters -->
                            <form action="/admin/questions" method="get"
                                  class="d-flex align-items-center gap-2 flex-wrap">
                                <label for="gradeId" class="mb-0 fw-bold me-2">Khối:</label>
                                <select name="gradeId" id="gradeId" class="form-select form-select-sm w-auto">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="grade" items="${grades}">
                                        <option value="${grade.gradeId}" ${grade.gradeId == param.gradeId ? 'selected' : ''}>${grade.gradeName}</option>
                                    </c:forEach>
                                </select>

                                <label for="subjectId" class="mb-0 fw-bold me-2">Môn học:</label>
                                <select name="subjectId" id="subjectId" class="form-select form-select-sm w-auto">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="subject" items="${subjects}">
                                        <option value="${subject.subjectId}" ${subject.subjectId == param.subjectId ? 'selected' : ''}>${subject.subjectName}</option>
                                    </c:forEach>
                                </select>

                                <label for="chapterId" class="mb-0 fw-bold me-2">Chương:</label>
                                <select name="chapterId" id="chapterId" class="form-select form-select-sm w-auto">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="chapter" items="${chapters}">
                                        <option value="${chapter.chapterId}" ${chapter.chapterId == param.chapterId ? 'selected' : ''}>${chapter.chapterName}</option>
                                    </c:forEach>
                                </select>

                                <label for="lessonId" class="mb-0 fw-bold me-2">Bài học:</label>
                                <select name="lessonId" id="lessonId" class="form-select form-select-sm w-auto">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="lesson" items="${lessons}">
                                        <option value="${lesson.lessonId}" ${lesson.lessonId == param.lessonId ? 'selected' : ''}>${lesson.lessonName}</option>
                                    </c:forEach>
                                </select>

                                <label for="levelId" class="mb-0 fw-bold me-2">Mức độ:</label>
                                <select name="levelId" id="levelId" class="form-select form-select-sm w-auto">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="level" items="${levels}">
                                        <option value="${level.levelQuestionId}" ${level.levelQuestionId == param.levelId ? 'selected' : ''}>${level.levelQuestionName}</option>
                                    </c:forEach>
                                </select>

                                <label for="statusId" class="mb-0 fw-bold me-2">Trạng thái:</label>
                                <select name="statusId" id="statusId" class="form-select form-select-sm w-auto">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="status" items="${statuses}">
                                        <option value="${status.statusId}" ${status.statusId == param.statusId ? 'selected' : ''}>
                                            <c:choose>
                                                <c:when test="${status.statusName == 'Pending'}">Đang xử lý</c:when>
                                                <c:when test="${status.statusName == 'Accepted'}">Chấp nhận</c:when>
                                                <c:when test="${status.statusName == 'Rejected'}">Từ chối</c:when>
                                                <c:otherwise>${status.statusName}</c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>

                                <button type="submit" class="btn btn-outline-primary btn-sm">Lọc</button>
                            </form>
                        </div>

                        <hr/>
                        <table class="table table-bordered table-hover table-fixed">
                            <thead>
                            <tr>
                                <th scope="col" class="text-center col-id">ID</th>
                                <th scope="col" class="text-center col-content">Nội dung</th>
                                <th scope="col" class="text-center col-grade">Khối</th>
                                <th scope="col" class="text-center col-subject">Môn học</th>
                                <th scope="col" class="text-center col-chapter">Chương</th>
                                <th scope="col" class="text-center col-lesson">Bài học</th>
                                <th scope="col" class="text-center col-level">Mức độ</th>
                                <th scope="col" class="text-center col-status">Trạng thái</th>
                                <th scope="col" class="text-center col-action">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="question" items="${questions}">
                                <tr>
                                    <td class="text-center col-id">${question.questionId}</td>
                                    <td class="col-content"><c:out value="${question.content}" escapeXml="false"/></td>
                                    <td class="text-center col-grade">${question.grade.gradeName}</td>
                                    <td class="text-center col-subject">${question.subject.subjectName}</td>
                                    <td class="text-center col-chapter">${question.chapter.chapterName}</td>
                                    <td class="text-center col-lesson">${question.lesson.lessonName}</td>
                                    <td class="text-center col-level">${question.levelQuestion.levelQuestionName}</td>
                                    <td class="text-center col-status">
                                        <c:choose>
                                            <c:when test="${question.status.statusName == 'Pending'}">Đang xử lý</c:when>
                                            <c:when test="${question.status.statusName == 'Accepted'}">Chấp nhận</c:when>
                                            <c:when test="${question.status.statusName == 'Rejected'}">Từ chối</c:when>
                                            <c:otherwise>${question.status.statusName}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center col-action">
                                        <div class="d-flex gap-2 justify-content-center">
                                            <div><a href="/admin/questions/${question.questionId}"
                                                    class="btn btn-success btn-sm">Chi tiết</a><div>

                                            <c:if test="${question.status.statusName == 'Pending'}">
                                                <form action="/admin/questions/approve/${question.questionId}" method="post" style="display:block;margin-top: 5px">

                                                    <button type="submit" class="btn btn-primary btn-sm approve-btn">Phê duyệt</button>
                                                </form>
                                                <form action="/admin/questions/reject/${question.questionId}" method="post" style="display:block; margin-top: 5px">

                                                    <button type="submit" class="btn btn-danger btn-sm reject-btn">Từ chối</button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <div class="pagination-container">
                            <c:set var="queryString" value=""/>
                            <c:if test="${not empty param.gradeId}">
                                <c:set var="queryString" value="${queryString}&gradeId=${param.gradeId}"/>
                            </c:if>
                            <c:if test="${not empty param.subjectId}">
                                <c:set var="queryString" value="${queryString}&subjectId=${param.subjectId}"/>
                            </c:if>
                            <c:if test="${not empty param.chapterId}">
                                <c:set var="queryString" value="${queryString}&chapterId=${param.chapterId}"/>
                            </c:if>
                            <c:if test="${not empty param.lessonId}">
                                <c:set var="queryString" value="${queryString}&lessonId=${param.lessonId}"/>
                            </c:if>
                            <c:if test="${not empty param.levelId}">
                                <c:set var="queryString" value="${queryString}&levelId=${param.levelId}"/>
                            </c:if>
                            <c:if test="${not empty param.statusId}">
                                <c:set var="queryString" value="${queryString}&statusId=${param.statusId}"/>
                            </c:if>
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center mb-0">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="/admin/questions?page=1${queryString}" aria-label="First">
                                                <span aria-hidden="true">««</span>
                                            </a>
                                        </li>
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="/admin/questions?page=${currentPage - 1}${queryString}" aria-label="Previous">
                                                <span aria-hidden="true">«</span>
                                            </a>
                                        </li>
                                        <c:set var="startPage" value="${currentPage - 2}"/>
                                        <c:set var="endPage" value="${currentPage + 2}"/>
                                        <c:if test="${startPage < 1}">
                                            <c:set var="startPage" value="1"/>
                                            <c:set var="endPage" value="${startPage + 4}"/>
                                        </c:if>
                                        <c:if test="${endPage > totalPages}">
                                            <c:set var="endPage" value="${totalPages}"/>
                                            <c:set var="startPage" value="${endPage - 4 > 0 ? endPage - 4 : 1}"/>
                                        </c:if>
                                        <c:forEach begin="${startPage}" end="${endPage}" varStatus="loop">
                                            <li class="page-item ${loop.index == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="/admin/questions?page=${loop.index}${queryString}">${loop.index}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="/admin/questions?page=${currentPage + 1}${queryString}" aria-label="Next">
                                                <span aria-hidden="true">»</span>
                                            </a>
                                        </li>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="/admin/questions?page=${totalPages}${queryString}" aria-label="Last">
                                                <span aria-hidden="true">»»</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Footer -->
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>
</body>
</html>