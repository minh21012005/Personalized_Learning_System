package swp.se1941jv.pls.controller.client.review;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.entity.Review;
import swp.se1941jv.pls.entity.Subject;

import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.service.ReviewService;
import swp.se1941jv.pls.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Controller
@RequestMapping("/subject")
public class SubjectReviewController {
    

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
            }

            Long userId = SecurityUtils.getCurrentUserId();

            boolean canReview = userId != null  &&
                    reviewService.canUserReviewSubject(userId, subjectId);

            model.addAttribute("canReview", canReview);

            model.addAttribute("currentUserId", userId);

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

           

            if (render) {
                return "client/review/subjectReview";
            }

            String encodedComment = comment != null ? URLEncoder.encode(comment.trim(), StandardCharsets.UTF_8) : "";

            return "redirect:/subject/detail/" + subjectId + "?render=true&comment=" + encodedComment + "&rating="
                    + (rating != null ? rating : "");
        } catch (RuntimeException e) {
            model.addAttribute("error", "Môn học không tìm thấy: " + subjectId);
            return "error/404";
        } catch (Exception e) {
            model.addAttribute("error", "Đã xảy ra lỗi không mong đợi");
            return "error/500";
        }
    }

}