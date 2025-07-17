<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Tạo Bài Kiểm Tra</title>
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
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
        }

        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
        }

        .form-label {
            font-weight: 500;
            color: #343a40;
        }

        .form-control, .form-select {
            border-radius: 0.25rem;
            border: 1px solid #ced4da;
        }

        .btn-select-questions {
            background-color: #28a745;
            border: none;
            padding: 10px 20px;
            font-size: 1rem;
            border-radius: 0.25rem;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .btn-select-questions:hover {
            background-color: #218838;
        }

        .btn-submit {
            background-color: #007bff;
            border: none;
            padding: 10px 20px;
            font-size: 1rem;
            border-radius: 0.25rem;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .btn-submit:hover {
            background-color: #0056b3;
        }

        .btn-cancel {
            background-color: #6c757d;
            border: none;
            padding: 10px 20px;
            font-size: 1rem;
            border-radius: 0.25rem;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        .btn-cancel:hover {
            background-color: #5a6268;
        }

        .modal-content {
            border-radius: 0.25rem;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            background: linear-gradient(90deg, #007bff, #0056b3);
            color: #ffffff;
            border-radius: 0.25rem 0.25rem 0 0;
        }

        .question-list {
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            padding: 10px;
            margin-bottom: 20px;
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

        .question-item input[type="checkbox"] {
            margin-right: 10px;
        }

        .question-item .chapter-info {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 10px;
        }

        .question-item .options {
            margin-top: 10px;
        }

        .question-item .option {
            padding: 8px;
            border-radius: 0.25rem;
            margin-bottom: 5px;
        }

        .question-item .option.correct {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .question-item .option.neutral {
            background-color: #ffffff;
            color: #212529;
            border: 1px solid #dee2e6;
        }

        .selected-questions {
            padding: 10px;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            background-color: #f8f9fa;
            min-height: 50px;
        }

        .selected-questions p {
            margin: 0;
            color: #6c757d;
        }

        .question-count {
            font-size: 0.9rem;
            font-weight: 500;
            color: #343a40;
            margin-bottom: 10px;
        }

        .error-message {
            color: #dc3545;
            font-size: 0.9rem;
            margin-top: 5px;
        }

        .mandatory::after {
            content: ' *';
            color: #dc3545;
        }

        @media (max-width: 768px) {
            .content {
                padding: 15px;
            }

            h1 {
                font-size: 1.5rem;
            }

            .btn-select-questions, .btn-submit, .btn-cancel {
                width: 100%;
                padding: 12px;
                font-size: 0.9rem;
            }

            .question-list {
                max-height: 300px;
            }

            .question-item {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<header>
    <jsp:include page="../layout_staff/header.jsp"/>
</header>
<!-- Main Container for Sidebar and Content -->
<div class="main-container">
    <!-- Sidebar -->
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../layout_staff/sidebar.jsp"/>
    </div>

    <!-- Main Content Area -->
    <div class="content">
        <main>
            <div class="container-fluid px-4">
                <div class="row mt-2">
                    <div class="col-md-8 col-12 mx-auto">
                        <h1>Tạo Bài Kiểm Tra</h1>
                        <hr/>
                        <form id="createTestForm" action="/staff/tests/save" method="post"
                              onsubmit="return validateForm()">
                            <c:if test="${not empty success}">
                                <div class="alert alert-success">${success}</div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">${error}</div>
                            </c:if>
                            <div class="row">
                                <div class="mb-3 col-9">
                                    <label for="testName" class="form-label mandatory">Tên bài kiểm tra</label>
                                    <input type="text" class="form-control" id="testName" name="testName" required>
                                    <div id="testNameError" class="error-message"></div>
                                </div>
                                <div class="mb-3 col-3">
                                    <label for="durationTime" class="form-label mandatory">Thời gian (phút)</label>
                                    <input type="number" class="form-control" id="durationTime" name="durationTime"
                                           required min="1">
                                    <div id="durationTimeError" class="error-message"></div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="mb-3 col-4">
                                    <label for="durationTime" class="form-label ">Số lần làm bài tối đa:</label>
                                    <input type="number" class="form-control" id="maxAttempts" name="maxAttempts"
                                           >
                                </div>
                                <div class="mb-3 col-4">
                                    <label for="startAt" class="form-label ">Thời gian bắt đầu</label>
                                    <input type="datetime-local" class="form-control" id="startAt" name="startAt"
                                           >
                                    <div id="startAtError" class="error-message"></div>
                                </div>
                                <div class="mb-3 col-4">
                                    <label for="endAt" class="form-label ">Thời gian kết thúc</label>
                                    <input type="datetime-local" class="form-control" id="endAt" name="endAt" >
                                    <div id="endAtError" class="error-message"></div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="mb-3 col-6">
                                    <label for="testCategory" class="form-label mandatory">Danh mục</label>
                                    <select class="form-select" id="testCategory" name="testCategoryId" required>
                                        <option value="">Chọn danh mục</option>
                                        <c:forEach var="category" items="${testCategories}">
                                            <option value="${category.testCategoryId}">${fn:escapeXml(category.name)}</option>
                                        </c:forEach>
                                    </select>
                                    <div id="testCategoryError" class="error-message"></div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="mb-3 col-4">
                                    <label for="subject" class="form-label mandatory">Môn học</label>
                                    <select class="form-select" id="subject" name="subjectId"
                                            onchange="loadChapters(this.value)">
                                        <option value="">Chọn môn học</option>
                                        <c:forEach var="subject" items="${subjects}">
                                            <option value="${subject.subjectId}">${fn:escapeXml(subject.subjectName)}</option>
                                        </c:forEach>
                                    </select>
                                    <div id="subjectError" class="error-message"></div>
                                </div>
                                <div class="mb-3 col-4">
                                    <label for="chapter" class="form-label">Chương</label>
                                    <select class="form-select" id="chapter" name="chapterId"
                                            onchange="loadLessons(this.value)">
                                        <option value="">Chọn chương (tùy chọn)</option>
                                    </select>
                                </div>
                                <div class="mb-3 col-4">
                                    <label for="lesson" class="form-label">Bài học</label>
                                    <select class="form-select" id="lesson" name="lessonId">
                                        <option value="">Chọn bài học (tùy chọn)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label mandatory">Câu hỏi đã chọn</label>
                                <div class="question-count" id="questionCount">Đã chọn: 0 câu hỏi</div>
                                <div class="selected-questions" id="selectedQuestions">
                                    <p>Chưa có câu hỏi nào được chọn.</p>
                                </div>
                                <button type="button" class="btn btn-select-questions" data-bs-toggle="modal"
                                        data-bs-target="#questionModal">Chọn câu hỏi
                                </button>
                                <div id="questionsError" class="error-message"></div>
                            </div>
                            <div class="d-flex gap-2 mb-3">
                                <button type="submit" class="btn btn-submit" name="action" value="saveDraft">Lưu bản nháp</button>
                                <button type="submit" class="btn btn-primary" name="action" value="requestApproval">Yêu cầu phê duyệt</button>
                                <a href="/staff/tests" class="btn btn-cancel">Hủy</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal chọn câu hỏi -->
<div class="modal fade" id="questionModal" tabindex="-1" aria-labelledby="questionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="questionModalLabel">Chọn Câu Hỏi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="question-list" id="questionList">
                    <p>Chọn môn học hoặc chương để tải câu hỏi.</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-primary" onclick="confirmQuestions()">Xác nhận</button>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer>
    <jsp:include page="../layout_staff/footer.jsp"/>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
<script>
    let selectedQuestionIds = [];
    let selectedQuestionTexts = [];

    function loadChapters(subjectId) {
        $('#chapter').html('<option value="">Chọn chương (tùy chọn)</option>');
        $('#lesson').html('<option value="">Chọn bài học (tùy chọn)</option>');
        $('#subjectError').text('');
        if (!subjectId) {
            loadQuestions();
            return;
        }
        $.ajax({
            url: '/staff/tests/chapters?subjectId=' + subjectId,
            method: 'GET',
            success: function (data) {
                var options = '<option value="">Chọn chương (tùy chọn)</option>';
                data.forEach(function (chapter) {
                    options += '<option value="' + chapter.chapterId + '">' + chapter.chapterName + '</option>';
                });
                $('#chapter').html(options);
                loadQuestions();
            },
            error: function () {
                $('#chapter').html('<option value="">Không có chương</option>');
            }
        });
    }

    function loadLessons(chapterId) {
        $('#lesson').html('<option value="">Chọn bài học (tùy chọn)</option>');
        if (!chapterId) {
            loadQuestions();
            return;
        }
        $.ajax({
            url: '/staff/tests/lessons?chapterId=' + chapterId,
            method: 'GET',
            success: function (data) {
                var options = '<option value="">Chọn bài học (tùy chọn)</option>';
                data.forEach(function (lesson) {
                    options += '<option value="' + lesson.lessonId + '">' + lesson.lessonName + '</option>';
                });
                $('#lesson').html(options);
                loadQuestions();
            },
            error: function () {
                $('#lesson').html('<option value="">Không có bài học</option>');
            }
        });
    }

    function loadQuestions() {
        var subjectId = $('#subject').val();
        var chapterId = $('#chapter').val();
        var lessonId = $('#lesson').val();
        var url = '/staff/tests/questions?subjectId=' + (subjectId || '') + '&chapterId=' + (chapterId || '')+ '&lessonId=' + (lessonId || '');
        $.ajax({
            url: url,
            method: 'GET',
            success: function (data) {
                var html = '';
                data.forEach(function (question) {
                    var isChecked = selectedQuestionIds.includes(question.questionId.toString()) ? 'checked' : '';
                    html += '<div class="question-item">' +
                        '<input type="checkbox" name="modalQuestionIds" value="' + question.questionId + '" ' + isChecked + '>' +
                        '<div>' +
                        '<p><strong>Câu hỏi:</strong> ' + question.content + ' (ID: ' + question.questionId + ')</p>' +
                        '<p class="chapter-info"><strong>Chương:</strong> ' + (question.chapterName || 'Không có chương') + '</p>' +
                        '<div class="options">';
                    question.options.forEach(function (option) {
                        var optionClass = option.correct ? 'correct' : 'neutral';
                        html += '<div class="option ' + optionClass + '">' + option.text + '</div>';
                    });
                    html += '</div></div></div>';
                });
                $('#questionList').html(html || '<p>Không có câu hỏi nào.</p>');
            },
            error: function () {
                $('#questionList').html('<p>Lỗi khi tải câu hỏi.</p>');
            }
        });
    }

    function confirmQuestions() {
        selectedQuestionIds = [];
        selectedQuestionTexts = [];
        $('#questionList input[name="modalQuestionIds"]:checked').each(function () {
            var questionId = $(this).val();
            var questionText = $(this).parent().find('p:first').text().trim();
            selectedQuestionIds.push(questionId);
            selectedQuestionTexts.push(questionText);
        });
        var selectedHtml = '';
        selectedQuestionTexts.forEach(function (text) {
            selectedHtml += '<p>' + text + '</p>';
        });
        $('#questionCount').html('Đã chọn: ' + selectedQuestionIds.length + ' câu hỏi');
        $('#selectedQuestions').html(selectedHtml || '<p>Chưa có câu hỏi nào được chọn.</p>');

        // Thêm input ẩn để gửi questionIds
        var form = $('#createTestForm');
        form.find('input[name="questionIds"]').remove();
        selectedQuestionIds.forEach(function (id) {
            form.append('<input type="hidden" name="questionIds" value="' + id + '">');
        });

        $('#questionModal').modal('hide');
    }

    function validateForm() {
        var isValid = true;
        $('#testNameError, #durationTimeError, #startAtError, #endAtError, #testStatusError, #testCategoryError, #subjectError, #questionsError').text('');

        var testName = $('#testName').val().trim();
        if (!testName) {
            $('#testNameError').text('Tên bài kiểm tra là bắt buộc.');
            isValid = false;
        }

        var durationTime = $('#durationTime').val();
        if (!durationTime || durationTime < 1) {
            $('#durationTimeError').text('Thời gian phải lớn hơn 0 phút.');
            isValid = false;
        }

        var startAt = $('#startAt').val();
        var endAt = $('#endAt').val();
        if (startAt && endAt && new Date(endAt) <= new Date(startAt)) {
            $('#endAtError').text('Thời gian kết thúc phải sau thời gian bắt đầu.');
            isValid = false;
        }

        var testCategory = $('#testCategory').val();
        if (!testCategory) {
            $('#testCategoryError').text('Danh mục là bắt buộc.');
            isValid = false;
        }

        var subjectId = $('#subject').val();
        var chapterId = $('#chapter').val();
        var lessonId = $('#lesson').val();
        if (!subjectId && !chapterId && !lessonId) {
            $('#subjectError').text('Phải chọn ít nhất một môn học, chương hoặc bài học.');
            isValid = false;
        }

        if (selectedQuestionIds.length === 0) {
            $('#questionsError').text('Phải chọn ít nhất một câu hỏi.');
            isValid = false;
        }

        return isValid;
    }

    // Tải lại câu hỏi khi mở modal
    $('#questionModal').on('show.bs.modal', function () {
        loadQuestions();
    });
</script>
</body>
</html>