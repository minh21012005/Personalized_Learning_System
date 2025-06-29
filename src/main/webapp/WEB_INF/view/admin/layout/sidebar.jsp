<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <div class="d-flex flex-column bg-dark" style="background-color: #1a252f;">
            <!-- Features Header -->
            <div class="p-3 text-white mt-3">
                <h5 class="mb-0"><i class="bi bi-grid ms-2 me-2"></i> Tính năng</h5>
            </div>
            <ul class="nav flex-column p-3">
                <li class="nav-item mb-2">
                    <a class="nav-link text-white ${activePage == 'dashboard' ? 'bg-primary rounded' : ''}"
                        href="/admin" style="padding: 8px 15px;">
                        <i class="bi bi-speedometer2 me-2"></i> Trang tổng quan
                    </a>
                </li>
                <li class="nav-item mb-2">
                    <a class="nav-link text-white ${activePage == 'user' ? 'bg-primary rounded' : ''}"
                        href="/admin/user" style="padding: 8px 15px;">
                        <i class="bi bi-person me-2"></i> Tài khoản
                    </a>
                </li>
                <li class="nav-item mb-2">
                    <a class="nav-link text-white ${activePage == 'transaction' ? 'bg-primary rounded' : ''}"
                        href="/admin/transaction" style="padding: 8px 15px;">
                        <i class="bi bi-cash-stack me-2"></i> Giao dịch
                    </a>
                </li>
                <li class="nav-item mb-2">
                    <a class="nav-link text-white" href="/admin/notification" style="padding: 8px 15px;">
                        <i class="bi bi-bell me-2"></i> Thông báo
                    </a>
                </li>
                <li class="nav-item mb-2">
                    <a class="nav-link text-white" href="/admin/grade" style="padding: 8px 15px;">
                        <i class="bi bi-book me-2"></i> Khối lớp
                    </a>
                </li>
                <li class="nav-item mb-2">
                    <a class="nav-link text-white" href="/admin/subject" style="padding: 8px 15px;">
                        <i class="bi bi-journal-text me-2"></i> Môn học
                    </a>
                </li>
                <li class="nav-item mb-2">
                    <a class="nav-link text-white" href="/admin/questions" style="padding: 8px 15px;">
                        <i class="bi bi-question-square me-2"></i> Câu hỏi
                    </a>
                </li>
                <li class="nav-item mb-2">
                    <a class="nav-link text-white" href="/admin/chapters" style="padding: 8px 15px;">
                        <i class="bi bi-question-square me-2"></i>  Chương học
                    </a>
                </li>
                <li class="nav-item mb-2">
                    <a class="nav-link text-white"
                    href="/admin/lessons" style="padding: 8px 15px;">
                        <i class="bi bi-question-square me-2"></i> Bài học
                    </a>
                </li>
            </ul>
        </div>