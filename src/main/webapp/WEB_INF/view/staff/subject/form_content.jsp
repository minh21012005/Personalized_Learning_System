<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="row justify-content-center">
    <div class="col-md-10 col-lg-8">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                
                <h3 class="mb-0"><spring:message code="${pageTitle}" text="${pageTitle != null ? pageTitle : 'Subject Form'}"/></h3>
            </div>
            <div class="card-body">
                <form:form modelAttribute="subject" action="${pageContext.request.contextPath}/admin/subject/save" method="post" enctype="multipart/form-data" cssClass="needs-validation" novalidate="novalidate">
                    <form:hidden path="subjectId"/> 

                    <div class="mb-3">
                        <form:label path="subjectName" cssClass="form-label"><spring:message code="subject.form.name.label"/> <span class="text-danger">*</span></form:label>
                        <form:input path="subjectName" cssClass="form-control ${status.hasError('subjectName') ? 'is-invalid' : ''}" required="required"/>
                        <form:errors path="subjectName" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="mb-3">
                        <form:label path="subjectDescription" cssClass="form-label"><spring:message code="subject.form.description.label"/></form:label>
                        <form:textarea path="subjectDescription" cssClass="form-control ${status.hasError('subjectDescription') ? 'is-invalid' : ''}" rows="3"/>
                        <form:errors path="subjectDescription" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="mb-3">
                        <form:label path="grade.gradeId" cssClass="form-label"><spring:message code="subject.form.grade.label"/> <span class="text-danger">*</span></form:label>

                        <form:select path="grade.gradeId" cssClass="form-select ${status.hasError('grade') || status.hasError('grade.gradeId') ? 'is-invalid' : ''}" required="required">
                            <spring:message code="subject.form.grade.select" var="selectGradeLabelText" text="-- Select Grade --"/>
                            <form:option value="" label="-- ${selectGradeLabelText} --"/>
                            <form:options items="${grades}" itemValue="gradeId" itemLabel="gradeName"/>
                        </form:select>
                        <form:errors path="grade" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="mb-3">
                        <label for="imageFile" class="form-label"><spring:message code="subject.form.image.label"/></label>
                        <input type="file" name="imageFile" class="form-control ${not empty imageFileError ? 'is-invalid' : ''}" id="imageFile" accept="image/*" />
                        <small class="form-text text-muted"><spring:message code="subject.form.image.help"/></small>
                        <c:if test="${not empty imageFileError}">
                            <div class="invalid-feedback d-block">${imageFileError}</div>
                        </c:if>

                        <c:set var="imageToShow" value="${not empty currentSubjectImage ? currentSubjectImage : subject.subjectImage}" />
                        <c:if test="${not empty imageToShow}">
                            <div class="mt-2">
                                <p class="mb-1"><spring:message code="subject.form.image.current"/></p>
                                <img src="/img/subjectImg/${subject.subjectImage}"
                                     alt="Current Subject" class="current-img-preview img-thumbnail" style="max-width: 150px; max-height: 150px;"/>
                            </div>
                        </c:if>
                    </div>

                    <div class="mb-3 form-check">
                        <form:checkbox path="isActive" cssClass="form-check-input" id="isActive"/>
                        <form:label path="isActive" cssClass="form-check-label" for="isActive"><spring:message code="subject.form.active.label"/></form:label>
                        <form:errors path="isActive" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <a href="<c:url value='/admin/subject'/>" class="btn btn-outline-secondary me-md-2">
                            <i class="fas fa-times-circle"></i> <spring:message code="button.cancel"/>
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> <spring:message code="button.save.subject" text="Save Subject"/>
                        </button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
      'use strict'
      var forms = document.querySelectorAll('.needs-validation')
      Array.prototype.slice.call(forms)
        .forEach(function (form) {
          form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) { 
              event.preventDefault()
              event.stopPropagation()
            }
            form.classList.add('was-validated') 
          }, false)
        })
    })()
</script>