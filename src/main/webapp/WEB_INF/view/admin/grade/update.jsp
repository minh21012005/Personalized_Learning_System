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
                <style>
                    body {

                        margin: 0;
                        min-height: 100vh;
                        display: flex;
                        flex-direction: column;
                        overflow-x: hidden;
                        /* Prevent horizontal scroll from fixed elements */
                    }

                    .sidebar {
                        position: fixed;
                        top: 55px;
                        /* Below header height */
                        left: 0;
                        width: 250px;
                        height: calc(100vh - 60px - 40px);
                        /* Subtract header and footer heights */
                        z-index: 1;
                        /* Behind header and footer */
                        background-color: #212529;
                        /* Dark background to match image */
                        overflow-y: auto;
                        /* Scrollable if content exceeds height */
                    }

                    header {
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        z-index: 3;
                        /* On top */
                        background-color: #212529;
                        /* Dark background to match image */
                    }

                    .content {
                        margin-left: 250px;
                        /* Match sidebar width */
                        margin-top: 60px;
                        /* Space for header height */
                        padding: 20px;
                        flex: 1;
                        /* Fill available space */
                    }

                    footer {
                        position: fixed;
                        bottom: 0;
                        left: 0;
                        /* Extend over sidebar */
                        right: 0;
                        z-index: 2;
                        /* Above sidebar, below header */
                        background-color: #212529;
                        /* Dark background to match image */
                        height: 40px;
                        /* Approximate footer height */
                    }

                    .form-control {
                        width: 225%;
                    }

                    .content .container {
                        padding-bottom: 80px;
                    }
                </style>
            </head>


            <body>
                <!-- Include Header -->
                <header>
                    <jsp:include page="../layout/header.jsp" />
                </header>

                <!-- Include Sidebar -->
                <div class="sidebar">
                    <jsp:include page="../layout/sidebar.jsp" />
                </div>

                <!-- Main Content Area -->

                <div class="content">
                    <div class="container mt-5">
                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <!-- Section 1: Edit Grade Name and Status -->
                        <h2>Chỉnh sửa khổi</h2>
                        <form:form id="gradeForm" action="${pageContext.request.contextPath}/admin/grade/update"
                            method="post" modelAttribute="grade">
                            <form:hidden path="gradeId" />
                            <input type="hidden" name="page" value="${currentPage}" />
                            <input type="hidden" name="pendingPage" value="${pendingCurrentPage}" />
                            <input type="hidden" name="keyword" value="${keyword}" />
                            <input type="hidden" name="pendingKeyword" value="${pendingKeyword}" />
                            <div class="mb-3">
                                <label for="gradeName" class="form-label">Tên khối</label>
                                <form:input path="gradeName" cssClass="form-control" id="gradeName" />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Trạng thái</label>
                                <div>
                                    <form:radiobutton path="active" value="true" id="active" />
                                    <label for="active">Hoạt động</label>
                                    <form:radiobutton path="active" value="false" id="inactive" />
                                    <label for="inactive">Không hoạt động</label>
                                </div>
                            </div>

                            <!-- Section 2: Assigned Subjects -->
                            <h2>Danh sách môn học trong khối</h2>
                            <div class="mb-3">
                                <input type="text" class="form-control" id="searchAssigned"
                                    placeholder="Tìm tên môn học">
                            </div>
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Xóa môn học</th>
                                        <th>Môn học</th>
                                        <th>Mô tả</th>
                                    </tr>
                                </thead>
                                <tbody id="assignedSubjects">
                                    <c:forEach var="subject" items="${subjects}">
                                        <tr>
                                            <td>
                                                <input type="checkbox" name="removeSubjectIds"
                                                    value="${subject.subjectId}" />
                                            </td>
                                            <td>
                                                <c:out value="${subject.subjectName}" />
                                            </td>
                                            <td>
                                                <c:out value="${subject.subjectDescription}" />
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
                            <h2>Danh sách môn học trong danh sách chờ</h2>
                            <div class="mb-3">
                                <input type="text" class="form-control" id="searchUnassigned"
                                    placeholder="Tìm tên môn học">
                            </div>
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Thêm môn học</th>
                                        <th>Tên môn học</th>
                                        <th>Mô tả</th>
                                    </tr>
                                </thead>
                                <tbody id="unassignedSubjects">
                                    <c:forEach var="subject" items="${pendingSubjects}">
                                        <tr>
                                            <td>
                                                <input type="checkbox" name="addSubjectIds"
                                                    value="${subject.subjectId}" />
                                            </td>
                                            <td>
                                                <c:out value="${subject.subjectName}" />
                                            </td>
                                            <td>
                                                <c:out value="${subject.subjectDescription}" />
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
                            <button type="submit" class="btn btn-success">Lưu</button>
                            <a href="/admin/grade" class="btn btn-secondary">Hủy</a>
                        </form:form>
                    </div>
                </div>
                </div>
                <!-- Include Footer -->
                <footer>
                    <jsp:include page="../layout/footer.jsp" />
                </footer>

                <!-- Bootstrap 5 JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>

                    document.getElementById('searchAssigned').addEventListener('input', function () {
                        let filter = this.value.toLowerCase();
                        let rows = document.querySelectorAll('#assignedSubjects tr');
                        rows.forEach(row => {
                            let subjectName = row.cells[1].textContent.toLowerCase();
                            row.style.display = subjectName.includes(filter) ? '' : 'none';
                        });
                    });

                    document.getElementById('searchUnassigned').addEventListener('input', function () {
                        let filter = this.value.toLowerCase();
                        let rows = document.querySelectorAll('#unassignedSubjects tr');
                        rows.forEach(row => {
                            let subjectName = row.cells[1].textContent.toLowerCase();
                            row.style.display = subjectName.includes(filter) ? '' : 'none';
                        });
                    });





                </script>
            </body>

            </html>