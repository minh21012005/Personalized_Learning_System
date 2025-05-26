<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>Trang thông tin cá nhân</title>
		<!-- Bootstrap CSS -->
		<link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
		<!-- Bootstrap Icons -->
		<link
			href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
			rel="stylesheet"
		/>
		<!-- Bootstrap Datepicker CSS -->
		<link
			href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css"
			rel="stylesheet"
		/>
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
				.form__item:focus {
					box-shadow: none;
				}
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
		<div class="container py-5">
			<div class="row">
				<!-- Sidebar -->
				<div class="col-md-3">
					<div class="sidebar">
						<div class="text-center">
							<img src="
							<c:choose>
								<c:when test="${not empty user.avatar}">
									${pageContext.request.contextPath}/resources/img/avatar/${user.avatar}
								</c:when>
								<c:otherwise>
									https://via.placeholder.com/100
								</c:otherwise>
							</c:choose>
							" alt="Profile Image" class="profile-img" />
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
						<form
							action="${pageContext.request.contextPath}/student/profile"
							method="post"
							enctype="multipart/form-data"
						>
							<div class="form-section">
								<div class="row">
									<div class="col-md-6 mb-3">
										<label
											for="fullName"
											class="form-label"
										>
											Họ và tên
										</label>
										<input
											type="text"
											class="form-control form__item"
											id="fullName"
											name="fullName"
											value="${user.fullName}"
											required
										/>
									</div>
									<div class="col-md-6 mb-3">
										<label
											for="birthDate"
											class="form-label"
										>
											Ngày sinh
										</label>
										<input
											type="date"
											class="form-control form__item"
											id="birthDate"
											name="dob"
											value="${user.dob}"
											required
										/>
									</div>
									<div class="col-md-6 mb-3">
										<label
											for="email"
											class="form-label form__item"
										>
											Email
										</label>
										<input
											type="email"
											class="form-control form__item"
											id="email"
											name="email"
											value="${user.email}"
											required
										/>
										<c:if test="${not empty fileError}">
											<div class="text-danger">
												${fileError}
											</div>
										</c:if>
									</div>
									<div class="col-md-6 mb-3">
										<label for="phone" class="form-label">
											Số điện thoại
										</label>
										<input
											type="text"
											class="form-control form__item"
											id="phone"
											name="phoneNumber"
											value="${user.phoneNumber}"
											required
										/>
									</div>
								</div>
							</div>

							<!-- Image Preview and Upload -->
							<div class="form-section">
								<div class="row mt-4">
									<h6>Ảnh đại diện</h6>
									<div class="col-md-6">
										<div class="image-preview">
											<img src="
											<c:choose>
												<c:when
													test="${not empty user.avatar}"
												>
													${pageContext.request.contextPath}/resources/img/avatar/${user.avatar}
												</c:when>
												<c:otherwise>
													https://via.placeholder.com/100
												</c:otherwise>
											</c:choose>
											" alt="Avatar" class="profile-img"
											/>
										</div>
									</div>
									<div class="col-md-8">
										<label for="avatar" class="form-label">
											Chọn ảnh đại diện mới
										</label>
										<input
											type="file"
											class="form-control form__item"
											id="avatar"
											name="file"
											accept="image/png,image/jpg,image/jpeg"
										/>
										<c:if test="${not empty fileError}">
											<div class="text-danger">
												${fileError}
											</div>
										</c:if>
									</div>
									<div
										class="col-md-2 d-flex align-items-end"
									>
										<button
											type="submit"
											class="btn btn-save-image"
										>
											Lưu thay đổi
										</button>
									</div>
								</div>
								<c:if test="${not empty success}">
									<div class="alert alert-success mt-3">
										${success}
									</div>
								</c:if>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<!-- jQuery -->
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<!-- Bootstrap JS and Popper.js -->
		<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"></script>
		<!-- Bootstrap Datepicker JS -->
		<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
		<!-- Datepicker Initialization -->
		<script>
			$(document).ready(function () {
				$("#birthDate")
					.datepicker({
						format: "dd / mm / yyyy", // Định dạng giống trong hình
						autoclose: true, // Tự động đóng khi chọn xong
						todayHighlight: true, // Làm nổi bật ngày hôm nay
						startView: 0, // Bắt đầu từ chế độ chọn ngày
						maxViewMode: 2, // Chế độ tối đa là chọn năm
						language: "vi", // Ngôn ngữ tiếng Việt (nếu có locale)
					})
					.on("changeDate", function (e) {
						// Đảm bảo giá trị được định dạng đúng
						const date = e.date;
						const day = String(date.getDate()).padStart(2, "0");
						const month = String(date.getMonth() + 1).padStart(
							2,
							"0"
						);
						const year = date.getFullYear();
						$(this).val(`${day} / ${month} / ${year}`);
					});

				// Đặt giá trị mặc định là ngày hiện tại (25/05/2025)
				$("#birthDate").datepicker("setDate", new Date(2025, 4, 25)); // Tháng 4 vì tháng trong JS bắt đầu từ 0
			});
		</script>
	</body>
</html>
