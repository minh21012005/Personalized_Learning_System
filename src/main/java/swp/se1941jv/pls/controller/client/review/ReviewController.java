package swp.se1941jv.pls.controller.client.review;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Review;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.entity.ReviewStatus;
import swp.se1941jv.pls.repository.PackageRepository;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.service.ReviewService;
import swp.se1941jv.pls.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller
@RequestMapping("/package")
public class ReviewController {
    private static final Logger logger = LoggerFactory.getLogger(ReviewController.class);

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private PackageRepository packageRepository;

    @Autowired
    private SubjectRepository subjectRepository;

    @Autowired
    private UserService userService;

    @GetMapping("/{packageId}/reviews")
    public String showReviews(@PathVariable Long packageId,
            @RequestParam(required = false) String comment,
            @RequestParam(required = false) Integer rating,
            @RequestParam(required = false) String success,
            @RequestParam(required = false) String fail,
            @RequestParam(value = "render", required = false) boolean render,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Package pkg = packageRepository.findById(packageId)
                    .orElseThrow(() -> new RuntimeException("Gói không tìm thấy"));
            model.addAttribute("pkg", pkg);

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            User currentUser = null;
            if (authentication != null && authentication.isAuthenticated()
                    && authentication.getPrincipal() instanceof UserDetails) {
                String username = authentication.getName();
                currentUser = userService.getUserByEmail(username);
            }
            Long currentUserId = (currentUser != null) ? currentUser.getUserId() : null;
            logger.debug("Người dùng hiện tại trong phiên: userId={}", currentUserId);

            boolean canReview = currentUser != null && currentUser.getUserId() != null &&
                    reviewService.canUserReviewPackage(currentUser.getUserId(), packageId);
            logger.debug("canReview: {}", canReview);
            model.addAttribute("canReview", canReview);
            model.addAttribute("currentUserId", currentUserId);

            List<Review> packageReviews = reviewService.getReviewsByPackageAndFilters(packageId, comment, rating);

            long reviewCount = packageReviews.size();
            double averageRating = packageReviews.stream()
                    .mapToInt(Review::getRating)
                    .average()
                    .orElse(0.0);

            model.addAttribute("packageReviews", packageReviews);
            model.addAttribute("reviewCount", reviewCount);
            model.addAttribute("averageRating", averageRating);
            model.addAttribute("selectedComment", comment);
            model.addAttribute("selectedRating", rating);

            if (success != null)
                model.addAttribute("success", success);
            if (fail != null)
                model.addAttribute("fail", fail);

            String reviewStatusMessage = null;
            if (currentUser != null && canReview) {
                ReviewStatus latestStatus = reviewService
                        .getLatestReviewStatusForUser(currentUser.getUserId(), packageId);
                if (latestStatus != null) {
                    if (latestStatus == ReviewStatus.APPROVED) {
                        reviewStatusMessage = "Bạn đã bình luận thành công!";
                    } else if (latestStatus == ReviewStatus.PENDING) {
                        reviewStatusMessage = "Bình luận của bạn đang chờ duyệt, vui lòng đợi một chút!";
                    }
                }
            }
            model.addAttribute("reviewStatusMessage", reviewStatusMessage);

            if (render) {
                return "client/review/reviewFragment";
            }
            // Chuyển hướng đến render=true cho lần tải ban đầu
            return "redirect:/package/" + packageId + "/reviews?render=true&comment=" + (comment != null ? comment : "")
                    + "&rating=" + (rating != null ? rating : "");
        } catch (RuntimeException e) {
            model.addAttribute("error", "Gói không tìm thấy: " + packageId);
            return "error/404";
        } catch (Exception e) {
            logger.error("Lỗi không mong đợi: {}", e.getMessage(), e);
            model.addAttribute("error", "Đã xảy ra lỗi không mong đợi");
            return "error/500";
        }
    }

    @PostMapping("/{packageId}/review")
    public String submitReview(@PathVariable Long packageId,
            @ModelAttribute("newReview") Review review,
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            HttpServletRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        User currentUser = null;
        if (authentication != null && authentication.isAuthenticated()
                && authentication.getPrincipal() instanceof UserDetails) {
            String username = authentication.getName();
            currentUser = userService.getUserByEmail(username);
        }
        if (currentUser == null) {
            return "redirect:/parent/course/detail/" + packageId + "?fail=Please log in to review.";
        }

        Package pkg = packageRepository.findById(packageId)
                .orElseThrow(() -> new RuntimeException("Package not found"));
        Subject subject = subjectId != null ? subjectRepository.findById(subjectId)
                .orElseThrow(() -> new RuntimeException("Subject not found")) : null;

        boolean reviewExists = reviewService.hasUserReviewedPackage(currentUser.getUserId(), packageId);
        if (reviewExists) {
            return "redirect:/parent/course/detail/" + packageId
                    + "?fail=You have already submitted a review for this package.";
        }

        if (reviewService.canUserReviewPackage(currentUser.getUserId(), packageId) ||
                (subject != null && reviewService.canUserReviewSubject(currentUser.getUserId(),
                        subjectId, packageId))) {
            try {
                reviewService.saveReview(review, currentUser, subject == null ? pkg : null, subject);
                return "redirect:/parent/course/detail/" + packageId
                        + "?success=Your review has been submitted and is pending approval.";
            } catch (Exception e) {
                return "redirect:/parent/course/detail/" + packageId
                        + "?fail=An error occurred while saving the review.";
            }
        } else {
            return "redirect:/parent/course/detail/" + packageId
                    + "?fail=You must purchase the package to review.";
        }
    }

    @PostMapping("/{packageId}/review/{reviewId}/useful")
    public String markAsUseful(@PathVariable Long packageId, @PathVariable Long reviewId,
            @RequestParam Long userId, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && authentication.getPrincipal() instanceof UserDetails) {
            User currentUser = userService.getUserByEmail(authentication.getName());
            if (currentUser != null && currentUser.getUserId().equals(userId) &&
                    reviewService.canUserReviewPackage(currentUser.getUserId(), packageId)) {
                reviewService.toggleUsefulCount(reviewId);
                redirectAttributes.addFlashAttribute("message", "Cập nhật 'Hữu ích' thành công!");
            } else {
                redirectAttributes.addFlashAttribute("message",
                        "Bạn không có quyền cập nhật 'Hữu ích'!");
            }
        } else {
            redirectAttributes.addFlashAttribute("message",
                    "Vui lòng đăng nhập để thực hiện hành động này!");
        }
        String referer = request.getHeader("Referer");
        return "redirect:" + (referer != null ? referer : "/package/" + packageId + "/reviews?render=true");
    }
}