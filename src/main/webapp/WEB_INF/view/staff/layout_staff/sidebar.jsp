<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="d-flex flex-column bg-dark vh-100 position-fixed" style="width: 250px; background-color: #1a252f;">
    <!-- Features Header -->
    <div class="p-3 text-white mt-2">
        <h5 class="mb-0"><i class="bi bi-grid ms-2 me-2"></i> Tính Năng</h5>
    </div>
    <ul class="nav flex-column p-3">
        <li class="nav-item mb-2">
            <a class="nav-link text-white ${activePage == 'questions' ? 'bg-primary rounded' : ''}"
               href="/staff/questions" style="padding: 8px 15px;">
                <i class="bi bi-question-square me-2"></i> Câu hỏi
            </a>
        </li>
        <li class="nav-item mb-2">
            <a class="nav-link text-white ${activePage == 'tests' ? 'bg-primary rounded' : ''}"
               href="/staff/tests" style="padding: 8px 15px;">
                <i class="bi bi-question-square me-2"></i> Bài kiểm tra
            </a>
        </li>
        <li class="nav-item mb-2">
            <a class="nav-link text-white ${activePage == 'subject' ? 'bg-primary rounded' : ''}"
               href="/staff/subject" style="padding: 8px 15px;">
                <i class="bi bi-journal-text me-2"></i> Môn học
            </a>
        </li>

        <li class="nav-item mb-2">
            <a class="nav-link text-white ${activePage == 'package' ? 'bg-primary rounded' : ''}"
               href="/staff/package" style="padding: 8px 15px;">
                <i class="bi bi-mortarboard me-2"></i> Gói học
            </a>
        </li>

    </ul>
</div>