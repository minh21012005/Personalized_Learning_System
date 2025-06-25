package swp.se1941jv.pls.controller.client.review;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import swp.se1941jv.pls.entity.Review;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.entity.ReviewStatus;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.service.ReviewService;
import swp.se1941jv.pls.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.servlet.http.HttpServletRequest;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Controller
@RequestMapping("/subject")
public class SubjectReviewController {
    private static final Logger logger = LoggerFactory.getLogger(SubjectReviewController.class);

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private SubjectRepository subjectRepository;

    @Autowired
    private UserService userService;

    @GetMapping("/{subjectId}/reviews")
    public String showReviews(@PathVariable Long subjectId,
            @RequestParam(required = false) String comment,
            @RequestParam(required = false) Integer rating,
            @RequestParam(required = false) String success,
            @RequestParam(required = false) String fail,
            @RequestParam(value = "render", required = false) boolean render,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Subject subject = subjectRepository.findById(subjectId)
                    .orElseThrow(() -> new RuntimeException("Môn học không tìm thấy"));
            model.addAttribute("subject", subject);

            if (comment != null && !comment.isEmpty()) {
                comment = URLDecoder.decode(comment, StandardCharsets.UTF_8).trim();
                ;

            }

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            User currentUser = null;
            if (authentication != null && authentication.isAuthenticated()
                    && authentication.getPrincipal() instanceof UserDetails) {
                String username = authentication.getName();
                currentUser = userService.getUserByEmail(username);
            }
            Long currentUserId = (currentUser != null) ? currentUser.getUserId() : null;

            boolean canReview = currentUser != null && currentUser.getUserId() != null &&
                    reviewService.canUserReviewSubject(currentUser.getUserId(), subjectId);

            model.addAttribute("canReview", canReview);

            model.addAttribute("currentUserId", currentUserId);

            List<Review> subjectReviews = reviewService.getReviewsBySubjectAndFilters(subjectId, comment, rating);
            long reviewCount = subjectReviews.size();
            double averageRating = subjectReviews.stream()
                    .mapToInt(Review::getRating)
                    .average()
                    .orElse(0.0);

            model.addAttribute("subjectReviews", subjectReviews);
            model.addAttribute("reviewCount", reviewCount);
            model.addAttribute("averageRating", averageRating);
            model.addAttribute("selectedComment", comment);
            model.addAttribute("selectedRating", rating);

            if (success != null)
                model.addAttribute("success", success);
            if (fail != null)
                model.addAttribute("fail", fail);

            String reviewStatusMessage = null;
            ReviewStatus latestStatus = null;
            if (currentUser != null && canReview) {
                latestStatus = reviewService.getLatestReviewStatusForUserAndSubject(currentUser.getUserId(), subjectId);
                if (latestStatus != null) {
                    switch (latestStatus) {
                        case APPROVED:
                            reviewStatusMessage = "Bạn đã bình luận thành công!";
                            break;
                        case PENDING:
                            reviewStatusMessage = "Bình luận của bạn đang chờ duyệt.";
                            break;
                        case REJECTED:
                            reviewStatusMessage = "Bình luận của bạn vi phạm. Bạn có thể gửi lại.";
                            break;
                        default:
                            reviewStatusMessage = null;
                    }
                }
            }
            model.addAttribute("reviewStatusMessage", reviewStatusMessage);
            model.addAttribute("latestReviewStatus", latestStatus);

            if (render) {
                return "client/review/subjectReview";
            }

            String encodedComment = comment != null ? URLEncoder.encode(comment.trim(), StandardCharsets.UTF_8) : "";
            return "redirect:/subject/" + subjectId + "/reviews?render=true&comment=" + encodedComment +
                    "&rating=" + (rating != null ? rating : "");
        } catch (RuntimeException e) {
            model.addAttribute("error", "Môn học không tìm thấy: " + subjectId);
            return "error/404";
        } catch (Exception e) {
            model.addAttribute("error", "Đã xảy ra lỗi không mong đợi");
            return "error/500";
        }
    }

    @PostMapping("/{subjectId}/review")
    public String submitReview(@PathVariable Long subjectId,
            @ModelAttribute("newReview") Review review,
            HttpServletRequest request) {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            User currentUser = null;
            if (authentication != null && authentication.isAuthenticated()
                    && authentication.getPrincipal() instanceof UserDetails) {
                String username = authentication.getName();
                currentUser = userService.getUserByEmail(username);
            }
            if (currentUser == null) {
                return "redirect:/subject/detail/" + subjectId + "?fail="
                        + URLEncoder.encode("Vui lòng đăng nhập để đánh giá.", StandardCharsets.UTF_8);
            }

            Subject subject = subjectRepository.findById(subjectId)
                    .orElseThrow(() -> new RuntimeException("Môn học không tìm thấy"));

            boolean reviewExists = reviewService.hasUserReviewedSubject(currentUser.getUserId(), subjectId);
            if (reviewExists) {
                return "redirect:/subject/detail/" + subjectId + "?fail="
                        + URLEncoder.encode("Bạn đã gửi đánh giá cho môn học này rồi.", StandardCharsets.UTF_8);
            }

            if (reviewService.canUserReviewSubject(currentUser.getUserId(), subjectId)) {
                reviewService.saveReview(review, currentUser, null, subject);
                return "redirect:/subject/detail/" + subjectId + "?success="
                        + URLEncoder.encode("Đánh giá của bạn đã được gửi và đang chờ duyệt.", StandardCharsets.UTF_8);
            } else {
                return "redirect:/subject/detail/" + subjectId + "?fail="
                        + URLEncoder.encode("Bạn phải đăng ký gói học chứa môn học này để đánh giá.",
                                StandardCharsets.UTF_8);
            }
        } catch (Exception e) {
            return "redirect:/subject/detail/" + subjectId + "?fail="
                    + URLEncoder.encode("Đã xảy ra lỗi khi lưu đánh giá.", StandardCharsets.UTF_8);
        }
    }
}