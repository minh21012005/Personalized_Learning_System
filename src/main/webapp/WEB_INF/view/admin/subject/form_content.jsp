<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="row justify-content-center">
    <div class="col-md-10 col-lg-8">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">${pageTitle != null ? pageTitle : 'Form môn học'}</h3>
            </div>
            <div class="card-body">
                <!-- Hiển thị thông báo nếu môn học đã được giao -->
                <c:if test="${not empty assignedTo and assignedTo != ''}">
                    <div class="alert alert-info">
                        Môn học này đã được giao cho ${assignedTo}
                    </div>
                </c:if>

                <!-- Hiển thị thông báo lỗi toàn cục nếu có -->
                <c:if test="${not empty errorMessageGlobal}">
                    <div class="alert alert-danger">
                        <c:out value="${errorMessageGlobal}"/>
                    </div>
                </c:if>

                <form:form modelAttribute="subject" action="${pageContext.request.contextPath}/admin/subject/save" method="post" enctype="multipart/form-data" cssClass="needs-validation" novalidate="novalidate">
                    <form:hidden path="subjectId"/>

                    <div class="mb-3">
                        <form:label path="subjectName" cssClass="form-label">Tên môn học <span class="text-danger">*</span></form:label>
                        <form:input path="subjectName" cssClass="form-control ${status.hasError('subjectName') ? 'is-invalid' : ''}" required="required" value="${not empty subject.subjectName ? subject.subjectName : ''}"/>
                        <form:errors path="subjectName" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="mb-3">
                        <form:label path="subjectDescription" cssClass="form-label">Mô tả</form:label>
                        <form:textarea path="subjectDescription" cssClass="form-control ${status.hasError('subjectDescription') ? 'is-invalid' : ''}" rows="3" value="${not empty subject.subjectDescription ? subject.subjectDescription : ''}"/>
                        <form:errors path="subjectDescription" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="mb-3">
                        <form:label path="gradeId" cssClass="form-label">Khối lớp <span class="text-danger">*</span></form:label>
                        <form:select path="gradeId" cssClass="form-select ${status.hasError('gradeId') ? 'is-invalid' : ''}" required="required">
                            <form:option value="" label="-- Chọn khối lớp --"/>
                            <c:forEach var="grade" items="${grades}">
                                <form:option value="${grade.gradeId}" label="${grade.gradeName}" selected="${grade.gradeId == subject.gradeId ? 'selected' : ''}"/>
                            </c:forEach>
                        </form:select>
                        <form:errors path="gradeId" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="mb-3">
                        <label for="imageFile" class="form-label">Hình ảnh</label>
                        <input type="file" name="imageFile" class="form-control ${not empty imageFileError ? 'is-invalid' : ''}" id="imageFile" accept="image/*" />
                        <small class="form-text text-muted">Chọn hình ảnh đại diện cho môn học</small>
                        <c:if test="${not empty imageFileError}">
                            <div class="invalid-feedback d-block"><c:out value="${imageFileError}"/></div>
                        </c:if>

                        <c:if test="${not empty currentSubjectImage and currentSubjectImage != ''}">
                            <div class="mt-2">
                                <p class="mb-1">Hình ảnh hiện tại</p>
                                <img src="/img/subjectImg/<c:out value='${currentSubjectImage}'/>"
                                     alt="Hình ảnh hiện tại" class="current-img-preview img-thumbnail" style="max-width: 150px; max-height: 150px;"/>
                            </div>
                        </c:if>
                        <c:if test="${empty currentSubjectImage or currentSubjectImage == ''}">
                            <div class="mt-2 text-muted">Không có hình ảnh</div>
                        </c:if>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <a href="<c:url value='/admin/subject'/>" class="btn btn-outline-secondary me-md-2">
                            <i class="fas fa-times-circle"></i> Hủy
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Lưu môn học
                        </button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</div>

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