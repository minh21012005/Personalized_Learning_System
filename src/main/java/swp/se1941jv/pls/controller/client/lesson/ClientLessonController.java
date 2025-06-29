package swp.se1941jv.pls.controller.client.lesson;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.*;
import swp.se1941jv.pls.dto.response.learningPageData.LearningPageDataDTO;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.service.*;

import java.util.List;

/**
 * Controller xử lý các yêu cầu từ phía client liên quan đến bài học.
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class ClientLessonController {

    private final SubjectService subjectService;
    private final LessonService lessonService;
    private final PackageService packageService;
    private final ChapterService chapterService;
    private final UserService userService;

    @GetMapping("/packages")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String showPackagedSubject(Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        List<PackageSubjectDTO> packageSubjects = packageService.getPackageSubjects();
        model.addAttribute("packageSubjects", packageSubjects);

        return "client/learning/packages";
    }

    @GetMapping("/packages/detail")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String showPackageDetail(@RequestParam("packageId") Long packageId, Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        PackageSubjectDTO packageSubject = packageService.getPackageDetail(packageId);

        model.addAttribute("packageSubject", packageSubject);
        model.addAttribute("subjects", packageSubject.getListSubject());

        return "client/learning/packageDetail";
    }


    /**
     * Hiển thị trang tổng quan của môn học với danh sách chapter và lesson.
     *
     * @param subjectId ID của môn học
     * @param model     Model để truyền dữ liệu đến JSP
     * @param redirectAttributes Để truyền thông báo lỗi
     * @return Tên view JSP hoặc redirect
     */
    @PreAuthorize("hasAnyRole('STUDENT')")
    @GetMapping("/learn") // Changed mapping for clarity, if it's the main learning page
    public String viewSubject(
            @RequestParam("subjectId") Long subjectId,
            @RequestParam("packageId") Long packageId,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Long userId = SecurityUtils.getCurrentUserId();
            if (userId == null) {
                log.warn("User ID not found in security context during /learn access.");
                redirectAttributes.addFlashAttribute("error", "Không thể xác định người dùng hiện tại. Vui lòng đăng nhập lại.");
                return "redirect:/login"; // Always redirect on no user
            }

            // Check access rights for the subject within the package for the user
            // Assuming subjectService.hasAccessSubjectInPackage now correctly takes subjectId, packageId, userId
            // as per previous discussion, if not, adjust the service method signature
            if (Boolean.FALSE.equals(subjectService.hasAccessSubjectInPackage(packageId, userId, subjectId))) {
                log.info("User {} attempted to access unauthorized subjectId {} in packageId {}.", userId, subjectId, packageId);
                redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền truy cập gói học này hoặc gói đã hết hạn.");
                return "redirect:/"; // Redirect to home page or an access denied page
            }

            // Fetch all necessary learning data in one optimized call
            LearningPageDataDTO learningData = subjectService.getLearningPageData(subjectId, packageId, userId);

            // Add the combined DTO to the model
            model.addAttribute("learningData", learningData);


            return "client/learning/learn"; // Return the name of your JSP file
        } catch (IllegalArgumentException e) {
            log.error("Error fetching learning data for subjectId {} in packageId {}: {}", subjectId, packageId, e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/";
        } catch (Exception e) {
            log.error("An unexpected error occurred while loading learning page for subjectId {} in packageId {}: {}", subjectId, packageId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Đã xảy ra lỗi không mong muốn khi tải trang học.");
            return "redirect:/";
        }
    }

}