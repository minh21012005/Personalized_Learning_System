package swp.se1941jv.pls.controller.admin;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.dto.response.SubjectResponseDTO;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.exception.ApplicationException;
import swp.se1941jv.pls.exception.DuplicateNameException;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.SubjectService;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/admin/subject/{subjectId}/chapters")
@RequiredArgsConstructor
public class ChapterController {

    private final SubjectService subjectService;
    private final ChapterService chapterService;

    /**
     * Hiển thị danh sách chương của một môn học.
     *
     * @param subjectId ID của môn học
     * @param chapterName Tên chương để lọc (tùy chọn)
     * @param status Trạng thái để lọc (tùy chọn)
     * @param model Model để truyền dữ liệu đến JSP
     * @param redirectAttributes Để truyền thông báo lỗi
     * @return Tên view JSP hoặc redirect
     */
    @GetMapping
    public String showChapters(
            @PathVariable Long subjectId,
            @RequestParam(required = false) String chapterName,
            @RequestParam(required = false) Boolean status,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            SubjectResponseDTO subject = subjectService.getSubjectResponseById(subjectId);
            if (subject == null) {
                log.warn("Subject not found: subjectId={}", subjectId);
                return "error/404";
            }

            List<ChapterResponseDTO> chapters = chapterService.findChaptersBySubjectId(subjectId, chapterName, status);
            model.addAttribute("subject", subject);
            model.addAttribute("chapters", chapters);
            model.addAttribute("chapterName", chapterName);
            model.addAttribute("status", status);
            return "admin/chapter/show";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/subject";
        } catch (Exception e) {
            log.error("Error fetching chapters: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi lấy danh sách chương");
            return "redirect:/admin/subject";
        }
    }

    /**
     * Hiển thị form tạo hoặc chỉnh sửa chương.
     *
     * @param subjectId ID của môn học
     * @param chapterId ID của chương (tùy chọn, để chỉnh sửa)
     * @param model Model để truyền dữ liệu đến JSP
     * @param redirectAttributes Để truyền thông báo lỗi
     * @return Tên view JSP hoặc redirect
     */
    @GetMapping("/save")
    public String showSaveChapterForm(
            @PathVariable Long subjectId,
            @RequestParam(required = false) Long chapterId,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Subject subject = subjectService.getSubjectById(subjectId).orElse(null);
            if (subject == null) {
                log.warn("Subject not found: subjectId={}", subjectId);
                return "error/404";
            }

            Chapter chapter = chapterId != null ? chapterService.getChapterById(chapterId).orElse(null) : new Chapter();
            if (chapterId != null && chapter == null) {
                log.warn("Chapter not found: chapterId={}", chapterId);
                redirectAttributes.addFlashAttribute("errorMessage", "Chương không tồn tại");
                return "redirect:/admin/subject/" + subjectId + "/chapters";
            }

            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapter);
            model.addAttribute("isEdit", chapterId != null);
            return "admin/chapter/save";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/subject/" + subjectId + "/chapters";
        } catch (Exception e) {
            log.error("Error showing chapter form: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi hiển thị form chương");
            return "redirect:/admin/subject/" + subjectId + "/chapters";
        }
    }

    /**
     * Xử lý lưu hoặc cập nhật chương.
     *
     * @param subjectId ID của môn học
     * @param chapter Entity chứa thông tin chương
     * @param bindingResult Kết quả validation
     * @param redirectAttributes Để truyền thông báo
     * @param model Model để truyền dữ liệu đến JSP
     * @return Redirect hoặc tên view JSP
     */
    @PostMapping("/save")
    public String saveChapter(
            @PathVariable Long subjectId,
            @Valid @ModelAttribute("chapter") Chapter chapter,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model) {
        Subject subject = subjectService.getSubjectById(subjectId).orElse(null);
        if (subject == null) {
            log.warn("Subject not found: subjectId={}", subjectId);
            return "error/404";
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapter);
            model.addAttribute("isEdit", chapter.getChapterId() != null);
            return "admin/chapter/save";
        }

        try {
            chapter.setSubject(subject);
            chapterService.saveChapter(chapter);
            redirectAttributes.addFlashAttribute("message", "Lưu chương thành công");
            return "redirect:/admin/subject/" + subjectId + "/chapters";
        } catch (ApplicationException e) {
            String field = e instanceof DuplicateNameException ? "chapterName" : null;
            bindingResult.rejectValue(field, "error.chapter", e.getMessage());
            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapter);
            model.addAttribute("isEdit", chapter.getChapterId() != null);
            return "admin/chapter/save";
        } catch (Exception e) {
            log.error("Error saving chapter: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi lưu chương");
            return "redirect:/admin/subject/" + subjectId + "/chapters";
        }
    }

    /**
     * Cập nhật trạng thái của các chương.
     *
     * @param subjectId ID của môn học
     * @param chapterIds Danh sách ID chương
     * @param redirectAttributes Để truyền thông báo
     * @return Redirect
     */
    @PostMapping("/update-status")
    public String updateChapterStatus(
            @PathVariable Long subjectId,
            @RequestParam List<Long> chapterIds,
            RedirectAttributes redirectAttributes) {
        try {
            SubjectResponseDTO subject = subjectService.getSubjectResponseById(subjectId);
            if (subject == null) {
                log.warn("Subject not found: subjectId={}", subjectId);
                return "error/404";
            }

            chapterService.toggleChaptersStatus(chapterIds);
            redirectAttributes.addFlashAttribute("message", "Cập nhật trạng thái thành công");
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            log.error("Error updating chapter status: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái");
        }
        return "redirect:/admin/subject/" + subjectId + "/chapters";
    }
}