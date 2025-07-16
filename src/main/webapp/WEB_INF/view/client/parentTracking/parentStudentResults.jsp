<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Theo dõi kết quả học tập của con</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary-color: #0d6efd;
            --secondary-color: #6c757d;
            --bg-color: #f8f9fa;
            --card-bg: #ffffff;
            --shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            --hover-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-color);
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .content {
            width: 96%;
            max-width: 1400px;
            margin: 0 auto;
            flex: 1;
            padding: 24px;
        }

        .card {
            border: none;
            border-radius: 12px;
            background-color: var(--card-bg);
            box-shadow: var(--shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: var(--hover-shadow);
        }

        .card-body {
            padding: 24px;
            position: relative;
        }

        .card-title {
            font-weight: 600;
            color: #212529;
        }

        .btn-view-more {
            font-weight: 500;
            border-radius: 8px;
            padding: 10px 20px;
            background-color: #fff;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            transition: all 0.3s ease;
        }

        .btn-view-more:hover {
            background-color: var(--primary-color);
            color: #fff;
            transform: translateX(-4px);
        }

        .table {
            background-color: var(--card-bg);
            border-radius: 8px;
            overflow: hidden;
        }

        .table th {
            background-color: #e9ecef;
            font-weight: 600;
            color: #212529;
        }

        .table td {
            vertical-align: middle;
            transition: background-color 0.2s ease;
        }

        .table tbody tr:hover {
            background-color: #f1f3f5;
        }

        /* Hiệu ứng loading */
        .loader {
            display: none;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            border: 4px solid #f3f3f3;
            border-top: 4px solid var(--primary-color);
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            z-index: 1000;
        }

        .card-body.loading .loader {
            display: block;
        }

        @keyframes spin {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }

        /* Kiểu cho input ngày và dropdown */
        .date-inputs {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            align-items: center;
            background-color: var(--card-bg);
            padding: 15px;
            border-radius: 8px;
            box-shadow: var(--shadow);
        }

        .date-inputs label {
            font-weight: 500;
            margin-right: 5px;
            color: #212529;
        }

        .date-inputs input, .date-inputs select {
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ced4da;
            transition: border-color 0.3s ease;
        }

        .date-inputs input:focus, .date-inputs select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 5px rgba(13, 110, 253, 0.3);
        }

        .date-inputs .btn {
            padding: 8px 16px;
            border-radius: 6px;
        }

        /* Kiểu cho canvas */
        .chart-container {
            position: relative;
            margin-top: 20px;
            height: 300px;
            background-color: var(--card-bg);
            border-radius: 8px;
            padding: 15px;
            box-shadow: var(--shadow);
        }

        /* Kiểu cho nút Action */
        .action-btn {
            padding: 6px 12px;
            font-size: 0.9rem;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        /* Kiểu cho bảng tiến độ học tập */
        .progress-table {
            margin-top: 20px;
        }

        .progress-table th {
            background-color: #e9ecef;
            font-weight: 600;
            color: #212529;
        }

        .progress-table td {
            vertical-align: middle;
            transition: background-color 0.2s ease;
        }

        .progress-table tbody tr:hover {
            background-color: #f1f3f5;
        }

        .progress-table .progress {
            height: 25px; /* Tăng kích thước thanh tiến độ */
            font-size: 14px; /* Kích thước chữ trong thanh */
            border-radius: 5px;
            margin-right: 10px; /* Khoảng cách với phần trăm */
            display: inline-block;
            width: 80%; /* Để phần trăm có chỗ bên cạnh */
        }

        .progress-table .progress-bar {
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff; /* Màu chữ trên thanh */
            border-radius: 5px;
            transition: width 0.3s ease;
        }

        .progress-table .progress-bar.bg-success {
            background-color: #28a745;
        }

        .progress-table .progress-bar.bg-primary {
            background-color: #0d6efd;
        }

        .progress-table .progress-percentage {
            color: var(--secondary-color); /* Màu xám mờ */
            font-size: 14px;
            vertical-align: middle;
            margin-left: 10px; /* Khoảng cách với progress-bar */
        }

        .progress-table .text-success {
            font-weight: bold;
        }

        .progress-table img {
            max-width: 60px;
            max-height: 60px;
            object-fit: cover;
            border-radius: 5px;
            box-shadow: var(--shadow);
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>
<div class="content">
    <div class="mb-4">
        <a href="/parent/children" class="btn btn-outline-primary btn-view-more">
            <i class="bi bi-arrow-left me-2"></i>Quay lại danh sách con
        </a>
    </div>
    <h1 class="mb-4 fw-bold">Theo dõi kết quả học tập của con</h1>

    <!-- Bài học gần đây -->
    <div class="card mb-4">
        <div class="card-body">
            <h2 class="card-title h4 fw-semibold">Bài học gần đây</h2>
            <table class="table table-striped" id="recentActivitiesTable">
                <thead>
                <tr>
                    <th>Bài học</th>
                    <th>Ngày học</th>
                    <th>Trạng thái</th>
                </tr>
                </thead>
                <tbody id="recentActivitiesBody">
                <!-- Dữ liệu sẽ được tải qua AJAX -->
                </tbody>
            </table>
            <button id="loadMoreActivities" class="btn btn-view-more">Xem thêm</button>
            <div class="loader" id="loaderActivities"></div>
        </div>
    </div>

    <!-- Thời lượng online -->
    <div class="card mb-4">
        <div class="card-body">
            <h2 class="card-title h4 fw-semibold">Thời lượng online</h2>
            <div class="date-inputs">
                <label for="startDate">Từ ngày:</label>
                <input type="date" id="startDate" name="startDate" class="form-control">
                <label for="endDate">Đến ngày:</label>
                <input type="date" id="endDate" name="endDate" class="form-control">
                <label for="timeRange">Xem theo:</label>
                <select id="timeRange" name="timeRange" class="form-select">
                    <option value="day">Ngày</option>
                    <option value="month">Tháng</option>
                    <option value="year">Năm</option>
                </select>
                <button id="filterDate" class="btn btn-primary">Lọc</button>
            </div>
            <div class="chart-container">
                <canvas id="onlineTimeChart"></canvas>
            </div>
            <div class="loader" id="loaderOnlineTime"></div>
        </div>
    </div>

    <!-- Bài kiểm tra gần đây -->
    <div class="card mb-4">
        <div class="card-body">
            <h2 class="card-title h4 fw-semibold">Bài kiểm tra gần đây</h2>
            <table class="table table-striped" id="recentTestsTable">
                <thead>
                <tr>
                    <th>Bài kiểm tra</th>
                    <th>Điểm số</th>
                    <th>Ngày hoàn thành</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody id="recentTestsBody">
                <!-- Dữ liệu sẽ được tải qua AJAX -->
                </tbody>
            </table>
            <button id="loadMoreTests" class="btn btn-view-more">Xem thêm</button>
            <div class="loader" id="loaderTests"></div>
        </div>
    </div>

    <!-- Tiến độ học tập -->
    <div class="card mb-4">
        <div class="card-body">
            <h2 class="card-title h4 fw-semibold">Tiến độ học tập</h2>
            <table class="table table-striped progress-table">
                <thead>
                <tr>
                    <th>Ảnh</th>
                    <th>Tên môn học</th>
                    <th>Số bài hoàn thành</th>
                    <th>Tổng số bài</th>
                    <th>Tiến độ (%)</th>
                </tr>
                </thead>
                <tbody id="progressBody">
                <!-- Dữ liệu sẽ được tải qua AJAX -->
                </tbody>
            </table>
            <div class="loader" id="loaderLearningProgress"></div>
        </div>
    </div>
</div>

<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<script>
    // Truyền childId từ server-side qua JavaScript bằng cách nối xâu
    var childId = "<c:out value='${childId}'/>"; // Sử dụng c:out để tránh XSS

    let onlineTimeData = { labels: [], datasets: [] };
    let onlineTimeChart = null; // Biến để lưu instance Chart

    $(document).ready(function() {
        let currentPage = 0;
        const pageSize = 10;

        // Hàm tải dữ liệu qua AJAX với hiệu ứng loading
        function loadData(endpoint, targetBody, loadMoreButton, loaderId, totalItemsKey, isInitial, startDate, endDate, timeRange) {
            $(loaderId).parent().addClass('loading'); // Hiển thị loader
            $.ajax({
                url: '/api/parent/' + endpoint,
                method: 'GET',
                data: { childId: childId, page: currentPage, size: pageSize, startDate: startDate, endDate: endDate, timeRange: timeRange },
                success: function(response) {
                    const items = response.data;
                    const totalItems = response.total || items.length;
                    if (isInitial && endpoint === 'daily-online-time') {
                        // Hủy biểu đồ cũ trước khi tạo mới
                        if (onlineTimeChart && typeof onlineTimeChart.destroy === 'function') {
                            onlineTimeChart.destroy();
                        }
                        onlineTimeData.labels = items.map(item => {
                            if (timeRange === 'month') {
                                return item.date.split('-')[0]; // Lấy tháng (ví dụ: "03" từ "03-2025")
                            } else if (timeRange === 'year') {
                                return item.date; // Lấy năm (ví dụ: "2025")
                            }
                            return item.date; // Giữ nguyên ngày cho "day"
                        });
                        onlineTimeData.datasets = [{
                            label: 'Thời gian học (phút)',
                            data: items.map(item => item.totalMinutes),
                            backgroundColor: 'rgba(13, 110, 253, 0.5)',
                            borderColor: '#0d6efd',
                            borderWidth: 2,
                            fill: true,
                            tension: 0.4
                        }];
                        renderChart('onlineTimeChart', onlineTimeData, 'onlineTimeChart');
                    } else if (isInitial && endpoint === 'learning-progress') {
                        $('#progressBody').empty();
                        items.forEach(item => {
                            let progressPercentage = item.progressPercentage || 0;
                            let progressBar = progressPercentage === 100
                                ? '<div class="progress" aria-label="Hoàn thành"><div class="progress-bar bg-success" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div></div>'
                                : '<div class="progress" aria-label="' + Math.round(progressPercentage) + '%"><div class="progress-bar bg-primary" role="progressbar" style="width: ' + progressPercentage + '%" aria-valuenow="' + progressPercentage + '" aria-valuemin="0" aria-valuemax="100"></div></div>';
                            let percentageText = progressPercentage === 100 ? 'Hoàn thành' : Math.round(progressPercentage) + '%';
                            $('#progressBody').append(`
                                <tr>
                                    <td><img src="/img/subjectImg/` + (item.subjectImage || '/img/default-subject.jpg') + `" alt="` + item.subjectName + `"></td>
                                    <td>` + item.subjectName + `</td>
                                    <td>` + (item.completedLessons || 0) + `</td>
                                    <td>` + (item.totalLessons || 0) + `</td>
                                    <td>` + progressBar + '<span class="progress-percentage">' + percentageText + '</span>' + `</td>
                                </tr>
                            `);
                        });
                    } else if (isInitial && endpoint === 'recent-lessons') {
                        $('#recentActivitiesBody').empty();
                        items.forEach(item => {
                            $('#recentActivitiesBody').append(`
                                <tr>
                                    <td>` + item.lessonName + `</td>
                                    <td>` + (item.lastUpdated || 'Chưa cập nhật') + `</td>
                                    <td>` + (item.isCompleted ? 'Hoàn thành' : 'Chưa hoàn thành') + `</td>
                                </tr>
                            `);
                        });
                    } else if (isInitial && endpoint === 'recent-tests') {
                        $('#recentTestsBody').empty();
                        items.forEach(item => {
                            $('#recentTestsBody').append(`
                                <tr>
                                    <td>` + item.testName + `</td>
                                    <td>` + (item.score ? item.score.toFixed(2) : '0.00') + `</td>
                                    <td>` + (item.timeEnd || 'Chưa hoàn thành') + `</td>
                                </tr>
                            `);
                        });
                    }
                    if (items.length < pageSize || (totalItemsKey && currentPage * pageSize >= totalItems)) {
                        $(loadMoreButton).hide();
                    } else {
                        $(loadMoreButton).show();
                    }
                },
                error: function() {
                    alert('Có lỗi xảy ra khi tải dữ liệu.');
                },
                complete: function() {
                    $(loaderId).parent().removeClass('loading'); // Ẩn loader sau khi hoàn thành
                }
            });
        }

        // Hàm vẽ biểu đồ
        function renderChart(chartId, data, chartVar) {
            const ctx = document.getElementById(chartId).getContext('2d');
            // Đảm bảo hủy biểu đồ cũ trước khi tạo mới, kiểm tra kiểu dữ liệu
            if (window[chartVar] && typeof window[chartVar].destroy === 'function') {
                window[chartVar].destroy();
            }
            window[chartVar] = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: data.labels,
                    datasets: data.datasets
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Thời gian (phút)',
                                color: '#000'
                            },
                            ticks: {
                                color: '#000'
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Ngày/Tháng/Năm',
                                color: '#000'
                            },
                            ticks: {
                                color: '#000'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            labels: {
                                color: '#000'
                            }
                        }
                    },
                    maintainAspectRatio: false
                }
            });
        }

        // Tải dữ liệu ban đầu
        loadData('recent-lessons', '#recentActivitiesBody', '#loadMoreActivities', '#loaderActivities', 'total', true, null, null, 'day');
        loadData('recent-tests', '#recentTestsBody', '#loadMoreTests', '#loaderTests', 'total', true, null, null, 'day');
        loadData('learning-progress', '#progressBody', null, '#loaderLearningProgress', null, true, null, null, null);

        // Xử lý nút lọc ngày và timeRange
        $('#filterDate').click(function() {
            currentPage = 0;
            const startDate = $('#startDate').val();
            const endDate = $('#endDate').val();
            const timeRange = $('#timeRange').val();
            loadData('daily-online-time', null, null, '#loaderOnlineTime', null, true, startDate, endDate, timeRange);
        });

        // Xử lý nút "Xem thêm"
        $('#loadMoreActivities').click(function() {
            currentPage++;
            loadData('recent-lessons', '#recentActivitiesBody', '#loadMoreActivities', '#loaderActivities', 'total', false, null, null, 'day');
        });

        $('#loadMoreTests').click(function() {
            currentPage++;
            loadData('recent-tests', '#recentTestsBody', '#loadMoreTests', '#loaderTests', 'total', false, null, null, 'day');
        });
    });
</script>
</body>
</html>