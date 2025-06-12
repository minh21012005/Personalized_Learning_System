<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Bắt đầu luyện tập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body { margin: 0; min-height: 100vh; display: flex; flex-direction: column; font-family: Arial, sans-serif; }
        .main-container { display: flex; flex: 1; }
        .content { flex: 1; padding: 20px; background-color: #f8f9fa; }
        .form-container { background: #fff; border-radius: 0.5rem; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); padding: 2rem; max-width: 600px; margin: 0 auto; }
        .checkbox-group { max-height: 200px; overflow-y: auto; border: 1px solid #ced4da; border-radius: 0.25rem; padding: 10px; }
        .checkbox-group label { display: block; margin-bottom: 5px; }
        .mandatory::after { content: "*"; color: red; margin-left: 5px; }
    </style>
</head>
<body>
<header><jsp:include page="../layout/header.jsp"/></header>
<div class="main-container">
    <div class="content">
        <main>
            <div class="container-fluid">
                <div style="margin-top: 100px;">
                    <div class="form-container">
                        <h1 class="mb-4 fw-bold">Bắt đầu luyện tập</h1>
                        <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>
                        <form action="/practice/start-practice" method="get" id="practiceForm">
                            <div class="form-group mb-3">
                                <label class="form-label mandatory">Chọn môn học</label>
                                <select name="subjectId" id="subjectId" class="form-select" required>
                                    <option value="">-- Chọn --</option>
                                    <c:forEach var="subject" items="${subjects}">
                                        <option value="${subject.subjectId}">${subject.subjectName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group mb-3">
                                <label class="form-label mandatory">Chọn bài học</label>
                                <div class="checkbox-group" id="lessonGroup">
                                    <!-- Lessons populated via AJAX -->
                                </div>
                            </div>
                            <div class="form-group mb-3">
                                <label class="form-label">Chọn mức độ</label>
                                <div class="checkbox-group" id="levelGroup">
                                    <c:forEach var="level" items="${levels}">
                                        <label><input type="checkbox" name="levelIds" value="${level.levelQuestionId}"> ${level.levelQuestionName}</label>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="form-group mb-3">
                                <label class="form-label mandatory">Số lượng câu hỏi</label>
                                <input type="number" name="questionCount" class="form-control" min="1" max="50" value="10" required>
                            </div>
                            <button type="submit" class="btn btn-primary">Bắt đầu</button>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
<footer><jsp:include page="../layout/footer.jsp"/></footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function () {
        // When subject changes, fetch lessons
        $('#subjectId').change(function () {
            var subjectId = $(this).val();
            if (subjectId) {
                loadLessons(subjectId);
            } else {
                $('#lessonGroup').empty();
            }
        });

        // Load lessons via API
        function loadLessons(subjectId) {
            $.ajax({
                url: '/practice/api/lessons-by-subject/' + subjectId,
                method: 'GET',
                success: function (data) {
                    var lessonGroup = $('#lessonGroup').empty();
                    if (data.length === 0) {
                        lessonGroup.append('<p>Không có bài học nào.</p>');
                        return;
                    }
                    $.each(data, function (index, lesson) {
                        lessonGroup.append(
                            '<label><input type="checkbox" name="lessonIds" value="' + lesson.lessonId + '"> ' + lesson.lessonName + '</label>'
                        );
                    });
                    addCheckboxValidation('lessonIds');
                },
                error: function () {
                    $('#lessonGroup').html('<p>Lỗi khi tải bài học.</p>');
                }
            });
        }

        // Validate lesson checkboxes (at least one must be checked)
        function addCheckboxValidation(name) {
            var checkboxes = $('input[name="' + name + '"]');
            checkboxes.on('change', function () {
                var checked = checkboxes.filter(':checked').length > 0;
                checkboxes.prop('required', !checked);
            });
        }

        // Form submission validation
        $('#practiceForm').submit(function (event) {
            var lessonChecked = $('input[name="lessonIds"]:checked').length > 0;
            if (!lessonChecked) {
                event.preventDefault();
                alert('Vui lòng chọn ít nhất một bài học.');
            }
        });
    });
</script>
</body>
</html>