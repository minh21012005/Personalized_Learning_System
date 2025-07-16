<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="subject.list.title" text="Manage Subjects"/></title>
    <link rel="stylesheet" href="<c:url value='/lib/bootstrap/css/bootstrap.css'/>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />

    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
            background-color: #f8f9fa;
            font-size: 1rem;
        }

        header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1030;
            height: 55px;
            background-color: #1a252f;
        }

        .main-container {
            display: flex;
            flex: 1;
            margin-top: 55px;
        }

        .sidebar {
            width: 250px;
            background-color: #1a252f;
            color: white;
            overflow-y: auto;
        }

        .content {
            flex: 1;
            padding: 20px;
            background-color: #f8f9fa;
            overflow-y: auto;
            padding-bottom: 80px;
        }

        footer {
            background-color: #1a252f;
            color: white;
            height: 40px;
            width: 100%;
        }

        .table {
            background-color: #ffffff;
            font-size: 1rem;
            border: 1px solid #dee2e6;
            margin-bottom: 1.5rem;
        }

        .table th,
        .table td {
            padding: 0.85rem 0.75rem;
            vertical-align: middle;
            border-left: 1px solid #dee2e6;
        }

        .table th:first-child,
        .table td:first-child {
            border-left: none;
        }

        .table thead th {
            background-color: #ffffff;
            color: #212529;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
            border-top: none;
        }

        .table thead th a.table-header-sort-link {
            color: inherit;
            text-decoration: none;
        }

        .table thead th a.table-header-sort-link:hover {
            color: #0d6efd;
        }

        .table tbody tr {
            background-color: #ffffff !important;
        }

        .table-hover tbody tr:hover {
            background-color: #f0f0f0 !important;
        }

        .subject-img-thumbnail {
            max-width: 70px;
            max-height: 50px;
            object-fit: cover;
        }

        .pagination-wrapper {
            margin-top: 1.5rem;
            margin-bottom: 1rem;
        }

        .pagination .page-link {
            color: #212529;
            background-color: #ffffff;
            border: 1px solid #dee2e6;
            margin-left: -1px;
        }

        .pagination .page-item:first-child .page-link {
            margin-left: 0;
            border-top-left-radius: .25rem;
            border-bottom-left-radius: .25rem;
        }

        .pagination .page-item:last-child .page-link {
            border-top-right-radius: .25rem;
            border-bottom-right-radius: .25rem;
        }

        .pagination .page-item:not(.active):not(.disabled) .page-link:hover {
            z-index: 2;
            color: #000000;
            background-color: #e9ecef;
            border-color: #dee2e6;
        }

        .pagination .page-item.active .page-link {
            z-index: 3;
            color: #212529;
            background-color: #e0e0e0;
            border-color: #adb5bd;
        }

        .pagination .page-item.active .page-link:focus,
        .pagination .page-item.active .page-link:hover {
            box-shadow: none;
            background-color: #d3d3d3;
            color: #212529;
        }

        .pagination .page-item.disabled .page-link {
            color: #adb5bd;
            pointer-events: none;
            background-color: #ffffff;
            border-color: #dee2e6;
        }

        /* Modal styles */
        .modal-dialog {
            max-width: 600px;
        }

        .modal-content {
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .modal-header {
            background-color: #1a252f;
            color: white;
            border-bottom: 1px solid #dee2e6;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }

        .modal-body {
            padding: 20px;
            max-height: 400px;
            overflow-y: auto;
        }

        .modal-footer {
            border-top: 1px solid #dee2e6;
            justify-content: flex-end;
        }

        .btn-close {
            filter: invert(1);
        }

        .feedback-btn {
            padding: 5px 10px;
            font-size: 0.9rem;
            border-radius: 5px;
            background-color: #0d6efd;
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .feedback-btn:hover {
            background-color: #0056b3;
        }

        .no-feedback {
            color: #6c757d;
            font-style: italic;
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout_staff/header.jsp" />
</header>

<div class="main-container">
    <div class="sidebar">
        <jsp:include page="../layout_staff/sidebar.jsp" />
    </div>

    <div class="content">
        <main>
            <div class="container-fluid px-4">
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
                                                <c:if test="${subject.status == 'PENDING' and not empty subject.submittedByFullName and subject.submittedByFullName != ''}">
                                                    (Nộp bởi: <c:out value="${subject.submittedByFullName}"/> lúc <c:out value="${subject.assignedAt}"/>)
                                                </c:if>
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
                                    <a href="<c:url value='/staff/subject/${subject.subjectId}/chapters'/>" class="btn btn-sm btn-primary me-1" title="<spring:message code="button.view"/>">
                                        <i class="fas fa-eye"></i> <spring:message code="button.view"/>
                                    </a>
                                    <c:if test="${subject.status == 'DRAFT'}">
                                        <form action="<c:url value='/staff/subject/submit/${subject.subjectId}'/>" method="post" style="display:inline;">
                                            <button type="submit" class="btn btn-sm btn-info me-1" title="<spring:message code="button.submit"/>">
                                                <i class="fas fa-paper-plane"></i> <spring:message code="button.submit"/>
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
                    </c:if>
                </div>
        </main>
    </div>
</div>

<footer>
    <jsp:include page="../layout_staff/footer.jsp" />
</footer>

<!-- Modal for Feedback -->
<div class="modal fade" id="feedbackModal" tabindex="-1" aria-labelledby="feedbackModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="feedbackModalLabel">Phản hồi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="feedbackContent">
                <!-- Nội dung phản hồi sẽ được chèn vào đây qua JavaScript -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Hàm hiển thị modal phản hồi
    function showFeedbackModal(feedback) {
        const feedbackContent = document.getElementById('feedbackContent');
        if (feedback && feedback.trim() !== "") {
            feedbackContent.innerHTML = `<p>${feedback.replace(/\n/g, '<br>')}</p>`;
        } else {
            feedbackContent.innerHTML = '<p class="no-feedback">Không có phản hồi.</p>';
        }
        new bootstrap.Modal(document.getElementById('feedbackModal')).show();
    }

    // Gắn sự kiện cho các nút "Xem phản hồi"
    document.addEventListener("DOMContentLoaded", function() {
        const feedbackButtons = document.querySelectorAll('.feedback-btn');
        feedbackButtons.forEach(button => {
            button.addEventListener('click', function() {
                const feedback = this.getAttribute('data-feedback');
                showFeedbackModal(feedback);
            });
        });
    });
</script>
</body>
</html>