<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Danh sách chương</title>
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
                            <h5 class="mb-0">Danh sách chương trong Môn học ID: <c:out value="${subject != null ? subject.subjectId : ''}"/></h5>
                            <a href="<c:url value='/staff/subject'/>" class="btn btn-secondary btn-sm">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <form action="<c:url value='/staff/subject/${subject != null ? subject.subjectId : ""}/chapters'/>" method="GET" class="mb-3">
                            <div class="row g-3 align-items-center">
                                <div class="col-auto">
                                    <label for="chapterName" class="col-form-label">Tên chương:</label>
                                </div>
                                <div class="col-auto">
                                    <input type="text" name="chapterName" id="chapterName" class="form-control form-control-sm"
                                           value="<c:out value='${chapterName != null ? chapterName : ""}'/>" placeholder="Nhập tên chương...">
                                </div>
                                <div class="col-auto">
                                    <label for="status" class="col-form-label">Trạng thái:</label>
                                </div>
                                <div class="col-auto">
                                    <select name="status" id="status" class="form-select form-select-sm">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="true" ${status == true ? 'selected' : ''}>Có</option>
                                        <option value="false" ${status == false ? 'selected' : ''}>Không</option>
                                    </select>
                                </div>
                                <div class="col-auto">
                                    <button type="submit" class="btn btn-info btn-sm">
                                        <i class="fas fa-filter"></i> Lọc
                                    </button>
                                    <a href="<c:url value='/staff/subject/${subject != null ? subject.subjectId : ""}/chapters'/>" class="btn btn-secondary btn-sm ms-2">
                                        <i class="fas fa-eraser"></i> Xóa bộ lọc
                                    </a>
                                </div>
                            </div>
                        </form>

                        <a href="<c:url value='/staff/subject/${subject != null ? subject.subjectId : ""}/chapters/new'/>" class="btn btn-primary mb-3">
                            <i class="fas fa-plus"></i> Thêm mới
                        </a>

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
                            <table class="table table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th>
                                        <c:url value="/staff/subject/${subject != null ? subject.subjectId : ''}/chapters" var="sortByIdUrl">
                                            <c:param name="chapterName" value="${chapterName != null ? chapterName : ''}"/>
                                            <c:param name="status" value="${status != null ? status : ''}"/>
                                            <c:param name="page" value="${currentPage != null ? currentPage : '0'}"/>
                                            <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                            <c:param name="sortField" value="chapterId"/>
                                            <c:param name="sortDir" value="${sortField eq 'chapterId' ? reverseSortDir : 'asc'}"/>
                                        </c:url>
                                        <a href="${sortByIdUrl}" class="table-header-sort-link">
                                            ID
                                            <c:if test="${sortField eq 'chapterId'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                                        </a>
                                    </th>
                                    <th>
                                        <c:url value="/staff/subject/${subject != null ? subject.subjectId : ''}/chapters" var="sortByNameUrl">
                                            <c:param name="chapterName" value="${chapterName != null ? chapterName : ''}"/>
                                            <c:param name="status" value="${status != null ? status : ''}"/>
                                            <c:param name="page" value="${currentPage != null ? currentPage : '0'}"/>
                                            <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                            <c:param name="sortField" value="chapterName"/>
                                            <c:param name="sortDir" value="${sortField eq 'chapterName' ? reverseSortDir : 'asc'}"/>
                                        </c:url>
                                        <a href="${sortByNameUrl}" class="table-header-sort-link">
                                            Tên chương
                                            <c:if test="${sortField eq 'chapterName'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                                        </a>
                                    </th>
                                    <th>Mô tả</th>
                                    <th>Trạng thái</th>
                                    <th>
                                        <c:url value="/staff/subject/${subject != null ? subject.subjectId : ''}/chapters" var="sortByCreatedByUrl">
                                            <c:param name="chapterName" value="${chapterName != null ? chapterName : ''}"/>
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
                                    <th>
                                        <c:url value="/staff/subject/${subject != null ? subject.subjectId : ''}/chapters" var="sortByCreatedAtUrl">
                                            <c:param name="chapterName" value="${chapterName != null ? chapterName : ''}"/>
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
                                    <th>Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="chapter" items="${chapters}">
                                    <tr>
                                        <td><c:out value="${chapter.chapterId != null ? chapter.chapterId : ''}"/></td>
                                        <td><c:out value="${chapter.chapterName != null ? chapter.chapterName : ''}"/></td>
                                        <td><c:out value="${chapter.chapterDescription != null ? chapter.chapterDescription : ''}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${chapter.status != null && chapter.status}">
                                                    <span class="badge bg-success">Có</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Không</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><c:out value="${chapter.userFullName != null ? chapter.userFullName : 'Không có thông tin'}"/></td>
                                        <td><c:out value="${chapter.createdAt != null ? chapter.createdAt : ''}"/></td>
                                        <td>
                                            <a href="<c:url value='/staff/subject/${subject != null ? subject.subjectId : ""}/chapters/${chapter.chapterId != null ? chapter.chapterId : ""}/lessons'/>"
                                               class="btn btn-sm btn-primary me-1" title="Xem">
                                                <i class="fas fa-eye"></i> Xem
                                            </a>
                                            <a href="<c:url value='/staff/subject/${subject != null ? subject.subjectId : ""}/chapters/${chapter.chapterId != null ? chapter.chapterId : ""}/edit'/>"
                                               class="btn btn-sm btn-warning me-1" title="Sửa">
                                                <i class="fas fa-edit"></i> Sửa
                                            </a>
                                            <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#deleteChapterModal${chapter.chapterId != null ? chapter.chapterId : ''}"
                                                    title="Xóa">
                                                <i class="fas fa-trash"></i> Xóa
                                            </button>
                                            <!-- Delete Confirmation Modal -->
                                            <div class="modal fade" id="deleteChapterModal${chapter.chapterId != null ? chapter.chapterId : ''}" tabindex="-1"
                                                 aria-labelledby="deleteChapterModalLabel${chapter.chapterId != null ? chapter.chapterId : ''}" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="deleteChapterModalLabel${chapter.chapterId != null ? chapter.chapterId : ''}">
                                                                Xác nhận xóa
                                                            </h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            Bạn có chắc chắn muốn xóa chương "<c:out value="${chapter.chapterName != null ? chapter.chapterName : 'Không xác định'}"/>?
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                            <form action="<c:url value='/staff/subject/${subject != null ? subject.subjectId : ""}/chapters/${chapter.chapterId != null ? chapter.chapterId : ""}/delete'/>" method="post">
                                                                <button type="submit" class="btn btn-danger">Xóa</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty chapters}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted">Không tìm thấy chương nào.</td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>

                        <c:if test="${chapterPage != null && chapterPage.totalPages > 0}">
                            <div class="pagination-wrapper text-center">
                                <div class="mb-2">
                                    <small>Hiển thị <c:out value="${chapterPage.numberOfElements != null ? chapterPage.numberOfElements : '0'}"/> trong tổng số <c:out value="${chapterPage.totalElements != null ? chapterPage.totalElements : '0'}"/> mục. Trang <c:out value="${chapterPage.number != null ? chapterPage.number + 1 : '1'}"/> / <c:out value="${chapterPage.totalPages != null ? chapterPage.totalPages : '1'}"/></small>
                                </div>
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${chapterPage.first ? 'disabled' : ''}">
                                            <c:url value="/staff/subject/${subject != null ? subject.subjectId : ''}/chapters" var="firstPageLink">
                                                <c:param name="chapterName" value="${chapterName != null ? chapterName : ''}"/>
                                                <c:param name="status" value="${status != null ? status : ''}"/>
                                                <c:param name="page" value="0"/>
                                                <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                            </c:url>
                                            <a class="page-link" href="${firstPageLink}">««</a>
                                        </li>
                                        <li class="page-item ${chapterPage.first ? 'disabled' : ''}">
                                            <c:url value="/staff/subject/${subject != null ? subject.subjectId : ''}/chapters" var="prevPageLink">
                                                <c:param name="chapterName" value="${chapterName != null ? chapterName : ''}"/>
                                                <c:param name="status" value="${status != null ? status : ''}"/>
                                                <c:param name="page" value="${chapterPage.number != null ? chapterPage.number - 1 : '0'}"/>
                                                <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                            </c:url>
                                            <a class="page-link" href="${prevPageLink}">«</a>
                                        </li>
                                        <c:set var="windowSize" value="2"/>
                                        <c:set var="startPageLoop" value="${chapterPage.number != null && chapterPage.number - windowSize > 0 ? chapterPage.number - windowSize : 0}"/>
                                        <c:set var="endPageLoop" value="${chapterPage.number != null && chapterPage.number + windowSize < chapterPage.totalPages - 1 ? chapterPage.number + windowSize : chapterPage.totalPages != null ? chapterPage.totalPages - 1 : 0}"/>
                                        <c:if test="${startPageLoop > 0}">
                                            <c:url value="/staff/subject/${subject != null ? subject.subjectId : ''}/chapters" var="pageLinkFirstDots">
                                                <c:param name="chapterName" value="${chapterName != null ? chapterName : ''}"/>
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
                                            <li class="page-item ${i == chapterPage.number ? 'active' : ''}">
                                                <c:url value="/staff/subject/${subject != null ? subject.subjectId : ''}/chapters" var="pageLink">
                                                    <c:param name="chapterName" value="${chapterName != null ? chapterName : ''}"/>
                                                    <c:param name="status" value="${status != null ? status : ''}"/>
                                                    <c:param name="page" value="${i}"/>
                                                    <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                    <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                    <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                                </c:url>
                                                <a class="page-link" href="${pageLink}">${i + 1}</a>
                                            </li>
                                        </c:forEach>
                                        <c:if test="${chapterPage.totalPages != null && endPageLoop < chapterPage.totalPages - 1}">
                                            <c:if test="${endPageLoop < chapterPage.totalPages - 2}">
                                                <li class="page-item disabled"><span class="page-link">...</span></li>
                                            </c:if>
                                            <c:url value="/staff/subject/${subject != null ? subject.subjectId : ''}/chapters" var="pageLinkLastDots">
                                                <c:param name="chapterName" value="${chapterName != null ? chapterName : ''}"/>
                                                <c:param name="status" value="${status != null ? status : ''}"/>
                                                <c:param name="page" value="${chapterPage.totalPages != null ? chapterPage.totalPages - 1 : '0'}"/>
                                                <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                            </c:url>
                                            <li class="page-item"><a class="page-link" href="${pageLinkLastDots}">${chapterPage.totalPages != null ? chapterPage.totalPages : '1'}</a></li>
                                        </c:if>
                                        <li class="page-item ${chapterPage.last ? 'disabled' : ''}">
                                            <c:url value="/staff/subject/${subject != null ? subject.subjectId : ''}/chapters" var="nextPageLink">
                                                <c:param name="chapterName" value="${chapterName != null ? chapterName : ''}"/>
                                                <c:param name="status" value="${status != null ? status : ''}"/>
                                                <c:param name="page" value="${chapterPage.number != null ? chapterPage.number + 1 : '1'}"/>
                                                <c:param name="size" value="${pageSize != null ? pageSize : '10'}"/>
                                                <c:param name="sortField" value="${sortField != null ? sortField : 'createdAt'}"/>
                                                <c:param name="sortDir" value="${sortDir != null ? sortDir : 'desc'}"/>
                                            </c:url>
                                            <a class="page-link" href="${nextPageLink}">»</a>
                                        </li>
                                        <li class="page-item ${chapterPage.last ? 'disabled' : ''}">
                                            <c:url value="/staff/subject/${subject != null ? subject.subjectId : ''}/chapters" var="lastPageLink">
                                                <c:param name="chapterName" value="${chapterName != null ? chapterName : ''}"/>
                                                <c:param name="status" value="${status != null ? status : ''}"/>
                                                <c:param name="page" value="${chapterPage.totalPages != null ? chapterPage.totalPages - 1 : '0'}"/>
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