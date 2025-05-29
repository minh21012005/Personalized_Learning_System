<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Grade Manager</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </head>

            <body>
                <div class="container mt-5">
                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <!-- Section 1: Edit Grade Name and Status -->
                    <h2>Edit Grade</h2>
                    <form:form id="gradeForm" action="${pageContext.request.contextPath}/admin/grade/update"
                        method="post" modelAttribute="grade">
                        <form:hidden path="gradeId" />
                        <input type="hidden" name="page" value="${currentPage}" />
                        <input type="hidden" name="pendingPage" value="${pendingCurrentPage}" />
                        <input type="hidden" name="keyword" value="${keyword}" />
                        <input type="hidden" name="pendingKeyword" value="${pendingKeyword}" />
                        <div class="mb-3">
                            <label for="gradeName" class="form-label">Grade Name</label>
                            <form:input path="gradeName" cssClass="form-control" id="gradeName" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <div>
                                <form:radiobutton path="active" value="true" id="active" />
                                <label for="active">Active</label>
                                <form:radiobutton path="active" value="false" id="inactive" />
                                <label for="inactive">Inactive</label>
                            </div>
                        </div>

                        <!-- Section 2: Assigned Subjects -->
                        <h2>Assigned Subjects</h2>
                        <div class="mb-3">
                            <input type="text" class="form-control" id="searchAssigned"
                                placeholder="Search by subject name">
                        </div>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Subject Name</th>
                                    <th>Description</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="assignedSubjects">
                                <c:forEach var="subject" items="${subjects}">
                                    <tr>
                                        <td>
                                            <c:out value="${subject.subjectName}" />
                                        </td>
                                        <td>
                                            <c:out value="${subject.subjectDescription}" />
                                        </td>
                                        <td>
                                            <c:if test="${grade.active}">
                                                <button type="button" class="btn btn-danger btn-sm"
                                                    onclick="removeSubject(${subject.subjectId}, ${grade.gradeId})">Remove</button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <!-- Pagination for Assigned Subjects -->
                        <nav>
                            <ul class="pagination">
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <li class="page-item ${i - 1 == currentPage ? 'active' : ''}">
                                        <a class="page-link"
                                            href="${pageContext.request.contextPath}/admin/grade/update/${grade.gradeId}?page=${i - 1}&pendingPage=${pendingCurrentPage}&keyword=${keyword}&pendingKeyword=${pendingKeyword}">${i}</a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </nav>

                        <!-- Section 3: Unassigned Subjects -->
                        <h2>Add Subjects to Grade</h2>
                        <div class="mb-3">
                            <input type="text" class="form-control" id="searchUnassigned"
                                placeholder="Search by subject name">
                        </div>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Subject Name</th>
                                    <th>Description</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="unassignedSubjects">
                                <c:forEach var="subject" items="${pendingSubjects}">
                                    <tr>
                                        <td>
                                            <c:out value="${subject.subjectName}" />
                                        </td>
                                        <td>
                                            <c:out value="${subject.subjectDescription}" />
                                        </td>
                                        <td>
                                            <c:if test="${grade.active}">
                                                <button type="button" class="btn btn-primary btn-sm"
                                                    onclick="addSubject(${subject.subjectId}, ${grade.gradeId})">Add</button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <!-- Pagination for Unassigned Subjects -->
                        <nav>
                            <ul class="pagination">
                                <c:forEach var="i" begin="1" end="${pendingTotalPages}">
                                    <li class="page-item ${i - 1 == pendingCurrentPage ? 'active' : ''}">
                                        <a class="page-link"
                                            href="${pageContext.request.contextPath}/admin/grade/update/${grade.gradeId}?page=${currentPage}&pendingPage=${i - 1}&keyword=${keyword}&pendingKeyword=${pendingKeyword}">${i}</a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </nav>

                        <!-- Save Button -->
                        <button type="submit" class="btn btn-success">Save</button>
                    </form:form>
                </div>

                <script>
                    // Filter for Assigned Subjects
                    document.getElementById('searchAssigned').addEventListener('input', function () {
                        let filter = this.value.toLowerCase();
                        let rows = document.querySelectorAll('#assignedSubjects tr');
                        rows.forEach(row => {
                            let subjectName = row.cells[0].textContent.toLowerCase();
                            row.style.display = subjectName.includes(filter) ? '' : 'none';
                        });
                    });

                    // Filter for Unassigned Subjects
                    document.getElementById('searchUnassigned').addEventListener('input', function () {
                        let filter = this.value.toLowerCase();
                        let rows = document.querySelectorAll('#unassignedSubjects tr');
                        rows.forEach(row => {
                            let subjectName = row.cells[0].textContent.toLowerCase();
                            row.style.display = subjectName.includes(filter) ? '' : 'none';
                        });
                    });

                    // Functions to handle add/remove subjects
                    function addSubject(subjectId, gradeId) {
                        const page = encodeURIComponent('${currentPage}' || '0');
                        const pendingPage = encodeURIComponent('${pendingCurrentPage}' || '0');
                        const keyword = encodeURIComponent('${keyword}' || '');
                        const pendingKeyword = encodeURIComponent('${pendingKeyword}' || '');
                        fetch('${pageContext.request.contextPath}/admin/grade/update', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: `gradeId=${gradeId}&addSubjectIds=${subjectId}&page=${page}&pendingPage=${pendingPage}&keyword=${keyword}&pendingKeyword=${pendingKeyword}`
                        }).then(() => location.reload()).catch(error => console.error('Error:', error));
                    }

                    function removeSubject(subjectId, gradeId) {
                        const page = encodeURIComponent('${currentPage}' || '0');
                        const pendingPage = encodeURIComponent('${pendingCurrentPage}' || '0');
                        const keyword = encodeURIComponent('${keyword}' || '');
                        const pendingKeyword = encodeURIComponent('${pendingKeyword}' || '');
                        fetch('${pageContext.request.contextPath}/admin/grade/update', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: `gradeId=${gradeId}&removeSubjectIds=${subjectId}&page=${page}&pendingPage=${pendingPage}&keyword=${keyword}&pendingKeyword=${pendingKeyword}`
                        }).then(() => location.reload()).catch(error => console.error('Error:', error));
                    }
                </script>
            </body>

            </html>