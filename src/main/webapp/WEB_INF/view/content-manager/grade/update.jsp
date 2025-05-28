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
                }

                .sidebar {
                    position: fixed;
                    top: 55px;
                    left: 0;
                    width: 250px;
                    height: calc(100vh - 60px - 40px);
                    z-index: 1;
                    background-color: #212529;
                    overflow-y: auto;
                }

                header {
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    z-index: 3;
                    background-color: #212529;
                }

                .content {
                    margin-left: 250px;
                    margin-top: 60px;
                    padding: 20px;
                    flex: 1;
                }

                footer {
                    position: fixed;
                    bottom: 0;
                    left: 0;
                    right: 0;
                    z-index: 2;
                    background-color: #212529;
                    height: 40px;
                }

                .custom-container {
                    max-width: 900px;
                    margin: 0 auto;
                    padding: 20px;
                    background-color: #fff;
                    border-radius: 8px;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                }

                .table {
                    margin-top: 20px;
                }

                .btn-back {
                    margin-top: 20px;
                    display: block;
                    width: fit-content;
                }
            </style>
        </head>

        <body>
            <header>
                <jsp:include page="../layout/header.jsp" />
            </header>
            <div class="sidebar">
                <jsp:include page="../layout/sidebar.jsp" />
            </div>
            <div class="content">
                <div class="custom-container">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${empty errorMessage and not empty warning}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            ${warning}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${empty errorMessage}">
                        <h2 class="text-center mb-4">Cập nhật khối lớp ${grade.gradeName}</h2>
                        <form action="/content-manager/grade/update" method="post">
                            <input type="hidden" name="gradeId" value="${grade.gradeId}">
                            <div class="mb-3">
                                <label for="gradeName" class="form-label">Tên khối lớp</label>
                                <input type="text" class="form-control" id="gradeName" name="gradeName"
                                    value="${grade.gradeName}" required>
                            </div>
                            <div class="mb-3">
                                <label for="isActive" class="form-label">Trạng thái</label>
                                <select class="form-select" id="isActive" name="isActive">
                                    <option value="true" <c:if test="${grade.isActive eq true}">selected
                    </c:if>>Active</option>
                    <option value="false" <c:if test="${grade.isActive eq false}">selected</c:if>>InActive</option>
                    </select>


                </div>
                <h3>Danh sách môn học của khối lớp</h3>
                <div class="filter-form mb-3">
                    <form action="/content-manager/grade/update/${grade.gradeId}" method="get" class="d-flex">
                        <input type="text" id="keyword" name="keyword" class="form-control me-2"
                            placeholder="Tìm kiếm theo tên môn học" value="${keyword}">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                        <a href="/content-manager/grade/update/${grade.gradeId}" class="btn btn-secondary ms-2">Xóa bộ
                            lọc</a>
                    </form>
                </div>
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th><input type="checkbox" id="selectAllSubjects" ${!grade.isActive ? 'disabled' : '' }>
                            </th>
                            <th>Subject ID</th>
                            <th>Subject Name</th>
                            <th>Description</th>
                            <th>Image</th>
                            <th>Active</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="subject" items="${subjects}">
                            <tr>
                                <td><input type="checkbox" name="removeSubjectIds" value="${subject.subjectId}"
                                        ${!grade.isActive ? 'disabled' : '' }></td>
                                <td>${subject.subjectId}</td>
                                <td>${subject.subjectName}</td>
                                <td>${subject.subjectDescription}</td>
                                <td>${subject.subjectImage}</td>
                                <td>${subject.active ? 'true' : 'false'}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty subjects}">
                            <tr>
                                <td colspan="6" class="text-center">Không có môn học nào đang hoạt động.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Phân trang">
                        <ul class="pagination">
                            <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                <a class="page-link"
                                    href="/content-manager/grade/update/${grade.gradeId}?page=${currentPage - 1}&keyword=${keyword}"
                                    aria-label="Trang trước">
                                    <span aria-hidden="true">«</span>
                                </a>
                            </li>
                            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link"
                                        href="/content-manager/grade/update/${grade.gradeId}?page=${i}&keyword=${keyword}">${i
                                        + 1}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages - 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                    href="/content-manager/grade/update/${grade.gradeId}?page=${currentPage + 1}&keyword=${keyword}"
                                    aria-label="Trang sau">
                                    <span aria-hidden="true">»</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
                <h3>Danh sách môn học trong hàng chờ</h3>
                <div class="filter-form mb-3">
                    <form action="/content-manager/grade/update/${grade.gradeId}" method="get" class="d-flex">
                        <input type="text" id="pendingKeyword" name="pendingKeyword" class="form-control me-2"
                            placeholder="Tìm kiếm theo tên môn học" value="${pendingKeyword}">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                        <a href="/content-manager/grade/update/${grade.gradeId}" class="btn btn-secondary ms-2">Xóa bộ
                            lọc</a>
                    </form>
                </div>
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th><input type="checkbox" id="selectAllPendingSubjects" ${!grade.isActive ? 'disabled' : ''
                                    }></th>
                            <th>Subject ID</th>
                            <th>Subject Name</th>
                            <th>Description</th>
                            <th>Image</th>
                            <th>Active</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="subject" items="${pendingSubjects}">
                            <tr>
                                <td><input type="checkbox" name="addSubjectIds" value="${subject.subjectId}"
                                        ${!grade.isActive ? 'disabled' : '' }></td>
                                <td>${subject.subjectId}</td>
                                <td>${subject.subjectName}</td>
                                <td>${subject.subjectDescription}</td>
                                <td>${subject.subjectImage}</td>
                                <td>${subject.active ? 'true' : 'false'}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty pendingSubjects}">
                            <tr>
                                <td colspan="6" class="text-center">Không có môn học nào trong hàng chờ.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <c:if test="${pendingTotalPages > 1}">
                    <nav aria-label="Phân trang">
                        <ul class="pagination">
                            <li class="page-item ${pendingCurrentPage == 0 ? 'disabled' : ''}">
                                <a class="page-link"
                                    href="/content-manager/grade/update/${grade.gradeId}?pendingPage=${pendingCurrentPage - 1}&pendingKeyword=${pendingKeyword}"
                                    aria-label="Trang trước">
                                    <span aria-hidden="true">«</span>
                                </a>
                            </li>
                            <c:forEach begin="0" end="${pendingTotalPages - 1}" var="i">
                                <li class="page-item ${pendingCurrentPage == i ? 'active' : ''}">
                                    <a class="page-link"
                                        href="/content-manager/grade/update/${grade.gradeId}?pendingPage=${i}&pendingKeyword=${pendingKeyword}">${i
                                        + 1}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${pendingCurrentPage == pendingTotalPages - 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                    href="/content-manager/grade/update/${grade.gradeId}?pendingPage=${pendingCurrentPage + 1}&pendingKeyword=${pendingKeyword}"
                                    aria-label="Trang sau">
                                    <span aria-hidden="true">»</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
                <button type="submit" class="btn btn-primary mt-3" ${!grade.isActive ? 'disabled' : '' }>Lưu</button>
                <a href="/content-manager/grade" class="btn btn-secondary mt-3 ms-2">Quay lại</a>
                </form>
                </c:if>
            </div>
            </div>
            <footer>
                <jsp:include page="../layout/footer.jsp" />
            </footer>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                // Select all checkboxes for Subjects
                document.getElementById('selectAllSubjects')?.addEventListener('change', function () {
                    document.querySelectorAll('input[name="removeSubjectIds"]').forEach(checkbox => {
                        checkbox.checked = this.checked;
                    });
                });
                // Select all checkboxes for Pending Subjects
                document.getElementById('selectAllPendingSubjects')?.addEventListener('change', function () {
                    document.querySelectorAll('input[name="addSubjectIds"]').forEach(checkbox => {
                        checkbox.checked = this.checked;
                    });
                });
            </script>
        </body>

        </html>