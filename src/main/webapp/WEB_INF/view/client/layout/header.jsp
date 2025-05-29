<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .header {
        background-color: white;
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        border-bottom: 1px solid rgba(0,0,0,0.2);
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
   img {
       width: 40px;
       height: 40px;
   }
   .logo img {
       vertical-align: middle;

   }

   .menu .head {
       display: none;
   }

   .menu ul {
       list-style: none;
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

    /* Hiệu ứng hover cho thẻ a trong menu */
    .menu a:hover {
        color: #2563EB; /* Xanh dương đậm khi hover */
    }

   .menu i {
       font-size: 10px;
       pointer-events: none;
       user-select: none;
       position: absolute;
       color: white;
       top: calc(50% - 5px);
   }
   .menu > ul > li > i {
       color: #64748B;
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
       z-index: 1;
       transform-origin: top;
       transform: scaleY(0);
       visibility: hidden;
       opacity: 0;
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

   .menu .sub-menu a {
       padding: 6px 24px;
   }
   .menu .sub-menu .dropdown > a {
       padding-right: 34px;
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
   .header-right .icon-btn {
       background-color: transparent;
       border: none;
       cursor: pointer;
       color: #64748B;
       font-size: 24px;
       transition: color 0.3s ease; /* Thêm transition cho màu icon */
   }
   .header-right > * {
       margin-left: 25px;
   }
   .header-right .open-menu-btn {
       display: none;
   }

    /* Hiệu ứng hover cho icon trong header-right */
    .header-right .icon-btn:hover {
        color: #2563EB; /* Xanh dương đậm khi hover */
    }

    /* User dropdown styles */
    .user-dropdown {
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
    }

    .user-circle {
        width: 30px;
        height: 30px;
        background-color: #6c757d;
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 14px;
    }

    .dropdown-menu {
        min-width: 150px;
        padding: 10px 0;
    }

    .dropdown-item {
        padding: 8px 20px;
        color: #64748B;
        transition: background-color 0.3s ease, color 0.3s ease;
    }

    .dropdown-item:hover {
        background-color: #2563EB;
        color: white;
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
           overflow-y: hidden;
           z-index: 1;
           transform: translateX(100%);
       }
       .menu a {
           color: white;
           transition: color 0.3s ease;
       }
       .menu a:hover {
           color: black;
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
           position: relative;
           display: inline-flex;
           align-items: center;
           justify-content: center;
           background-color: transparent;
           cursor: pointer;
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

       .menu i {
           height: 34px;
           width: 34px;
           border: 1px solid hsla(0, 0%, 100%, 0.25);
           display: inline-flex;
           align-items: center;
           justify-content: center;
           pointer-events: auto;
           cursor: pointer;
           top: 7px;
       }

       .menu .dropdown.active > i {
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
           display: none;
       }

       .menu .dropdown.active > .sub-menu {
           display: block;
       }

       .menu .sub-menu li:last-child {
           border: none;
       }

       .menu .sub-menu a {
           padding: 12px 0 12px 15px;
       }
       .menu .sub-menu span {
           background-image: none;
       }
       .menu .sub-menu i {
           transform: none;
           right: 0;
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
   }
</style>
<!-- header top -->
<div class="header">
    <div class="container head-container">
        <%--    Logo--%>
        <div class="logo">
            <img  src="/img/logo.jpg" alt="Logo PLS"/>
        </div>
        <%--    Logo--%>
        <%--    Menu    --%>
        <div class="menu">
            <div class="head">
                <img src="/img/logo.jpg" alt="Logo PLS"/>
                <button type="button" class="close-menu-btn">
                    <i class="fa-solid fa-x"></i>
                </button>
            </div>
            <ul>
                <li>
                    <a href="/">Trang chủ</a>
                </li>
                <li class="dropdown">
                    <a href="#">Khoá học</a>
                    <i class="fa-solid fa-chevron-down"></i>
                    <ul class="sub-menu">
                        <li>
                            <a href="/">
                                <span>Trang chủ</span>
                            </a>
                        </li>
                        <li>
                            <a>
                                <span>Page2</span>
                            </a>
                        </li>
                        <li>
                            <a>
                                <span>Page3</span>
                            </a>
                        </li>
                        <li>
                            <a>
                                <span>Page4</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <li>
                    <a href="#">Dịch vụ</a>
                </li>

                <li>
                    <a href="#">Tin tức</a>
                </li>
                <li>
                    <a href="#">Liên hệ</a>
                </li>
            </ul>
        </div>
        <%--    Menu    --%>
        <div class="header-right">

            <button type="button" class="bell-btn icon-btn">
                <i class="fa-regular fa-bell"></i>
            </button>
            <button type="button" class="heart-btn icon-btn">
                <i class="fa-regular fa-heart"></i>
            </button>
            <%
                String fullName = (String) session.getAttribute("fullName");
                String avatar = (String) session.getAttribute("avatar");
                if (fullName == null) {
            %>
            <button type="button" class="user-btn icon-btn">
                <a href="/login" style="color: inherit; text-decoration: none;">
                    <i class="fa-regular fa-user"></i>
                </a>
            </button>
            <%
            } else {
                String initial = fullName != null && !fullName.isEmpty() ? fullName.substring(0, 1).toUpperCase() : "U";
                String avatarPath = avatar != null && !avatar.isEmpty() ? "/img/avatar/" + avatar : "/img/default-avatar.png";
            %>
            <div class="user-dropdown icon-btn">
                <a href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                    <img src="<%= avatarPath %>" alt="User Avatar" class="user-avatar" />
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                    <li><a class="dropdown-item" href="/account/profile">Thông tin cá nhân</a></li>
                    <li><form method="post" action="/logout">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button class="dropdown-item">Logout</button>
                    </form></li>
                </ul>
            </div>
            <%
                }
            %>
            <button type="button" class="open-menu-btn icon-btn">
                <i class="fa-solid fa-bars"></i>
            </button>
        </div>
    </div>
</div>
<!-- header top -->

<!-- JavaScript to initialize Bootstrap tooltips -->
<script>
    const menu = document.querySelector(".menu");
    const openMenuBtn = document.querySelector(".open-menu-btn");
    const closeMenuBtn = document.querySelector(".close-menu-btn");

    [openMenuBtn, closeMenuBtn].forEach((btn) => {
        btn.addEventListener("click", () => {
            menu.classList.toggle("open");
            menu.style.transition = "transform 0.5 ease"
        })
    })

    menu.addEventListener("transitioned", function () {
        this.removeAttribute("style")
    })

    menu.querySelectorAll(".dropdown > i").forEach((arrow)  => {
        arrow.addEventListener("click",function (){
            this.closest(".dropdown").classList.toggle("active");
        })
    })
</script>