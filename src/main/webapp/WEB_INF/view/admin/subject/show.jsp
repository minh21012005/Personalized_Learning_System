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
               
<c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessageGlobal}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${errorMessageGlobal}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty viewName}">
                <%-- Bao gồm file JSP nội dung chính --%>
                <%-- Đường dẫn này sẽ là tương đối với thư mục WEB-INF/view/ --%>
                <jsp:include page="${viewName}.jsp" />
            </c:when>
            <c:otherwise>
                <p>Welcome to the Admin!</p> <%-- Hoặc một nội dung mặc định nào đó --%>
            </c:otherwise>
        </c:choose>
            </div>

            <!-- Include Footer -->
            <footer>
                <jsp:include page="../layout/footer.jsp" />
            </footer>

            <!-- Bootstrap 5 JS -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>