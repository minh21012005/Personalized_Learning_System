package swp.se1941jv.pls.controller.content_manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
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
  @PreAuthorize("hasAnyRole('ADMIN', 'CONTENT_MANAGER')")
@Controller
@RequestMapping("/admin/reviews")

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
            @RequestParam(required = false) String packageId, // Changed to String
            @RequestParam(required = false) String subjectId, // Changed to String
            @RequestParam(required = false) String status, // Changed to String
            @RequestParam(required = false) String rating, // Changed to String
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

            // Handle packageId and subjectId
            Long packageIdLong = null;
            Long subjectIdLong = null;
            if (packageId != null && !packageId.equals("all") && !packageId.isEmpty()) {
                packageIdLong = Long.parseLong(packageId);
            }
            if (subjectId != null && !subjectId.equals("all") && !subjectId.isEmpty()) {
                subjectIdLong = Long.parseLong(subjectId);
            }

            // Handle status and rating
            ReviewStatus statusEnum = null;
            Integer ratingInt = null;
            if (status != null && !status.isEmpty()) {
                statusEnum = ReviewStatus.valueOf(status);
            }
            if (rating != null && !rating.isEmpty()) {
                ratingInt = Integer.parseInt(rating);
            }

            String cmt = comment == null ? "" : comment.trim();
            Pageable pageable = PageRequest.of(page, size,Sort.by(Sort.Direction.DESC, "createdAt"));
            Page<Review> reviewPage = reviewService.filterReviews(type, packageIdLong, subjectIdLong, statusEnum,
                    ratingInt, cmt, pageable);

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
            model.addAttribute("comment", cmt);

            return "content-manager/review/view";
        } catch (Exception e) {
            model.addAttribute("error", "Đã xảy ra lỗi khi tải danh sách đánh giá: " + e.getMessage());
            return "error/500";
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