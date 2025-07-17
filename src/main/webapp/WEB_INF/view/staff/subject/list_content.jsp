<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- FORM FILTER --%>
<form action="<c:url value='/staff/subject'/>" method="GET" class="mb-3">
    <div class="row g-3 align-items-center">
        <div class="col-auto">
            <label for="filterGradeId" class="col-form-label"><spring:message code="subject.list.grade"/>:</label>
        </div>
        <div class="col-auto" style="min-width: 180px;">
            <select name="filterGradeId" id="filterGradeId" class="form-select form-select-sm">
                <option value=""><spring:message code="subject.filter.allGrades"/></option>
                <c:forEach var="grade" items="${gradesForFilter}">
                    <option value="${grade.gradeId}" ${grade.gradeId == filterGradeId ? 'selected' : ''}>
                        <c:out value="${grade.gradeName}"/>
                    </option>
                </c:forEach>
            </select>
        </div>
        <div class="col-auto">
            <label for="filterName" class="col-form-label"><spring:message code="subject.list.name"/>:</label>
        </div>
        <div class="col-auto">
            <input type="text" name="filterName" id="filterName" class="form-control form-control-sm"
                   value="<c:out value='${filterName}'/>" placeholder="<spring:message code="subject.filter.enterName"/>">
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-info btn-sm">
                <i class="fas fa-filter"></i> <spring:message code="button.filter"/>
            </button>
            <a href="<c:url value='/staff/subject'/>" class="btn btn-secondary btn-sm ms-2">
                <i class="fas fa-eraser"></i> <spring:message code="button.clear"/>
            </a>
        </div>
    </div>
</form>

<div class="table-responsive">
    <table class="table table-hover">
        <thead>
        <tr>
            <th>
                <c:url value="/staff/subject" var="sortByIdUrl">
                    <c:param name="filterName" value="${filterName}" />
                    <c:param name="filterGradeId" value="${filterGradeId}" />
                    <c:param name="page" value="${currentPage}" />
                    <c:param name="size" value="${pageSize}" />
                    <c:param name="sortField" value="subjectId" />
                    <c:param name="sortDir" value="${sortField eq 'subjectId' ? reverseSortDir : 'asc'}" />
                </c:url>
                <a href="${sortByIdUrl}" class="table-header-sort-link">
                    <spring:message code="subject.list.id"/>
                    <c:if test="${sortField eq 'subjectId'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                </a>
            </th>
            <th><spring:message code="subject.list.image"/></th>
            <th>
                <c:url value="/staff/subject" var="sortByNameUrl">
                    <c:param name="filterName" value="${filterName}" />
                    <c:param name="filterGradeId" value="${filterGradeId}" />
                    <c:param name="page" value="${currentPage}" />
                    <c:param name="size" value="${pageSize}" />
                    <c:param name="sortField" value="subjectName" />
                    <c:param name="sortDir" value="${sortField eq 'subjectName' ? reverseSortDir : 'asc'}" />
                </c:url>
                <a href="${sortByNameUrl}" class="table-header-sort-link">
                    <spring:message code="subject.list.name"/>
                    <c:if test="${sortField eq 'subjectName'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                </a>
            </th>
            <th><spring:message code="subject.list.description"/></th>
            <th><spring:message code="subject.list.grade"/></th>
            <th><spring:message code="subject.list.status"/></th>
            <th>
                <c:url value="/staff/subject" var="sortByAssignedByUrl">
                    <c:param name="filterName" value="${filterName}" />
                    <c:param name="filterGradeId" value="${filterGradeId}" />
                    <c:param name="page" value="${currentPage}" />
                    <c:param name="size" value="${pageSize}" />
                    <c:param name="sortField" value="assignedByFullName" />
                    <c:param name="sortDir" value="${sortField eq 'assignedByFullName' ? reverseSortDir : 'asc'}" />
                </c:url>
                <a href="${sortByAssignedByUrl}" class="table-header-sort-link">
                    <spring:message code="subject.list.assignedBy"/>
                    <c:if test="${sortField eq 'assignedByFullName'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                </a>
            </th>
            <th>
                <c:url value="/staff/subject" var="sortByAssignedAtUrl">
                    <c:param name="filterName" value="${filterName}" />
                    <c:param name="filterGradeId" value="${filterGradeId}" />
                    <c:param name="page" value="${currentPage}" />
                    <c:param name="size" value="${pageSize}" />
                    <c:param name="sortField" value="assignedAt" />
                    <c:param name="sortDir" value="${sortField eq 'assignedAt' ? reverseSortDir : 'desc'}" />
                </c:url>
                <a href="${sortByAssignedAtUrl}" class="table-header-sort-link">
                    <spring:message code="subject.list.assignedAt"/>
                    <c:if test="${sortField eq 'assignedAt'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                </a>
            </th>
            <th><spring:message code="subject.table.feedback" text="Phản hồi"/></th>
            <th><spring:message code="label.actions"/></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="subject" items="${subjects}">
            <tr>
                <td><c:out value="${subject.subjectId}" default=""/></td>
                <td>
                    <c:choose>
                        <c:when test="${not empty subject.subjectImage and subject.subjectImage != ''}">
                            <img src="/img/subjectImg/<c:out value='${subject.subjectImage}'/>" alt="<c:out value='${subject.subjectName}'/>" class="subject-img-thumbnail"/>
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted"><spring:message code="subject.list.noImage" text="Không có hình ảnh"/></span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td><c:out value="${subject.subjectName}" default=""/></td>
                <td><c:out value="${subject.subjectDescription}" default=""/></td>
                <td><c:out value="${not empty subject.gradeName ? subject.gradeName : 'N/A'}"/></td>
                <td>
                    <c:if test="${not empty subject.status}">
                        <span class="badge bg-${subject.status == 'DRAFT' ? 'secondary' : subject.status == 'PENDING' ? 'warning' : subject.status == 'APPROVED' ? 'success' : 'danger'}">
                            <spring:message code="subject.status.${subject.status}"/>
                        </span>
                    </c:if>
                </td>
                <td><c:out value="${not empty subject.assignedByFullName ? subject.assignedByFullName : 'Không có thông tin'}"/></td>
                <td><c:out value="${subject.assignedAt}" default=""/></td>
                <td>
                    <c:choose>
                        <c:when test="${not empty subject.feedback}">
                            <button class="feedback-btn" data-feedback="${fn:escapeXml(subject.feedback)}">Xem phản hồi</button>
                        </c:when>
                        <c:otherwise>
                            <span class="no-feedback">Không có phản hồi</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <a href="<c:url value='/staff/subject/${subject.subjectId}/chapters'/>" class="btn btn-sm btn-primary me-1 mb-1" title="<spring:message code="button.view"/>">
                        <i class="fas fa-eye"></i> <spring:message code="button.view"/>
                    </a>
                    <c:if test="${subject.status == 'DRAFT'}">
                        <form action="<c:url value='/staff/subject/submit/${subject.subjectId}'/>" method="post" style="display:inline;">
                            <button type="submit" class="btn btn-sm btn-info me-1 mb-1" title="<spring:message code="button.submit"/>">
                                <i class="fas fa-paper-plane"></i> <spring:message code="button.submit"/>
                            </button>
                        </form>
                    </c:if>
                    <c:if test="${subject.status == 'PENDING'}">
                        <form action="<c:url value='/staff/subject/cancel/${subject.subjectId}'/>" method="post" style="display:inline;">
                            <button type="submit" class="btn btn-sm btn-warning me-1 mb-1" title="<spring:message code="button.cancel"/>">
                                <i class="fas fa-times"></i> <spring:message code="button.cancel"/>
                            </button>
                        </form>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty subjects}">
            <tr>
                <td colspan="10" class="text-center text-muted"><spring:message code="subject.list.noSubjectsFound.criteria"/></td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<c:if test="${subjectPage.totalPages > 0}">
    <div class="pagination-wrapper text-center">
        <div class="mb-2">
            <small><spring:message code="subject.list.showingItems" arguments="${subjectPage.numberOfElements},${subjectPage.totalElements},${subjectPage.number + 1},${subjectPage.totalPages}"/></small>
        </div>
        <div>
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${subjectPage.first ? 'disabled' : ''}">
                        <c:url value="/staff/subject" var="firstPageLink">
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
                        <c:url value="/staff/subject" var="prevPageLink">
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
                        <c:url value="/staff/subject" var="pageLinkFirstDots">
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
                            <c:url value="/staff/subject" var="pageLink">
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
                        <c:url value="/staff/subject" var="pageLinkLastDots">
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
                        <c:url value="/staff/subject" var="nextPageLink">
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
                        <c:url value="/staff/subject" var="lastPageLink">
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
    </div>
</c:if>