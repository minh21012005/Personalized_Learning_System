<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>PLS - Admin - Dashboard</title>
                    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.min.css">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <!-- Chart.js CDN -->
                    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
                    <style>
                        body {
                            margin: 0;
                            min-height: 100vh;
                            display: flex;
                            flex-direction: column;
                            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
                            background-color: #f8f9fa;
                        }

                        header {
                            background-color: #212529;
                            color: white;
                            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                        }

                        .main-container {
                            display: flex;
                            flex: 1;
                        }

                        .sidebar {
                            width: 240px;
                            background-color: #212529;
                            color: white;
                            overflow-y: auto;
                            transition: width 0.3s ease;
                        }

                        .sidebar a {
                            color: #ced4da;
                            padding: 12px 16px;
                            display: block;
                            transition: background-color 0.2s ease;
                        }

                        .sidebar a:hover {
                            color: white;
                            background-color: #343a40;
                        }

                        .content {
                            flex: 1;
                            padding: 24px;
                            background-color: #f8f9fa;
                        }

                        footer {
                            background-color: #212529;
                            color: white;
                            height: 56px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            box-shadow: 0 -1px 3px rgba(0, 0, 0, 0.1);
                        }

                        .card {
                            border: none;
                            border-radius: 8px;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                            transition: box-shadow 0.2s ease;
                        }

                        .card:hover {
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                        }

                        .course-card {
                            transition: box-shadow 0.2s ease;
                        }

                        .course-card:hover {
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                        }

                        .review-card .card-body {
                            padding: 12px;
                        }

                        .review-card i {
                            color: #ffca2c;
                            font-size: 0.9em;
                        }

                        .dashboard-title {
                            font-size: 1.75rem;
                            font-weight: 600;
                            color: #212529;
                            margin-bottom: 24px;
                        }

                        .section-title {
                            font-size: 1.25rem;
                            font-weight: 500;
                            color: #212529;
                            margin-bottom: 16px;
                        }

                        .card-title {
                            font-size: 1.1rem;
                            font-weight: 500;
                            margin-bottom: 8px;
                        }

                        .card-text.fs-3 {
                            font-size: 1.5rem !important;
                            font-weight: 600;
                        }

                        .badge {
                            padding: 6px 12px;
                            font-weight: 500;
                        }

                        .course-stats {
                            display: flex;
                            justify-content: space-between;
                            gap: 10px;
                        }

                        .course-stats>div {
                            flex: 1;
                            text-align: center;
                        }

                        .chart-container {
                            position: relative;
                            max-height: 300px;
                        }

                        #revenueChart {
                            height: 180px !important;
                        }
                    </style>
                </head>

                <body>
                    <!-- Header -->
                    <header>
                        <jsp:include page="../layout/header.jsp" />
                    </header>

                    <!-- Main Container for Sidebar and Content -->
                    <div class="main-container">
                        <!-- Sidebar -->
                        <div class="sidebar d-flex flex-column">
                            <jsp:include page="../layout/sidebar.jsp" />
                        </div>

                        <!-- Main Content Area -->
                        <div class="content">
                            <!-- Dashboard Title -->
                            <h2 class="dashboard-title">Admin Dashboard</h2>

                            <!-- Revenue Summary -->
                            <div class="row mb-5">
                                <div class="col-md-4 mb-3">
                                    <div class="card text-dark bg-info-subtle">
                                        <div class="card-body">
                                            <h5 class="card-title">Số người dùng</h5>
                                            <p class="card-text fs-3">${totalActiveUser}</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <div class="card text-dark bg-success-subtle">
                                        <div class="card-body">
                                            <h5 class="card-title">Tổng doanh thu</h5>
                                            <p class="card-text fs-3">
                                                <fmt:formatNumber value="${totalRevenue}" type="number"
                                                    groupingUsed="true" />
                                                <span class="vnd-symbol">₫</span>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <div class="card text-dark bg-warning-subtle">
                                        <div class="card-body">
                                            <h5 class="card-title">Số khóa học</h5>
                                            <p class="card-text fs-3">${totalActivePackage}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Reviews Summary -->
                            <h4 class="section-title">Tổng quan đánh giá</h4>
                            <div class="row mb-5">
                                <div class="col-md-2 mb-3">
                                    <div class="card review-card">
                                        <div class="card-body text-center">
                                            <p class="card-text mb-1">Tổng cộng</p>
                                            <h4 class="fw-bold">${totalReview}</h4>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-2 mb-3">
                                    <div class="card review-card">
                                        <div class="card-body text-center">
                                            <p class="card-text mb-1">1 Sao <i class="bi bi-star-fill"></i></p>
                                            <h4 class="fw-bold">${oneStarRated}</h4>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-2 mb-3">
                                    <div class="card review-card">
                                        <div class="card-body text-center">
                                            <p class="card-text mb-1">2 Sao <i class="bi bi-star-fill"></i></p>
                                            <h4 class="fw-bold">${twoStarRated}</h4>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-2 mb-3">
                                    <div class="card review-card">
                                        <div class="card-body text-center">
                                            <p class="card-text mb-1">3 Sao <i class="bi bi-star-fill"></i></p>
                                            <h4 class="fw-bold">${threeStarRated}</h4>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-2 mb-3">
                                    <div class="card review-card">
                                        <div class="card-body text-center">
                                            <p class="card-text mb-1">4 Sao <i class="bi bi-star-fill"></i></p>
                                            <h4 class="fw-bold">${fourStarRated}</h4>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-2 mb-3">
                                    <div class="card review-card">
                                        <div class="card-body text-center">
                                            <p class="card-text mb-1">5 Sao <i class="bi bi-star-fill"></i></p>
                                            <h4 class="fw-bold">${fiveStarRated}</h4>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Top 3 Courses -->
                            <h4 class="section-title">Top 3 Khóa Học</h4>
                            <div class="row mb-5">
                                <c:forEach var="p" items="${top3Packages}" varStatus="status" end="2">
                                    <div class="col-md-4 mb-3">
                                        <div class="card h-100 shadow-sm course-card">
                                            <div class="card-body p-4">
                                                <span class="badge bg-light text-dark mb-3 fs-6">
                                                    <fmt:formatNumber value="${p.price}" type="number"
                                                        groupingUsed="true" />
                                                    <span class="vnd-symbol">₫</span>
                                                </span>
                                                <h5 class="card-title fw-semibold">${p.name}</h5>
                                                <div class="course-stats mt-3">
                                                    <div>
                                                        <strong class="fs-5">
                                                            <c:out value="${fn:length(p.userPackages)}" />
                                                        </strong><br>
                                                        <small>Số người học</small>
                                                    </div>
                                                    <div>
                                                        <strong class="fs-5">
                                                            <c:out value="${packageOrderCounts[p]}" />
                                                        </strong><br>
                                                        <small>Lượt mua</small>
                                                    </div>
                                                    <div>
                                                        <strong class="fs-5">
                                                            <c:out value="${packageAverageRating[p]}" />
                                                        </strong><br>
                                                        <small>Đánh giá</small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Revenue Chart -->
                            <h4 class="section-title">Tăng trưởng doanh thu</h4>
                            <div class="card">
                                <div class="card-body p-4">
                                    <div class="chart-container">
                                        <canvas id="revenueChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Footer -->
                    <footer>
                        <jsp:include page="../layout/footer.jsp" />
                    </footer>

                    <!-- Bootstrap JS -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <!-- Chart.js Initialization -->
                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            const revenueLabels = [
                                <c:forEach var="data" items="${revenueData}" varStatus="loop">
                                    "${data.month}"${loop.last ? '' : ','}
                                </c:forEach>
                            ];
                            const revenueData = [
                                <c:forEach var="data" items="${revenueData}" varStatus="loop">
                                    ${data.amount}${loop.last ? '' : ','}
                                </c:forEach>
                            ];

                            const ctx = document.getElementById('revenueChart').getContext('2d');
                            new Chart(ctx, {
                                type: 'line',
                                data: {
                                    labels: revenueLabels,
                                    datasets: [{
                                        label: 'Doanh thu (VNĐ)',
                                        data: revenueData,
                                        borderColor: '#0d6efd',
                                        backgroundColor: 'rgba(13, 110, 253, 0.2)',
                                        fill: true,
                                        tension: 0.4
                                    }]
                                },
                                options: {
                                    responsive: true,
                                    maintainAspectRatio: false,
                                    plugins: {
                                        legend: {
                                            position: 'top',
                                            labels: {
                                                font: {
                                                    size: 12
                                                }
                                            }
                                        },
                                        tooltip: {
                                            callbacks: {
                                                label: function (context) {
                                                    return context.dataset.label + ': ' + context.parsed.y.toLocaleString('vi-VN') + ' ₫';
                                                }
                                            }
                                        }
                                    },
                                    scales: {
                                        x: {
                                            title: {
                                                display: true,
                                                text: 'Tháng',
                                                font: {
                                                    size: 14
                                                }
                                            }
                                        },
                                        y: {
                                            title: {
                                                display: true,
                                                text: 'Doanh thu (VNĐ)',
                                                font: {
                                                    size: 14
                                                }
                                            },
                                            ticks: {
                                                callback: function (value) {
                                                    return value.toLocaleString('vi-VN') + ' ₫';
                                                }
                                            }
                                        }
                                    }
                                }
                            });
                        });
                    </script>
                </body>

                </html>