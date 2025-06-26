package swp.se1941jv.pls.controller.client.lesson;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.*;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.exception.ApplicationException;
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
    @GetMapping("/packages/detail/subject")
    public String viewSubject(
            @RequestParam("subjectId") Long subjectId,
            @RequestParam("packageId") Long packageId,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Long userId = SecurityUtils.getCurrentUserId();
            if (userId == null) {
                model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
                return "redirect:/login";
            }

            // Kiểm tra quyền truy cập gói học
            if (Boolean.FALSE.equals(subjectService.hasAccessSubjectInPackage(packageId, subjectId, userId))) {
                redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền truy cập gói học này.");
                return "redirect:/";
            }

            User user = userService.getUserById(userId);

            if (user == null) {
                model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
                return "redirect:/login";
            }

            SubjectResponseDTO subject = subjectService.getSubjectResponseDTOById(subjectId,packageId, userId);

            // Lấy danh sách chapter đã phê duyệt
            List<ChapterResponseDTO> chapters = subject.getListChapter();

            // Lấy lesson đầu tiên của chapter đầu tiên (nếu có) để hiển thị mặc định
            LessonResponseDTO defaultLesson = chapters.stream()
                    .filter(chapter -> !chapter.getListLesson().isEmpty())
                    .findFirst()
                    .flatMap(chapter -> chapter.getListLesson().stream().findFirst())
                    .orElse(null);

            // Lấy chapter chứa lesson mặc định
            ChapterResponseDTO defaultChapter = chapters.stream()
                    .filter(chapter -> chapter.getListLesson().contains(defaultLesson))
                    .findFirst()
                    .orElse(null);

            model.addAttribute("user",user);
            model.addAttribute("subject", subject);
            model.addAttribute("chapters", chapters);
            model.addAttribute("chapter", defaultChapter);
            model.addAttribute("lesson", defaultLesson);
            return "client/learning/learn";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi hiển thị môn học");
            return "redirect:/";
        }
    }

}