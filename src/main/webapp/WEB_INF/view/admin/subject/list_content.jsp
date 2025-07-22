<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .subject-img-thumbnail {
        max-width: 50px;
        max-height: 50px;
        object-fit: cover;
        border-radius: 5px;
    }
    .table th, .table td {
        vertical-align: middle;
    }
    .btn-sm {
        padding: 0.25rem 0.5rem;
        font-size: 0.875rem;
    }
    .pagination .page-link {
        color: #007bff;
    }
    .pagination .page-item.active .page-link {
        background-color: #007bff;
        border-color: #007bff;
    }
    .form-control-sm, .form-select-sm {
        font-size: 0.875rem;
    }
    .card {
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .card-header {
        background-color: #f8f9fa;
        border-bottom: 1px solid #e9ecef;
    }
</style>

<div class="container mt-4">
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">Quản lý môn học</h5>
            <div>
                <a href="<c:url value='/admin/subject/new'/>" class="btn btn-primary btn-sm">
                    <i class="fas fa-plus-circle"></i> Thêm môn học mới
                </a>
                <a href="<c:url value='/admin/subject/pending'/>" class="btn btn-dark btn-sm">
                    <i class="fas fa-file"></i> Danh sách môn học chờ duyệt
                </a>
            </div>
        </div>
        <div class="card-body">
            <!-- FORM FILTER -->
            <form action="<c:url value='/admin/subject'/>" method="GET" class="mb-4">
                <div class="row g-3 align-items-center">
                    <div class="col-auto">
                        <label for="filterGradeId" class="col-form-label">Khối lớp:</label>
                    </div>
                    <div class="col-auto" style="min-width: 180px;">
                        <select name="filterGradeId" id="filterGradeId" class="form-select form-select-sm">
                            <option value="">Tất cả khối lớp</option>
                            <c:forEach var="grade" items="${gradesForFilter}">
                                <option value="${grade.gradeId}" ${grade.gradeId == filterGradeId ? 'selected' : ''}>
                                    <c:out value="${grade.gradeName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-auto">
                        <label for="filterName" class="col-form-label">Tên môn học:</label>
                    </div>
                    <div class="col-auto">
                        <input type="text" name="filterName" id="filterName" class="form-control form-control-sm"
                               value="<c:out value='${filterName}'/>" placeholder="Nhập tên môn học">
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-info btn-sm">
                            <i class="fas fa-filter"></i> Lọc
                        </button>
                        <a href="<c:url value='/admin/subject'/>" class="btn btn-secondary btn-sm ms-2">
                            <i class="fas fa-eraser"></i> Xóa bộ lọc
                        </a>
                    </div>
                </div>
            </form>

            <div class="table-responsive">
                <table class="table table-hover table-bordered">
                    <thead class="table-light">
                    <tr>
                        <th>
                            <c:url value="/admin/subject" var="sortByIdUrl">
                                <c:param name="filterName" value="${filterName}" />
                                <c:param name="filterGradeId" value="${filterGradeId}" />
                                <c:param name="page" value="${currentPage}" />
                                <c:param name="size" value="${pageSize}" />
                                <c:param name="sortField" value="subjectId" />
                                <c:param name="sortDir" value="${sortField eq 'subjectId' ? reverseSortDir : 'asc'}" />
                            </c:url>
                            <a href="${sortByIdUrl}" class="table-header-sort-link">
                                ID
                                <c:if test="${sortField eq 'subjectId'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                            </a>
                        </th>
                        <th>Hình ảnh</th>
                        <th>
                            <c:url value="/admin/subject" var="sortByNameUrl">
                                <c:param name="filterName" value="${filterName}" />
                                <c:param name="filterGradeId" value="${filterGradeId}" />
                                <c:param name="page" value="${currentPage}" />
                                <c:param name="size" value="${pageSize}" />
                                <c:param name="sortField" value="subjectName" />
                                <c:param name="sortDir" value="${sortField eq 'subjectName' ? reverseSortDir : 'asc'}" />
                            </c:url>
                            <a href="${sortByNameUrl}" class="table-header-sort-link">
                                Tên môn học
                                <c:if test="${sortField eq 'subjectName'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                            </a>
                        </th>
                        <th>Mô tả</th>
                        <th>Khối lớp</th>
                        <th>Trạng thái</th>
                        <th>Trạng thái duyệt</th>
                        <th>Người được giao</th>
                        <th>
                            <c:url value="/admin/subject" var="sortByCreatedAtUrl">
                                <c:param name="filterName" value="${filterName}" />
                                <c:param name="filterGradeId" value="${filterGradeId}" />
                                <c:param name="page" value="${currentPage}" />
                                <c:param name="size" value="${pageSize}" />
                                <c:param name="sortField" value="createdAt" />
                                <c:param name="sortDir" value="${(sortField eq 'createdAt' && sortDir eq 'desc') ? 'asc' : 'desc'}" />
                            </c:url>
                            <a href="${sortByCreatedAtUrl}" class="table-header-sort-link">
                                Ngày tạo
                                <c:if test="${sortField eq 'createdAt'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                            </a>
                        </th>
                        <th>
                            <c:url value="/admin/subject" var="sortByUpdatedAtUrl">
                                <c:param name="filterName" value="${filterName}" />
                                <c:param name="filterGradeId" value="${filterGradeId}" />
                                <c:param name="page" value="${currentPage}" />
                                <c:param name="size" value="${pageSize}" />
                                <c:param name="sortField" value="updatedAt" />
                                <c:param name="sortDir" value="${sortField eq 'updatedAt' ? reverseSortDir : 'asc'}" />
                            </c:url>
                            <a href="${sortByUpdatedAtUrl}" class="table-header-sort-link">
                                Ngày cập nhật
                                <c:if test="${sortField eq 'updatedAt'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                            </a>
                        </th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="subject" items="${subjects}" varStatus="loop">
                        <tr>
                            <td><c:out value="${subject.subjectId}" default=""/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty subject.subjectImage and subject.subjectImage != ''}">
                                        <img src="/img/subjectImg/<c:out value='${subject.subjectImage}'/>"
                                             alt="<c:out value='${subject.subjectName}'/>" class="subject-img-thumbnail"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Không có hình ảnh</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><c:out value="${subject.subjectName}" default=""/></td>
                            <td><c:out value="${subject.subjectDescription}" default=""/></td>
                            <td><c:out value="${not empty subject.gradeName ? subject.gradeName : 'N/A'}"/></td>
                            <td>
                                <span class="badge bg-${subject.isActive ? 'success' : 'secondary'}">
                                        ${subject.isActive ? 'Kích hoạt' : 'Không kích hoạt'}
                                </span>
                            </td>
                            <td>
                                <c:if test="${not empty subject.status}">
                                    <span class="badge bg-${subject.status == 'DRAFT' ? 'secondary' : subject.status == 'PENDING' ? 'warning' : subject.status == 'APPROVED' ? 'success' : subject.status == 'PUBLISHED' ? 'primary' : 'danger'}">
                                        <c:choose>
                                            <c:when test="${subject.status == 'DRAFT'}">Nháp</c:when>
                                            <c:when test="${subject.status == 'PENDING'}">Chờ duyệt</c:when>
                                            <c:when test="${subject.status == 'APPROVED'}">Đã duyệt</c:when>
                                            <c:when test="${subject.status == 'PUBLISHED'}">Đã xuất bản</c:when>
                                            <c:when test="${subject.status == 'REJECTED'}">Bị từ chối</c:when>
                                            <c:otherwise>${subject.status}</c:otherwise>
                                        </c:choose>

                                    </span>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty subject.assignedToFullName and subject.assignedToFullName != ''}">
                                        <c:out value="${subject.assignedToFullName}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Chưa được giao</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><c:out value="${subject.createdAt}" default=""/></td>
                            <td><c:out value="${subject.updatedAt}" default=""/></td>
                            <td>
                                <c:if test="${subject.status != 'DRAFT'}">
                                    <a href="<c:url value='/admin/subject/${subject.subjectId}/detail'/>" class="btn btn-sm btn-success me-1 mb-1" title="Chi tiết">
                                        <i class="fas fa-info-circle"></i> Chi tiết
                                    </a>
                                </c:if>

                                <a href="<c:url value='/admin/subject/edit/${subject.subjectId}'/>" class="btn btn-sm btn-warning me-1 mb-1" title="Sửa">
                                    <i class="fas fa-edit"></i> Sửa
                                </a>
                                <c:if test="${subject.status == 'DRAFT'}">
                                    <a href="<c:url value='/admin/subject/assign/${subject.subjectId}'/>" class="btn btn-sm btn-info me-1 mb-1" title="Giao nhiệm vụ">
                                        <i class="fas fa-user-plus"></i> Giao
                                    </a>
                                </c:if>
                                <c:if test="${subject.status == 'APPROVED' or subject.status == 'PUBLISHED'}">
                                    <a href="<c:url value='/admin/subject/revert/${subject.subjectId}'/>" class="btn btn-sm btn-secondary me-1 mb-1" title="Hoàn tác">
                                        <i class="fas fa-undo"></i> Hoàn tác
                                    </a>
                                </c:if>
                                <c:if test="${subject.status == 'APPROVED' and subject.isActive == false}">
                                    <a href="<c:url value='/admin/subject/publish/${subject.subjectId}'/>" class="btn btn-sm btn-primary me-1 mb-1" title="Xuất bản"
                                       onclick="return confirm('Bạn có chắc chắn muốn xuất bản môn học ${subject.subjectName}?');">
                                        <i class="fas fa-upload"></i> Xuất bản
                                    </a>
                                </c:if>
<%--                                <a href="<c:url value='/admin/subject/delete/${subject.subjectId}'/>"--%>
<%--                                   class="btn btn-sm btn-danger" title="Xóa"--%>
<%--                                   onclick="return confirm('Bạn có chắc chắn muốn xóa môn học ${subject.subjectName}? Hành động này không thể hoàn tác.');">--%>
<%--                                    <i class="fas fa-trash-alt"></i> Xóa--%>
<%--                                </a>--%>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty subjects}">
                        <tr>
                            <td colspan="11" class="text-center text-muted">Không tìm thấy môn học nào theo tiêu chí</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <c:if test="${subjectPage.totalPages > 0}">
                <div class="pagination-wrapper text-center mt-4">
                    <div class="mb-2">
                        <small>Hiển thị ${subjectPage.numberOfElements} trên tổng số ${subjectPage.totalElements} môn học (Trang ${subjectPage.number + 1}/${subjectPage.totalPages})</small>
                    </div>
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${subjectPage.first ? 'disabled' : ''}">
                                <c:url value="/admin/subject" var="firstPageLink">
                                    <c:param name="filterName" value="${filterName}" />
                                    <c:param name="filterGradeId" value="${filterGradeId}" />
                                    <c:param name="page" value="0" />
                                    <c:param name="size" value="${pageSize}" />
                                    <c:param name="sortField" value="${sortField}" />
                                    <c:param name="sortDir" value="${sortDir}" />
                                </c:url>
                                <a class="page-link" href="${firstPageLink}">««</a>
                            </li>
                            <li class="page-item ${subjectPage.first ? 'disabled' : ''}">
                                <c:url value="/admin/subject" var="prevPageLink">
                                    <c:param name="filterName" value="${filterName}" />
                                    <c:param name="filterGradeId" value="${filterGradeId}" />
                                    <c:param name="page" value="${subjectPage.number - 1}" />
                                    <c:param name="size" value="${pageSize}" />
                                    <c:param name="sortField" value="${sortField}" />
                                    <c:param name="sortDir" value="${sortDir}" />
                                </c:url>
                                <a class="page-link" href="${prevPageLink}">«</a>
                            </li>
                            <c:set var="windowSize" value="2" />
                            <c:set var="startPageLoop" value="${subjectPage.number - windowSize > 0 ? subjectPage.number - windowSize : 0}" />
                            <c:set var="endPageLoop" value="${subjectPage.number + windowSize < subjectPage.totalPages - 1 ? subjectPage.number + windowSize : subjectPage.totalPages - 1}" />
                            <c:if test="${startPageLoop > 0}">
                                <c:url value="/admin/subject" var="pageLinkFirstDots">
                                    <c:param name="filterName" value="${filterName}" />
                                    <c:param name="filterGradeId" value="${filterGradeId}" />
                                    <c:param name="page" value="0" />
                                    <c:param name="size" value="${pageSize}" />
                                    <c:param name="sortField" value="${sortField}" />
                                    <c:param name="sortDir" value="${sortDir}" />
                                </c:url>
                                <li class="page-item"><a class="page-link" href="${pageLinkFirstDots}">1</a></li>
                                <c:if test="${startPageLoop > 1}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                            </c:if>
                            <c:forEach begin="${startPageLoop}" end="${endPageLoop}" var="i">
                                <li class="page-item ${i == subjectPage.number ? 'active' : ''}">
                                    <c:url value="/admin/subject" var="pageLink">
                                        <c:param name="filterName" value="${filterName}" />
                                        <c:param name="filterGradeId" value="${filterGradeId}" />
                                        <c:param name="page" value="${i}" />
                                        <c:param name="size" value="${pageSize}" />
                                        <c:param name="sortField" value="${sortField}" />
                                        <c:param name="sortDir" value="${sortDir}" />
                                    </c:url>
                                    <a class="page-link" href="${pageLink}">${i + 1}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${endPageLoop < subjectPage.totalPages - 1}">
                                <c:if test="${endPageLoop < subjectPage.totalPages - 2}">
                                    <li class="page-item disabled"><span class="page-link">...</span></li>
                                </c:if>
                                <c:url value="/admin/subject" var="pageLinkLastDots">
                                    <c:param name="filterName" value="${filterName}" />
                                    <c:param name="filterGradeId" value="${filterGradeId}" />
                                    <c:param name="page" value="${subjectPage.totalPages - 1}" />
                                    <c:param name="size" value="${pageSize}" />
                                    <c:param name="sortField" value="${sortField}" />
                                    <c:param name="sortDir" value="${sortDir}" />
                                </c:url>
                                <li class="page-item"><a class="page-link" href="${pageLinkLastDots}">${subjectPage.totalPages}</a></li>
                            </c:if>
                            <li class="page-item ${subjectPage.last ? 'disabled' : ''}">
                                <c:url value="/admin/subject" var="nextPageLink">
                                    <c:param name="filterName" value="${filterName}" />
                                    <c:param name="filterGradeId" value="${filterGradeId}" />
                                    <c:param name="page" value="${subjectPage.number + 1}" />
                                    <c:param name="size" value="${pageSize}" />
                                    <c:param name="sortField" value="${sortField}" />
                                    <c:param name="sortDir" value="${sortDir}" />
                                </c:url>
                                <a class="page-link" href="${nextPageLink}">»</a>
                            </li>
                            <li class="page-item ${subjectPage.last ? 'disabled' : ''}">
                                <c:url value="/admin/subject" var="lastPageLink">
                                    <c:param name="filterName" value="${filterName}" />
                                    <c:param name="filterGradeId" value="${filterGradeId}" />
                                    <c:param name="page" value="${subjectPage.totalPages - 1}" />
                                    <c:param name="size" value="${pageSize}" />
                                    <c:param name="sortField" value="${sortField}" />
                                    <c:param name="sortDir" value="${sortDir}" />
                                </c:url>
                                <a class="page-link" href="${lastPageLink}">»»</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
</div>