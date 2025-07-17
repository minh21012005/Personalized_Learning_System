<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="d-flex flex-column bg-dark vh-100 position-fixed" style="width: 250px; background-color: #1a252f;">
    <!-- Features Header -->
    <div class="p-3 text-white mt-2">
        <h5 class="mb-0"><i class="bi bi-grid ms-2 me-2"></i> Features</h5>
    </div>
    <ul class="nav flex-column p-3">
        <li class="nav-item mb-2">
            <a class="nav-link text-white "
               href="/admin" style="padding: 8px 15px;">
                <i class="bi bi-speedometer2 me-2"></i> Dashboard
            </a>
        </li>
        <li class="nav-item mb-2">
            <a class="nav-link text-white"
               href="/admin/user" style="padding: 8px 15px;">
                <i class="bi bi-person me-2"></i> User
            </a>
        </li>
        <li class="nav-item mb-2">
            <a class="nav-link text-white "
               href="/admin/grade" style="padding: 8px 15px;">
                <i class="bi bi-book me-2"></i> Grades
            </a>
        </li>
        <li class="nav-item mb-2">
            <a class="nav-link text-white ${pageContext.request.requestURI.contains('/admin/subject') ? 'bg-primary rounded' : ''}"
               href="/admin/subject" style="padding: 8px 15px;">
                <i class="bi bi-journal-text me-2"></i> Subject
            </a>
        </li>
        <li class="nav-item mb-2">
            <a class="nav-link text-white ${activePage == 'questions' ? 'bg-primary rounded' : ''}"
               href="/admin/questions" style="padding: 8px 15px;">
                <i class="bi bi-question-square me-2"></i> Câu hỏi
            </a>
        </li>
        <li class="nav-item mb-2">
            <a class="nav-link text-white ${activePage == 'tests' ? 'bg-primary rounded' : ''}"
               href="/admin/tests" style="padding: 8px 15px;">
                <i class="bi bi-question-square me-2"></i> Bài kiểm tra
            </a>
        </li>


        <li class="nav-item mb-2">
            <a class="nav-link text-white ${activePage == 'packages' ? 'bg-primary rounded' : ''}"
               href="/admin/package" style="padding: 8px 15px;">
                <i class="bi bi-question-square me-2"></i> Gói học
            </a>
    </ul>
</div>