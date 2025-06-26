<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>Trang thông tin cá nhân</title>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
	<!-- Bootstrap Icons -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />

	<%--Font-awesome--%>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSF7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

	<!-- Custom CSS -->
	<style>
		ul {
			margin: 0;
		}
		.profile-page body {
			background-color: #f5f5f5;
		}
		.profile-page .sidebar {
			background-color: #fff;
			border-radius: 10px;
			padding: 20px;
			height: fit-content;
			box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
		}
		.profile-page .main-content {
			background-color: #fff;
			border-radius: 10px;
			padding: 20px;
			box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
		}
		.profile-page .nav-link {
			color: #333;
			padding: 10px 10px;
			border-radius: 5px;
		}
		.profile-page .nav-link.active {
			background-color: #343a40;
			color: #fff;
		}
		.profile-page .form-section {
			background-color: #ffffff;
			border: #e2e8f0 1px solid;
			border-radius: 10px;
			padding: 20px;
		}
		.profile-page .image-preview i {
			font-size: 50px;
			color: #adb5bd;
		}
		.profile-page .btn-save-image {
			background-color: #343a40;
			color: #fff;
			border-radius: 5px;
		}
		.profile-page .btn-upload {
			border: 1px solid #ddd;
			border-radius: 5px;
			padding: 5px 10px;
			font-size: 14px;
			color: #333;
			background-color: #f8f9fa;
		}
		.profile-page .btn-remove-image {
			background-color: #dc3545;
			color: #fff;
			border-radius: 5px;
			margin-top: 10px;
		}
	</style>
</head>
<body>
<header>
	<jsp:include page="../layout/header.jsp"/>
</header>

<div class="profile-page mt-5">
	<div class="container py-5">
		<div class="row">
			<!-- Sidebar -->
			<div class="col-md-3">
				<jsp:include page="../layout/sidebar.jsp"/>
			</div>

			<!-- Main Content -->
			<div class="col-md-9">
				<div class="main-content">
					<form:form action="/account/profile" method="post" modelAttribute="user" enctype="multipart/form-data">
						<div class="form-section">
							<div class="row">
								<div class="col-md-6 mb-3">
									<label for="fullName" class="form-label">Họ và tên</label>
									<form:input type="text" class="form-control form__item" id="fullName" path="fullName" required="true" />
									<c:set var="errorFullName">
										<form:errors path="fullName" cssClass="text-danger" />
									</c:set>
										${errorFullName}
								</div>
								<div class="col-md-6 mb-3">
									<label for="birthDate" class="form-label">Ngày sinh</label>
									<form:input type="date" class="form-control form__item" id="birthDate" path="dob" required="true" />
									<c:set var="errorDob">
										<form:errors path="dob" cssClass="text-danger" />
									</c:set>
										${errorDob}
								</div>
								<div class="col-md-6 mb-3">
									<label for="email" class="form-label">Email</label>
									<form:input type="email" class="form-control form__item" id="email" path="email" required="true" readonly="true" />
									<c:set var="errorEmail">
										<form:errors path="email" cssClass="text-danger" />
									</c:set>
										${errorEmail}
								</div>
								<form:input type="hidden" path="password" />
								<div class="col-md-6 mb-3">
									<label for="phone" class="form-label">Số điện thoại</label>
									<form:input type="text" class="form-control form__item" id="phone" path="phoneNumber" required="true" />
									<c:set var="errorPhone">
										<form:errors path="phoneNumber" cssClass="text-danger" />
									</c:set>
										${errorPhone}
								</div>
							</div>
						</div>

						<!-- Image Preview and Upload -->
						<div class="form-section">
							<div class="row">
								<div class="col-md-6 col-12">
									<label for="avatarFile" class="form-label">Avatar:</label>
									<input class="form-control" type="file" id="avatarFile" name="file"
										   accept=".png, .jpg, .jpeg" />
									<c:if test="${not empty fileError}">
										<div class="invalid-feedback d-block">${fileError}</div>
									</c:if>
								</div>
								<div class="col-12 mt-3">
									<c:choose>
										<c:when test="${not empty user.avatar}">
											<img style="max-height: 250px; display: block"
												 alt="Image not found" id="avatarPreview"
												 src="/img/avatar/${user.avatar}" />
										</c:when>
										<c:otherwise>
											<img style="max-height: 250px; display: none"
												 alt="Image not found" id="avatarPreview" src="#" />
										</c:otherwise>
									</c:choose>
									<!-- Remove Image Button -->
									<div class="mt-2">
										<button type="button" class="btn btn-remove-image" id="removeImageBtn" style="display: ${not empty user.avatar ? 'inline-block' : 'none'}">Xóa ảnh</button>
									</div>
								</div>
							</div>
							<c:if test="${not empty success}">
								<div class="alert alert-success mt-3 alert-dismissible fade show" role="alert">
										${success}
									<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
								</div>
							</c:if>
						</div>
						<form:input type="hidden" path="avatar" id="avatarInput" />
						<div class="col-md-2 mt-2 d-flex align-items-end">
							<button type="submit" class="btn btn-save-image">Lưu thay đổi</button>
						</div>
					</form:form>
				</div>
			</div>
		</div>
	</div>
</div>

<footer>
	<jsp:include page="../layout/footer.jsp" />
</footer>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script> -->
<script>
	$(document).ready(() => {
		const avatarFile = $("#avatarFile");
		const avatarPreview = $("#avatarPreview");
		const removeImageBtn = $("#removeImageBtn");
		const avatarInput = $("#avatarInput");

		// Khởi tạo avatarInput với tên file ảnh hiện tại
		<c:if test="${not empty user.avatar}">
		avatarInput.val("${user.avatar}");
		</c:if>

		// Xử lý khi chọn ảnh mới
		avatarFile.change(function (e) {
			if (e.target.files.length > 0) {
				const imgURL = URL.createObjectURL(e.target.files[0]);
				avatarPreview.attr("src", imgURL).css({ "display": "block" });
				removeImageBtn.css({ "display": "inline-block" });
				avatarInput.val(""); // Xóa giá trị avatar cũ để ưu tiên file mới
			}
		});

		// Xử lý khi nhấn nút xóa ảnh
		removeImageBtn.click(function () {
			avatarPreview.attr("src", "#").css({ "display": "none" });
			avatarFile.val(""); // Xóa file đã chọn
			avatarInput.val(""); // Đặt avatar về rỗng để backend xóa avatar
			removeImageBtn.css({ "display": "none" });
		});
	});
</script>
</body>
</html>