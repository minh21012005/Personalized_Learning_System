<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Quản Lý Bài Kiểm Tra</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
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
            padding-bottom: 100px;
        }

        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .table-container {
            overflow-x: auto;
        }

        .table-fixed {
            table-layout: auto;
            width: 100%;
            min-width: 1200px;
        }

        .table-fixed th,
        .table-fixed td {
            padding: 12px;
            vertical-align: middle;
            word-wrap: break-word;
            white-space: normal;
        }

        .col-id {
            width: 8%;
        }

        .col-test-name {
            width: 15%;
        }

        .col-subject {
            width: 12%;
        }

        .col-chapter {
            width: 12%;
        }

        .col-duration {
            width: 10%;
        }

        .col-start-time {
            width: 15%;
        }

        .col-end-time {
            width: 15%;
        }

        .col-status {
            width: 10%;
        }

        .col-category {
            width: 10%;
        }

        .col-is-open {
            width: 10%;
        }

        .col-action {
            width: 15%;
        }

        .pagination {
            justify-content: center;
            margin-top: 20px;
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

        .form-select-sm, .form-control-sm {
            padding: 6px 12px;
            font-size: 0.875rem;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 0.875rem;
        }

        .btn-action {
            margin-right: 5px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
    <script>
        $(document).ready(function () {
            $("#filterSubject").change(function () {
                var subjectId = $(this).val();
                var chapterSelect = $("#filterChapter");
                chapterSelect.empty().append('<option value="">-- Chọn --</option>');
                if (subjectId) {
                    $.get("/admin/tests/chapters?subjectId=" + subjectId)
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

            $('.delete-btn').click(function (e) {
                if (!confirm('Bạn có chắc muốn xóa bài kiểm tra này?')) {
                    e.preventDefault();
                }
            });

            $('.approve-btn').click(function (e) {
                if (!confirm('Bạn có chắc muốn phê duyệt bài kiểm tra này?')) {
                    e.preventDefault();
                }
            });

            $('.reject-btn').click(function (e) {
                if (!confirm('Bạn có chắc muốn từ chối bài kiểm tra này?')) {
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

                    <h2>Phê Duyệt Bài Kiểm Tra</h2>
                    <div class="row col-12 mx-auto mt-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <!-- Filters -->
                            <form action="/admin/tests" method="get" class="d-flex align-items-center gap-2 flex-wrap">
                                <label for="filterSubject" class="mb-0 fw-bold me-2">Môn học:</label>
                                <select name="subjectId" id="filterSubject" class="form-select form-select-sm w-auto">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="subject" items="${subjects}">
                                        <option value="${subject.subjectId}" ${subject.subjectId == param.subjectId ? 'selected' : ''}>${fn:escapeXml(subject.subjectName)}</option>
                                    </c:forEach>
                                </select>
                                <label for="filterChapter" class="mb-0 fw-bold me-2">Chương:</label>
                                <select name="chapterId" id="filterChapter" class="form-select form-select-sm w-auto">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="chapter" items="${chapters}">
                                        <option value="${chapter.chapterId}" ${chapter.chapterId == param.chapterId ? 'selected' : ''}>${fn:escapeXml(chapter.chapterName)}</option>
                                    </c:forEach>
                                </select>
                                <label for="testStatusId" class="mb-0 fw-bold me-2">Trạng Thái:</label>
                                <select name="testStatusId" id="filterChapter" class="form-select form-select-sm w-auto">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="status" items="${statuses}">
                                        <option value="${status.testStatusId}" ${status.testStatusId == param.testStatusId ? 'selected' : ''}>${fn:escapeXml(status.testStatusName)}</option>
                                    </c:forEach>
                                </select>
                                <label for="filterStartAt" class="mb-0 fw-bold me-2">Thời gian bắt đầu:</label>
                                <input type="datetime-local" name="startAt" id="filterStartAt"
                                       class="form-control form-control-sm w-auto" value="${param.startAt}">
                                <label for="filterEndAt" class="mb-0 fw-bold me-2">Thời gian kết thúc:</label>
                                <input type="datetime-local" name="endAt" id="filterEndAt"
                                       class="form-control form-control-sm w-auto" value="${param.endAt}">
                                <button type="submit" class="btn btn-outline-primary btn-sm">Lọc</button>
                            </form>
                        </div>
                        <hr/>
                        <div class="table-container">
                            <table class="table table-bordered table-hover table-fixed">
                                <thead>
                                <tr>
                                    <th scope="col" class="text-center col-id">ID</th>
                                    <th scope="col" class="text-center col-test-name">Tên bài kiểm tra</th>
                                    <th scope="col" class="text-center col-subject">Môn học</th>
                                    <th scope="col" class="text-center col-chapter">Chương</th>
                                    <th scope="col" class="text-center col-duration">Thời gian (phút)</th>
                                    <th scope="col" class="text-center col-duration">số lần làm tối đa</th>
                                    <th scope="col" class="text-center col-start-time">Thời gian bắt đầu</th>
                                    <th scope="col" class="text-center col-end-time">Thời gian kết thúc</th>
                                    <th scope="col" class="text-center col-status">Trạng thái</th>
                                    <th scope="col" class="text-center col-is-open">Mở/Đóng</th>
                                    <th scope="col" class="text-center col-category">Danh mục</th>
                                    <th scope="col" class="text-center col-reason">Lý do</th>
                                    <th scope="col" class="text-center col-action">Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${empty tests}">
                                        <tr>
                                            <td colspan="11" class="text-center">Không có bài kiểm tra nào.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="test" items="${tests}">
                                            <tr>
                                                <td class="text-center col-id">${test.testId}</td>
                                                <td class="col-test-name">${fn:escapeXml(test.testName)}</td>
                                                <td class="text-center col-subject">${fn:escapeXml(test.subjectName != null ? test.subjectName : 'Chưa xác định')}</td>
                                                <td class="text-center col-chapter">${fn:escapeXml(test.chapterName != null ? test.chapterName : 'Chưa xác định')}</td>
                                                <td class="text-center col-duration">${test.durationTime}</td>
                                                <td class="text-center col-duration">${test.maxAttempts}</td>
                                                <td class="text-center col-start-time">${fn:escapeXml(test.startAt)}</td>
                                                <td class="text-center col-end-time">${fn:escapeXml(test.endAt)}</td>
                                                <td class="text-center col-status">${fn:escapeXml(test.statusName)}</td>
                                                <td class="text-center col-is-open">${test.isOpen ? "Mở":"Đóng"}</td>
                                                <td class="text-center col-category">${fn:escapeXml(test.categoryName)}</td>
                                                <td class="text-center col-reason">${fn:escapeXml(test.reason != null ? test.reason : 'Chưa có')}</td>
                                                <td class="text-center col-action">
                                                    <div class="d-flex gap-2 justify-content-center">
                                                        <a href="/admin/tests/details/${test.testId}"
                                                           class="btn btn-success btn-sm btn-action">Chi tiết</a>

                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <div class="pagination-container">
                            <c:set var="queryString" value=""/>
                            <c:if test="${not empty param.subjectId}">
                                <c:set var="queryString" value="${queryString}&subjectId=${param.subjectId}"/>
                            </c:if>
                            <c:if test="${not empty param.chapterId}">
                                <c:set var="queryString" value="${queryString}&chapterId=${param.chapterId}"/>
                            </c:if>
                            <c:if test="${not empty param.startAt}">
                                <c:set var="queryString" value="${queryString}&startAt=${param.startAt}"/>
                            </c:if>
                            <c:if test="${not empty param.endAt}">
                                <c:set var="queryString" value="${queryString}&endAt=${param.endAt}"/>
                            </c:if>
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Test pagination">
                                    <ul class="pagination justify-content-center mb-0">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="/admin/tests?page=1${queryString}"
                                               aria-label="First">
                                                <span aria-hidden="true">««</span>
                                            </a>
                                        </li>
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="/admin/tests?page=${currentPage - 1}${queryString}"
                                               aria-label="Previous">
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
                                                <a class="page-link"
                                                   href="/admin/tests?page=${loop.index}${queryString}">${loop.index}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="/admin/tests?page=${currentPage + 1}${queryString}"
                                               aria-label="Next">
                                                <span aria-hidden="true">»</span>
                                            </a>
                                        </li>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="/admin/tests?page=${totalPages}${queryString}"
                                               aria-label="Last">
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