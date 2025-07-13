<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="row justify-content-center">
    <div class="col-md-10 col-lg-8">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Duyệt môn học</h3>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/subject/review" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="subjectId" value="${subject.subjectId}"/>

                    <div class="mb-3">
                        <label class="form-label">Tên môn học:</label>
                        <input type="text" class="form-control" value="${subject.subjectName}" disabled/>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Người nộp:</label>
                        <input type="text" class="form-control"
                               value="${subject.submittedByFullName != null ? subject.submittedByFullName  : 'Không có thông tin'}"
                               disabled/>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Ngày nộp:</label>
                        <input type="text" class="form-control"
                               value="${subject.submittedAt != null ? subject.submittedAt.format(customDateFormatter) : 'Không có thông tin'}"
                               disabled/>
                    </div>

                    <div class="mb-3">
                        <label for="status" class="form-label">Trạng thái: <span class="text-danger">*</span></label>
                        <select name="status" id="status" class="form-select" required>
                            <option value="">-- Chọn trạng thái --</option>
                            <option value="APPROVED">Đã duyệt</option>
                            <option value="REJECTED">Từ chối</option>
                        </select>
                        <div class="invalid-feedback">
                            Vui lòng chọn trạng thái
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="feedback" class="form-label">Phản hồi:</label>
                        <textarea name="feedback" id="feedback" class="form-control" rows="4" placeholder="Nhập phản hồi nếu từ chối môn học"></textarea>
                        <small class="form-text text-muted">Bắt buộc nếu từ chối môn học</small>
                        <div class="invalid-feedback">
                            Phản hồi là bắt buộc khi từ chối môn học
                        </div>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <a href="<c:url value='/admin/subject'/>" class="btn btn-outline-secondary me-md-2">
                            <i class="fas fa-times-circle"></i> Hủy
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-check-circle"></i> Duyệt môn học
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
                    document.getElementById('feedback').nextElementSibling.textContent = 'Phản hồi là bắt buộc khi từ chối môn học';
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