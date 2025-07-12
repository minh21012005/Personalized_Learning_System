<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Bài Kiểm Tra</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .main-container {
            margin-top: 70px;
            padding: 20px;
            flex: 1;
        }
        .table-container {
            overflow-x: auto;
        }
        .table-fixed {
            table-layout: auto;
            width: 100%;
            min-width: 800px;
        }
        .table-fixed th,
        .table-fixed td {
            padding: 12px;
            vertical-align: middle;
            word-wrap: break-word;
            white-space: normal;
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
        .form-control-sm {
            padding: 6px 12px;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>
<div class="main-container">
    <h1>Lịch Sử Bài Kiểm Tra</h1>
    <div class="row col-12 mx-auto mt-4">
        <form action="/tests/history" method="get" class="d-flex align-items-center gap-2 flex-wrap mb-3">
            <label for="startDate" class="mb-0 fw-bold me-2">Từ ngày:</label>
            <input type="date" name="startDate" id="startDate" class="form-control form-control-sm w-auto" value="${startDate}">
            <label for="endDate" class="mb-0 fw-bold me-2">Đến ngày:</label>
            <input type="date" name="endDate" id="endDate" class="form-control form-control-sm w-auto" value="${endDate}">
            <button type="submit" class="btn btn-outline-primary btn-sm">Lọc</button>
        </form>
        <hr/>
        <div class="table-container">
            <table class="table table-bordered table-hover table-fixed">
                <thead>
                <tr>
                    <th class="text-center">ID</th>
                    <th class="text-center">Tên bài kiểm tra</th>
                    <th class="text-center">Số câu đúng</th>
                    <th class="text-center">Tổng số câu</th>
                    <th class="text-center">Thời gian bắt đầu</th>
                    <th class="text-center">Thời gian kết thúc</th>
                    <th class="text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty testHistoryPage.content}">
                        <tr>
                            <td colspan="7" class="text-center">Không có bài kiểm tra nào.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="history" items="${testHistoryPage.content}">
                            <tr>
                                <td class="text-center">${history.testId}</td>
                                <td>${fn:escapeXml(history.testName)}</td>
                                <td class="text-center">${history.correctAnswers}</td>
                                <td class="text-center">${history.totalQuestions}</td>
                                <td class="text-center">${fn:escapeXml(history.startTime)}</td>
                                <td class="text-center">${fn:escapeXml(history.endTime)}</td>
                                <td class="text-center">
                                    <a href="/tests/history/${history.testId}" class="btn btn-success btn-sm">Chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
        <c:if test="${testHistoryPage.totalPages > 1}">
            <nav aria-label="Test history pagination">
                <ul class="pagination justify-content-center mb-0">
                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                        <a class="page-link" href="/tests/history?page=0&size=${pageSize}${not empty startDate ? '&startDate=' + startDate : ''}${not empty endDate ? '&endDate=' + endDate : ''}" aria-label="First">
                            <span aria-hidden="true">««</span>
                        </a>
                    </li>
                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                        <a class="page-link" href="/tests/history?page=${currentPage - 1}&size=${pageSize}${not empty startDate ? '&startDate=' + startDate : ''}${not empty endDate ? '&endDate=' + endDate : ''}" aria-label="Previous">
                            <span aria-hidden="true">«</span>
                        </a>
                    </li>
                    <c:set var="startPage" value="${currentPage - 2}"/>
                    <c:set var="endPage" value="${currentPage + 2}"/>
                    <c:if test="${startPage < 0}">
                        <c:set var="startPage" value="0"/>
                        <c:set var="endPage" value="${startPage + 4}"/>
                    </c:if>
                    <c:if test="${endPage >= testHistoryPage.totalPages}">
                        <c:set var="endPage" value="${testHistoryPage.totalPages - 1}"/>
                        <c:set var="startPage" value="${endPage - 4 >= 0 ? endPage - 4 : 0}"/>
                    </c:if>
                    <c:forEach begin="${startPage}" end="${endPage}" varStatus="loop">
                        <li class="page-item ${loop.index == currentPage ? 'active' : ''}">
                            <a class="page-link" href="/tests/history?page=${loop.index}&size=${pageSize}${not empty startDate ? '&startDate=' + startDate : ''}${not empty endDate ? '&endDate=' + endDate : ''}">${loop.index + 1}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == testHistoryPage.totalPages - 1 ? 'disabled' : ''}">
                        <a class="page-link" href="/tests/history?page=${currentPage + 1}&size=${pageSize}${not empty startDate ? '&startDate=' + startDate : ''}${not empty endDate ? '&endDate=' + endDate : ''}" aria-label="Next">
                            <span aria-hidden="true">»</span>
                        </a>
                    </li>
                    <li class="page-item ${currentPage == testHistoryPage.totalPages - 1 ? 'disabled' : ''}">
                        <a class="page-link" href="/tests/history?page=${testHistoryPage.totalPages - 1}&size=${pageSize}${not empty startDate ? '&startDate=' + startDate : ''}${not empty endDate ? '&endDate=' + endDate : ''}" aria-label="Last">
                            <span aria-hidden="true">»»</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</div>
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>