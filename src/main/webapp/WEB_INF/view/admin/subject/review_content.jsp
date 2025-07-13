<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="row justify-content-center">
    <div class="col-md-10 col-lg-8">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0"><spring:message code="subject.form.review.title" text="Review Subject"/></h3>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/subject/review" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="subjectId" value="${subject.subjectId}"/>

                    <div class="mb-3">
                        <label class="form-label"><spring:message code="subject.form.name.label"/>:</label>
                        <input type="text" class="form-control" value="${subject.subjectName}" disabled/>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><spring:message code="subject.form.review.submitter.label"/>:</label>
                        <input type="text" class="form-control" value="${submitter.fullName} (${submitter.email})" disabled/>
                    </div>

                    <div class="mb-3">
                        <label class="form-label"><spring:message code="subject.form.review.submittedAt.label"/>:</label>
                        <input type="text" class="form-control" value="${submittedAt.format(customDateFormatter)}" disabled/>
                    </div>

                    <div class="mb-3">
                        <label for="status" class="form-label"><spring:message code="subject.form.review.status.label"/> <span class="text-danger">*</span></label>
                        <select name="status" id="status" class="form-select" required>
                            <option value=""><spring:message code="subject.form.review.status.select" text="-- Select Status --"/></option>
                            <option value="APPROVED"><spring:message code="subject.status.APPROVED"/></option>
                            <option value="REJECTED"><spring:message code="subject.status.REJECTED"/></option>
                        </select>
                        <div class="invalid-feedback">
                            <spring:message code="subject.form.review.status.required" text="Please select a status"/>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="feedback" class="form-label"><spring:message code="subject.form.review.feedback.label"/></label>
                        <textarea name="feedback" id="feedback" class="form-control" rows="4" placeholder="<spring:message code="subject.form.review.feedback.placeholder"/>"></textarea>
                        <small class="form-text text-muted"><spring:message code="subject.form.review.feedback.help" text="Required if rejecting the subject"/></small>
                        <div class="invalid-feedback">
                            <spring:message code="subject.form.review.feedback.required" text="Feedback is required when rejecting the subject"/>
                        </div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <a href="<c:url value='/admin/subject'/>" class="btn btn-outline-secondary me-md-2">
                            <i class="fas fa-times-circle"></i> <spring:message code="button.cancel"/>
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check-circle"></i> <spring:message code="button.review" text="Review Subject"/>
                        </button>
                    </div>
                </form>
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
                var status = document.getElementById('status').value;
                var feedback = document.getElementById('feedback').value;
                if (status === 'REJECTED' && (!feedback || feedback.trim() === '')) {
                    event.preventDefault();
                    event.stopPropagation();
                    document.getElementById('feedback').classList.add('is-invalid');
                    document.getElementById('feedback').nextElementSibling.textContent = '<spring:message code="subject.form.review.feedback.required"/>';
                }
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>