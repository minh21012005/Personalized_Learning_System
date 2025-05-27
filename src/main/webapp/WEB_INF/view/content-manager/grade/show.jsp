<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
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
                <div class="col-md-12 col-12 mx-auto">
                    <h3>List grades

                    </h3>
                </div>
                <!-- Search and Filter Form -->


                <div class="d-flex justify-content-between mb-3 me-3">
                    <form action="/content-manager/grade" method="get" class="d-flex">
                        <label for="keyword" class="visually-hidden">Tìm kiếm theo tên khối lớp</label>
                        <input type="text" id="keyword" name="keyword" class="form-control me-2"
                            placeholder="Tìm kiếm theo tên khối lớp" value="${param.keyword}">


                        <select id="isActive" name="isActive" class="form-select me-2">
                            <option value="" <c:if test="${empty param.isActive}">selected</c:if>>Tất cả
                            </option>
                            <option value="true" <c:if test="${param.isActive eq 'true'}">selected</c:if>>Active
                            </option>
                            <option value="false" <c:if test="${param.isActive eq 'false'}">selected</c:if>
                                >InActive</option>
                        </select>

                        <button type="submit" class="btn btn-primary">Search</button>
                        <a href="/content-manager/grade" class="btn btn-secondary ms-2">Delete Filter</a>
                    </form>
                    <a href="/content-manager/grade/create" class="btn btn-primary btn-lg">Create</a>
                </div>
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>Grade ID</th>
                            <th>Grade Name</th>
                            <th>Active</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty grades}">
                                <c:forEach var="grade" items="${grades}">
                                    <tr>
                                        <td>${grade.gradeId}</td>
                                        <td>${grade.gradeName}</td>
                                        <td>${grade.active}</td>
                                        <td>
                                            <a href="/content-manager/grade/view/${grade.gradeId}"
                                                class="btn btn-success">View</a>
                                            <a href="/content-manager/grade/update/${grade.gradeId}"
                                                class="btn btn-warning mx-2">Update</a>
                                            <a href="/content-manager/grade/delete/${grade.gradeId}"
                                                class="btn btn-danger">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="text-center">No grades found</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                <a class="page-link"
                                    href="/content-manager/grade?page=${currentPage - 1}&keyword=${param.keyword}&isActive=${param.isActive}"
                                    aria-label="Previous">
                                    <span aria-hidden="true">«</span>
                                </a>
                            </li>
                            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link"
                                        href="/content-manager/grade?page=${i}&keyword=${param.keyword}&isActive=${param.isActive}">${i
                                        + 1}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                    href="/content-manager/grade?page=${currentPage + 1}&keyword=${param.keyword}&isActive=${param.isActive}"
                                    aria-label="Next">
                                    <span aria-hidden="true">»</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>

                <!-- Total Grades -->
                <div class="text-center">
                    <p>Total grades: ${totalItems}</p>
                </div>
            </div>
            <!-- Include Footer -->
            <footer>
                <jsp:include page="../layout/footer.jsp" />
            </footer>

            <!-- Bootstrap 5 JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>