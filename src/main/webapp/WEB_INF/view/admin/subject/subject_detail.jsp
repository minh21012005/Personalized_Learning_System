<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<div class="row justify-content-center">
    <div class="text-start mb-2">
        <a href="<c:url value='/admin/subject'/>" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left"></i> Quay lại
        </a>
    </div>
    <div class="col-md-10 col-lg-8">
        <div class="card shadow-sm">

            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Chi tiết môn học - <c:out value="${subjectDetail.subjectName}"/></h3>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="form-label">ID:</label>
                    <input type="text" class="form-control" value="${subjectDetail.subjectId}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mô tả:</label>
                    <textarea class="form-control" rows="4" disabled><c:out value="${subjectDetail.subjectDescription}"/></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Hình ảnh:</label>
                    <c:choose>
                        <c:when test="${not empty subjectDetail.subjectImage}">
                            <img src="/img/subjectImg/<c:out value='${subjectDetail.subjectImage}'/>" alt="${subjectDetail.subjectName}" class="img-fluid" style="max-width: 200px;"/>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">Không có hình ảnh</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="mb-3">
                    <label class="form-label">Khối lớp:</label>
                    <input type="text" class="form-control" value="${subjectDetail.gradeName != null ? subjectDetail.gradeName : 'N/A'}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Trạng thái:</label>
                    <span class="badge bg-${subjectDetail.status == 'DRAFT' ? 'secondary' : subjectDetail.status == 'PENDING' ? 'warning' : subjectDetail.status == 'APPROVED' ? 'success' : 'danger'}">
                        <c:choose>
                            <c:when test="${subjectDetail.status == 'DRAFT'}">Bản nháp</c:when>
                            <c:when test="${subjectDetail.status == 'PENDING'}">Chờ xử lý</c:when>
                            <c:when test="${subjectDetail.status == 'APPROVED'}">Chấp nhận</c:when>
                            <c:when test="${subjectDetail.status == 'REJECTED'}">Từ chối</c:when>
                            <c:otherwise>Không có trạng thái</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="mb-3">
                    <label class="form-label">Được giao cho:</label>
                    <input type="text" class="form-control" value="${subjectDetail.assignedToFullName != null ? subjectDetail.assignedToFullName : 'Chưa được giao'}" disabled/>
                </div>

                <div class="mb-3">
                    <label class="form-label">Ngày tạo:</label>
                    <input type="text" class="form-control" value="${subjectDetail.createdAt}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Ngày cập nhật:</label>
                    <input type="text" class="form-control" value="${subjectDetail.updatedAt}" disabled/>
                </div>

                <h4>Danh sách chương</h4>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên chương</th>
                            <th>Mô tả</th>
                            <th>Trạng thái</th>
                            <th>Người tạo</th>
                            <th>Ngày tạo</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="chapter" items="${subjectDetail.chapters}">
                            <tr>
                                <td><c:out value="${chapter.chapterId}"/></td>
                                <td><c:out value="${chapter.chapterName}"/></td>
                                <td><c:out value="${chapter.chapterDescription}"/></td>
                                <td>
                                        <span class="badge bg-${chapter.status ? 'success' : 'secondary'}">
                                            <c:out value="${chapter.status ? 'Hoạt động' : 'Không hoạt động'}"/>
                                        </span>
                                </td>
                                <td><c:out value="${chapter.userCreatedFullName != null ? chapter.userCreatedFullName : 'N/A'}"/></td>
                                <td><c:out value="${chapter.createdAt}"/></td>
                                <td>
                                    <a href="<c:url value='/admin/subject/${subjectDetail.subjectId}/chapters/${chapter.chapterId}/detail'/>" class="btn btn-sm btn-primary">
                                        <i class="fas fa-eye"></i> Xem
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty subjectDetail.chapters}">
                            <tr>
                                <td colspan="7" class="text-center text-muted">Không tìm thấy chương nào.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>