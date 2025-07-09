package swp.se1941jv.pls.controller.client.review;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import swp.se1941jv.pls.config.SecurityUtils;
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
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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

            // Giải mã comment để xử lý ký tự Unicode
            if (comment != null && !comment.isEmpty()) {
                comment = URLDecoder.decode(comment, StandardCharsets.UTF_8);
                logger.debug("Decoded comment: {}", comment);
            }

      
         
              Long userId = SecurityUtils.getCurrentUserId();

            boolean canReview = userId != null  &&
                    reviewService.canUserReviewPackage(userId, packageId);
            logger.debug("canReview: {}", canReview);
            model.addAttribute("canReview", canReview);
            model.addAttribute("userId", userId);

            List<Review> packageReviews = reviewService.getReviewsByPackageAndFilters(packageId, comment, rating);
            logger.debug("Found {} reviews for packageId={}, comment={}, rating={}",
                    packageReviews.size(), packageId, comment, rating);

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
            if (userId != null && canReview) {
                ReviewStatus latestStatus = reviewService
                        .getLatestReviewStatusForUser(userId, packageId);
                if (latestStatus != null) {
                    if (latestStatus == ReviewStatus.APPROVED) {
                        reviewStatusMessage = "Bạn đã đánh giá thành công!";
                    } else if (latestStatus == ReviewStatus.PENDING) {
                        reviewStatusMessage = "Đánh giá của bạn đang chờ duyệt, vui lòng đợi một chút!";
                    } else if (latestStatus == ReviewStatus.REJECTED) {
                        reviewStatusMessage = "Đánh giá của bạn vi phạm nguyên tắc chung! Bạn không thể đánh giá ở mục này ";
                    }
                }
            }
            model.addAttribute("reviewStatusMessage", reviewStatusMessage);

            if (render) {
                logger.debug("Rendering fragment with {} reviews", packageReviews.size());
                return "client/review/reviewFragment";
            }

            String encodedComment = comment != null ? URLEncoder.encode(comment, StandardCharsets.UTF_8) : "";

            return "redirect:/parent/course/detail/" + packageId + "?render=true&comment=" + encodedComment +
                    "&rating=" + (rating != null ? rating : "");
        } catch (RuntimeException e) {
            logger.error("Package not found: {}", packageId, e);
            model.addAttribute("error", "Gói không tìm thấy: " + packageId);
            return "error/404";
        } catch (Exception e) {
            logger.error("Unexpected error: {}", e.getMessage(), e);
            model.addAttribute("error", "Đã xảy ra lỗi không mong đợi");
            return "error/500";
        }
    }

    @PostMapping("/{packageId}/review")
    public String submitReview(@PathVariable Long packageId,
            @ModelAttribute("newReview") Review review,
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            HttpServletRequest request) {
        Long userId = SecurityUtils.getCurrentUserId();

        Package pkg = packageRepository.findById(packageId)
                .orElseThrow(() -> new RuntimeException("Package not found"));
        Subject subject = subjectId != null ? subjectRepository.findById(subjectId)
                .orElseThrow(() -> new RuntimeException("Subject not found")) : null;

        boolean reviewExists = reviewService.hasUserReviewedPackage(userId, packageId);

        if (reviewExists) {
            return "redirect:/parent/course/detail/" + packageId
                    + "?fail=You have already submitted a review for this package.";
        }

        if (reviewService.canUserReviewPackage(userId, packageId)) {
            try {
                  User currentUser = userService.getUserById(userId);
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

}