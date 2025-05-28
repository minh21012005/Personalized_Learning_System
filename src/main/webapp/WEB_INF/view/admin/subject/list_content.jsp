<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Bỏ dòng này nếu không dùng fmt:formatDate cho các kiểu Date cũ nữa --%>
<%-- <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> --%>

<%-- Không cần các thẻ html, head, body ở đây vì nó sẽ được nhúng vào show.jsp --%>
<%-- Các message thành công/lỗi đã được xử lý ở show.jsp --%>

<h1 class="mb-3">${pageTitle != null ? pageTitle : 'Manage Subjects'}</h1>

<div class="mb-3">
    <%-- Sửa lại href để trỏ đến URL tạo mới đúng --%>
    <a href="<c:url value='/admin/subject/new'/>" class="btn btn-primary">
        <i class="fas fa-plus-circle"></i> Add New Subject
    </a>
</div>

<div class="table-responsive">
    <table class="table table-striped table-bordered table-hover">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Image</th>
            <th>Subject Name</th>
            <th>Description</th>
            <th>Grade</th>
            <th>Active</th>
            <th>Created At</th>
            <th>Updated At</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="subject" items="${subjects}">
            <tr>
                <td>${subject.subjectId}</td>
                <td>
                    <c:choose>
                        <c:when test="${not empty subject.subjectImage}">
                            <img src="<c:url value='/subject-images/${subject.subjectImage}'/>"
                                 alt="${subject.subjectName}" class="subject-img-thumbnail"/>
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted">No Image</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td><c:out value="${subject.subjectName}"/></td>
                <td><c:out value="${subject.subjectDescription}"/></td>
                <td><c:out value="${subject.grade.gradeName != null ? subject.grade.gradeName : 'N/A'}"/></td>
                <td>
                    <c:choose>
                        <c:when test="${subject.isActive}">
                            <span class="badge bg-success">Yes</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary">No</span>
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
                    <a href="<c:url value='/admin/subject/edit/${subject.subjectId}'/>" class="btn btn-sm btn-outline-primary me-1" title="Edit">
                        <i class="fas fa-edit"></i> Edit
                    </a>
                    <a href="<c:url value='/admin/subject/delete/${subject.subjectId}'/>"
                       class="btn btn-sm btn-outline-danger" title="Delete"
                       onclick="return confirm('Are you sure you want to delete subject \'${subject.subjectName}\'? This action cannot be undone.');">
                        <i class="fas fa-trash-alt"></i> Delete
                    </a>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty subjects}">
            <tr>
                <td colspan="9" class="text-center text-muted">No subjects found.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>