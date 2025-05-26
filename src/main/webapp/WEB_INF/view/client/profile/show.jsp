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
	<!-- Custom CSS -->
	<style>
		body {
			background-color: #f5f5f5;
		}
		.sidebar {
			background-color: #fff;
			border-radius: 10px;
			padding: 20px;
			height: fit-content;
			box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
		}
		.main-content {
			background-color: #fff;
			border-radius: 10px;
			padding: 20px;
			box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
		}
		.profile-img {
			width: 100px;
			height: 100px;
			border-radius: 50%;
			object-fit: cover;
		}
		.share-profile-btn {
			border: 1px solid #ddd;
			border-radius: 5px;
			padding: 5px 10px;
			font-size: 14px;
			color: #333;
			background-color: #f8f9fa;
		}
		.nav-link {
			color: #333;
			padding: 10px 10px;
			border-radius: 5px;
		}
		.nav-link.active {
			background-color: #343a40;
			color: #fff;
		}
		.form-section {
			background-color: #ffffff;
			border: #e2e8f0 1px solid;
			border-radius: 10px;
			padding: 20px;
		}
		.form__item:focus {
			box-shadow: none;
		}
		.image-preview {
			background-color: #e9ecef;
			border-radius: 10px;
			height: 200px;
			display: flex;
			align-items: center;
			justify-content: center;
			margin-bottom: 20px;
		}
		.image-preview i {
			font-size: 50px;
			color: #adb5bd;
		}
		.btn-save-image {
			background-color: #343a40;
			color: #fff;
			border-radius: 5px;
		}
		.btn-upload {
			border: 1px solid #ddd;
			border-radius: 5px;
			padding: 5px 10px;
			font-size: 14px;
			color: #333;
			background-color: #f8f9fa;
		}
	</style>
</head>
<body>
	<header>
		<jsp:include page="../layout/header.jsp"/>
	</header>

	<div class="container py-5">
		<div class="row">
			<!-- Sidebar -->
			<div class="col-md-3">
				<div class="sidebar">
					<div class="text-center">
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
						<h5 class="mt-3">${user.fullName}</h5>
					</div>
					<ul class="nav flex-column mt-4">
						<li class="nav-item">
							<a href="#" class="nav-link active">Profile</a>
						</li>
					</ul>
				</div>
			</div>

			<!-- Main Content -->
			<div class="col-md-9">
				<div class="main-content">
					<form:form action="/student/profile" method="post" modelAttribute="user" enctype="multipart/form-data">
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
							<div class="row mt-4">
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
								</div>
							</div>
							<c:if test="${not empty success}">
								<div class="alert alert-success mt-3">${success}</div>
							</c:if>
						</div>
						<form:input type="hidden" path="avatar" />
						<div class="col-md-2 mt-2 d-flex align-items-end">
							<button type="submit" class="btn btn-save-image">Lưu thay đổi</button>
						</div>
					</form:form>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
<script>
	$(document).ready(() => {
		const avatarFile = $("#avatarFile");
		avatarFile.change(function (e) {
			const imgURL = URL.createObjectURL(e.target.files[0]);
			$("#avatarPreview").attr("src", imgURL);
			$("#avatarPreview").css({ "display": "block" });
		});
	});
</script>
</body>
</html>