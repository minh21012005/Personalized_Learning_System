<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>${isEdit ? 'Chỉnh sửa chương' : 'Thêm chương'}</title>
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
    <jsp:include page="../../admin/layout/header.jsp"/>
</header>

<div class="main-container">
    <div class="sidebar d-flex flex-column">
        <jsp:include page="../../admin/layout/sidebar.jsp"/>
    </div>
    <div class="content">
        <main>
            <div class="container px-4">
                <div class="card mt-4">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">${isEdit ? 'Chỉnh sửa chương' : 'Thêm chương'} trong ${subject.subjectName}</h5>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form:form method="post" action="${isEdit ? '/staff/subject/'.concat(subjectId).concat('/chapters/').concat(chapter.chapterId) : '/staff/subject/'.concat(subjectId).concat('/chapters')}"
                                   modelAttribute="chapter" class="mt-4" id="chapterForm">
                            <c:if test="${isEdit}">
                                <input type="hidden" name="_method" value="PUT"/>
                            </c:if>
                            <form:hidden path="chapterId"/>
                            <div class="row mb-3">
                                <label for="chapterNameInput" class="col-sm-3 col-form-label">Tên chương</label>
                                <div class="col-sm-9">
                                    <c:set var="errorChapterName"><form:errors path="chapterName" cssClass="invalid-feedback"/></c:set>
                                    <form:input type="text" id="chapterNameInput" path="chapterName"
                                                class="form-control ${not empty errorChapterName ? 'is-invalid' : ''}"
                                                placeholder="Nhập tên chương"/>
                                        ${errorChapterName}
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label for="chapterDescriptionInput" class="col-sm-3 col-form-label">Mô tả chương</label>
                                <div class="col-sm-9">
                                    <c:set var="errorChapterDescription"><form:errors path="chapterDescription" cssClass="invalid-feedback"/></c:set>
                                    <form:textarea id="chapterDescriptionInput" path="chapterDescription"
                                                   class="form-control ${not empty errorChapterDescription ? 'is-invalid' : ''}"
                                                   rows="6" maxlength="1000" placeholder="Nhập mô tả (tối đa 1000 ký tự)"/>
                                        ${errorChapterDescription}
                                </div>
                            </div>
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label">Trạng thái</label>
                                <div class="col-sm-9">
                                    <div class="d-flex gap-3">
                                        <div class="form-check">
                                            <form:radiobutton path="status" value="true" id="statusActive"
                                                              cssClass="form-check-input" checked="${isEdit && chapter.status ? 'checked' : !isEdit ? 'checked' : ''}"/>
                                            <label class="form-check-label" for="statusActive">Hoạt động</label>
                                        </div>
                                        <div class="form-check">
                                            <form:radiobutton path="status" value="false" id="statusInactive"
                                                              cssClass="form-check-input" checked="${isEdit && !chapter.status ? 'checked' : ''}"/>
                                            <label class="form-check-label" for="statusInactive">Không hoạt động</label>
                                        </div>
                                    </div>
                                    <form:errors path="status" cssClass="invalid-feedback d-block"/>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="d-flex gap-2 justify-content-end">
                                    <button type="submit" class="btn btn-primary">${isEdit ? 'Cập nhật' : 'Lưu'}</button>
                                    <a href="/staff/subject/${subjectId}/chapters" class="btn btn-secondary">Hủy</a>
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
    <jsp:include page="../../admin/layout/footer.jsp"/>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>