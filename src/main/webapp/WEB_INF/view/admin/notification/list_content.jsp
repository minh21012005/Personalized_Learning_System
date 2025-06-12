<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<div class="d-flex justify-content-between align-items-center mb-4 page-header"> 
    <h3 class="mb-0"><c:out value="${pageTitle}" default="Danh sách Thông báo"/></h3> 
    <a href="${pageContext.request.contextPath}/admin/notification/create" class="btn btn-primary"> 
        <i class="bi bi-plus-lg me-2"></i>Tạo thông báo mới 
    </a>
</div>

<%-- Search + Filter Form --%>
<form action="${pageContext.request.contextPath}/admin/notification/show" method="get" class="row g-3 align-items-center mb-4 p-3 bg-light border rounded">
    <div class="col-md-5">
        <label for="keyword" class="form-label visually-hidden">Tìm theo tiêu đề</label>
        <input type="text" id="keyword" name="keyword" class="form-control" placeholder="Tìm theo tiêu đề thông báo..."
               value="<c:out value='${param.keyword}'/>">
    </div>
    <div class="col-md-4"> 
        <label for="filterTargetType" class="form-label visually-hidden">Loại đối tượng</label>
        <select id="filterTargetType" name="filterTargetType" class="form-select">
            <option value="" <c:if test="${empty param.filterTargetType}">selected</c:if>>Tất cả loại đối tượng</option>
            <option value="USER" <c:if test="${param.filterTargetType eq 'USER'}">selected</c:if>>User cụ thể</option>
            <option value="PACKAGE" <c:if test="${param.filterTargetType eq 'PACKAGE'}">selected</c:if>>Theo Package</option>
            <option value="SUBJECT" <c:if test="${param.filterTargetType eq 'SUBJECT'}">selected</c:if>>Theo Subject</option>
            <option value="ROLE" <c:if test="${param.filterTargetType eq 'ROLE'}">selected</c:if>>Theo Role</option>
        </select>
    </div>
    <div class="col-md-auto">
        <button type="submit" class="btn btn-primary"><i class="bi bi-search me-2"></i>Tìm</button> 
        <a href="${pageContext.request.contextPath}/admin/notification/show" class="btn btn-secondary ms-2">Xóa lọc</a>
    </div>
</form>

<c:if test="${not empty errorMessage && empty notificationList}">
    <div class="alert alert-danger" role="alert">
        <i class="fas fa-exclamation-triangle me-2"></i><c:out value="${errorMessage}"/>
    </div>
</c:if>
<c:if test="${empty notificationList && empty errorMessage && empty formErrorMessage}">
    <div class="alert alert-info" role="alert">
        <i class="fas fa-info-circle me-2"></i>Chưa có thông báo nào được tạo.
    </div>
</c:if>

<c:if test="${not empty notificationList}">
    <div class="list-notification-cards">
        <c:forEach var="n" items="${notificationList}" varStatus="status">
            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <div class="row g-3 align-items-center">
                        <div class="col-lg-2 col-md-3 text-center text-md-start mb-3 mb-md-0">
                            <c:choose>
                                <c:when test="${not empty n.thumbnail}">
                                    <img src="<c:url value='${n.thumbnail}'/>" alt="Thumbnail"
                                         class="img-fluid rounded" style="width: 100px; height: 100px; object-fit: cover; border: 1px solid #dee2e6;"
                                         onerror="this.style.display='none'; this.parentElement.innerHTML='<div class=\'d-flex align-items-center justify-content-center bg-light rounded\' style=\'width: 100px; height: 100px; border: 1px dashed #ccc;\'><span class=\'text-danger small\'>Ảnh lỗi</span></div>';"/>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex align-items-center justify-content-center bg-light rounded"
                                         style="width: 100px; height: 100px; border: 1px dashed #ccc;">
                                        <small class="text-muted">No Image</small>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="col-lg-7 col-md-6">
                            <h5 class="card-title mb-1"><c:out value="${n.title}"/></h5>
                            <div class="d-flex align-items-center text-muted small mb-2 flex-wrap">
                                <span class="me-3"><i class="far fa-calendar-alt me-1"></i>
                                <c:if test="${n.createdAt != null}">Tạo lúc: <c:out value="${n.createdAt}"/></c:if>
                                <c:if test="${n.createdAt == null}">Ngày tạo không xác định</c:if>
                                </span>
                                <span><i class="fas fa-bullseye me-1"></i>Đối tượng: 
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${n.targetType == 'USER'}">bg-primary</c:when>
                                            <c:when test="${n.targetType == 'PACKAGE'}">bg-success</c:when>
                                            <c:when test="${n.targetType == 'SUBJECT'}">bg-info text-dark</c:when>
                                            <c:when test="${n.targetType == 'ROLE'}">bg-warning text-dark</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>
                                     "><c:out value="${n.targetType}"/></span>
                                </span>
                            </div>
                            <p class="card-text mb-2" style="font-size: 0.9rem; color: #495057;">
                                <c:out value="${fn:substring(n.content, 0, 120)}"/>
                                <c:if test="${fn:length(n.content) > 120}">...</c:if>
                            </p>
                            <c:if test="${not empty n.link}">
                                <a href="<c:url value='${n.link}'/>" target="_blank" rel="noopener noreferrer" class="card-link_custom small" style="word-break: break-all; font-size: 0.85rem;">
                                   <i class="fas fa-link me-1"></i> <c:out value="${n.link}"/>
                                </a>
                            </c:if>
                        </div>

                        <div class="col-lg-3 col-md-3 mt-3 mt-md-0 text-center text-lg-end"> 
                            <a href="${pageContext.request.contextPath}/admin/notification/edit/${n.notificationId}" 
                               class="btn btn-success btn-sm me-1"> 
                                <i class="bi bi-pencil-square"></i> Sửa
                            </a>
                            <button type="button" class="btn btn-warning btn-sm" 
                                    data-notification-id="${n.notificationId}"
                                    data-notification-title="<c:out value='${n.title}' escapeXml='true'/>"
                                    onclick="confirmDeleteNotification(this)">
                                <i class="bi bi-trash-fill"></i> Xóa
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <c:if test="${not empty notificationList && totalPages > 0}">
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin/notification/show?page=${currentPage - 1}&size=${pageSize}&keyword=${param.keyword}&filterTargetType=${param.filterTargetType}">«</a>
                </li>
                <c:forEach begin="0" end="${totalPages - 1}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/admin/notification/show?page=${i}&size=${pageSize}&keyword=${param.keyword}&filterTargetType=${param.filterTargetType}">${i + 1}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage >= totalPages - 1 ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin/notification/show?page=${currentPage + 1}&size=${pageSize}&keyword=${param.keyword}&filterTargetType=${param.filterTargetType}">»</a>
                </li>
            </ul>
        </nav>
    </c:if>

    <c:if test="${not empty notificationList}">
        <div class="text-center mt-3 mb-3">
            <p>Tổng số thông báo: <strong><c:out value="${totalItems}" default="0"/></strong></p>
        </div>
    </c:if>
</c:if>

<div class="modal fade" id="deleteNotificationConfirmModal" tabindex="-1" aria-labelledby="deleteNotificationConfirmModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title" id="deleteNotificationConfirmModalLabel"><i class="fas fa-exclamation-triangle me-2"></i>Xác nhận xóa</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        Bạn có chắc chắn muốn xóa thông báo: "<strong id="notificationTitleToDeleteInModal"></strong>"? <br/>
        Hành động này không thể hoàn tác.
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
        <form id="deleteActualNotificationForm" method="POST" style="display: inline;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit" class="btn btn-danger"><i class="fas fa-trash-alt me-1"></i>Xác nhận xóa</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script type="text/javascript"> 
    function confirmDeleteNotification(buttonElement) {
        const notificationId = buttonElement.getAttribute('data-notification-id');
        const notificationTitle = buttonElement.getAttribute('data-notification-title');

        document.getElementById('notificationTitleToDeleteInModal').textContent = notificationTitle;
        const deleteForm = document.getElementById('deleteActualNotificationForm');
        deleteForm.action = '${pageContext.request.contextPath}/admin/notification/delete/' + notificationId;
        
        const deleteModalElement = document.getElementById('deleteNotificationConfirmModal');
        const deleteModal = bootstrap.Modal.getOrCreateInstance(deleteModalElement);
        deleteModal.show();
    }
</script>