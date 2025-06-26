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
                <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
                <!-- head: below existing links -->
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/gh/habibmhamadi/multi-select-tag@4.0.1/dist/css/multi-select-tag.min.css">
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

                    .placeholder-message {
                        padding: 10px;
                        margin-top: 8px;
                        background-color: #f8f9fa;
                        border-radius: 5px;
                        font-size: 0.95rem;
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
                        margin-left: 15%;
                        margin-top: 3%;
                        padding: 20px;
                        flex: 1;
                        display: flex;
                        justify-content: center;
                        padding-bottom: 100px;
                    }

                    .container {
                        max-width: 600px;
                        width: 100%;
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
                <script>
                    $(document).ready(() => {
                        const avatarFile = $("#image");
                        avatarFile.change(function (e) {
                            const imgURL = URL.createObjectURL(e.target.files[0]);
                            $("#imagePreview").attr("src", imgURL);
                            $("#imagePreview").css({ "display": "block" });
                        });
                    });
                </script>
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
                                <h3>Cập nhật gói </h3>
                            </div>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" role="alert">
                                    ${error}
                                </div>
                            </c:if>
                            <form:form method="post" action="/staff/package/update" modelAttribute="pkg"
                                enctype="multipart/form-data">
                                <form:hidden path="packageId" value="${pkg.packageId}" />
                                <div class="mb-3">
                                    <c:set var="errorName">
                                        <form:errors path="name" cssClass="invalid-feedback" />
                                    </c:set>
                                    <label for="name" class="form-label">Tên gói</label>
                                    <form:input path="name"
                                        class="form-control ${not empty errorName ? 'is-invalid' : ''}" id="name" />
                                    ${errorName}
                                </div>
                                <div class="mb-3">
                                    <c:set var="errorDesc">
                                        <form:errors path="description" cssClass="invalid-feedback" />


                                    </c:set>
                                    <label for="name" class="form-label">Mô Tả</label>
                                    <form:textarea path="description"
                                        class="form-control ${not empty errorDesc ? 'is-invalid' : ''}" id="description"
                                        rows="3" />
                                    ${errorDesc}
                                </div>
                                <div class="row mb-3">

                                    <div class="col-md-6">
                                        <c:set var="errorPrice">
                                            <form:errors path="price" cssClass="invalid-feedback" />
                                        </c:set>
                                        <label for="price" class="form-label">Giá</label>
                                        <div class="input-group">
                                            <form:input path="price" type="number" step="1"
                                                class="form-control ${not empty errorPrice ? 'is-invalid' : ''}"
                                                id="price" placeholder="VD: 199000"
                                                value="${newPackage.price != null ? newPackage.price.intValue() : ''}" />
                                            <span class="input-group-text">VNĐ</span>
                                        </div>
                                        ${errorPrice}
                                    </div>

                                    <div class="col-md-6">
                                        <c:set var="errorDuration">
                                            <form:errors path="durationDays" cssClass="invalid-feedback" />
                                        </c:set>
                                        <label for="durationDays" class="form-label">Số ngày hiệu lực</label>
                                        <form:input path="durationDays" type="number"
                                            class="form-control ${not empty errorDuration ? 'is-invalid' : ''}"
                                            id="durationDays" placeholder="VD: 30" />
                                        ${errorDuration}
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <c:set var="errorGrade">
                                        <form:errors path="grade.gradeId" cssClass="invalid-feedback" />
                                    </c:set>
                                    <label for="gradeId" class="form-label">Khối lớp</label>
                                    <form:select path="grade.gradeId"
                                        class="form-select ${not empty errorGrade ? 'is-invalid' : ''}" id="gradeId"
                                        onchange="this.form.submit()">
                                        <form:option value="" label="-- Chọn khối lớp --" />
                                        <c:forEach var="grade" items="${grades}">
                                            <form:option value="${grade.gradeId}">${grade.gradeName}</form:option>
                                        </c:forEach>
                                    </form:select>
                                    ${errorGrade}
                                </div>


                        </div>
                        <div class="mb-3">
                            <label for="subjects" class="form-label">Môn học</label>
                            <select name="subjects" id="subjects" multiple class="form-select">
                                <c:forEach var="subject" items="${subjects}">
                                    <c:set var="isSelected" value="false" />
                                    <c:forEach var="pkgSubject" items="${pkg.packageSubjects}">
                                        <c:if test="${pkgSubject.subject.subjectId == subject.subjectId}">
                                            <c:set var="isSelected" value="true" />
                                        </c:if>
                                    </c:forEach>
                                    <option value="${subject.subjectId}" ${isSelected ? 'selected' : '' }>
                                        ${subject.subjectName}
                                    </option>
                                </c:forEach>
                            </select>
                            <c:if test="${empty subjects}">
                                <div class="text-muted text-center placeholder-message">
                                    <i class="bi bi-exclamation-circle me-1"></i> Danh sách môn học đang trống
                                </div>
                            </c:if>
                            <c:if test="${not empty subjectsError}">
                                <div class="invalid-feedback d-block">${subjectsError}</div>
                            </c:if>
                        </div>
                        <div class="mb-3">
                            <c:set var="errorPackageType">
                                <form:errors path="packageType" cssClass="invalid-feedback" />
                            </c:set>
                            <label for="packageType" class="form-label">Loại gói</label>
                            <form:select path="packageType"
                                class="form-select ${not empty errorPackageType ? 'is-invalid' : ''}" id="packageType">
                                <form:option value="" label="-- Chọn loại gói --" />
                                <form:option value="FULL_COURSE" label="Học và luyện tập" />
                                <form:option value="PRACTICE_ONLY" label="Chỉ luyện tập" />
                            </form:select>
                            ${errorPackageType}
                        </div>

                        <div class="mb-3">
                            <c:set var="errorImage">
                                <form:errors path="image" cssClass="invalid-feedback" />
                            </c:set>
                            <label for="image" class="form-label">Anh (bắt buộc):</label>
                            <input class="form-control ${not empty errorImage ? 'is-invalid' : ''}" type="file"
                                id="image" name="file" accept=".png, .jpg, .jpeg" />
                            ${errorImage}
                        </div>
                        <div class="col-12 mt-3">
                            <c:choose>
                                <c:when test="${not empty pkg.image}">
                                    <img style="max-height: 250px; display: block" alt="Image not found"
                                        id="imagePreview" src="/img/package/${pkg.image}" />
                                </c:when>
                                <c:otherwise>
                                    <img style="max-height: 250px; display: none" alt="Image not found"
                                        id="imagePreview" src="#" />
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <form:hidden path="status" value="PENDING" />
                        <form:errors path="status" cssClass="invalid-feedback" />





                        <button type="submit" class="btn btn-primary">Lưu</button>
                        <a href="/staff/package" class="btn btn-secondary">Hủy</a>
                        </form:form>
                    </div>
                </div>


                <!-- Include Footer -->
                <footer>
                    <jsp:include page="../layout/footer.jsp" />
                </footer>

                <!-- End of <body> -->
                <script
                    src="https://cdn.jsdelivr.net/gh/habibmhamadi/multi-select-tag@4.0.1/dist/js/multi-select-tag.min.js"></script>
                <!-- Bootstrap 5 JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                    var tagSelector = new MultiSelectTag('subjects', {
                        maxSelection: 5,              // default unlimited.
                        required: true,               // default false.
                        placeholder: 'Search tags',   // default 'Search'.
                        onChange: function (selected) { // Callback when selection changes.
                            console.log('Selection changed:', selected);
                        }
                    }

                    );


                    // Ngăn người dùng thêm giá trị tùy ý
                    document.addEventListener('DOMContentLoaded', function () {
                        const searchInput = document.querySelector('.multi-select-tag .search-input');
                        if (searchInput) {
                            searchInput.addEventListener('keydown', function (e) {
                                if (e.key === 'Enter') {
                                    e.preventDefault(); // Ngăn hành vi mặc định của Enter
                                    if (!this.value || !Array.from(document.getElementById('subjects').options).some(opt => opt.text.toLowerCase().includes(this.value.toLowerCase()))) {
                                        this.value = ''; // Xóa giá trị nếu không hợp lệ
                                    }
                                }
                            });
                        }
                    });
                </script>
                <script>
                    // Hàm chung để ngăn dấu chấm/phẩy và chỉ giữ số nguyên
                    function restrictToIntegers(inputElement) {
                        // Ngăn nhập dấu chấm và dấu phẩy
                        inputElement.addEventListener("keypress", function (e) {
                            if (e.key === '.' || e.key === ',') {
                                e.preventDefault();
                            }
                        });

                        // Chỉ giữ lại số nguyên
                        inputElement.addEventListener("input", function () {
                            let value = this.value.replace(/\D/g, ''); // Chỉ giữ lại số
                            this.value = value;
                        });
                    }

                    // Áp dụng cho trường price
                    restrictToIntegers(document.getElementById("price"));

                    // Áp dụng cho trường durationDays
                    restrictToIntegers(document.getElementById("durationDays"));


                </script>

            </body>



            </html>