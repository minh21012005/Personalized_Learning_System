<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Luyện Tập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f4f7fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .main-container {
            margin-top: 80px;
            padding: 30px;
            flex: 1;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            background-color: #ffffff;
        }
        .card-header {
            background-color: #007bff;
            color: #ffffff;
            font-weight: bold;
            border-radius: 10px 10px 0 0;
            padding: 15px;
        }
        .filter-form {
            margin-bottom: 20px;
            background-color: #e9ecef;
            padding: 15px;
            border-radius: 8px;
        }
        .table {
            margin-bottom: 0;
        }
        .table th {
            background-color: #e9ecef;
            font-weight: 600;
        }
        .table td {
            vertical-align: middle;
        }
        .btn-details {
            background-color: #28a745;
            border: none;
            padding: 8px 16px;
            font-size: 0.9rem;
            border-radius: 5px;
        }
        .btn-details:hover {
            background-color: #218838;
        }
        .btn-filter {
            background-color: #007bff;
            border: none;
            padding: 8px 16px;
            font-size: 0.9rem;
            border-radius: 5px;
        }
        .btn-filter:hover {
            background-color: #0056b3;
        }
        .pagination {
            justify-content: center;
            margin-top: 20px;
        }
        .pagination .page-link {
            color: #007bff;
            border-radius: 5px;
            margin: 0 3px;
        }
        .pagination .page-item.active .page-link {
            background-color: #007bff;
            border-color: #007bff;
        }
        .pagination .page-item.disabled .page-link {
            color: #6c757d;
        }
        .no-data {
            text-align: center;
            color: #6c757d;
            padding: 20px;
            font-size: 1.1rem;
        }
        #practiceChart {
            max-height: 400px;
            margin-top: 20px;
        }
        @media (max-width: 768px) {
            .main-container {
                padding: 15px;
            }
            .table {
                font-size: 0.9rem;
            }
            .btn-details, .btn-filter {
                width: 100%;
                padding: 10px;
            }
            .filter-form {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
<header>
    <jsp:include page="../layout/header.jsp"/>
</header>
<div class="main-container">
    <div class="card">
        <div class="card-header">
            <h4 class="mb-0">Lịch Sử Luyện Tập</h4>
        </div>
        <div class="card-body">
            <!-- Form lọc thời gian -->
            <form class="filter-form" action="/practices/history" method="get">
                <div class="row g-3 align-items-center">
                    <div class="col-md-3">
                        <label for="startDate" class="form-label">Từ ngày:</label>
                        <input type="date" id="startDate" name="startDate" class="form-control" value="${startDate}">
                    </div>
                    <div class="col-md-3">
                        <label for="endDate" class="form-label">Đến ngày:</label>
                        <input type="date" id="endDate" name="endDate" class="form-control" value="${endDate}">
                    </div>
                    <div class="col-md-2">
                        <label for="daysRange" class="form-label">Phạm vi biểu đồ:</label>
                        <select id="daysRange" name="daysRange" class="form-control">
                            <option value="7" selected>7 ngày</option>
                            <option value="30">30 ngày</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"> </label>
                        <button type="submit" class="btn btn-filter w-100">Lọc</button>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"> </label>
                        <a href="/practices/history" class="btn btn-secondary w-100">Xóa bộ lọc</a>
                    </div>
                </div>
                <input type="hidden" name="page" value="0">
                <input type="hidden" name="size" value="${pageSize}">
            </form>
            <!-- Biểu đồ điểm trung bình -->
            <canvas id="practiceChart"></canvas>
            <!-- Danh sách bài kiểm tra -->
            <c:if test="${not empty testHistoryPage.content}">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th scope="col"></th>
                        <th scope="col">Tổng Số Câu Hỏi</th>
                        <th scope="col">Số Câu Đúng</th>
                        <th scope="col">Thời Gian Bắt Đầu</th>
                        <th scope="col">Thời Gian Kết Thúc</th>
                        <th scope="col">Hành Động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="test" items="${testHistoryPage.content}">
                        <tr>
                            <td>${fn:escapeXml(test.testName)}</td>
                            <td>${test.totalQuestions}</td>
                            <td>${test.correctAnswers}</td>
                            <td>${fn:escapeXml(test.startTime)}</td>
                            <td>${fn:escapeXml(test.endTime)}</td>
                            <td>
                                <a href="/practices/history/${test.testId}" class="btn btn-details">Xem chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <!-- Phân trang -->
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li class="page-item ${testHistoryPage.first ? 'disabled' : ''}">
                            <a class="page-link" href="/practices/history?page=${testHistoryPage.number - 1}&size=${pageSize}&startDate=${startDate}&endDate=${endDate}" aria-label="Previous">
                                <span aria-hidden="true">«</span>
                            </a>
                        </li>
                        <c:forEach begin="0" end="${testHistoryPage.totalPages - 1}" var="i">
                            <li class="page-item ${i == testHistoryPage.number ? 'active' : ''}">
                                <a class="page-link" href="/practices/history?page=${i}&size=${pageSize}&startDate=${startDate}&endDate=${endDate}">${i + 1}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${testHistoryPage.last ? 'disabled' : ''}">
                            <a class="page-link" href="/practices/history?page=${testHistoryPage.number + 1}&size=${pageSize}&startDate=${startDate}&endDate=${endDate}" aria-label="Next">
                                <span aria-hidden="true">»</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
            <c:if test="${empty testHistoryPage.content}">
                <p class="no-data">Không tìm thấy bài kiểm tra nào trong khoảng thời gian này.</p>
            </c:if>
        </div>
    </div>
</div>
<footer>
    <jsp:include page="../layout/footer.jsp"/>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
        crossorigin="anonymous"></script>
<script>
    let chartInstance = null;

    function drawChart(labels, scores, days) {
        const ctx = document.getElementById('practiceChart')?.getContext('2d');
        if (!ctx) return;

        // Hủy biểu đồ cũ nếu có
        if (chartInstance) {
            chartInstance.destroy();
        }

        chartInstance = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Điểm trung bình (Thang 10)',
                    data: scores,
                    borderColor: '#007bff',
                    backgroundColor: 'rgba(0, 123, 255, 0.1)',
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#007bff',
                    pointBorderColor: '#ffffff',
                    pointHoverBackgroundColor: '#ffffff',
                    pointHoverBorderColor: '#007bff'
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 10,
                        title: {
                            display: true,
                            text: 'Điểm trung bình'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Ngày'
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    title: {
                        display: true,
                        text: `Thống kê điểm trung bình ${days} ngày gần nhất (Thang 10)`
                    }
                }
            }
        });
    }

    function fetchAverageScore(days) {
        $.ajax({
            url: '/practices/average-score',
            type: 'GET',
            data: { days: days },
            success: function (response) {
                if (response.error) {
                    console.error(response.error);
                    return;
                }
                const labels = response.labels || [];
                const scores = response.scores || [];
                drawChart(labels, scores.map(score => parseFloat(score.toFixed(1))), days);
            },
            error: function (xhr, status, error) {
                console.error('Lỗi khi gọi API:', error);
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        const daysRangeSelect = document.getElementById('daysRange');
        fetchAverageScore(daysRangeSelect.value);

        daysRangeSelect.addEventListener('change', function () {
            fetchAverageScore(this.value);
        });
    });
</script>
</body>
</html>