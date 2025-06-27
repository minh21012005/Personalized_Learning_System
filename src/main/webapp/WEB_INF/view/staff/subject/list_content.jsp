<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

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
            <th><spring:message code="subject.list.active"/></th>
            <th>
                <c:url value="/staff/subject" var="sortByCreatedAtUrl">
                    <c:param name="filterName" value="${filterName}" />
                    <c:param name="filterGradeId" value="${filterGradeId}" />
                    <c:param name="page" value="${currentPage}" />
                    <c:param name="size" value="${pageSize}" />
                    <c:param name="sortField" value="createdAt" />
                    <c:param name="sortDir" value="${(sortField eq 'createdAt' && sortDir eq 'desc') ? 'asc' : 'desc'}" />
                </c:url>
                <a href="${sortByCreatedAtUrl}" class="table-header-sort-link">
                    <spring:message code="subject.list.createdAt"/>
                    <c:if test="${sortField eq 'createdAt'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                </a>
            </th>
            <th>
                 <c:url value="/staff/subject" var="sortByUpdatedAtUrl">
                    <c:param name="filterName" value="${filterName}" />
                    <c:param name="filterGradeId" value="${filterGradeId}" />
                    <c:param name="page" value="${currentPage}" />
                    <c:param name="size" value="${pageSize}" />
                    <c:param name="sortField" value="updatedAt" />
                    <c:param name="sortDir" value="${sortField eq 'updatedAt' ? reverseSortDir : 'asc'}" />
                </c:url>
                <a href="${sortByUpdatedAtUrl}" class="table-header-sort-link">
                    <spring:message code="subject.list.updatedAt"/>
                    <c:if test="${sortField eq 'updatedAt'}"><i class="fas fa-sort-${sortDir eq 'asc' ? 'up' : 'down'}"></i></c:if>
                </a>
            </th>
            <th><spring:message code="label.actions"/></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="subject" items="${subjects}">
             <tr>
                <td>${subject.subjectId}</td>
                <td>
                    <c:choose>
                        <c:when test="${not empty subject.subjectImage}">
                            <img src="/img/subjectImg/${subject.subjectImage}"
                                 alt="${subject.subjectName}" class="subject-img-thumbnail"/>
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted"><spring:message code="subject.list.noImage" text="No Image"/></span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td><c:out value="${subject.subjectName}"/></td>
                <td><c:out value="${subject.subjectDescription}"/></td>
                <td><c:out value="${subject.grade.gradeName != null ? subject.grade.gradeName : 'N/A'}"/></td>
                <td>
                    <c:choose>
                        <c:when test="${subject.isActive}">
                            <span class="badge bg-success"><spring:message code="label.yes"/></span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary"><spring:message code="label.no"/></span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:if test="${subject.createdAt != null}">
                        ${subject.createdAt.format(customDateFormatter)}
                    </c:if>
                </td>
                <td>
                    <c:if test="${subject.updatedAt != null}">
                        ${subject.updatedAt.format(customDateFormatter)}
                    </c:if>
                </td>
                <td>
                    <a href="<c:url value='/staff/subject/${subject.subjectId}/chapters'/>" class="btn btn-sm btn-primary me-1" >
                        <i class="fas fa-eye"></i> View
                    </a>

                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty subjects}">
            <tr>
                <td colspan="9" class="text-center text-muted"><spring:message code="subject.list.noSubjectsFound.criteria"/></td>
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
                    <%-- Nút First --%>
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
                    <%-- Nút Previous --%>
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

                    <%-- Các nút số trang --%>
                    <c:set var="windowSize" value="2" /> <%-- Số lượng trang hiển thị ở mỗi bên của trang hiện tại --%>
                    <c:set var="startPageLoop" value="${subjectPage.number - windowSize > 0 ? subjectPage.number - windowSize : 0}" />
                    <c:set var="endPageLoop" value="${subjectPage.number + windowSize < subjectPage.totalPages - 1 ? subjectPage.number + windowSize : subjectPage.totalPages - 1}" />

                    <%-- Hiển thị nút trang đầu tiên và "..." nếu cần --%>
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

                    <%-- Vòng lặp hiển thị các nút số trang trong "cửa sổ" --%>
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

                    <%-- Hiển thị nút trang cuối cùng và "..." nếu cần --%>
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

                    <%-- Nút Next --%>
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
                     <%-- Nút Last --%>
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