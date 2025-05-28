<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta charset="UTF-8" />
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="/lib/bootstrap/css/bootstrap.css">
    <link rel="stylesheet" href="/css/style.css" />
</head>
<body>

<%--   HEADER--%>
    <header>
        <jsp:include page="../layout/header.jsp"/>
    </header>
    <div class="homescreen">
        <div class="overlap-wrapper">
            <div class="overlap">

               <div class="main-frame">
                   <div class="hero-section">
                       <div class="hero-content">
                           <div class="hero-text">
                               <p class="hero-title">Unlock Your Potential with Byway</p>
                               <p class="hero-description">
                                   Welcome to Byway, where learning knows no bounds. We believe that education is the key to personal
                                   and professional growth, and we're here to guide you on your journey to success.
                               </p>
                           </div>
                           <button class="cta-button"><div class="button-label">Start your instructor journey</div></button>
                       </div>
                       <div class="hero-graphic">
                           <div class="graphic-overlap">
                               <div class="dot-pattern-1">
                                   <div class="dot"></div>
                                   <div class="dot"></div>
                                   <!-- Thêm 42 dot khác như code gốc nếu cần -->
                               </div>
                               <div class="dot-pattern-2">
                                   <div class="dot"></div>
                                   <div class="dot"></div>
                                   <!-- Thêm 42 dot khác -->
                               </div>
                               <div class="graphic-circle"></div>
                               <div class="image-container">
                                   <img class="main-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-6-1.png" />
                               </div>
                               <img class="secondary-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-6.png" />
                               <img class="ellipse-1" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-55.svg" />
                               <img class="ellipse-2" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-54.svg" />
                               <img class="additional-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-8.png" />
                               <div class="small-circle"></div>
                               <img class="polygon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/polygon-1.svg" />
                           </div>
                           <div class="community-section">
                               <div class="community-image">
                                   <img class="community-img" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-7.png" />
                               </div>
                               <div class="community-info">
                                   <div class="avatar-group">
                                       <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-65.png" />
                                       <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-62.png" />
                                       <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-64.png" />
                                       <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-63.png" />
                                       <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-66.png" />
                                   </div>
                                   <p class="community-text">Join our community of 1200+ Students</p>
                               </div>
                               <img class="ellipse-3" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-57.svg" />
                           </div>
                       </div>
                   </div>
                   <div class="stats-section">
                       <div class="stat-item">
                           <div class="stat-number">250+</div>
                           <p class="stat-description">Courses by our best mentors</p>
                       </div>
                       <img class="divider" src="https://c.animaapp.com/mb5881k9TTFl8D/img/line-1.svg" />
                       <div class="stat-item">
                           <div class="stat-number">1000+</div>
                           <p class="stat-description">Courses by our best mentors</p>
                       </div>
                       <img class="divider" src="https://c.animaapp.com/mb5881k9TTFl8D/img/line-1.svg" />
                       <div class="stat-item">
                           <div class="stat-number">15+</div>
                           <p class="stat-description">Courses by our best mentors</p>
                       </div>
                       <img class="divider" src="https://c.animaapp.com/mb5881k9TTFl8D/img/line-1.svg" />
                       <div class="stat-item">
                           <div class="stat-number">2400+</div>
                           <p class="stat-description">Courses by our best mentors</p>
                       </div>
                   </div>
                   <div class="category-section">
                       <div class="section-header">
                           <div class="section-title">Top Categories</div>
                           <button class="see-all-button"><div class="button-label">See All</div></button>
                       </div>
                       <div class="category-list">
                           <div class="category-card">
                               <div class="category-content">
                                   <div class="category-icon">
                                       <img class="icon-img" src="https://c.animaapp.com/mb5881k9TTFl8D/img/telescope.svg" />
                                   </div>
                                   <div class="category-name">Astrology</div>
                                   <div class="course-count">11 Courses</div>
                               </div>
                           </div>
                           <div class="category-card">
                               <div class="category-content">
                                   <div class="category-icon">
                                       <div class="icon-code-browser"></div>
                                   </div>
                                   <div class="category-name">Development</div>
                                   <div class="course-count">12 Courses</div>
                               </div>
                           </div>
                           <div class="category-card">
                               <div class="category-content">
                                   <div class="category-icon">
                                       <div class="icon-briefcase"></div>
                                   </div>
                                   <div class="category-name">Marketing</div>
                                   <div class="course-count">12 Courses</div>
                               </div>
                           </div>
                           <div class="category-card">
                               <div class="category-content">
                                   <div class="category-icon">
                                       <div class="icon-physics"></div>
                                   </div>
                                   <div class="category-name">Physics</div>
                                   <div class="course-count">14 Courses</div>
                               </div>
                           </div>
                       </div>
                   </div>
                   <div class="courses-section">
                       <div class="section-header">
                           <div class="section-title">Top Courses</div>
                           <button class="see-all-button"><div class="button-label">See All</div></button>
                       </div>
                       <div class="course-list">
                           <div class="course-card">
                               <div class="course-content">
                                   <img class="course-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/rectangle-1080-4.png" />
                                   <div class="course-details">
                                       <div class="course-info">
                                           <div class="course-title">Beginner’s Guide to Design</div>
                                           <div class="instructor-name">By Ronald Richards</div>
                                       </div>
                                       <div class="course-meta">
                                           <div class="ratings">
                                               <div class="star-icon">
                                                   <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />
                                               </div>
                                               <div class="star-icon">
                                                   <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />
                                               </div>
                                               <div class="star-icon">
                                                   <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />
                                               </div>
                                               <div class="star-icon">
                                                   <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />
                                               </div>
                                               <div class="star-icon">
                                                   <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />
                                               </div>
                                           </div>
                                           <div class="rating-count">(1200 Ratings)</div>
                                       </div>
                                       <p class="course-duration">22 Total Hours. 155 Lectures. Beginner</p>
                                   </div>
                                   <div class="course-price">$149.9</div>
                               </div>
                           </div>
                           <!-- Thêm 3 course-card khác tương tự nếu cần -->
                       </div>
                   </div>
                   <div class="instructors-section">
                       <div class="section-header">
                           <div class="section-title">Top Instructors</div>
                           <button class="see-all-button"><div class="button-label">See All</div></button>
                       </div>
                       <div class="instructor-list">
                           <div class="instructor-card">
                               <div class="instructor-content">
                                   <img class="instructor-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/rectangle-1136-1.png" />
                                   <div class="instructor-details">
                                       <div class="instructor-info">
                                           <div class="instructor-name">Ronald Richards</div>
                                           <div class="instructor-title">UI/UX Designer</div>
                                       </div>
                                       <img class="divider" src="https://c.animaapp.com/mb5881k9TTFl8D/img/line-55.svg" />
                                       <div class="instructor-stats">
                                           <div class="rating">
                                               <div class="star-icon">
                                                   <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />
                                               </div>
                                               <div class="rating-value">4.9</div>
                                           </div>
                                           <div class="student-count">2400 Students</div>
                                       </div>
                                   </div>
                               </div>
                           </div>
                           <!-- Thêm 4 instructor-card khác tương tự nếu cần -->
                       </div>
                   </div>
                   <div class="testimonials-section">
                       <p class="section-title">What Our Customer Say About Us</p>
                       <div class="testimonial-list">
                           <div class="testimonial-card">
                               <img class="quote-icon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ri-double-quotes-l.svg" />
                               <p class="testimonial-text">
                                   "Byway's tech courses are top-notch! As someone who's always looking to stay ahead in
                                   the rapidly evolving tech world, I appreciate the up-to-date content and engaging multimedia."
                               </p>
                               <div class="testimonial-author">
                                   <img class="author-avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-61-4.png" />
                                   <div class="author-info">
                                       <div class="author-name">Jane Doe</div>
                                       <div class="author-title">Designer</div>
                                   </div>
                               </div>
                           </div>
                           <!-- Thêm 3 testimonial-card khác tương tự nếu cần -->
                       </div>
                       <div class="testimonial-nav">
                           <div class="nav-button">
                               <img class="nav-icon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/icon-left-chevron-1.svg" />
                           </div>
                           <div class="nav-button">
                               <img class="nav-icon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/icon-chevron-right.svg" />
                           </div>
                       </div>
                   </div>
                   <div class="cta-section">
                       <div class="cta-block">
                           <div class="cta-image"></div>
                           <div class="cta-content">
                               <div class="cta-text">
                                   <div class="cta-title">Become an Instructor</div>
                                   <p class="cta-description">
                                       Instructors from around the world teach millions of students on Byway. We provide the tools and
                                       skills to teach what you love.
                                   </p>
                               </div>
                               <button class="cta-button">
                                   <div class="button-label">Start Your Instructor Journey</div>
                                   <img class="arrow-icon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/icon-arrow-narrow-right.svg" />
                               </button>
                           </div>
                       </div>
                       <div class="cta-block">
                           <div class="cta-content">
                               <div class="cta-text">
                                   <p class="cta-title">Transform your life through education</p>
                                   <p class="cta-description">
                                       Learners around the world are launching new careers, advancing in their fields, and enriching
                                       their lives.
                                   </p>
                               </div>
                               <button class="cta-button">
                                   <div class="button-label">Checkout Courses</div>
                                   <img class="arrow-icon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/icon-arrow-narrow-right.svg" />
                               </button>
                           </div>
                           <div class="cta-image"></div>
                       </div>
                   </div>
               </div>
           </div>
        </div>
    </div>
<%--    FOOTER--%>
    <jsp:include page="../layout/footer.jsp" />
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>