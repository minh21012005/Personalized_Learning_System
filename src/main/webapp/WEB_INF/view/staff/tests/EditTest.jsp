<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Chỉnh Sửa Bài Kiểm Tra</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #f0f4f8 0%, #e0e7ef 100%);
        }
        header {
            background-color: #1a252f;
            color: white;
            width: 100%;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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
            box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);
        }
        .content {
            flex: 1;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 8px;
            margin: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }
        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 -2px 4px rgba(0, 0, 0, 0.1);
        }
        h1 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #1a252f;
            margin-bottom: 20px;
        }
        hr {
            border-top: 2px solid #dee2e6;
            margin: 20px 0;
        }
        .form-label {
            font-weight: 500;
            color: #343a40;
            margin-bottom: 8px;
        }
        .form-control, .form-select {
            border-radius: 6px;
            border: 1px solid #ced4da;
            padding: 10px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.2);
        }
        .btn-select-questions {
            background: linear-gradient(90deg, #28a745, #218838);
            border: none;
            padding: 12px 24px;
            font-size: 1rem;
            border-radius: 6px;
            font-weight: 500;
            color: white;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-select-questions:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .btn-submit {
            background: linear-gradient(90deg, #007bff, #0056b3);
            border: none;
            padding: 12px 24px;
            font-size: 1rem;
            border-radius: 6px;
            font-weight: 500;
            color: white;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .btn-cancel {
            background: linear-gradient(90deg, #6c757d, #5a6268);
            border: none;
            padding: 12px 24px;
            font-size: 1rem;
            border-radius: 6px;
            font-weight: 500;
            color: white;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .modal-content {
            border-radius: 8px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
            background: #ffffff;
        }
        .modal-header {
            background: linear-gradient(90deg, #007bff, #0056b3);
            color: #ffffff;
            border-radius: 8px 8px 0 0;
            padding: 15px 20px;
        }
        .question-list {
            max-height: 500px;
            overflow-y: auto;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            padding: 15px;
            background: #f8f9fa;
        }
        .question-item {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            background-color: #ffffff;
            border-radius: 6px;
            margin-bottom: 10px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .question-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .question-item:last-child {
            border-bottom: none;
        }
        .question-item input[type="checkbox"] {
            margin-right: 12px;
            transform: scale(1.2);
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
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 8px;
            font-size: 0.95rem;
        }
        .question-item .option.correct {
            background: linear-gradient(90deg, #d4edda, #c3e6cb);
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .question-item .option.neutral {
            background: #ffffff;
            color: #212529;
            border: 1px solid #dee2e6;
        }
        .selected-questions {
            padding: 15px;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            background: #f8f9fa;
            min-height: 60px;
        }
        .selected-questions p {
            margin: 0;
            color: #6c757d;
            font-size: 0.95rem;
        }
        .question-count {
            font-size: 1rem;
            font-weight: 600;
            color: #1a252f;
            margin-bottom: 12px;
        }
        .error-message {
            color: #dc3545;
            font-size: 0.9rem;
            margin-top: 8px;
        }
        .mandatory::after {
            content: ' *';
            color: #dc3545;
        }
        .alert {
            border-radius: 6px;
            margin-bottom: 20px;
        }
        @media (max-width: 768px) {
            .content {
                padding: 15px;
                margin: 10px;
            }
            h1 {
                font-size: 1.5rem;
            }
            .btn-select-questions, .btn-submit, .btn-cancel {
                width: 100%;
                padding: 10px;
                font-size: 0.9rem;
            }
            .question-list {
                max-height: 350px;
            }
            .question-item {
                padding: 10px;
            }
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
    <script>
        let selectedQuestionIds = [];
        let selectedQuestionTexts = [];

        $(document).ready(function () {
            // Initialize selected questions
            <c:forEach var="question" items="${test.questions}">
            selectedQuestionIds.push('${question.questionId}');
            selectedQuestionTexts.push('Câu hỏi: ${fn:escapeXml(question.content)} (ID: ${question.questionId})');
            </c:forEach>
            updateSelectedQuestions();

            $("#subject").change(function () {
                loadChapters(this.value);
            });
        });

        function loadChapters(subjectId) {
            $('#chapter').html('<option value="">Chọn chương (tùy chọn)</option>');
            $('#subjectError').text('');
            if (!subjectId) {
                loadQuestions();
                return;
            }
            $.ajax({
                url: '/admin/tests/chapters?subjectId=' + subjectId,
                method: 'GET',
                success: function(data) {
                    var options = '<option value="">Chọn chương (tùy chọn)</option>';
                    data.forEach(function(chapter) {
                        options = options + '<option value="' + chapter.chapterId + '">' + chapter.chapterName + '</option>';
                    });
                    $('#chapter').html(options);
                    loadQuestions();
                },
                error: function() {
                    $('#chapter').html('<option value="">Không có chương</option>');
                }
            });
        }

        function loadQuestions() {
            var subjectId = $('#subject').val();
            var chapterId = $('#chapter').val();
            var url = '/admin/tests/questions?subjectId=' + (subjectId || '') + '&chapterId=' + (chapterId || '');
            $.ajax({
                url: url,
                method: 'GET',
                success: function(data) {
                    var html = '';
                    data.forEach(function(question) {
                        var isChecked = selectedQuestionIds.includes(question.questionId.toString()) ? 'checked' : '';
                        html = html + '<div class="question-item">' +
                            '<input type="checkbox" name="modalQuestionIds" value="' + question.questionId + '" ' + isChecked + '>' +
                            '<div>' +
                            '<p><strong>Câu hỏi:</strong> ' + question.content + ' (ID: ' + question.questionId + ')</p>' +
                            '<p class="chapter-info"><strong>Chương:</strong> ' + (question.chapterName || 'Không có chương') + '</p>' +
                            '<div class="options">';
                        question.options.forEach(function(option) {
                            var optionClass = option.isCorrect ? 'correct' : 'neutral';
                            html = html + '<div class="option ' + optionClass + '">' + option.text + '</div>';
                        });
                        html = html + '</div></div></div>';
                    });
                    $('#questionList').html(html || '<p>Không có câu hỏi nào.</p>');
                },
                error: function() {
                    $('#questionList').html('<p>Lỗi khi tải câu hỏi.</p>');
                }
            });
        }

        function confirmQuestions() {
            selectedQuestionIds = [];
            selectedQuestionTexts = [];
            $('#questionList input[name="modalQuestionIds"]:checked').each(function() {
                var questionId = $(this).val();
                var questionText = $(this).parent().find('p:first').text().trim();
                selectedQuestionIds.push(questionId);
                selectedQuestionTexts.push(questionText);
            });
            updateSelectedQuestions();
            $('#questionModal').modal('hide');
        }

        function updateSelectedQuestions() {
            var selectedHtml = '';
            selectedQuestionTexts.forEach(function(text) {
                selectedHtml = selectedHtml + '<p>' + text + '</p>';
            });
            $('#questionCount').html('Đã chọn: ' + selectedQuestionIds.length + ' câu hỏi');
            $('#selectedQuestions').html(selectedHtml || '<p>Chưa có câu hỏi nào được chọn.</p>');

            // Thêm input ẩn để gửi questionIds
            var form = $('#editTestForm');
            form.find('input[name="questionIds"]').remove();
            selectedQuestionIds.forEach(function(id) {
                form.append('<input type="hidden" name="questionIds" value="' + id + '">');
            });
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
            if (!startAt) {
                $('#startAtError').text('Thời gian bắt đầu là bắt buộc.');
                isValid = false;
            }

            var endAt = $('#endAt').val();
            if (!endAt) {
                $('#endAtError').text('Thời gian kết thúc là bắt buộc.');
                isValid = false;
            } else if (startAt && new Date(endAt) <= new Date(startAt)) {
                $('#endAtError').text('Thời gian kết thúc phải sau thời gian bắt đầu.');
                isValid = false;
            }

            var testStatus = $('#testStatus').val();
            if (!testStatus) {
                $('#testStatusError').text('Trạng thái là bắt buộc.');
                isValid = false;
            }

            var testCategory = $('#testCategory').val();
            if (!testCategory) {
                $('#testCategoryError').text('Danh mục là bắt buộc.');
                isValid = false;
            }

            var subjectId = $('#subject').val();
            var chapterId = $('#chapter').val();
            if (!subjectId && !chapterId) {
                $('#subjectError').text('Phải chọn ít nhất một môn học hoặc chương.');
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
                        <h1>Chỉnh Sửa Bài Kiểm Tra</h1>
                        <hr/>
                        <form id="editTestForm" action="/admin/tests/edit/${test.testId}" method="post" onsubmit="return validateForm()">
                            <c:if test="${not empty success}">
                                <div class="alert alert-success">${success}</div>
                            </c:if>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">${error}</div>
                            </c:if>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="testName" class="form-label mandatory">Tên bài kiểm tra</label>
                                        <input type="text" class="form-control" id="testName" name="testName" value="${fn:escapeXml(test.testName)}" required>
                                        <div id="testNameError" class="error-message"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="durationTime" class="form-label mandatory">Thời gian (phút)</label>
                                        <input type="number" class="form-control" id="durationTime" name="durationTime" value="${test.durationTime}" required min="1">
                                        <div id="durationTimeError" class="error-message"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="startAt" class="form-label mandatory">Thời gian bắt đầu</label>
                                        <input type="datetime-local" class="form-control" id="startAt" name="startAt" value="${test.startAt}" required>
                                        <div id="startAtError" class="error-message"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="endAt" class="form-label mandatory">Thời gian kết thúc</label>
                                        <input type="datetime-local" class="form-control" id="endAt" name="endAt" value="${test.endAt}" required>
                                        <div id="endAtError" class="error-message"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="testStatus" class="form-label mandatory">Trạng thái</label>
                                        <select class="form-select" id="testStatus" name="testStatusId" required>
                                            <option value="">Chọn trạng thái</option>
                                            <c:forEach var="status" items="${testStatuses}">
                                                <option value="${status.testStatusId}" ${status.testStatusId == test.testStatus.testStatusId ? 'selected' : ''}>${fn:escapeXml(status.statusName)}</option>
                                            </c:forEach>
                                        </select>
                                        <div id="testStatusError" class="error-message"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="testCategory" class="form-label mandatory">Danh mục</label>
                                        <select class="form-select" id="testCategory" name="testCategoryId" required>
                                            <option value="">Chọn danh mục</option>
                                            <c:forEach var="category" items="${testCategories}">
                                                <option value="${category.testCategoryId}" ${category.testCategoryId == test.testCategory.testCategoryId ? 'selected' : ''}>${fn:escapeXml(category.categoryName)}</option>
                                            </c:forEach>
                                        </select>
                                        <div id="testCategoryError" class="error-message"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="subject" class="form-label mandatory">Môn học</label>
                                        <select class="form-select" id="subject" name="subjectId" onchange="loadChapters(this.value)">
                                            <option value="">Chọn môn học</option>
                                            <c:forEach var="subject" items="${subjects}">
                                                <option value="${subject.subjectId}" ${subject.subjectId == test.subjectName ? 'selected' : ''}>${fn:escapeXml(subject.subjectName)}</option>
                                            </c:forEach>
                                        </select>
                                        <div id="subjectError" class="error-message"></div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="chapter" class="form-label">Chương</label>
                                        <select class="form-select" id="chapter" name="chapterId">
                                            <option value="">Chọn chương (tùy chọn)</option>
                                            <c:forEach var="chapter" items="${chapters}">
                                                <option value="${chapter.chapterId}" ${chapter.chapterId == test.chapterName ? 'selected' : ''}>${fn:escapeXml(chapter.chapterName)}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="mb-3">
                                        <label class="form-label mandatory">Câu hỏi đã chọn</label>
                                        <div class="question-count" id="questionCount">Đã chọn: ${test.questions.size()} câu hỏi</div>
                                        <div class="selected-questions" id="selectedQuestions">
                                            <c:forEach var="question" items="${test.questions}">
                                                <p>Câu hỏi: ${fn:escapeXml(question.content)} (ID: ${question.questionId})</p>
                                            </c:forEach>
                                        </div>
                                        <button type="button" class="btn btn-select-questions" data-bs-toggle="modal" data-bs-target="#questionModal">Chọn câu hỏi</button>
                                        <div id="questionsError" class="error-message"></div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="d-flex gap-2 mb-3">
                                        <button type="submit" class="btn btn-submit">Cập nhật</button>
                                        <a href="/admin/tests/list" class="btn btn-cancel">Hủy</a>
                                    </div>
                                </div>
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
</body>
</html>