<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                    rel="stylesheet">
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
                    <div class="container mt-5">
                        <div class="row">
                            <div class="col-md-6 col-12 mx-auto">
                                <h3>Tạo thêm khối </h3>
                            </div>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" role="alert">
                                    ${error}
                                </div>
                            </c:if>
                            <form:form method="post" action="/admin/grade/create" modelAttribute="newGrade">
                                <div class="mb-3">
                                    <label class="from-label">Grade name</label>
                                    <form:input type="text" class="form-control" path="gradeName" />


                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Active</label>
                                    <form:select path="active" class="form-control">
                                        <form:option value="true">True</form:option>
                                        <form:option value="false">False</form:option>
                                    </form:select>
                                </div>



                                <button type="submit" class="btn btn-primary">Lưu</button>
                                <a href="/admin/grade" class="btn btn-secondary">Hủy</a>
                            </form:form>
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