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

<%--    HEADER--%>
    <header>
        <jsp:include page="../layout/header.jsp"/>
    </header>
<%--<div class="homescreen">--%>
<%--    <div class="overlap-wrapper">--%>
<%--        <div class="overlap">--%>
<%--            <jsp:include page="../layout/header.jsp" />--%>
<%--&lt;%&ndash;            <div class="main-frame">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div class="hero-section">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="hero-content">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="hero-text">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <p class="hero-title">Unlock Your Potential with Byway</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <p class="hero-description">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                Welcome to Byway, where learning knows no bounds. We believe that education is the key to personal&ndash;%&gt;--%>
<%--&lt;%&ndash;                                and professional growth, and we're here to guide you on your journey to success.&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <button class="cta-button"><div class="button-label">Start your instructor journey</div></button>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="hero-graphic">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="graphic-overlap">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="dot-pattern-1">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="dot"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="dot"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <!-- Thêm 42 dot khác như code gốc nếu cần -->&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="dot-pattern-2">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="dot"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="dot"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <!-- Thêm 42 dot khác -->&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="graphic-circle"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="image-container">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <img class="main-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-6-1.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <img class="secondary-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-6.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <img class="ellipse-1" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-55.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <img class="ellipse-2" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-54.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <img class="additional-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-8.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="small-circle"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <img class="polygon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/polygon-1.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="community-section">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="community-image">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <img class="community-img" src="https://c.animaapp.com/mb5881k9TTFl8D/img/image-7.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="community-info">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="avatar-group">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-65.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-62.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-64.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-63.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <img class="avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-66.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <p class="community-text">Join our community of 1200+ Students</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <img class="ellipse-3" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-57.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div class="stats-section">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="stat-item">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="stat-number">250+</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <p class="stat-description">Courses by our best mentors</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <img class="divider" src="https://c.animaapp.com/mb5881k9TTFl8D/img/line-1.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="stat-item">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="stat-number">1000+</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <p class="stat-description">Courses by our best mentors</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <img class="divider" src="https://c.animaapp.com/mb5881k9TTFl8D/img/line-1.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="stat-item">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="stat-number">15+</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <p class="stat-description">Courses by our best mentors</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <img class="divider" src="https://c.animaapp.com/mb5881k9TTFl8D/img/line-1.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="stat-item">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="stat-number">2400+</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <p class="stat-description">Courses by our best mentors</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div class="category-section">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="section-header">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="section-title">Top Categories</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <button class="see-all-button"><div class="button-label">See All</div></button>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="category-list">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="category-card">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="category-content">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="category-icon">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <img class="icon-img" src="https://c.animaapp.com/mb5881k9TTFl8D/img/telescope.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="category-name">Astrology</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="course-count">11 Courses</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="category-card">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="category-content">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="category-icon">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="icon-code-browser"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="category-name">Development</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="course-count">12 Courses</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="category-card">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="category-content">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="category-icon">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="icon-briefcase"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="category-name">Marketing</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="course-count">12 Courses</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="category-card">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="category-content">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="category-icon">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="icon-physics"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="category-name">Physics</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="course-count">14 Courses</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div class="courses-section">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="section-header">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="section-title">Top Courses</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <button class="see-all-button"><div class="button-label">See All</div></button>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="course-list">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="course-card">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="course-content">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <img class="course-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/rectangle-1080-4.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="course-details">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="course-info">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div class="course-title">Beginner’s Guide to Design</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div class="instructor-name">By Ronald Richards</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="course-meta">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div class="ratings">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <div class="star-icon">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                                <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <div class="star-icon">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                                <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <div class="star-icon">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                                <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <div class="star-icon">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                                <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <div class="star-icon">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                                <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div class="rating-count">(1200 Ratings)</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <p class="course-duration">22 Total Hours. 155 Lectures. Beginner</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="course-price">$149.9</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <!-- Thêm 3 course-card khác tương tự nếu cần -->&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div class="instructors-section">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="section-header">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="section-title">Top Instructors</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <button class="see-all-button"><div class="button-label">See All</div></button>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="instructor-list">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="instructor-card">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="instructor-content">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <img class="instructor-image" src="https://c.animaapp.com/mb5881k9TTFl8D/img/rectangle-1136-1.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="instructor-details">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="instructor-info">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div class="instructor-name">Ronald Richards</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div class="instructor-title">UI/UX Designer</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <img class="divider" src="https://c.animaapp.com/mb5881k9TTFl8D/img/line-55.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="instructor-stats">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div class="rating">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <div class="star-icon">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                                <img class="star" src="https://c.animaapp.com/mb5881k9TTFl8D/img/star-3.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                            <div class="rating-value">4.9</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                        <div class="student-count">2400 Students</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <!-- Thêm 4 instructor-card khác tương tự nếu cần -->&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div class="testimonials-section">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <p class="section-title">What Our Customer Say About Us</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="testimonial-list">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="testimonial-card">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <img class="quote-icon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ri-double-quotes-l.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <p class="testimonial-text">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                "Byway's tech courses are top-notch! As someone who's always looking to stay ahead in&ndash;%&gt;--%>
<%--&lt;%&ndash;                                the rapidly evolving tech world, I appreciate the up-to-date content and engaging multimedia."&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="testimonial-author">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <img class="author-avatar" src="https://c.animaapp.com/mb5881k9TTFl8D/img/ellipse-61-4.png" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="author-info">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="author-name">Jane Doe</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    <div class="author-title">Designer</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <!-- Thêm 3 testimonial-card khác tương tự nếu cần -->&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="testimonial-nav">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="nav-button">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <img class="nav-icon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/icon-left-chevron-1.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="nav-button">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <img class="nav-icon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/icon-chevron-right.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                <div class="cta-section">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="cta-block">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="cta-image"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="cta-content">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="cta-text">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="cta-title">Become an Instructor</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <p class="cta-description">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    Instructors from around the world teach millions of students on Byway. We provide the tools and&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    skills to teach what you love.&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <button class="cta-button">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="button-label">Start Your Instructor Journey</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <img class="arrow-icon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/icon-arrow-narrow-right.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </button>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <div class="cta-block">&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="cta-content">&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <div class="cta-text">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <p class="cta-title">Transform your life through education</p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <p class="cta-description">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    Learners around the world are launching new careers, advancing in their fields, and enriching&ndash;%&gt;--%>
<%--&lt;%&ndash;                                    their lives.&ndash;%&gt;--%>
<%--&lt;%&ndash;                                </p>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                            <button class="cta-button">&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <div class="button-label">Checkout Courses</div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                                <img class="arrow-icon" src="https://c.animaapp.com/mb5881k9TTFl8D/img/icon-arrow-narrow-right.svg" />&ndash;%&gt;--%>
<%--&lt;%&ndash;                            </button>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                        <div class="cta-image"></div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                    </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </div>&ndash;%&gt;--%>
<%--&lt;%&ndash;            </div>&ndash;%&gt;--%>
<%--            <jsp:include page="../layout/footer.jsp" />--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>