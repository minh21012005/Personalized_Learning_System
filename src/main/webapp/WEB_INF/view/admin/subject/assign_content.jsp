<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="row justify-content-center">
    <div class="col-md-10 col-lg-8">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Giao môn học</h3>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/subject/assign" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="subjectId" value="${subject.subjectId}"/>

                    <div class="mb-3">
                        <label class="form-label">Tên môn học:</label>
                        <input type="text" class="form-control" value="${subject.subjectName}" disabled/>
                    </div>

                    <div class="mb-3">
                        <label for="userId" class="form-label">Người được giao <span class="text-danger">*</span></label>
                        <select name="userId" id="userId" class="form-select" required>
                            <option value="0">Không giao</option>
                            <c:forEach var="user" items="${contentCreators}">
                                <option value="${user.userId}"><c:out value="${user.fullName} (${user.email})"/></option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">
                            Vui lòng chọn một người hoặc chọn "Không giao".
                        </div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <a href="<c:url value='/admin/subject'/>" class="btn btn-outline-secondary me-md-2">
                            <i class="fas fa-times-circle"></i> Hủy
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Giao môn học
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
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>