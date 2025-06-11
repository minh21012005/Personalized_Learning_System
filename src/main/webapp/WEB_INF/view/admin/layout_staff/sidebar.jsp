<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="d-flex flex-column bg-dark" style="background-color: #1a252f;">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <!-- Features Header -->
    <div class="p-3 text-white mt-3">
        <h5 class="mb-0"><i class="bi bi-grid ms-2 me-2"></i> Tính năng</h5>
    </div>
    <ul class="nav flex-column p-3">
        <li class="nav-item mb-2">
            <a class="nav-link text-white ${activePage == 'dashboard' ? 'bg-primary rounded' : ''}"
               href="/staff" style="padding: 8px 15px;">
                <i class="bi bi-speedometer2 me-2"></i> Trang tổng quan
            </a>
        </li>

        <li class="nav-item mb-2">
            <a class="nav-link text-white" href="/staff/questions" style="padding: 8px 15px;">
                <i class="fa fa-question-circle me-2"></i>  Câu hỏi
            </a>
        </li>
    </ul>
</div>