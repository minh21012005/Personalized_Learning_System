<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Chi Tiết Bài Kiểm Tra</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .question-item {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            background-color: #f8f9fa;
            border-radius: 0.25rem;
            margin-bottom: 10px;
        }
        .question-item:last-child {
            border-bottom: none;
        }
        .option {
            padding: 8px;
            border-radius: 0.25rem;
            margin-bottom: 5px;
        }
        .option.correct {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .option.neutral {
            background-color: #ffffff;
            color: #212529;
            border: 1px solid #dee2e6;
        }
    </style>
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
            <div class="container-fluid px-4">
                <h1>Chi Tiết Bài Kiểm Tra</h1>
                <hr/>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title">${fn:escapeXml(test.testName)}</h5>
                        <p><strong>ID:</strong> ${test.testId}</p>
                        <p><strong>Môn học:</strong> ${fn:escapeXml(test.subjectName != null ? test.subjectName : 'Chưa xác định')}</p>
                        <p><strong>Chương:</strong> ${fn:escapeXml(test.chapterName != null ? test.chapterName : 'Chưa xác định')}</p>
                        <p><strong>Bài học:</strong> ${fn:escapeXml(test.lessonName != null ? test.lessonName : 'Chưa xác định')}</p>
                        <p><strong>Thời gian (phút):</strong> ${test.durationTime}</p>
                        <p><strong>Số lần làm tối đa:</strong> ${test.maxAttempts}</p>
                        <p><strong>Thời gian bắt đầu:</strong> ${fn:escapeXml(test.startAt)}</p>
                        <p><strong>Thời gian kết thúc:</strong> ${fn:escapeXml(test.endAt)}</p>
                        <p><strong>Trạng thái:</strong> ${fn:escapeXml(test.statusName)}</p>
                        <p><strong>Mở/Đóng:</strong> ${test.isOpen ? 'Mở' : 'Đóng'}</p>
                        <p><strong>Danh mục:</strong> ${fn:escapeXml(test.categoryName)}</p>
                        <c:if test="${not empty test.reason}">
                            <p><strong>Lý do phê duyệt/từ chối:</strong> ${fn:escapeXml(test.reason)}</p>
                        </c:if>
                    </div>
                </div>
                <h5>Câu hỏi</h5>
                <div class="question-list">
                    <c:forEach var="question" items="${test.questions}">
                        <div class="question-item">
                            <p><strong>Câu hỏi:</strong> ${fn:escapeXml(question.content)} (ID: ${question.questionId})</p>
                            <p><strong>Chương:</strong> ${fn:escapeXml(question.chapterName != null ? question.chapterName : 'Chưa xác định')}</p>
                            <div class="options">
                                <c:forEach var="option" items="${question.options}">
                                    <div class="option ${option.correct ? 'correct' : 'neutral'}">${fn:escapeXml(option.text)}</div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="d-flex gap-2">
                    <a href="/admin/tests" class="btn btn-secondary">Quay lại</a>
                    <!-- Allow re-approval/re-rejection for approved or rejected tests -->
                    <c:if test="${test.statusName == 'Đang Xử Lý' || test.statusName == 'Chấp Nhận' || test.statusName == 'Từ Chối'}">
                        <!-- Approve Form -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#approveModal">Phê duyệt</button>
                        <div class="modal fade" id="approveModal" tabindex="-1" aria-labelledby="approveModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="approveModalLabel">Phê duyệt bài kiểm tra</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="/admin/tests/approve/${test.testId}" method="post">
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label for="approveReason" class="form-label">Lý do phê duyệt <span class="text-danger">*</span></label>
                                                <textarea class="form-control" id="approveReason" name="reason" rows="4" required></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Xác nhận phê duyệt</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Reject Form -->
                        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal">Từ chối</button>
                        <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="rejectModalLabel">Từ chối bài kiểm tra</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="/admin/tests/reject/${test.testId}" method="post">
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label for="rejectReason" class="form-label">Lý do từ chối <span class="text-danger">*</span></label>
                                                <textarea class="form-control" id="rejectReason" name="reason" rows="4" required></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Footer -->
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>