<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trung tâm Tương tác</title>
    <link rel="stylesheet" href="<c:url value='/lib/bootstrap/css/bootstrap.css'/>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    
    <style>

        body { margin: 0; min-height: 100vh; display: flex; flex-direction: column; overflow-x: hidden; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif; background-color: #f8f9fa; font-size: 1rem; }
        header { position: fixed; top: 0; left: 0; right: 0; z-index: 1030; height: 55px; background-color: #1a252f; }
        .main-container { display: flex; flex: 1; margin-top: 55px; }
        .sidebar { width: 250px; background-color: #1a252f; color: white; overflow-y: auto; }
        .content { flex: 1; padding: 20px; background-color: #f8f9fa; overflow-y: auto; }
        footer { background-color: #1a252f; color: white; height: 40px; width: 100%; margin-top: auto; }

         .comment-card {
                        border: 1px solid #e0e0e0;
                        border-radius: 8px;
                        margin-bottom: 20px;
                        background-color: #fcfcfc;
                    }

                    .comment-header {
                        padding: 15px;
                        border-bottom: 1px solid #e0e0e0;
                        font-weight: 500;
                        background-color: #f8f9fa;
                    }

                    .comment-body {
                        padding: 15px;
                    }

                    .comment {
                        border-left: 2px solid #eee;
                        padding-left: 15px;
                        margin-top: 15px;
                    }

                    .comment .author-info {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .comment .author-avatar {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        object-fit: cover;
                    }

                    .comment .author-name {
                        font-weight: 689;
                    }

                    .comment .comment-meta {
                        color: #888;
                        font-size: 0.9em;
                    }

                    .comment-content {
                        margin-top: 5px;
                    }

                    .replies {
                        margin-left: 20px;
                        border-left: 2px solid #f0f0f0;
                    }

                    .reply-form {
                        margin-top: 10px;
                    }

                    .btn-reply,
                    .btn-delete {
                        cursor: pointer;
                        font-size: 0.9em;
                        user-select: none;
                        font-weight: 500;
                    }

                    .btn-reply {
                        color: #007bff;
                    }

                    .btn-delete {
                        color: #dc3545;
                    }


                    .status-badge {
                        display: inline-block;
                        padding: 0.25em 0.6em;
                        font-size: 75%;
                        font-weight: 700;
                        line-height: 1;
                        text-align: center;
                        white-space: nowrap;
                        vertical-align: baseline;
                        border-radius: 0.375rem;
                        color: #fff;
                        margin-left: 10px;
                    }

                    .status-PENDING {
                        background-color: #ffc107;
                        color: #000;
                    }

                    .status-APPROVED {
                        background-color: #198754;
                    }

                    .status-REJECTED {
                        background-color: #dc3545;
                    }


                    .comment-actions {
                        margin-top: 8px;
                    }

                    .action-link {
                        cursor: pointer;
                        font-size: 0.9em;
                        user-select: none;
                        font-weight: 500;
                        margin-right: 15px;
                        text-decoration: none;
                        transition: opacity 0.2s;
                    }

                    .action-link:hover {
                        opacity: 0.7;
                    }

                    .action-approve {
                        color: #198754;
                    }

                    .action-reject {
                        color: #dc3545;
                    }

                    .action-reply {
                        color: #007bff;
                    }

                    .action-delete {
                        color: #6c757d;
                    }

                    .action-show {
                        color: #0dcaf0;
                    }

                    .filter-bar {
                        background-color: #fff;
                        padding: 15px;
                        border: 1px solid #dee2e6;
                        border-radius: 8px;
                        margin-bottom: 20px;
                        display: flex;
                        gap: 20px;
                        align-items: center;
                    }

                    .stats-summary span {
                        margin-right: 15px;
                        font-size: 0.9em;
                    }

                    .stats-summary strong {
                        font-size: 1.1em;
                    }

    </style>
</head>

<body>

    <header>
        <jsp:include page="../layout/header.jsp" />
    </header>

    <div class="main-container">
        <div class="sidebar">
            <jsp:include page="../layout/sidebar.jsp" />
        </div>

        <div class="content">
            <main>
                <div class="container-fluid px-4">
                    <h3>Trung tâm Tương tác</h3>
                    <p class="text-muted">Tất cả câu hỏi từ người dùng trên mọi môn học và bài giảng.</p>

                    <hr>

                    <div class="filter-bar">
                        <div class="row w-100 g-3 align-items-center">
                            <div class="col-12">
                                <div id="stats-container" class="stats-summary">
                                    <span>Đang tải thống kê...</span>
                                </div>
                            </div>
                            <div class="col-lg-4 col-md-12">
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Tìm theo nội dung..." id="keyword-search-input">
                                    <button class="btn btn-outline-secondary" type="button" id="keyword-search-button">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-lg-5 col-md-7">
                                <div class="input-group">
                                    <input type="text" class="form-control" id="start-date-input" placeholder="Từ ngày">
                                    <input type="text" class="form-control" id="end-date-input" placeholder="Đến ngày">
                                    <button class="btn btn-primary" type="button" id="date-filter-button">Lọc</button>
                                    <button class="btn btn-outline-secondary" type="button" id="date-clear-button" title="Xóa bộ lọc ngày">
                                        <i class="bi bi-x-lg"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-lg-3 col-md-5">
                                 <select class="form-select" id="status-filter">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="PENDING">Chờ duyệt</option>
                                    <option value="APPROVED">Đã duyệt</option>
                                    <option value="REJECTED">Đã từ chối</option>
                                    <option value="HIDDEN">Đã ẩn</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div id="hub-container">
                        <p>Đang tải bình luận...</p>
                    </div>
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center" id="pagination-container">
                        </ul>
                    </nav>
                </div>
            </main>
        </div>
    </div>

    <footer>
        <jsp:include page="../layout/footer.jsp" />
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <script>
        window.API_URLS = {
            hub: '<c:url value="/api/communications/hub"/>',
            stats: '<c:url value="/api/communications/hub/statistics"/>',
            comment: '<c:url value="/api/communications"/>',
            lesson: '<c:url value="/api/communications/lesson"/>',
            images: '<c:url value="/images/"/>'
        };
    </script>
    <script src="<c:url value='/js/communication-hub.js'/>"></script>

</body>
</html>