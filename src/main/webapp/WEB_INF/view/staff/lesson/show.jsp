<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Danh sách bài học</title>
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
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
        }
        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
        }
        .table-header-sort-link {
            color: inherit;
            text-decoration: none;
        }
        .table-header-sort-link:hover {
            text-decoration: underline;
        }
        .pagination .page-link {
            color: black;
            border: 1px solid #dee2e6;
        }
        .pagination .page-link:hover {
            background-color: #e9ecef;
            color: black;
        }
        .pagination .page-item.active .page-link {
            background-color: #d3d3d3;
            border-color: #d3d3d3;
            color: black;
        }
        .pagination .page-item.disabled .page-link {
            color: #6c757d;
            pointer-events: none;
            background-color: #fff;
            border-color: #dee2e6;
        }
        @media (max-width: 767.98px) {
            .sidebar {
                width: 200px;
                position: fixed;
                top: 0;
                left: 0;
                height: 100%;
                transform: translateX(-100%);
                z-index: 1000;
            }
            .sidebar.active {
                transform: translateX(0);
            }
            .content {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout_staff/header.jsp"/>
</header>

<div class="main-container">
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../layout_staff/sidebar.jsp"/>
    </div>
    <div class="content">
        <main>
            <div class="container px-4">
                <div class="card mt-4">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Danh sách bài học trong Môn học ID: <c:out value="${subjectId}"/> - Chương: <c:out value="${lessons[0].chapterName != null ? lessons[0].chapterName : ''}"/></h5>
                            <a href="<c:url value='/staff/subject/${subjectId}/chapters'/>" class="btn btn-secondary btn-sm">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <form action="<c:url value='/staff/subject/${subjectId}/chapters/${chapterId}/lessons'/>" method="get"
                              class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-3">
                            <div class="d-flex flex-column flex-md-row align-items-md-center mb-2 mb-md-0">
                                <label for="lessonName" class="mb-0 fw-bold me-md-2">Tên bài học:</label>
                                <div class="d-flex gap-2 me-md-2">
                                    <input type="text" id="lessonName" name="lessonName"
                                           class="form-control form-control-sm"
                                           value="<c:out value='${lessonName != null ? lessonName : ""}'/>"
                                           placeholder="Nhập tên bài học...">
                                </div>
                                <label for="status" class="mb-0 fw-bold me-md-2">Trạng thái:</label>
                                <div class="d-flex gap-2 me-md-2">
                                    <select id="status" name="status" class="form-select form-select-sm">
                                        <option value="" ${param.status == null ? 'selected' : ''}>Tất cả trạng thái</option>
                                        <option value="true" ${param.status == 'true' ? 'selected' : ''}>Có</option>
                                        <option value="false" ${param.status == 'false' ? 'selected' : ''}>Không</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-outline-primary btn-sm">Lọc</button>
                                <a href="<c:url value='/staff/subject/${subjectId}/chapters/${chapterId}/lessons'/>" class="btn btn-outline-secondary btn-sm ms-2">Xóa bộ lọc</a>
                            </div>
                            <a href="<c:url value='/staff/subject/${subjectId}/chapters/${chapterId}/lessons/new'/>" class="btn btn-primary btn-sm">Thêm mới</a>
                        </form>

                        <c:if test="${not empty message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    ${message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <div class="table-responsive">
                            <table class="table table-bordered table-hover table-striped">
                                <thead>
                                <tr>
                                    <th scope="col" class="text-center col-1">ID</th>
                                    <th scope="col" class="text-center col-2">
                                        <c:url value="/staff/subject/${subjectId}/chapters/${chapterId}/lessons" var="sortByNameUrl">
                                            <c:param name="lessonName" value="${lessonName != null ? lessonName : ''}"/>
                                            <c:param name="status" value="${status != null ? status : ''}"/>
                                            <c:param name="page" value="${currentPage != null ? currentPage : '0'}"/>
                                            <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                            <c:param name="sortField" value="lessonName"/>
                                            <c:param name="sortDir" value="${sortField eq 'lessonName' ? reverseSortDir : 'asc'}"/>
                                        </c:url>
                                        <a href="${sortByNameUrl}" class="table-header-sort-link">
                                            Tên bài học
                                            <c:if test="${sortField eq 'lessonName'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                                        </a>
                                    </th>
                                    <th scope="col" class="text-center col-2">Link video</th>
                                    <th scope="col" class="text-center col-2">Thời lượng video</th>
                                    <th scope="col" class="text-center col-1">Trạng thái</th>
                                    <th scope="col" class="text-center col-2">
                                        <c:url value="/staff/subject/${subjectId}/chapters/${chapterId}/lessons" var="sortByCreatedByUrl">
                                            <c:param name="lessonName" value="${lessonName != null ? lessonName : ''}"/>
                                            <c:param name="status" value="${status != null ? status : ''}"/>
                                            <c:param name="page" value="${currentPage != null ? currentPage : '0'}"/>
                                            <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                            <c:param name="sortField" value="userFullName"/>
                                            <c:param name="sortDir" value="${sortField eq 'userFullName' ? reverseSortDir : 'asc'}"/>
                                        </c:url>
                                        <a href="${sortByCreatedByUrl}" class="table-header-sort-link">
                                            Người tạo
                                            <c:if test="${sortField eq 'userFullName'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                                        </a>
                                    </th>
                                    <th scope="col" class="text-center col-2">
                                        <c:url value="/staff/subject/${subjectId}/chapters/${chapterId}/lessons" var="sortByCreatedAtUrl">
                                            <c:param name="lessonName" value="${lessonName != null ? lessonName : ''}"/>
                                            <c:param name="status" value="${status != null ? status : ''}"/>
                                            <c:param name="page" value="${currentPage != null ? currentPage : '0'}"/>
                                            <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                            <c:param name="sortField" value="createdAt"/>
                                            <c:param name="sortDir" value="${sortField eq 'createdAt' ? reverseSortDir : 'desc'}"/>
                                        </c:url>
                                        <a href="${sortByCreatedAtUrl}" class="table-header-sort-link">
                                            Ngày tạo
                                            <c:if test="${sortField eq 'createdAt'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                                        </a>
                                    </th>
                                    <th scope="col" class="text-center">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="lesson" items="${lessons}">
                                    <tr>
                                        <td class="text-center"><c:out value="${lesson.lessonId != null ? lesson.lessonId : ''}"/></td>
                                        <td><c:out value="${lesson.lessonName != null ? lesson.lessonName : ''}"/></td>
                                        <td class="text-center">
                                            <a href="<c:out value="${lesson.videoSrc}" escapeXml="true"/>" target="_blank" class="btn btn-link" title="Xem video">
                                                Xem video
                                            </a>
                                        </td>
                                        <td class="text-center"><c:out value="${lesson.videoTime != null ? lesson.videoTime : ''}"/></td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${lesson.status != null && lesson.status}">
                                                    <span class="badge bg-success">Có</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Không</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><c:out value="${lesson.userFullName != null ? lesson.userFullName : 'Không có thông tin'}"/></td>
                                        <td><c:out value="${lesson.createdAt != null ? lesson.createdAt : ''}"/></td>
                                        <td class="text-center">
                                            <a href="<c:url value='/staff/subject/${subjectId}/chapters/${chapterId}/lessons/${lesson.lessonId}'/>"
                                               class="btn btn-sm btn-primary me-1" title="Xem">
                                                <i class="fas fa-eye"></i> Xem
                                            </a>
                                            <a href="<c:url value='/staff/subject/${subjectId}/chapters/${chapterId}/lessons/${lesson.lessonId}/edit'/>"
                                               class="btn btn-sm btn-warning me-1" title="Sửa">
                                                <i class="fas fa-edit"></i> Sửa
                                            </a>
                                            <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#deleteLessonModal<c:out value="${lesson.lessonId}"/>"
                                                    title="Xóa">
                                                <i class="fas fa-trash"></i> Xóa
                                            </button>
                                            <!-- Delete Confirmation Modal -->
                                            <div class="modal fade" id="deleteLessonModal<c:out value="${lesson.lessonId}"/>"
                                                 tabindex="-1" aria-labelledby="deleteLessonModalLabel<c:out value="${lesson.lessonId}"/>"
                                                 aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="deleteLessonModalLabel<c:out value="${lesson.lessonId}"/>">
                                                                Xác nhận xóa
                                                            </h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            Bạn có chắc chắn muốn xóa bài học "<c:out value="${lesson.lessonName != null ? lesson.lessonName : 'Không xác định'}"/>?
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                            <form action="<c:url value='/staff/subject/${subjectId}/chapters/${chapterId}/lessons/${lesson.lessonId}/delete'/>" method="post">
                                                                <button type="submit" class="btn btn-danger">Xóa</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty lessons}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted">Không tìm thấy bài học nào.</td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>

                        <c:if test="${lessonPage != null && lessonPage.totalPages > 0}">
                            <div class="pagination-wrapper text-center">
                                <div class="mb-2">
                                    <small>Hiển thị <c:out value="${lessonPage.numberOfElements != null ? lessonPage.numberOfElements : '0'}"/> trong tổng số <c:out value="${lessonPage.totalElements != null ? lessonPage.totalElements : '0'}"/> mục. Trang <c:out value="${lessonPage.number != null ? lessonPage.number + 1 : '1'}"/> / <c:out value="${lessonPage.totalPages != null ? lessonPage.totalPages : '1'}"/></small>
                                </div>
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${lessonPage.first ? 'disabled' : ''}">
                                            <c:url value="/staff/subject/${subjectId}/chapters/${chapterId}/lessons" var="firstPageLink">
                                                <c:param name="lessonName" value="${lessonName != null ? lessonName : ''}"/>
                                                <c:param name="status" value="${status != null ? status : ''}"/>
                                                <c:param name="page" value="0"/>
                                                <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                            </c:url>
                                            <a class="page-link" href="${firstPageLink}">««</a>
                                        </li>
                                        <li class="page-item ${lessonPage.first ? 'disabled' : ''}">
                                            <c:url value="/staff/subject/${subjectId}/chapters/${chapterId}/lessons" var="prevPageLink">
                                                <c:param name="lessonName" value="${lessonName != null ? lessonName : ''}"/>
                                                <c:param name="status" value="${status != null ? status : ''}"/>
                                                <c:param name="page" value="${lessonPage.number != null ? lessonPage.number - 1 : '0'}"/>
                                                <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                            </c:url>
                                            <a class="page-link" href="${prevPageLink}">«</a>
                                        </li>
                                        <c:set var="windowSize" value="2"/>
                                        <c:set var="startPageLoop" value="${lessonPage.number != null && lessonPage.number - windowSize > 0 ? lessonPage.number - windowSize : 0}"/>
                                        <c:set var="endPageLoop" value="${lessonPage.number != null && lessonPage.number + windowSize < lessonPage.totalPages - 1 ? lessonPage.number + windowSize : lessonPage.totalPages != null ? lessonPage.totalPages - 1 : 0}"/>
                                        <c:if test="${startPageLoop > 0}">
                                            <c:url value="/staff/subject/${subjectId}/chapters/${chapterId}/lessons" var="pageLinkFirstDots">
                                                <c:param name="lessonName" value="${lessonName != null ? lessonName : ''}"/>
                                                <c:param name="status" value="${status != null ? status : ''}"/>
                                                <c:param name="page" value="0"/>
                                                <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                            </c:url>
                                            <li class="page-item"><a class="page-link" href="${pageLinkFirstDots}">1</a></li>
                                            <c:if test="${startPageLoop > 1}">
                                                <li class="page-item disabled"><span class="page-link">...</span></li>
                                            </c:if>
                                        </c:if>
                                        <c:forEach begin="${startPageLoop}" end="${endPageLoop}" var="i">
                                            <li class="page-item ${i == lessonPage.number ? 'active' : ''}">
                                                <c:url value="/staff/subject/${subjectId}/chapters/${chapterId}/lessons" var="pageLink">
                                                    <c:param name="lessonName" value="${lessonName != null ? lessonName : ''}"/>
                                                    <c:param name="status" value="${status != null ? status : ''}"/>
                                                    <c:param name="page" value="${i}"/>
                                                    <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                    <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                    <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                                </c:url>
                                                <a class="page-link" href="${pageLink}">${i + 1}</a>
                                            </li>
                                        </c:forEach>
                                        <c:if test="${lessonPage.totalPages != null && endPageLoop < lessonPage.totalPages - 1}">
                                            <c:if test="${endPageLoop < lessonPage.totalPages - 2}">
                                                <li class="page-item disabled"><span class="page-link">...</span></li>
                                            </c:if>
                                            <c:url value="/staff/subject/${subjectId}/chapters/${chapterId}/lessons" var="pageLinkLastDots">
                                                <c:param name="lessonName" value="${lessonName != null ? lessonName : ''}"/>
                                                <c:param name="status" value="${status != null ? status : ''}"/>
                                                <c:param name="page" value="${lessonPage.totalPages != null ? lessonPage.totalPages - 1 : '0'}"/>
                                                <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                            </c:url>
                                            <li class="page-item"><a class="page-link" href="${pageLinkLastDots}">${lessonPage.totalPages != null ? lessonPage.totalPages : '1'}</a></li>
                                        </c:if>
                                        <li class="page-item ${lessonPage.last ? 'disabled' : ''}">
                                            <c:url value="/staff/subject/${subjectId}/chapters/${chapterId}/lessons" var="nextPageLink">
                                                <c:param name="lessonName" value="${lessonName != null ? lessonName : ''}"/>
                                                <c:param name="status" value="${status != null ? status : ''}"/>
                                                <c:param name="page" value="${lessonPage.number != null ? lessonPage.number + 1 : '1'}"/>
                                                <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                            </c:url>
                                            <a class="page-link" href="${nextPageLink}">»</a>
                                        </li>
                                        <li class="page-item ${lessonPage.last ? 'disabled' : ''}">
                                            <c:url value="/staff/subject/${subjectId}/chapters/${chapterId}/lessons" var="lastPageLink">
                                                <c:param name="lessonName" value="${lessonName != null ? lessonName : ''}"/>
                                                <c:param name="status" value="${status != null ? status : ''}"/>
                                                <c:param name="page" value="${lessonPage.totalPages != null ? lessonPage.totalPages - 1 : '0'}"/>
                                                <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                            </c:url>
                                            <a class="page-link" href="${lastPageLink}">»»</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<footer>
    <jsp:include page="../layout_staff/footer.jsp"/>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>