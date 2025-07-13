<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="row justify-content-center">
    <div class="col-md-10 col-lg-8">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Chi tiết chương - <c:out value="${chapterDetail.chapterName}"/></h3>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="form-label">ID:</label>
                    <input type="text" class="form-control" value="${chapterDetail.chapterId}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mô tả:</label>
                    <textarea class="form-control" rows="4" disabled><c:out value="${chapterDetail.chapterDescription}"/></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Trạng thái:</label>
                    <span class="badge bg-${chapterDetail.status ? 'success' : 'secondary'}">
                        <c:out value="${chapterDetail.status ? 'Hoạt động' : 'Không hoạt động'}"/>
                    </span>
                </div>
                <div class="mb-3">
                    <label class="form-label">Người tạo:</label>
                    <input type="text" class="form-control" value="${chapterDetail.userCreatedFullName != null ? chapterDetail.userCreatedFullName : 'N/A'}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Ngày tạo:</label>
                    <input type="text" class="form-control" value="${chapterDetail.createdAt}" disabled/>
                </div>

                <h4>Danh sách bài học</h4>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên bài học</th>
                            <th>Mô tả</th>
                            <th>Trạng thái</th>
                            <th>Người tạo</th>
                            <th>Ngày tạo</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="lesson" items="${chapterDetail.lessons}">
                            <tr>
                                <td><c:out value="${lesson.lessonId}"/></td>
                                <td><c:out value="${lesson.lessonName}"/></td>
                                <td><c:out value="${lesson.lessonDescription}"/></td>
                                <td>
                                        <span class="badge bg-${lesson.status ? 'success' : 'secondary'}">
                                            <c:out value="${lesson.status ? 'Hoạt động' : 'Không hoạt động'}"/>
                                        </span>
                                </td>
                                <td><c:out value="${lesson.userCreatedFullName != null ? lesson.userCreatedFullName : 'N/A'}"/></td>
                                <td><c:out value="${lesson.createdAt}"/></td>
                                <td>
                                    <a href="<c:url value='/admin/subject/${subjectId}/chapters/${chapterDetail.chapterId}/lessons/${lesson.lessonId}/detail'/>" class="btn btn-sm btn-primary">
                                        <i class="fas fa-eye"></i> Xem
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty chapterDetail.lessons}">
                            <tr>
                                <td colspan="7" class="text-center text-muted">Không tìm thấy bài học nào.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                    <a href="<c:url value='/admin/subject/${subjectId}/detail'/>" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>