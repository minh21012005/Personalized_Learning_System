<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<%-- Các message lỗi field đã được xử lý qua <form:errors>, lỗi global ở show.jsp --%>
<div class="row justify-content-center">
    <div class="col-md-10 col-lg-8"> <%-- Tăng chiều rộng một chút --%>
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">${pageTitle != null ? pageTitle : 'Subject Form'}</h3>
            </div>
            <div class="card-body">
                <form:form modelAttribute="subject" action="${pageContext.request.contextPath}/admin/subject/save" method="post" enctype="multipart/form-data" cssClass="needs-validation" novalidate="novalidate">
                    <form:hidden path="subjectId"/>

                    <div class="mb-3">
                        <form:label path="subjectName" cssClass="form-label">Subject Name <span class="text-danger">*</span></form:label>
                        <form:input path="subjectName" cssClass="form-control" required="required"/>
                        <form:errors path="subjectName" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="mb-3">
                        <form:label path="subjectDescription" cssClass="form-label">Description</form:label>
                        <form:textarea path="subjectDescription" cssClass="form-control" rows="3"/>
                        <form:errors path="subjectDescription" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="mb-3">
                        <form:label path="grade.gradeId" cssClass="form-label">Grade <span class="text-danger">*</span></form:label>
                        <form:select path="grade.gradeId" cssClass="form-select" required="required">
                            <form:option value="" label="-- Select Grade --"/>
                            <form:options items="${grades}" itemValue="gradeId" itemLabel="gradeName"/>
                        </form:select>
                        <form:errors path="grade" cssClass="invalid-feedback d-block"/>
                        <form:errors path="grade.gradeId" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="mb-3">
                        <label for="imageFile" class="form-label">Subject Image</label>
                        <input type="file" name="imageFile" class="form-control" id="imageFile" accept="image/*" />
                        <small class="form-text text-muted">Leave blank to keep the current image (if any when editing). Recommended size: 300x200px.</small>
                        <c:if test="${not empty subject.subjectImage}">
                            <div class="mt-2">
                                <p class="mb-1">Current Image:</p>
                                <img src="<c:url value='/subject-images/${subject.subjectImage}'/>"
                                     alt="Current Subject" class="current-img-preview"/>
                            </div>
                        </c:if>
                        <c:if test="${empty subject.subjectImage && not empty currentSubjectImage}">
                             <div class="mt-2">
                                <p class="mb-1">Current Image:</p>
                                <img src="<c:url value='/subject-images/${currentSubjectImage}'/>"
                                     alt="Current Subject" class="current-img-preview"/>
                            </div>
                        </c:if>
                    </div>

                    <div class="mb-3 form-check">
                        <form:checkbox path="isActive" cssClass="form-check-input" id="isActive"/>
                        <form:label path="isActive" cssClass="form-check-label" for="isActive">Is Active?</form:label>
                        <form:errors path="isActive" cssClass="invalid-feedback d-block"/>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <a href="<c:url value='/admin/subjects'/>" class="btn btn-outline-secondary me-md-2">
                            <i class="fas fa-times-circle"></i> Cancel
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Subject
                        </button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</div>
<%-- Script validation Bootstrap không cần ở đây nữa, đã có ở show.jsp (nếu cần) --%>
<%-- Tuy nhiên, script validation thường đi kèm với form, có thể giữ lại nếu muốn --%>
<script>
    // Bootstrap 5 form validation
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