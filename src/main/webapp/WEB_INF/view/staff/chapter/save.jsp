<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!doctype html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><spring:message code="${isEdit ? 'chapter.edit.title' : 'chapter.create.title'}"/></title>
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
        .card-footer {
            position: sticky;
            bottom: 0;
            background: white;
            padding: 10px;
            border-top: 1px solid #dee2e6;
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
                            <h5 class="mb-0"><spring:message code="${isEdit ? 'chapter.edit.title' : 'chapter.create.title'}" arguments="${subject.subjectName}"/></h5>
                            <a href="<c:url value='/staff/subject/${subject.subjectId}/chapters'/>" class="btn btn-secondary btn-sm">
                                <i class="fas fa-arrow-left"></i> <spring:message code="button.back"/>
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <%-- Giả định errorMessage chứa key của message property --%>
                                <spring:message code="${errorMessage}"/>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form:form method="post"
                                   action="${isEdit ? '/staff/subject/'.concat(subject.subjectId).concat('/chapters/').concat(chapter.chapterId) : '/staff/subject/'.concat(subject.subjectId).concat('/chapters')}"
                                   modelAttribute="chapter" cssClass="needs-validation mt-4" id="chapterForm" novalidate="novalidate">
                            <form:hidden path="chapterId"/>
                            <form:hidden path="subjectId"/>
                            <div class="mb-3">
                                <form:label path="chapterName" cssClass="form-label"><spring:message code="chapter.list.name"/> <span class="text-danger">*</span></form:label>
                                <form:input type="text" id="chapterNameInput" path="chapterName"
                                            cssClass="form-control ${status.error ? 'is-invalid' : ''}"
                                            placeholder="Nhập tên chương" required="required"/>
                                    <%-- Sử dụng <form:errors> để hiển thị lỗi validation cụ thể cho trường chapterName --%>
                                <form:errors path="chapterName" cssClass="invalid-feedback d-block"/>
                            </div>
                            <div class="mb-3">
                                <form:label path="chapterDescription" cssClass="form-label"><spring:message code="chapter.list.description"/></form:label>
                                <form:textarea id="chapterDescriptionInput" path="chapterDescription"
                                               cssClass="form-control ${status.error ? 'is-invalid' : ''}"
                                               rows="6" maxlength="1000" placeholder="Nhập mô tả (tối đa 1000 ký tự)"/>
                                <form:errors path="chapterDescription" cssClass="invalid-feedback d-block"/>
                            </div>
                            <div class="card-footer">
                                <div class="d-flex gap-2 justify-content-end">
                                    <button type="submit" class="btn btn-primary"><spring:message code="${isEdit ? 'button.edit' : 'button.save'}"/></button>
                                    <a href="<c:url value='/staff/subject/${subject.subjectId}/chapters'/>" class="btn btn-secondary"><spring:message code="button.cancel"/></a>
                                </div>
                            </div>
                        </form:form>
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
<script>
    (function () {
        'use strict';
        var forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>
</body>
</html>