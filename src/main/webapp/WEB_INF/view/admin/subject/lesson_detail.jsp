<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .video-container {
        position: relative;
        width: 100%;
        aspect-ratio: 16 / 9;
        overflow: hidden;
    }
    .video-container iframe {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
    }
</style>

<div class="row justify-content-center">
    <div class="text-start mb-2">
        <a href="<c:url value='/admin/subject/${subjectId}/chapters/${chapterId}/detail'/>" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left"></i> Quay lại
        </a>
    </div>
    <div class="col-md-10 col-lg-8">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0">Chi tiết bài học - <c:out value="${lessonDetail.lessonName}"/></h3>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="form-label">ID:</label>
                    <input type="text" class="form-control" value="${lessonDetail.lessonId}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Mô tả:</label>
                    <textarea class="form-control" rows="4" disabled><c:out value="${lessonDetail.lessonDescription}"/></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Trạng thái:</label>
                    <span class="badge bg-${lessonDetail.status ? 'success' : 'secondary'}">
                        <c:out value="${lessonDetail.status ? 'Hoạt động' : 'Không hoạt động'}"/>
                    </span>
                </div>
                <div class="mb-3">
                    <label class="form-label">Link video:</label>
                    <input type="text" class="form-control" value="${lessonDetail.videoSrc}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Xem video:</label>
                    <c:choose>
                        <c:when test="${not empty lessonDetail.videoSrc}">
                            <div class="video-container">
                                <iframe src="<c:out value='${lessonDetail.videoSrc}'/>"
                                        title="<c:out value='${lessonDetail.videoTitle}'/>"
                                        frameborder="0"
                                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                                        allowfullscreen></iframe>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">Không có video</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="mb-3">
                    <label class="form-label">Tiêu đề video:</label>
                    <input type="text" class="form-control" value="${lessonDetail.videoTitle}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Thời lượng video:</label>
                    <input type="text" class="form-control" value="${lessonDetail.videoTime}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Hình ảnh thu nhỏ:</label>
                    <c:choose>
                        <c:when test="${not empty lessonDetail.thumbnailUrl}">
                            <img src="<c:out value='${lessonDetail.thumbnailUrl}'/>" alt="${lessonDetail.lessonName}" class="img-fluid" style="max-width: 200px;"/>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">Không có hình ảnh thu nhỏ</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="mb-3">
                    <label class="form-label">Người tạo:</label>
                    <input type="text" class="form-control" value="${lessonDetail.userCreatedFullName != null ? lessonDetail.userCreatedFullName : 'N/A'}" disabled/>
                </div>
                <div class="mb-3">
                    <label class="form-label">Ngày tạo:</label>
                    <input type="text" class="form-control" value="${lessonDetail.createdAt}" disabled/>
                </div>

                <h4>Tài liệu</h4>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>Tên tệp</th>
                            <th>Đường dẫn</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="material" items="${lessonDetail.lessonMaterials}">
                            <tr>
                                <td><c:out value="${material.fileName}"/></td>
                                <td><a href="/files/materials/<c:out value='${material.filePath}'/>" target="_blank"><c:out value="${material.filePath}"/></a></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty lessonDetail.lessonMaterials}">
                            <tr>
                                <td colspan="2" class="text-center text-muted">Không có tài liệu</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>