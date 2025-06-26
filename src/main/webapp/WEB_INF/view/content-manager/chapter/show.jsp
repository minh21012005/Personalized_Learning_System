<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="_csrf" content="${_csrf.token}"/>
    <title>Quản lý chương học</title>
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
            padding: 1rem;
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
        .table-fixed th, .table-fixed td {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            padding: 0.5rem;
            vertical-align: middle;
        }
        .col-id { width: 5%; }
        .col-name { width: 20%; }
        .col-subject { width: 15%; }
        .col-user { width: 15%; }
        .col-date { width: 12%; }
        .col-status { width: 10%; }
        .col-active { width: 13%; }
        .col-action { width: 10%; min-width: 200px; }
        .pagination .page-item {
            margin: 0 2px;
        }
        .pagination .page-link {
            color: #212529;
            border: 1px solid #dee2e6;
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
            border-radius: 0.25rem;
        }
        .pagination .page-link:hover {
            background-color: #e9ecef;
            color: #212529;
        }
        .pagination .page-item.active .page-link {
            background-color: #6c757d;
            border-color: #6c757d;
            color: white;
        }
        .pagination .page-item.disabled .page-link {
            color: #6c757d;
            background-color: #fff;
            cursor: not-allowed;
        }
        .alert {
            position: fixed;
            top: 1rem;
            right: 1rem;
            z-index: 1000;
            max-width: 90%;
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
                padding: 0.75rem;
            }
            .table-fixed th, .table-fixed td {
                font-size: 0.8rem;
                padding: 0.3rem;
            }
            .btn-sm {
                font-size: 0.75rem;
                padding: 0.2rem 0.4rem;
            }
            .col-action {
                min-width: 170px;
            }
            .col-name, .col-subject, .col-user {
                min-width: 120px;
            }
        }
        @media (max-width: 576px) {
            .form-group {
                margin-bottom: 0.5rem;
            }
            .btn-sm {
                font-size: 0.7rem;
                padding: 0.15rem 0.3rem;
            }
            .col-action {
                min-width: 150px;
            }
            .col-name, .col-subject, .col-user {
                min-width: 100px;
            }
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>

<div class="main-container">
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../layout/sidebar.jsp"/>
    </div>

    <div class="content">
        <main>
            <div class="container-fluid px-2">
                <div class="card mt-3">
                    <div class="card-header">
                        <h5 class="mb-0">Quản lý chương học</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <form action="/admin/chapters" method="get" class="row g-2 align-items-center">
                                <div class="row">
                                    <div class="col-md-3 col-sm-6">
                                        <label for="subjectId" class="form-label mb-0">Môn học:</label>
                                        <select name="subjectId" id="subjectId" class="form-select form-select-sm">
                                            <option value="">Tất cả</option>
                                            <c:forEach var="subject" items="${subjects}">
                                                <option value="${subject.subjectId}" ${subject.subjectId == subjectId ? 'selected' : ''}>${subject.subjectName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-3 col-sm-6">
                                        <label for="chapterStatus" class="form-label mb-0">Trạng thái phê duyệt:</label>
                                        <select name="chapterStatus" id="chapterStatus" class="form-select form-select-sm">
                                            <option value="">Tất cả</option>
                                            <option value="PENDING" ${chapterStatus == 'PENDING' ? 'selected' : ''}>Chờ xử lí</option>
                                            <option value="APPROVED" ${chapterStatus == 'APPROVED' ? 'selected' : ''}>Chấp nhận</option>
                                            <option value="REJECTED" ${chapterStatus == 'REJECTED' ? 'selected' : ''}>Từ chối</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3 col-sm-6">
                                        <label for="status" class="form-label mb-0">Trạng thái hiển thị:</label>
                                        <select name="status" id="status" class="form-select form-select-sm">
                                            <option value="">Tất cả</option>
                                            <option value="true" ${status == true ? 'selected' : ''}>Đang hoạt động</option>
                                            <option value="false" ${status == false ? 'selected' : ''}>Không hoạt động</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3 col-sm-6">
                                        <label for="userCreated" class="form-label mb-0">Người tạo:</label>
                                        <select name="userCreated" id="userCreated" class="form-select form-select-sm">
                                            <option value="">Tất cả</option>
                                            <c:forEach var="user" items="${contentManagers}">
                                                <option value="${user.userId}" ${user.userId == userCreated ? 'selected' : ''}>${user.fullName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-3 col-sm-6">
                                        <label for="startDate" class="form-label mb-0">Từ ngày:</label>
                                        <input type="date" name="startDate" id="startDate" class="form-control form-control-sm" value="${startDate != null ? startDate.toLocalDate() : ''}">
                                    </div>
                                    <div class="col-md-3 col-sm-6">
                                        <label for="endDate" class="form-label mb-0">Đến ngày:</label>
                                        <input type="date" name="endDate" id="endDate" class="form-control form-control-sm" value="${endDate != null ? endDate.toLocalDate() : ''}">
                                    </div>
                                </div>
                                <div class="row mt-2">
                                    <div class="col-md-3 col-sm-6 d-flex align-items-end">
                                        <button type="submit" class="btn btn-outline-primary btn-sm me-2">Lọc</button>
                                        <a href="/admin/chapters" class="btn btn-outline-secondary btn-sm">Xóa lọc</a>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <div id="alertContainer"></div>

                        <div class="table-responsive">
                            <table class="table table-bordered table-hover table-fixed">
                                <thead>
                                <tr>
                                    <th scope="col" class="text-center col-id">ID</th>
                                    <th scope="col" class="text-center col-name">Tên chương</th>
                                    <th scope="col" class="text-center col-subject">Môn học</th>
                                    <th scope="col" class="text-center col-user">Người tạo</th>
                                    <th scope="col" class="text-center col-date">Ngày nộp</th>
                                    <th scope="col" class="text-center col-status">Trạng thái phê duyệt</th>
                                    <th scope="col" class="text-center col-active">Hiển thị</th>
                                    <th scope="col" class="text-center col-action">Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:if test="${not empty chapters}">
                                    <c:forEach var="chapter" items="${chapters}">
                                        <tr>
                                            <td class="text-center col-id">${chapter.chapterId}</td>
                                            <td class="col-name">${chapter.chapterName}</td>
                                            <td class="text-center col-subject">${chapter.subjectName}</td>
                                            <td class="text-center col-user">${chapter.userFullName}</td>
                                            <td class="text-center col-date">${chapter.updatedAt}</td>
                                            <td class="text-center col-status">
                                                <c:choose>
                                                    <c:when test="${chapter.chapterStatus.statusCode == 'DRAFT'}">
                                                        <span class="badge bg-warning">${chapter.chapterStatus.description}</span>
                                                    </c:when>
                                                    <c:when test="${chapter.chapterStatus.statusCode == 'PENDING'}">
                                                        <span class="badge bg-primary">${chapter.chapterStatus.description}</span>
                                                    </c:when>
                                                    <c:when test="${chapter.chapterStatus.statusCode == 'APPROVED'}">
                                                        <span class="badge bg-success">${chapter.chapterStatus.description}</span>
                                                    </c:when>
                                                    <c:when test="${chapter.chapterStatus.statusCode == 'REJECTED'}">
                                                        <span class="badge bg-danger">${chapter.chapterStatus.description}</span>
                                                    </c:when>
                                            </c:choose>
                                            </td>
                                            <td class="text-center col-active"><span class="badge ${chapter.status ? 'bg-success' : 'bg-danger'}">${chapter.status ? 'Đang hoạt động' : 'Không hoạt động'}</span></td>
                                            <td class="text-center col-action">
                                                <div class="d-flex gap-2 d-flex flex-column align-items-center justify-content-center">
                                                    <div>
                                                        <a href="/admin/chapters/${chapter.chapterId}/detail"
                                                            class="btn btn-info btn-sm">Chi tiết</a>
                                                    </div>
                                                        <c:if test="${chapter.chapterStatus.statusCode == 'PENDING'}">
                                                            <form action="/admin/chapters/${chapter.chapterId}/update-status" method="post" style="display:block;">
                                                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                                                <input type="hidden" name="newStatus" value="APPROVED">
                                                                <button type="submit" class="btn btn-success btn-sm w-100">Phê duyệt</button>
                                                            </form>
                                                            <form action="/admin/chapters/${chapter.chapterId}/update-status" method="post" style="display:block;">
                                                                <input type="hidden" name="_csrf" value="${_csrf.token}">
                                                                <input type="hidden" name="newStatus" value="REJECTED">
                                                                <button type="submit" class="btn btn-danger btn-sm w-100">Từ chối</button>
                                                            </form>
                                                        </c:if>
                                                </div>

                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                <c:if test="${empty chapters}">
                                    <tr>
                                        <td colspan="8" class="text-center">Chưa có chương học nào.</td>
                                    </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>

                        <c:set var="queryString" value=""/>
                        <c:if test="${not empty subjectId}">
                            <c:set var="queryString" value="${queryString}&subjectId=${subjectId}"/>
                        </c:if>
                        <c:if test="${not empty chapterStatus}">
                            <c:set var="queryString" value="${queryString}&chapterStatus=${chapterStatus}"/>
                        </c:if>
                        <c:if test="${not empty status}">
                            <c:set var="queryString" value="${queryString}&status=${status}"/>
                        </c:if>
                        <c:if test="${not empty userCreated}">
                            <c:set var="queryString" value="${queryString}&userCreated=${userCreated}"/>
                        </c:if>
                        <c:if test="${not empty startDate}">
                            <c:set var="queryString" value="${queryString}&startDate=${startDate.toLocalDate()}"/>
                        </c:if>
                        <c:if test="${not empty endDate}">
                            <c:set var="queryString" value="${queryString}&endDate=${endDate.toLocalDate()}"/>
                        </c:if>
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Page navigation" class="mt-3">
                                <ul class="pagination pagination-sm justify-content-center mb-0">
                                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                        <a class="page-link" href="/admin/chapters?page=0${queryString}" aria-label="First">
                                            <span aria-hidden="true">««</span>
                                        </a>
                                    </li>
                                    <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                        <a class="page-link" href="/admin/chapters?page=${currentPage - 1}${queryString}" aria-label="Previous">
                                            <span aria-hidden="true">«</span>
                                        </a>
                                    </li>
                                    <c:set var="startPage" value="${currentPage - 2}"/>
                                    <c:set var="endPage" value="${currentPage + 2}"/>
                                    <c:if test="${startPage < 0}">
                                        <c:set var="startPage" value="0"/>
                                        <c:set var="endPage" value="${startPage + 4}"/>
                                    </c:if>
                                    <c:if test="${endPage > totalPages - 1}">
                                        <c:set var="endPage" value="${totalPages - 1}"/>
                                        <c:set var="startPage" value="${endPage - 4 > 0 ? endPage - 4 : 0}"/>
                                    </c:if>
                                    <c:forEach begin="${startPage}" end="${endPage}" varStatus="loop">
                                        <li class="page-item ${currentPage == loop.index ? 'active' : ''}">
                                            <a class="page-link" href="/admin/chapters?page=${loop.index}${queryString}">${loop.index + 1}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="/admin/chapters?page=${currentPage + 1}${queryString}" aria-label="Next">
                                            <span aria-hidden="true">»</span>
                                        </a>
                                    </li>
                                    <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="/admin/chapters?page=${totalPages - 1}${queryString}" aria-label="Last">
                                            <span aria-hidden="true">»»</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>
</body>
</html>