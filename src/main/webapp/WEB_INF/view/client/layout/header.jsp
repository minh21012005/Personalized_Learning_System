<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> <%-- Thêm taglib functions cho fn:startsWith --%>

<style>
    .header {
        background-color: white;
        position: absolute; 
        left:0;
        top: 0;
        width: 100%;
        border-bottom: 1px solid rgba(0,0,0,0.2);
        z-index: 1030;
    }

   .container {
       max-width: 1170px;
       margin: auto;
       padding: 0 15px;
   }
   .head-container {
       display: flex;
       align-items: center;
       justify-content: space-between;
   }
  
   .logo img {
       width: 40px; 
       height: 40px;
       vertical-align: middle;
   }

   .menu .head {
       display: none;
   }

   .menu ul {
       list-style: none;
       padding-left: 0; 
       margin-bottom: 0;
   }

   .menu > ul > li {
       display: inline-block;
   }
   .menu > ul > li:not(:last-child) {
       margin-right: 40px;
   }
   .menu .dropdown {
       position: relative;
   }
   .menu a {
       text-decoration: none;
       text-transform: capitalize;
       font-size: 20px;
       color: #64748B;
       line-height: 1.5;
       display: block;
       transition: color 0.3s ease;
   }

   .menu > ul > li > a {
       padding: 24px 0;
   }

   .menu > ul > .dropdown > a {
       padding-right: 15px;
   }

    .menu a:hover {
        color: #2563EB;
    }

   .menu i.fa-chevron-down { 
       font-size: 10px;
       pointer-events: none;
       user-select: none;
       position: absolute;
       color: #64748B;
       top: calc(50% - 5px);
       right: 0;
   }

   .menu .sub-menu {
       position: absolute;
       top: 100%;
       left: 0;
       width: 230px;
       padding: 15px 0;
       background-color: #2563EB; 
       box-shadow: 0 0 5px hsla(0, 0%, 0%, 0.5);
       z-index: 1000; 
       transform-origin: top;
       transform: scaleY(0);
       visibility: hidden;
       opacity: 0;
       list-style: none; 
    }

    .menu .sub-menu a {
        color: white;
        transition: all 0.3s ease;
    }
    .menu .sub-menu a:hover {
        color: black; 
    }
   .menu li:hover > .sub-menu {
       opacity: 1;
       transform: none;
       visibility: visible;
       transition: all 0.5s ease;
   }

   .menu .sub-menu li a { /* Sửa selector để áp dụng padding đúng cho thẻ a bên trong li */
       padding: 6px 24px;
       display: block; /* Đảm bảo thẻ a chiếm toàn bộ li để dễ click */
   }

   .menu .sub-menu span {
       background-image: linear-gradient(hsl(0, 0%, 100%), hsl(0, 0%, 100%));
       background-size: 0 1px;
       background-repeat: no-repeat;
       background-position: 0 100%;
       transition: background-size 0.5s ease;
   }
   .menu .sub-menu li:hover > a > span {
       background-size: 100% 1px;
   }
   .header-right { 
        display: flex;
        align-items: center;
   }
   .header-right .icon-btn {
       background-color: transparent;
       border: none;
       cursor: pointer;
       color: #64748B;
       font-size: 24px;
       padding: 0; 
       line-height: 1; 
       transition: color 0.3s ease; 
   }
   .header-right > * { 
       margin-left: 25px;
   }
   .header-right > *:first-child { 
        margin-left: 0;
   }
   .header-right .open-menu-btn {
       display: none;
   }

    .header-right .icon-btn:hover,
    .header-right .icon-btn:focus { 
        color: #2563EB; 
    }

    .user-dropdown { /* Class này dùng cho div bọc avatar và dropdown của user */
        position: relative;
        display: inline-flex; 
        align-items: center;
    }

    .user-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
        border: 1px solid #ddd; 
        cursor: pointer; 
    }
   
    .header-right .dropdown-menu { /* Style chung cho các dropdown menu trong header-right */
        min-width: 180px; 
        padding: 0.5rem 0; 
        margin-top: 0.5rem !important; /* Đẩy dropdown xuống một chút */
        border: 1px solid rgba(0,0,0,0.1); 
        box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15); 
        z-index: 1021; /* Đảm bảo dropdown hiển thị trên các element khác */
    }

    .header-right .dropdown-item { 
        padding: 0.5rem 1rem;
        color: #333;
        font-size: 0.9rem; 
        transition: background-color 0.15s ease-in-out, color 0.15s ease-in-out;
        white-space: nowrap; /* Ngăn text xuống dòng trong dropdown item */
    }
    .header-right .dropdown-item:hover,
    .header-right .dropdown-item:focus {
        background-color: #e9ecef; 
        color: #007bff; 
    }
    .header-right form .dropdown-item { /* Style cho nút logout bên trong form */
        width: 100%;
        text-align: left;
        background: none;
        border: none;
        /* padding: 0.5rem 1rem; Kế thừa từ .header-right .dropdown-item */
        /* color: #333; Kế thừa */
        /* font-size: 0.9rem; Kế thừa */
    }
    /* .header-right form .dropdown-item:hover,
    .header-right form .dropdown-item:focus {
        background-color: #e9ecef; 
        color: #007bff; 
    } */
    
    .notification-dropdown-container { /* Class mới cho div bọc nút chuông */
        position: relative; 
    }

    .notification-dropdown-menu { /* Kế thừa .header-right .dropdown-menu và custom thêm */
        width: 360px; 
        max-height: 450px; 
        overflow-y: auto;
        /* Bỏ class dropdown-menu-end để nó căn trái mặc định */
        /* Nếu muốn căn giữa với icon chuông (rộng ~22px), có thể dùng: */
        /* left: 50% !important; */
        /* transform: translateX(calc(-50% + 11px)) !important; */ /* 11px là một nửa icon chuông */
        /* Hoặc đơn giản hơn, nếu nút chuông không quá sát phải: */
        /* left: 0; */ 
    }
    .notification-badge-custom {
        font-size: 0.65em; 
        padding: 0.25em 0.45em; 
    }

   @media (max-width: 991px) {
       .header {
           padding: 12px 0;
       }
       .menu {
           position: fixed;
           right: 0;
           top: 0;
           width: 320px;
           height: 100%;
           background-color: #2563EB;
           padding: 15px 30px 30px;
           overflow-y: auto; 
           z-index: 1050; 
           transform: translateX(100%);
           transition: transform 0.3s ease-in-out; 
       }
       .menu a {
           color: white;
           transition: color 0.3s ease;
       }
       .menu a:hover {
           color: #f0f0f0; 
       }
       .menu.open {
           transform: none;
       }
       .menu .head {
           display: flex;
           align-items: center;
           justify-content: space-between;
           margin-bottom: 25px;
       }

       .menu .close-menu-btn {
           border: none;
           height: 35px;
           width: 35px;
           display: inline-flex;
           align-items: center;
           justify-content: center;
           background-color: transparent;
           cursor: pointer;
           color: white; 
       }

       .menu > ul > li {
           display: block;
       }

       .menu > ul > li:not(:last-child){
           margin-right: 0;
       }

       .menu li {
           border-bottom: 1px solid hsla(0, 0%, 100%, 0.25);
       }

       .menu li:first-child {
           border-top: 1px solid hsla(0, 0%, 100%, 0.25);
       }

       .menu > ul > li > a {
           padding: 12px 0;
       }

       .menu > ul > .dropdown > a {
           padding-right: 34px; 
       }

       .menu i.fa-chevron-down { 
           height: 34px;
           width: 34px;
           border: 1px solid hsla(0, 0%, 100%, 0.25);
           display: inline-flex;
           align-items: center;
           justify-content: center;
           pointer-events: auto;
           cursor: pointer;
           top: 7px; 
           color: white; 
       }

       .menu .dropdown.active > i.fa-chevron-down {
           background-color: hsla(0, 0%, 100%, 0.25);
           transform: rotate(180deg);
       }

       .menu .sub-menu {
           position: static;
           opacity: 1;
           transform: none;
           visibility: visible;
           padding: 0;
           transition: none;
           box-shadow: none; 
           background-color: transparent; 
           display: none; 
       }

       .menu .dropdown.active > .sub-menu {
           display: block;
       }

       .menu .sub-menu li:last-child {
           border: none;
       }

       .menu .sub-menu li a { /* Sửa selector */
           padding: 12px 0 12px 15px; 
       }
       .menu .sub-menu span {
           background-image: none;
       }
       .header-right .open-menu-btn {
           display: inline-flex; 
           align-items: center;
           justify-content: center;
           height: 40px; 
           width: 44px;
           cursor: pointer;
       }
       .header-right .icon-btn {
           font-size: 20px;
       }
       .header-right .notification-dropdown-menu {
            width: auto; 
            max-width: calc(100vw - 30px); 
            /* Để căn giữa dropdown trên mobile nếu cần: */
            /* left: 50% !important; */
            /* transform: translateX(-50%) !important; */
            /* Hoặc để nó căn theo cạnh phải của màn hình: */
            /* right: 15px !important; left: auto !important; transform: none !important; */
       }
       .header-right .user-dropdown .dropdown-menu { /* Đảm bảo user dropdown cũng căn phải trên mobile */
           right: 0 !important;
           left: auto !important;
       }
   }
</style>
<div class="header">
    <div class="container head-container">
        <%-- Logo --%>
        <div class="logo">
            <a href="${pageContext.request.contextPath}/"><img src="<c:url value='/img/logo.jpg'/>" alt="Logo PLS"/></a>
        </div>

        <%-- Menu --%>
        <div class="menu">
            <div class="head">
                <img src="<c:url value='/img/logo.jpg'/>" alt="Logo PLS"/>
                <button type="button" class="close-menu-btn" aria-label="Đóng menu">
                    <i class="fa-solid fa-x"></i>
                </button>
            </div>
            <ul>
                <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                <li class="dropdown">
                    <a href="javascript:void(0);">Khoá học</a> <%-- Tránh link # --%>
                    <i class="fa-solid fa-chevron-down"></i>
                    <ul class="sub-menu">
                        <li><a href="${pageContext.request.contextPath}/courses/all"><span>Tất cả khóa học</span></a></li>
                        <li><a href="${pageContext.request.contextPath}/courses/category/dev"><span>Lập trình</span></a></li>
                        <li><a href="${pageContext.request.contextPath}/courses/category/design"><span>Thiết kế</span></a></li>
                    </ul>
                </li>
                <li><a href="${pageContext.request.contextPath}/services">Dịch vụ</a></li>
                <li><a href="${pageContext.request.contextPath}/news">Tin tức</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Liên hệ</a></li>
            </ul>
        </div>

        <%-- Header Right --%>
        <div class="header-right">
            <%-- Notification Dropdown --%>
            <div class="nav-item dropdown icon-btn notification-dropdown-container"> 
                <button type="button" class="bell-btn icon-btn position-relative border-0 bg-transparent p-0"  
                        id="clientNotificationDropdownToggle" data-bs-toggle="dropdown"
                        data-bs-auto-close="outside" aria-expanded="false" title="Thông báo">
                    <i class="fa-regular fa-bell" style="font-size: 22px;"></i> 
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger notification-badge-custom" 
                          id="clientUnreadNotificationBadge" style="display: none;">
                        <span id="clientUnreadNotificationCount">0</span>
                    </span>
                </button>
                <%-- BỎ class "dropdown-menu-end" để nó căn trái mặc định so với toggle button (hoặc container cha) --%>
                <ul class="dropdown-menu shadow border-0 mt-2 notification-dropdown-menu" 
                    aria-labelledby="clientNotificationDropdownToggle" id="clientNotificationDropdownMenu">
                    <%-- Tiêu đề "Notifications" và HR sẽ được thêm bởi `notification_dropdown.jsp` qua AJAX --%>
                    
                    <div id="clientNotificationDropdownContentLoading" class="text-center p-4" style="display: none;">
                        <div class="spinner-border text-primary spinner-border-sm" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                    <div id="clientNotificationDropdownContentActual">
                        <%-- Nội dung AJAX từ notification_dropdown.jsp sẽ được load vào đây --%>
                    </div>
                    
                    <li><hr class="dropdown-divider my-0"></li>
                    <li>
                        <a class="dropdown-item text-center text-primary small py-2 dropdown-footer-link" 
                           href="${pageContext.request.contextPath}/notification/client/all">
                            Xem tất cả thông báo
                        </a>
                    </li>
                </ul>
            </div>

            <%-- Heart Button --%>
            <button type="button" class="heart-btn icon-btn" title="Yêu thích">
                <i class="fa-regular fa-heart"></i>
            </button>
            
            <%-- User Info/Login Button - Sử dụng JSTL --%>
            <c:set var="sessionFullName" value="${sessionScope.fullName}" />
            <c:set var="sessionAvatar" value="${sessionScope.avatar}" />

            <c:choose>
                <c:when test="${empty sessionFullName}">
                    <%-- Người dùng chưa đăng nhập --%>
                    <button type="button" class="user-btn icon-btn" title="Đăng nhập">
                        <a href="${pageContext.request.contextPath}/login" style="color: inherit; text-decoration: none;">
                            <i class="fa-regular fa-user"></i>
                        </a>
                    </button>
                </c:when>
                <c:otherwise>
                    <%-- Người dùng đã đăng nhập --%>
                    <c:set var="avatarUrl" value="${pageContext.request.contextPath}/img/default-avatar.png"/> 
                    <c:if test="${not empty sessionAvatar}">
                        <%-- Kiểm tra nếu sessionAvatar là URL đầy đủ --%>
                        <c:if test="${fn:startsWith(sessionAvatar, 'http://') || fn:startsWith(sessionAvatar, 'https://')}">
                            <c:set var="avatarUrl" value="${sessionAvatar}"/>
                        </c:if>
                        <%-- Nếu không phải URL đầy đủ, giả sử là tên file và nối với context path --%>
                        <c:if test="${not (fn:startsWith(sessionAvatar, 'http://') || fn:startsWith(sessionAvatar, 'https://'))}">
                            <c:set var="avatarUrl" value="${pageContext.request.contextPath}/img/avatar/${sessionAvatar}"/>
                        </c:if>
                    </c:if>

                    <div class="user-dropdown icon-btn">
                        <a href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" title="Tài khoản của tôi">
                            <img src="${avatarUrl}" alt="User Avatar" class="user-avatar" 
                                 onerror="this.onerror=null; this.src='<c:url value="/img/default-avatar.png"/>';" />
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown"> {/* Giữ dropdown-menu-end cho user dropdown */}
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/account/profile">Thông tin cá nhân</a></li>
                            <li>
                                <form method="post" action="${pageContext.request.contextPath}/logout" style="margin:0;">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="dropdown-item">Logout</button>
                                </form>
                            </li>
                        </ul>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <button type="button" class="open-menu-btn icon-btn" aria-label="Mở menu">
                <i class="fa-solid fa-bars"></i>
            </button>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const menu = document.querySelector(".menu");
        const openMenuBtn = document.querySelector(".header-right .open-menu-btn"); // Selector cụ thể hơn
        const closeMenuBtn = document.querySelector(".menu .close-menu-btn"); 

        if (menu && openMenuBtn && closeMenuBtn) {
            [openMenuBtn, closeMenuBtn].forEach((btn) => {
                btn.addEventListener("click", () => {
                    menu.classList.toggle("open");
                });
            });

            menu.querySelectorAll(".menu .dropdown > i.fa-chevron-down").forEach((arrow)  => { 
                arrow.addEventListener("click", function (event){
                    event.stopPropagation(); 
                    this.closest(".dropdown").classList.toggle("active");
                });
            });
        } else {
            if (!menu) console.warn("Menu element not found");
            if (!openMenuBtn) console.warn("Open menu button not found");
            if (!closeMenuBtn) console.warn("Close menu button not found");
        }
    });
</script>