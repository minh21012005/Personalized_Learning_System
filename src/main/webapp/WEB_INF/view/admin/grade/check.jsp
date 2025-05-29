<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Test Grade Update</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            </head>

            <body>
                <div class="container mt-5">
                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <!-- Form using Spring form taglib -->
                    <h2>Test Grade Update</h2>
                    <form:form action="${pageContext.request.contextPath}/admin/grade/update" method="post"
                        modelAttribute="grade">
                        <form:hidden path="gradeId" />
                        <div class="mb-3">
                            <label for="gradeName" class="form-label">Grade Name</label>
                            <form:input path="gradeName" cssClass="form-control" id="gradeName" />
                        </div>
                        <button type="submit" class="btn btn-success">Save</button>
                    </form:form>
                </div>
            </body>

            </html>