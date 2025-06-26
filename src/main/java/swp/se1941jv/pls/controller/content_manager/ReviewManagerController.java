package swp.se1941jv.pls.controller.content_manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.entity.Review;
import swp.se1941jv.pls.entity.ReviewStatus;
import swp.se1941jv.pls.repository.PackageRepository;
import swp.se1941jv.pls.repository.ReviewRepository;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.service.ReviewService;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Controller
@RequestMapping("/admin/reviews")
// @PreAuthorize("hasRole('ROLE_ADMIN')")
public class ReviewManagerController {

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private PackageRepository packageRepository;

    @Autowired
    private SubjectRepository subjectRepository;

    @GetMapping
    public String listReviews(
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Long packageId,
            @RequestParam(required = false) Long subjectId,
            @RequestParam(required = false) ReviewStatus status,
            @RequestParam(required = false) Integer rating,
            @RequestParam(required = false) String comment,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {
        try {
            // Prepare filter data for dropdowns
            model.addAttribute("packages", packageRepository.findAll());
            model.addAttribute("subjects", subjectRepository.findAll());
            model.addAttribute("statuses", ReviewStatus.values());
            model.addAttribute("ratings", List.of(1, 2, 3, 4, 5));

            // Call filterReviews from ReviewService
            Pageable pageable = PageRequest.of(page, size);
            Page<Review> reviewPage = reviewService.filterReviews(type, packageId, subjectId, status, rating, comment,
                    pageable);

            // Add attributes to model
            model.addAttribute("reviews", reviewPage.getContent());
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", reviewPage.getTotalPages());
            model.addAttribute("totalItems", reviewPage.getTotalElements());
            model.addAttribute("size", size);
            model.addAttribute("type", type);
            model.addAttribute("packageId", packageId);
            model.addAttribute("subjectId", subjectId);
            model.addAttribute("status", status);
            model.addAttribute("rating", rating);
            model.addAttribute("comment", comment);

            return "content-manager/review/view";
        } catch (Exception e) {
            model.addAttribute("error", "Đã xảy ra lỗi khi tải danh sách đánh giá: " + e.getMessage());
            return "error/500";
        }
    }

    @GetMapping("/{reviewId}")
    public String getReviewDetails(@PathVariable Long reviewId, Model model) {
        try {
            Review review = reviewRepository.findById(reviewId)
                    .orElseThrow(() -> new RuntimeException("Đánh giá không tìm thấy"));
            model.addAttribute("review", review);
            return "admin/reviews/detail";
        } catch (Exception e) {
            model.addAttribute("error", "Đánh giá không tìm thấy: " + e.getMessage());
            return "error/404";
        }
    }

    @PostMapping("/{reviewId}/approve")
    public String approveReview(@PathVariable Long reviewId, Model model) {
        try {
            Review review = reviewRepository.findById(reviewId)
                    .orElseThrow(() -> new RuntimeException("Đánh giá không tìm thấy"));
            if (review.getStatus() == ReviewStatus.PENDING) {
                review.setStatus(ReviewStatus.APPROVED);
                reviewRepository.save(review);
            }
            return "redirect:/admin/reviews?success="
                    + URLEncoder.encode("Phê duyệt thành công!", StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "redirect:/admin/reviews?error="
                    + URLEncoder.encode("Lỗi khi phê duyệt: " + e.getMessage(), StandardCharsets.UTF_8);
        }
    }

    @PostMapping("/{reviewId}/reject")
    public String rejectReview(@PathVariable Long reviewId, Model model) {
        try {
            Review review = reviewRepository.findById(reviewId)
                    .orElseThrow(() -> new RuntimeException("Đánh giá không tìm thấy"));
            if (review.getStatus() == ReviewStatus.PENDING) {
                review.setStatus(ReviewStatus.REJECTED);
                reviewRepository.save(review);
            }
            return "redirect:/admin/reviews?success="
                    + URLEncoder.encode("Từ chối thành công!", StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "redirect:/admin/reviews?error="
                    + URLEncoder.encode("Lỗi khi từ chối: " + e.getMessage(), StandardCharsets.UTF_8);
        }
    }
}