<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <meta charset="utf-8" />
                <title>Thanh toán - PLS</title>
                <link rel="stylesheet" href="/css/checkout.css">
            </head>

            <body>
                <div class="checkout-minhnb">
                    <div class="container">
                        <header class="main-header">
                            <nav class="main-nav">
                                <div class="logo-wrapper">
                                    <div class="logo"></div>
                                    <span class="brand-name">PLS</span>
                                </div>
                                <span class="nav-item">Categories</span>
                                <form class="search-form" role="search">
                                    <input type="search" class="search-input" placeholder="Search courses"
                                        aria-label="Search courses" />
                                    <button type="submit" class="search-button" aria-label="Submit search">
                                        <img src="https://c.animaapp.com/mc0hohc0Q9222b/img/heroicons-magnifying-glass-20-solid.svg"
                                            alt="Search icon" class="search-icon" />
                                    </button>
                                </form>
                                <span class="nav-item">Teach on PLS</span>
                                <div class="user-actions">
                                    <button class="action-button" aria-label="Favorites">
                                        <img src="https://c.animaapp.com/mc0hohc0Q9222b/img/heart.svg" alt="Heart icon"
                                            class="action-icon" />
                                    </button>
                                    <button class="action-button" aria-label="Cart">
                                        <img src="https://c.animaapp.com/mc0hohc0Q9222b/img/icon-cart.svg"
                                            alt="Cart icon" class="action-icon" />
                                    </button>
                                    <button class="action-button" aria-label="Notifications">
                                        <img src="https://c.animaapp.com/mc0hohc0Q9222b/img/bell-01.svg" alt="Bell icon"
                                            class="action-icon" />
                                    </button>
                                    <div class="user-avatar">
                                        <span class="avatar-initial">J</span>
                                    </div>
                                </div>
                            </nav>
                        </header>
                        <main class="main-content">
                            <div class="payment-info">
                                <section class="qr-section">
                                    <h2 class="section-title">Quét QR để thanh toán</h2>
                                    <img src="${qrUrl}" alt="QR Code for payment" class="qr-code" />
                                    <div class="total-amount">
                                        <span class="amount-label">Tổng tiền</span>
                                        <span class="amount-value">
                                            <fmt:formatNumber value="${amount}" type="number" groupingUsed="true" /> VND
                                        </span>
                                    </div>
                                </section>
                                <section class="payment-form">
                                    <form action="/parent/checkout" method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="amount" value="${amount}">
                                        <c:forEach var="pkgId" items="${packageIds}">
                                            <input type="hidden" name="packageIds" value="${pkgId}" />
                                        </c:forEach>
                                        <div class="form-group">
                                            <label for="transaction-id">Mã giao dịch</label>
                                            <input type="text" id="transaction-id" name="transferCode"
                                                placeholder="Nhập mã" required />
                                        </div>
                                        <div class="form-group">
                                            <label for="notes">Ghi chú (nếu có)</label>
                                            <textarea id="notes" name="note" rows="3"></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label for="transfer-content">Nội dung chuyển khoản</label>
                                            <input type="text" id="transfer-content" name="addInfo" value="${addInfo}"
                                                readonly />
                                        </div>
                                        <div class="form-group">
                                            <label for="receipt-upload">Ảnh biên lai</label>
                                            <div class="file-upload-container">
                                                <div class="file-upload">
                                                    <input type="file" id="receipt-upload" name="evidenceImage"
                                                        accept="image/*" />
                                                </div>
                                                <img id="image-preview" class="image-preview" alt="Image Preview" />
                                            </div>
                                        </div>
                                        <div class="button-container">
                                            <button type="submit" class="confirm-button">Xác nhận thanh toán thành
                                                công</button>
                                        </div>
                                    </form>

                                </section>
                            </div>
                        </main>
                        <footer class="main-footer">
                            <div class="footer-content">
                                <div class="footer-brand">
                                    <img src="https://c.animaapp.com/mc0hohc0Q9222b/img/image-4.png" alt="Byway logo"
                                        class="footer-logo" />
                                    <p class="brand-description">
                                        Empowering learners through accessible and engaging online education.<br />
                                        Byway is a leading online learning platform dedicated to providing high-quality,
                                        flexible, and affordable educational experiences.
                                    </p>
                                </div>
                                <nav class="footer-nav">
                                    <div class="nav-column">
                                        <h3>Get Help</h3>
                                        <ul>
                                            <li><a href="#">Contact Us</a></li>
                                            <li><a href="#">Latest Articles</a></li>
                                            <li><a href="#">FAQ</a></li>
                                        </ul>
                                    </div>
                                    <div class="nav-column">
                                        <h3>Programs</h3>
                                        <ul>
                                            <li><a href="#">Art & Design</a></li>
                                            <li><a href="#">Business</a></li>
                                            <li><a href="#">IT & Software</a></li>
                                            <li><a href="#">Languages</a></li>
                                            <li><a href="#">Programming</a></li>
                                        </ul>
                                    </div>
                                    <div class="nav-column">
                                        <h3>Contact Us</h3>
                                        <address>
                                            <p>Address: 123 Main Street, Anytown, CA 12345</p>
                                            <p>Tel: +(123) 456-7890</p>
                                            <p>Mail: bywayedu@webkul.in</p>
                                        </address>
                                        <div class="social-links">
                                            <img src="https://c.animaapp.com/mc0hohc0Q9222b/img/image-3.png"
                                                alt="Social media icons" class="social-icons" />
                                        </div>
                                    </div>
                                </nav>
                            </div>
                        </footer>
                    </div>
                </div>
                <script>
                    document.getElementById('receipt-upload').addEventListener('change', function (event) {
                        const file = event.target.files[0];
                        const preview = document.getElementById('image-preview');
                        if (file) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                preview.src = e.target.result;
                                preview.style.display = 'block';
                            };
                            reader.readAsDataURL(file);
                        } else {
                            preview.src = '';
                            preview.style.display = 'none';
                        }
                    });
                </script>
            </body>

            </html>