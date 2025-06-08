<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>


<c:set var="currentIsEditMode" value="${not empty isEditMode ? isEditMode : false}"/>
<c:set var="currentFormAction" value="${not empty formAction ? formAction : (currentIsEditMode ? pageContext.request.contextPath.concat('/admin/notification/edit/').concat(notificationId) : pageContext.request.contextPath.concat('/admin/notification/create'))}"/>
<c:set var="submitButtonText" value="${currentIsEditMode ? 'Cập nhật thông báo' : 'Gửi thông báo'}"/>
<c:set var="submitButtonIcon" value="${currentIsEditMode ? 'fas fa-save' : 'fas fa-paper-plane'}"/>

<%-- Tiêu đề của phần content này (sẽ được bao bởi show.jsp) --%>
<%-- Tiêu đề chính của trang (pageTitle) đã được đặt ở show.jsp --%>
<%-- Nếu bạn muốn có một tiêu đề phụ riêng cho form ở đây, có thể thêm:
    <h4 class="mb-3">${currentIsEditMode ? 'Chỉnh sửa thông báo' : 'Tạo thông báo mới'}</h4>
--%>

<div class="card shadow-sm">
    <div class="card-header">
        <h5 class="mb-0">${currentIsEditMode ? 'Chỉnh sửa thông báo' : 'Tạo thông báo mới'}</h5>
    </div>
    <div class="card-body">
        <form action="${currentFormAction}" method="post" id="notificationForm">
         
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <c:if test="${currentIsEditMode && not empty notificationId}">
                <%-- <input type="hidden" name="id" value="${notificationId}" /> --%>
            </c:if>

           
            <c:if test="${not empty formErrorMessage}">
                <div class="alert alert-warning alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i><c:out value="${formErrorMessage}"/>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            

            <div class="row">
                <div class="col-md-12">
                    <div class="form-group mb-3">
                        <label for="title" class="form-label">Tiêu đề <span class="text-danger">*</span>:</label>
                        <input type="text" class="form-control" id="title" name="title" value="<c:out value='${title}' escapeXml='true'/>" required maxlength="255">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12">
                    <div class="form-group mb-3">
                        <label for="content" class="form-label">Nội dung <span class="text-danger">*</span>:</label>
                        <textarea class="form-control" id="content" name="content" rows="5" required><c:out value='${content}' escapeXml='true'/></textarea>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group mb-3">
                        <label for="link" class="form-label">Link <span class="text-danger">*</span>:</label>
                        <input type="text" class="form-control" id="link" name="link" value="<c:out value='${link}' escapeXml='true'/>" required maxlength="255">
                        <small class="form-text text-muted">Ví dụ: /page/detail/123 hoặc https://example.com</small>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group mb-3">
                        <label for="thumbnail" class="form-label">Thumbnail (URL ảnh):</label>
                        <input type="url" class="form-control" id="thumbnail" name="thumbnail" value="<c:out value='${thumbnail}' escapeXml='true'/>" maxlength="255">
                        <small class="form-text text-muted">URL ảnh hợp lệ (http:// hoặc https://).</small>
                    </div>
                </div>
            </div>

            <%-- 
                Khi Edit, không cho sửa Target Type và Target Value để đơn giản hóa.
                Select box sẽ bị disabled.
                Nếu bạn muốn cho phép sửa người nhận, cần logic phức tạp hơn ở cả backend và frontend
                để load và pre-select người nhận cũ, cũng như xử lý việc thay đổi người nhận.
            --%>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group mb-3">
                        <label for="targetType" class="form-label">Đối tượng nhận <c:if test="${not currentIsEditMode}"><span class="text-danger">*</span></c:if>:</label>
                        <select class="form-select" name="targetType" id="targetType" 
                                <c:if test="${not currentIsEditMode}">required</c:if> 
                                <c:if test="${currentIsEditMode}">disabled</c:if>>
                            <option value="" disabled <c:if test="${empty selectedTargetType && not currentIsEditMode}">selected</c:if>>-- Chọn loại đối tượng --</option>
                            <option value="USER" <c:if test="${selectedTargetType == 'USER'}">selected</c:if>>User cụ thể (Student/Parent)</option>
                            <option value="PACKAGE" <c:if test="${selectedTargetType == 'PACKAGE'}">selected</c:if>>Các user theo Package</option>
                            <option value="SUBJECT" <c:if test="${selectedTargetType == 'SUBJECT'}">selected</c:if>>Các user theo Subject</option>
                            <option value="ROLE" <c:if test="${selectedTargetType == 'ROLE'}">selected</c:if>>Các user theo Role (Student/Parent)</option>
                        </select>
                        <c:if test="${currentIsEditMode}">
                            <%-- Khi select bị disabled, giá trị của nó không được gửi đi.
                                 Nếu backend cần targetType khi edit (dù không cho sửa),
                                 chúng ta cần gửi nó qua một input hidden.
                                 Tuy nhiên, phiên bản controller hiện tại cho processUpdateNotification
                                 không nhận targetType, nên dòng này có thể không cần thiết.
                            --%>
                             <input type="hidden" name="targetType" value="${selectedTargetType}" />
                        </c:if>
                    </div>
                </div>
                <div class="col-md-6">
                    <div id="targetValue-area" class="form-group mb-3" 
                         style="${currentIsEditMode ? 'display: none;' : (empty selectedTargetType ? 'display: none;' : '') }"> 
                        <label for="targetValue" id="targetValueLabel" class="form-label">Chọn giá trị <c:if test="${not currentIsEditMode}"><span class="text-danger">*</span></c:if>:</label>
                        <select class="form-select" name="targetValue" id="targetValue" multiple 
                                <c:if test="${not currentIsEditMode && not empty selectedTargetType}">required</c:if>>
                            <%-- Options sẽ được JS thêm vào --%>
                        </select>
                        <small id="targetValueHelp" class="form-text text-muted"></small>
                    </div>
                </div>
            </div>

            <div class="mt-4 border-top pt-3">
                <button type="submit" class="btn btn-primary"><i class="${submitButtonIcon} me-1"></i> <c:out value="${submitButtonText}"/></button>
                <a href="${pageContext.request.contextPath}/admin/notification/show" class="btn btn-outline-secondary ms-2"><i class="fas fa-times me-1"></i> Hủy</a>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function () {
        const allUsersData = [
            <c:forEach items="${allUsers}" var="user" varStatus="loopStatus">
                { 
                    id: '${user.userId}', 
                    textValue: '<c:out value="${user.fullName}" escapeXml="true"/> (<c:out value="${user.email}" escapeXml="true"/>)'
                }<c:if test="${not loopStatus.last}">,</c:if>
            </c:forEach>
        ];

        const allPackagesData = [
            <c:forEach items="${allPackages}" var="pkg" varStatus="loopStatus">
                { 
                    id: '${pkg.packageId}', 
                    textValue: '<c:out value="${pkg.name}" escapeXml="true"/>'
                }<c:if test="${not loopStatus.last}">,</c:if>
            </c:forEach>
        ];

        const allSubjectsData = [
            <c:forEach items="${allSubjects}" var="subject" varStatus="loopStatus">
                { 
                    id: '${subject.subjectId}', 
                    textValue: '<c:out value="${subject.subjectName}" escapeXml="true"/>'
                }<c:if test="${not loopStatus.last}">,</c:if>
            </c:forEach>
        ];

        const allRolesData = [
            <c:forEach items="${allRoles}" var="roleName" varStatus="loopStatus">
                { 
                    id: '<c:out value="${roleName}" escapeXml="true"/>', 
                    textValue: '<c:out value="${roleName}" escapeXml="true"/>'
                }<c:if test="${not loopStatus.last}">,</c:if>
            </c:forEach>
        ];

        const selectedTargetTypeFromModel = "${selectedTargetType}";
        const selectedTargetValuesFromModel = [
            <c:forEach items="${selectedTargetValues}" var="val" varStatus="loopStatus">
                "${val}"<c:if test="${not loopStatus.last}">,</c:if>
            </c:forEach>
        ];
        
        const currentIsEditModeJS = ${not empty isEditMode && isEditMode ? true : false};

        const targetTypeSelect = document.getElementById('targetType');
        const targetValueArea = document.getElementById('targetValue-area');
        const targetValueSelect = document.getElementById('targetValue');
        const targetValueLabel = document.getElementById('targetValueLabel');
        const targetValueHelp = document.getElementById('targetValueHelp');

        function updateTargetValueOptions() {
            if (currentIsEditModeJS && targetTypeSelect.disabled) {
                targetValueArea.style.display = 'none';
                return;
            }

            const type = targetTypeSelect.value;
            targetValueArea.style.display = 'none';
            targetValueSelect.innerHTML = '';
            targetValueSelect.required = false;
            targetValueHelp.textContent = '';

            if (!type) {
                return;
            }

            const formErrorMsg = '${fn:escapeXml(formErrorMessage)}';

            let dataSource = [];
            let labelText = "Chọn giá trị:";
            let helpTextDefault = "Giữ Ctrl (hoặc Cmd trên Mac) để chọn nhiều mục.";

            switch (type) {
                case 'USER':
                    dataSource = allUsersData;
                    labelText = "Chọn User (Student/Parent, Active):";
                    if (dataSource.length === 0) {
                        helpTextDefault = formErrorMsg.includes("User") || formErrorMsg.includes("người dùng") ? "Lỗi tải DS User." : "Không có User phù hợp.";
                    }
                    break;
                case 'PACKAGE':
                    dataSource = allPackagesData;
                    labelText = "Chọn Package (Active):";
                    if (dataSource.length === 0) {
                        helpTextDefault = formErrorMsg.includes("Package") || formErrorMsg.includes("gói học") ? "Lỗi tải DS Package." : "Không có Package phù hợp.";
                    }
                    break;
                case 'SUBJECT':
                    dataSource = allSubjectsData;
                    labelText = "Chọn Subject (Active):";
                    if (dataSource.length === 0) {
                        helpTextDefault = formErrorMsg.includes("Subject") || formErrorMsg.includes("môn học") ? "Lỗi tải DS Subject." : "Không có Subject phù hợp.";
                    }
                    break;
                case 'ROLE':
                    dataSource = allRolesData;
                    labelText = "Chọn Role (Student/Parent):";
                    if (dataSource.length === 0) {
                        helpTextDefault = formErrorMsg.includes("Role") || formErrorMsg.includes("vai trò") ? "Lỗi tải DS Role." : "Không có Role phù hợp.";
                    }
                    break;
                default:
                    return;
            }

            targetValueHelp.textContent = helpTextDefault;
            targetValueLabel.textContent = labelText;
            if (!currentIsEditModeJS || !targetTypeSelect.disabled) {
                targetValueArea.style.display = 'block';
            }

            if (dataSource.length > 0) {
                dataSource.forEach(item => {
                    const option = document.createElement('option');
                    option.value = item.id;
                    option.textContent = item.textValue;

                    if (!currentIsEditModeJS && selectedTargetValuesFromModel.includes(String(option.value))) {
                        option.selected = true;
                    }
                    targetValueSelect.appendChild(option);
                });
                if (!currentIsEditModeJS) {
                    targetValueSelect.required = true;
                }
            }
        }

        targetTypeSelect.addEventListener('change', updateTargetValueOptions);

        if (selectedTargetTypeFromModel && (!currentIsEditModeJS || !targetTypeSelect.disabled)) {
            updateTargetValueOptions();
        } else if (currentIsEditModeJS && targetTypeSelect.disabled) {
            targetValueArea.style.display = 'none';
        }
    });
</script>