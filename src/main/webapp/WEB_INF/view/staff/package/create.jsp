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
            </head>


            <body>
                <!-- Include Header -->
                <header>
                    <jsp:include page="../layout_staff/header.jsp" />
                </header>


                <!-- Include Sidebar -->
                <div class="sidebar">
                    <jsp:include page="../layout_staff/sidebar.jsp" />
                </div>


                <!-- Main Content Area -->


                <div class="content">
                    <div class="container mt-5">
                        <div class="row">
                            <div class="col-md-6 col-12 mx-auto">
                                <h3>Tạo mới gói </h3>
                            </div>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" role="alert">
                                    ${error}
                                </div>
                            </c:if>
                            <form:form method="post" action="/staff/package/create" modelAttribute="newPackage"
                                enctype="multipart/form-data">
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
                                    <form:select path="grade.gradeId" class="form-select" id="gradeId">
                                        <form:option value="" label="-- Chọn khối lớp --" />
                                        <c:forEach var="grade" items="${grades}">
                                            <form:option value="${grade.gradeId}">${grade.gradeName}</form:option>
                                        </c:forEach>
                                    </form:select>

                                    ${errorGrade}
                                </div>


                        </div>
                        <div class="mb-3">
                            <label for="subjectIds" class="form-label">Môn học</label>
                            <div id="subjects-wrapper">
                                <select name="subjectIds" id="subjects" multiple="multiple" class="form-select">
                                    <c:choose>
                                        <c:when test="${not empty subjects}">
                                            <c:forEach var="subject" items="${subjects}">
                                                <option value="${subject.subjectId}">${subject.subjectName}</option>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="" disabled>Chọn môn học</option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                            </div>
                            <c:if test="${not empty subjectsError}">
                                <div class="invalid-feedback">${subjectsError}</div>
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
                            <label for="image" class="form-label">Avatar (bắt buộc):</label>
                            <input class="form-control ${not empty errorImage ? 'is-invalid' : ''}" type="file"
                                id="image" name="file" eaccept=".png, .jpg, .jpg" required />
                            ${errorImage}
                        </div>




                        <div class="col-12 mt-3">
                            <img style="max-height: 250px; display: none;" alt="Image not found" id="image" />
                        </div>

                        <form:hidden path="status" value="PENDING" />
                        <form:errors path="status" cssClass="invalid-feedback" />

                        <button type="submit" class="btn btn-primary">Lưu</button>
                        <a href="/staff/package" class="btn btn-secondary">Hủy</a>
                        <input name="abc" type="hidden" id="s">
                        </form:form>
                    </div>
                </div>


                <!-- Include Footer -->
                <footer>
                    <jsp:include page="../layout_staff/footer.jsp" />
                </footer>

                <!-- End of <body> -->
                <script
                    src="https://cdn.jsdelivr.net/gh/habibmhamadi/multi-select-tag@4.0.1/dist/js/multi-select-tag.min.js"></script>
                <!-- Bootstrap 5 JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
    document.addEventListener('DOMContentLoaded', function () {
        const gradeSelect = document.getElementById('gradeId');

        function initMultiSelect() {
            const realSelect = document.querySelector('#subjects');
            if (realSelect) {
                realSelect.setAttribute('name', 'subjectIds');
                realSelect.removeAttribute('disabled');
                realSelect.style.position = 'absolute';
                realSelect.style.opacity = '0';
                realSelect.style.pointerEvents = 'none';

                
                realSelect.addEventListener('change', function () {
                    const selectedSubjects = Array.from(this.selectedOptions).map(opt => opt.textContent);
                    console.log("📌 Môn học đang chọn:", selectedSubjects);
                });
document.addEventListener('click', function () {
        const select = document.querySelector('#subjects');
        const selectedIds = Array.from(select.selectedOptions).map(opt => opt.value.trim());
        const hid = document.querySelector("#s");

        if (hid) {
            hid.value = selectedIds.join(','); // Ví dụ: "1,3,5"
            console.log("📤 Danh sách ID môn học:", selectedIds);
        }
    });

            }

            new MultiSelectTag('subjects', {
                maxSelection: 5,
                required: true,
                placeholder: 'Search tags',
            });
        }

      
        initMultiSelect();

        
        gradeSelect.addEventListener('change', function (event) {
            const gradeId = event.target.value.trim();
            if (!gradeId) return;

            fetch('/staff/package/subjects-json?gradeId=' + gradeId)
                .then(res => res.json())
                .then(subjects => {
                    const wrapper = document.getElementById('subjects-wrapper');
                    wrapper.innerHTML = ''; // Xóa select cũ

                    // Tạo select mới
                    const select = document.createElement('select');
                    select.setAttribute('id', 'subjects');
                    select.setAttribute('multiple', 'multiple');
                    select.className = 'form-select';

                    if (Array.isArray(subjects) && subjects.length > 0) {
                        subjects.forEach(sub => {
                            const option = document.createElement('option');
                            option.value = sub.subjectId;
                            option.textContent = sub.subjectName || '(No name)';
                            select.appendChild(option);
                        });
                    } else {
                        const option = document.createElement('option');
                        option.disabled = true;
                        select.appendChild(option);
                    }

                    wrapper.appendChild(select);

                  
                    initMultiSelect();
                })
                .catch(err => {
                    console.error("❌ Lỗi khi fetch:", err);
                });
        });

       
        document.querySelector('form').addEventListener('submit', function (e) {
            const select = document.querySelector('#subjects');
            const selected = Array.from(select.selectedOptions).map(opt => opt.value);
            console.log("📤 Môn học gửi đi:", selected);

            if (selected.length === 0) {
                e.preventDefault();
                alert("⚠️ Bạn phải chọn ít nhất một môn học!");
            }
        });
    });
</script>



            </body>



            </html>