<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PLS - Chỉnh sửa câu hỏi</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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

        .form-container {
            background: #fff;
            border-radius: 0.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            padding: 2rem;
            max-width: 900px;
            margin: 0 auto;
        }

        .option-group {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 0.25rem;
            margin-bottom: 1rem;
            border: 1px solid #dee2e6;
        }

        .preview {
            background: #e9ecef;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
            padding: 0.75rem;
            margin-top: 0.5rem;
            min-height: 2rem;
        }

        .image-preview {
            max-width: 200px;
            max-height: 200px;
            border-radius: 0.25rem;
            margin-left: 1rem;
            display: none;
            object-fit: contain;
        }

        .mandatory::after {
            content: ' *';
            color: #dc3545;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
    <script>
        var optionCount = <c:out value="${fn:length(submittedOptions != null ? submittedOptions : options)}"/>;

        $(document).ready(function () {
            // Populate dependent dropdowns on page load
            var gradeId = $("#gradeId").val();
            var subjectId = $("#subjectId").val();
            var chapterId = $("#chapterId").val();

            if (gradeId) {
                $.get("/api/subjects-by-grade/" + gradeId)
                    .done(function (data) {
                        var subjectSelect = $("#subjectId");
                        subjectSelect.empty();
                        subjectSelect.append('<option value="">-- Chọn --</option>');
                        data.forEach(function (subject) {
                            subjectSelect.append('<option value="' + (subject ? subject.subjectId : '') + '"' +
                                (subject.subjectId == subjectId ? ' selected' : '') + '>' +
                                (subject ? subject.subjectName : '') + '</option>');
                        });
                        if (subjectId) {
                            loadChapters(subjectId, chapterId);
                        }
                    });
            }

            function loadChapters(subjectId, selectedChapterId) {
                $.get("/api/chapters-by-subject/" + subjectId)
                    .done(function (data) {
                        var chapterSelect = $("#chapterId");
                        chapterSelect.empty();
                        chapterSelect.append('<option value="">-- Chọn --</option>');
                        data.forEach(function (chapter) {
                            chapterSelect.append('<option value="' + chapter.chapterId + '"' +
                                (chapter.chapterId == selectedChapterId ? ' selected' : '') + '>' +
                                chapter.chapterName + '</option>');
                        });
                        if (selectedChapterId) {
                            loadLessons(selectedChapterId, $("#lessonId").val());
                        }
                    });
            }

            function loadLessons(chapterId, selectedLessonId) {
                $.get("/api/lessons-by-chapter/" + chapterId)
                    .done(function (data) {
                        var lessonSelect = $("#lessonId");
                        lessonSelect.empty();
                        lessonSelect.append('<option value="">-- Chọn --</option>');
                        data.forEach(function (lesson) {
                            lessonSelect.append('<option value="' + lesson.lessonId + '"' +
                                (lesson.lessonId == selectedLessonId ? ' selected' : '') + '>' +
                                lesson.lessonName + '</option>');
                        });
                    });
            }

            $("#gradeId").change(function () {
                var gradeId = $(this).val();
                if (gradeId) {
                    $.get("/api/subjects-by-grade/" + gradeId)
                        .done(function (data) {
                            var subjectSelect = $("#subjectId");
                            subjectSelect.empty();
                            subjectSelect.append('<option value="">-- Chọn --</option>');
                            data.forEach(function (subject) {
                                subjectSelect.append('<option value="' + (subject ? subject.subjectId : '') + '">' +
                                    (subject ? subject.subjectName : '') + '</option>');
                            });
                            $("#chapterId").empty().append('<option value="">-- Chọn --</option>');
                            $("#lessonId").empty().append('<option value="">-- Chọn --</option>');
                        })
                        .fail(function () {
                            alert('Không thể tải danh sách môn học. Vui lòng thử lại.');
                        });
                } else {
                    $("#subjectId").empty().append('<option value="">-- Chọn --</option>');
                    $("#chapterId").empty().append('<option value="">-- Chọn --</option>');
                    $("#lessonId").empty().append('<option value="">-- Chọn --</option>');
                }
            });

            $("#subjectId").change(function () {
                var subjectId = $(this).val();
                if (subjectId) {
                    $.get("/api/chapters-by-subject/" + subjectId)
                        .done(function (data) {
                            var chapterSelect = $("#chapterId");
                            chapterSelect.empty();
                            chapterSelect.append('<option value="">-- Chọn --</option>');
                            data.forEach(function (chapter) {
                                chapterSelect.append('<option value="' + chapter.chapterId + '">' +
                                    chapter.chapterName + '</option>');
                            });
                            $("#lessonId").empty().append('<option value="">-- Chọn --</option>');
                        })
                        .fail(function () {
                            alert('Không thể tải danh sách chương. Vui lòng thử lại.');
                        });
                } else {
                    $("#chapterId").empty().append('<option value="">-- Chọn --</option>');
                    $("#lessonId").empty().append('<option value="">-- Chọn --</option>');
                }
            });

            $("#chapterId").change(function () {
                var chapterId = $(this).val();
                if (chapterId) {
                    $.get("/api/lessons-by-chapter/" + chapterId)
                        .done(function (data) {
                            var lessonSelect = $("#lessonId");
                            lessonSelect.empty();
                            lessonSelect.append('<option value="">-- Chọn --</option>');
                            data.forEach(function (lesson) {
                                lessonSelect.append('<option value="' + lesson.lessonId + '">' +
                                    lesson.lessonName + '</option>');
                            });
                        })
                        .fail(function () {
                            alert('Không thể tải danh sách bài học. Vui lòng thử lại.');
                        });
                } else {
                    $("#lessonId").empty().append('<option value="">-- Chọn --</option>');
                }
            });

            $("#imageInput").change(function () {
                var file = this.files[0];
                var imagePreview = $("#imagePreview");
                var allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
                var maxSize = 5 * 1024 * 1024; // 5MB

                if (file) {
                    var fileExtension = file.name.split('.').pop().toLowerCase();
                    if (!allowedExtensions.includes(fileExtension)) {
                        alert('Chỉ được phép tải lên file ảnh định dạng JPG, JPEG, PNG hoặc GIF.');
                        this.value = '';
                        imagePreview.hide();
                        return;
                    }
                    if (file.size > maxSize) {
                        alert('Kích thước file ảnh không được vượt quá 5MB.');
                        this.value = '';
                        imagePreview.hide();
                        return;
                    }
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        imagePreview.attr('src', e.target.result).show();
                    };
                    reader.readAsDataURL(file);
                } else {
                    imagePreview.hide();
                }
            });

            window.addOption = function () {
                optionCount++;
                var optionsContainer = document.getElementById("optionsContainer");
                var optionGroup = document.createElement("div");
                optionGroup.className = "option-group mb-3";
                optionGroup.id = "optionGroup" + optionCount;

                optionGroup.innerHTML = '<label class="form-label fw-semibold">Đáp án ' + optionCount + '</label>' +
                    '<textarea name="options" class="option-content form-control" data-index="' + (optionCount - 1) + '" placeholder="Nhập đáp án ' + optionCount + '"></textarea>' +
                    '<div class="d-flex align-items-center gap-2 mt-2">' +
                    '<div class="form-check">' +
                    '<input type="checkbox" name="isCorrect" value="' + (optionCount - 1) + '" class="form-check-input"/>' +
                    '<label class="form-check-label">Đúng</label>' +
                    '</div>' +
                    '<button type="button" onclick="removeOption(' + optionCount + ')" class="btn btn-danger btn-sm">Xóa</button>' +
                    '</div>' +
                    '<div class="preview" id="preview' + optionCount + '"></div>';

                optionsContainer.appendChild(optionGroup);

                $('.option-content[data-index="' + (optionCount - 1) + '"]').on('input', function () {
                    var index = $(this).data('index');
                    var value = $(this).val().replace(/\n/g, '<br>');
                    $('#preview' + (index + 1)).html(value);
                    MathJax.typesetPromise();
                });
            };

            window.removeOption = function (index) {
                var options = document.querySelectorAll("#optionsContainer .option-group");
                if (options.length > 2) {
                    var optionGroup = document.getElementById("optionGroup" + index);
                    if (optionGroup) {
                        optionGroup.remove();
                        optionCount--;
                        reindexOptions();
                    }
                } else {
                    alert('Phải có ít nhất 2 đáp án.');
                }
            };

            window.reindexOptions = function () {
                var options = document.querySelectorAll("#optionsContainer .option-group");
                options.forEach(function (option, index) {
                    var newIndex = index + 1;
                    option.id = "optionGroup" + newIndex;
                    option.querySelector("label").textContent = "Đáp án " + newIndex;
                    var textarea = option.querySelector('textarea');
                    textarea.placeholder = "Nhập đáp án " + newIndex;
                    textarea.setAttribute('data-index', index);
                    option.querySelector('input[type="checkbox"]').value = index;
                    option.querySelector("button").setAttribute("onclick", "removeOption(" + newIndex + ")");
                    var preview = option.querySelector('.preview');
                    preview.id = "preview" + newIndex;
                });
                optionCount = options.length;
            };

            $('.option-content').each(function () {
                var index = $(this).data('index');
                $(this).on('input', function () {
                    var value = $(this).val().replace(/\n/g, '<br>');
                    $('#preview' + (index + 1)).html(value);
                    MathJax.typesetPromise();
                });
                // Initial preview rendering
                var value = $(this).val().replace(/\n/g, '<br>');
                $('#preview' + (index + 1)).html(value);
            });

            var contentTextarea = document.querySelector('textarea[name="content"]');
            var previewDiv = document.createElement("div");
            previewDiv.className = 'preview';
            previewDiv.id = 'contentPreview';
            contentTextarea.parentNode.insertAdjacentElement('afterend', previewDiv);

            contentTextarea.addEventListener('input', function () {
                var content = this.value.replace(/\n/g, '<br>');
                document.getElementById('contentPreview').innerHTML = content;
                MathJax.typesetPromise();
            });
            // Initial content preview
            var content = contentTextarea.value.replace(/\n/g, '<br>');
            document.getElementById('contentPreview').innerHTML = content;

            MathJax.typeset();
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
            <div class="container-fluid">
                <div class="mt-4">
                    <div class="form-container">
                        <h1 class="mb-4 fw-bold">Chỉnh sửa câu hỏi</h1>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">${success}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <form:form modelAttribute="question" method="post"
                                   action="/staff/questions/update/${question.questionId}"
                                   enctype="multipart/form-data" class="needs-validation">
                            <div class="form-group mb-3">
                                <label class="form-label mandatory">Khối</label>
                                <select id="gradeId" name="gradeId" class="form-select" required>
                                    <option value="">-- Chọn --</option>
                                    <c:forEach items="${grades}" var="grade">
                                        <option value="${grade.gradeId}" ${grade.gradeId == (submittedGradeId != null ? submittedGradeId : question.grade.gradeId) ? 'selected' : ''}>${grade.gradeName}</option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">Vui lòng chọn khối.</div>
                            </div>

                            <div class="form-group mb-3">
                                <label class="form-label mandatory">Môn học</label>
                                <select id="subjectId" name="subjectId" class="form-select" required>
                                    <option value="">-- Chọn --</option>
                                    <c:forEach items="${subjects}" var="subject">
                                        <option value="${subject.subjectId}" ${subject.subjectId == (submittedSubjectId != null ? submittedSubjectId : question.subject.subjectId) ? 'selected' : ''}>${subject.subjectName}</option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">Vui lòng chọn môn học.</div>
                            </div>

                            <div class="form-group mb-3">
                                <label class="form-label mandatory">Chương</label>
                                <select id="chapterId" name="chapterId" class="form-select" required>
                                    <option value="">-- Chọn --</option>
                                    <c:forEach items="${chapters}" var="chapter">
                                        <option value="${chapter.chapterId}" ${chapter.chapterId == (submittedChapterId != null ? submittedChapterId : question.chapter.chapterId) ? 'selected' : ''}>${chapter.chapterName}</option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">Vui lòng chọn chương.</div>
                            </div>

                            <div class="form-group mb-3">
                                <label class="form-label mandatory">Bài học</label>
                                <select id="lessonId" name="lessonId" class="form-select" required>
                                    <option value="">-- Chọn --</option>
                                    <c:forEach items="${lessons}" var="lesson">
                                        <option value="${lesson.lessonId}" ${lesson.lessonId == (submittedLessonId != null ? submittedLessonId : question.lesson.lessonId) ? 'selected' : ''}>${lesson.lessonName}</option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">Vui lòng chọn bài học.</div>
                            </div>

                            <div class="form-group mb-3">
                                <label class="form-label mandatory">Nội dung câu hỏi</label>
                                <form:textarea path="content"
                                               placeholder="Nhập nội dung câu hỏi (dùng \$...\$ cho công thức toán, ví dụ: \$x^2 + y^2 = z^2\$)"
                                               class="form-control" rows="5"
                                               value="${submittedContent != null ? submittedContent : question.content}"/>
                                <div class="preview" id="contentPreview"></div>
                                <div class="invalid-feedback">Vui lòng nhập nội dung câu hỏi.</div>
                            </div>

                            <div class="form-group mb-3 d-flex align-items-center">
                                <div>
                                    <label class="form-label">Hình ảnh (tùy chọn)</label>
                                    <input type="file" id="imageInput" name="image"
                                           accept="image/jpeg,image/png,image/gif" class="form-control"/>
                                    <c:if test="${not empty question.image}">
                                        <small class="form-text text-muted">Hình ảnh hiện tại: ${question.image}</small>
                                        <img src="/img/question_bank/${question.image}"
                                             class="image-preview mt-2" alt="Hình ảnh hiện tại"
                                             style="display: block;"/>
                                    </c:if>
                                </div>
                                <img id="imagePreview" class="image-preview" alt="Ảnh xem trước"/>
                            </div>

                            <div id="optionsContainer">
                                <c:choose>
                                    <c:when test="${not empty submittedOptions}">
                                        <c:forEach items="${submittedOptions}" var="option" varStatus="status">
                                            <div class="option-group mb-3" id="optionGroup${status.count}">
                                                <label class="form-label fw-semibold">Đáp án ${status.count}</label>
                                                <textarea name="options" class="option-content form-control"
                                                          data-index="${status.index}"
                                                          placeholder="Nhập đáp án ${status.count}"><c:out
                                                        value="${option}"/></textarea>
                                                <div class="d-flex align-items-center gap-2 mt-2">
                                                    <div class="form-check">
                                                        <input type="checkbox" name="isCorrect" value="${status.index}"
                                                               class="form-check-input" ${submittedIsCorrect[status.index] ? 'checked' : ''}/>
                                                        <label class="form-check-label">Đúng</label>
                                                    </div>
                                                    <button type="button" onclick="removeOption(${status.count})"
                                                            class="btn btn-danger btn-sm">Xóa
                                                    </button>
                                                </div>
                                                <div class="preview" id="preview${status.count}"><c:out
                                                        value="${option}" escapeXml="false"/></div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${options}" var="option" varStatus="status">
                                            <div class="option-group mb-3" id="optionGroup${status.count}">
                                                <label class="form-label fw-semibold">Đáp án ${status.count}</label>
                                                <textarea name="options" class="option-content form-control"
                                                          data-index="${status.index}"
                                                          placeholder="Nhập đáp án ${status.count}"><c:out
                                                        value="${option.text}"/></textarea>
                                                <div class="d-flex align-items-center gap-2 mt-2">
                                                    <div class="form-check">
                                                        <input type="checkbox" name="isCorrect" value="${status.index}"
                                                               class="form-check-input" ${option.correct ? 'checked' : ''}/>
                                                        <label class="form-check-label">Đúng</label>
                                                    </div>
                                                    <button type="button" onclick="removeOption(${status.count})"
                                                            class="btn btn-danger btn-sm">Xóa
                                                    </button>
                                                </div>
                                                <div class="preview" id="preview${status.count}"><c:out
                                                        value="${option.text}" escapeXml="false"/></div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="form-group mb-3">
                                <button type="button" class="btn btn-success" onclick="addOption()">Thêm đáp án</button>
                            </div>

                            <div class="form-group mb-3">
                                <label class="form-label mandatory">Mức độ</label>
                                <form:select path="levelQuestion.levelQuestionId" class="form-select" required="true">
                                    <form:option value="">-- Chọn --</form:option>
                                    <form:options items="${levels}" itemValue="levelQuestionId"
                                                  itemLabel="levelQuestionName"/>
                                </form:select>
                                <div class="invalid-feedback">Vui lòng chọn mức độ.</div>
                            </div>

                            <div class="form-group mb-3">
                                <label class="form-label">Trạng thái</label>
                                <div class="d-flex gap-3">
                                    <div class="form-check">
                                        <form:radiobutton path="active" value="true" class="form-check-input"
                                                          label="Kích hoạt"/>
                                    </div>
                                    <div class="form-check">
                                        <form:radiobutton path="active" value="false" class="form-check-input"
                                                          label="Vô hiệu hóa"/>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group mb-3">
                                <label class="form-label">Hiển thị cuối bài học</label>
                                <div class="form-check">
                                    <form:checkbox path="displayAtEndOfLesson" class="form-check-input"/>
                                    <label class="form-check-label">Có</label>
                                </div>
                            </div>

                            <div class="d-flex gap-2 mb-3">
                                <button type="submit" class="btn btn-primary">Lưu</button>
                                <a href="/staff/questions" class="btn btn-secondary">Hủy</a>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Footer -->
<footer>
    <jsp:include page="../layout_staff/footer.jsp"/>
</footer>
</body>
</html>
