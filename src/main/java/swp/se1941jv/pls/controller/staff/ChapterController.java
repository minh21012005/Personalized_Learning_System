package swp.se1941jv.pls.controller.staff;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
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
@RequestMapping("/staff/subject/{subjectId}/chapters")
@RequiredArgsConstructor
public class ChapterController {

    private final SubjectService subjectService;
    private final ChapterService chapterService;

    /**
     * Hiển thị danh sách chương của một môn học.
     */
    @PreAuthorize("hasAnyRole('STAFF')")
    @GetMapping
    public String showChapters(
            @PathVariable Long subjectId,
            @RequestParam(required = false) String chapterName,
            @RequestParam(required = false) Boolean status,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Subject subject = subjectService.getSubjectById(subjectId).orElse(null);
            if (subject == null) {
                log.warn("Subject not found: subjectId={}", subjectId);
                return "error/404";
            }

            List<ChapterResponseDTO> chapters = chapterService.findChaptersBySubjectId(subjectId, chapterName, status);
            model.addAttribute("subject", subject);
            model.addAttribute("chapters", chapters);
            model.addAttribute("chapterName", chapterName);
            model.addAttribute("status", status);
            return "staff/chapter/show";
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
     * Hiển thị form tạo chương mới.
     */
    @PreAuthorize("hasAnyRole('STAFF')")
    @GetMapping("/new")
    public String showCreateChapterForm(
            @PathVariable Long subjectId,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Subject subject = subjectService.getSubjectById(subjectId).orElse(null);
            if (subject == null) {
                log.warn("Subject not found: subjectId={}", subjectId);
                return "error/404";
            }

            model.addAttribute("subject", subject);
            model.addAttribute("chapter", new Chapter());
            model.addAttribute("isEdit", false);
            return "staff/chapter/save";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        } catch (Exception e) {
            log.error("Error showing chapter form: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi hiển thị form chương");
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        }
    }

    /**
     * Hiển thị form chỉnh sửa chương.
     */
    @PreAuthorize("hasAnyRole('STAFF')")
    @GetMapping("/{chapterId}/edit")
    public String showEditChapterForm(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Subject subject = subjectService.getSubjectById(subjectId).orElse(null);
            if (subject == null) {
                log.warn("Subject not found: subjectId={}", subjectId);
                return "error/404";
            }

            Chapter chapter = chapterService.getChapterById(chapterId).orElse(null);
            if (chapter == null) {
                log.warn("Chapter not found: chapterId={}", chapterId);
                redirectAttributes.addFlashAttribute("errorMessage", "Chương không tồn tại");
                return "redirect:/staff/subject/" + subjectId + "/chapters";
            }

            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapter);
            model.addAttribute("isEdit", true);
            return "staff/chapter/save";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        } catch (Exception e) {
            log.error("Error showing chapter form: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi hiển thị form chương");
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        }
    }

    /**
     * Xử lý tạo chương mới.
     */
    @PreAuthorize("hasAnyRole('STAFF')")
    @PostMapping
    public String createChapter(
            @PathVariable Long subjectId,
            @Valid @ModelAttribute("chapter") Chapter chapter,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model) {
        return handleChapterSave(subjectId, chapter, bindingResult, redirectAttributes, model, false);
    }

    /**
     * Xử lý cập nhật chương.
     */
    @PreAuthorize("hasAnyRole('STAFF')")
    @PutMapping("/{chapterId}")
    public String updateChapter(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @Valid @ModelAttribute("chapter") Chapter chapter,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model) {
        chapter.setChapterId(chapterId);
        return handleChapterSave(subjectId, chapter, bindingResult, redirectAttributes, model, true);
    }

    /**
     * Xử lý nộp chương (chuyển trạng thái từ DRAFT sang PENDING).
     */
    @PreAuthorize("hasAnyRole('STAFF')")
    @PostMapping("/{chapterId}/submit")
    public String submitChapter(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            RedirectAttributes redirectAttributes) {
        try {
            Subject subject = subjectService.getSubjectById(subjectId).orElse(null);
            if (subject == null) {
                log.warn("Subject not found: subjectId={}", subjectId);
                return "error/404";
            }
            chapterService.submitChapter(chapterId);
            redirectAttributes.addFlashAttribute("message", "Nộp chương thành công");
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        } catch (Exception e) {
            log.error("Error submitting chapter: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi nộp chương");
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        }
    }

    /**
     * Xử lý hủy chương (chuyển trạng thái từ PENDING về DRAFT).
     */
    @PreAuthorize("hasAnyRole('STAFF')")
    @PostMapping("/{chapterId}/cancel")
    public String cancelChapter(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            RedirectAttributes redirectAttributes) {
        try {
            Subject subject = subjectService.getSubjectById(subjectId).orElse(null);
            if (subject == null) {
                log.warn("Subject not found: subjectId={}", subjectId);
                return "error/404";
            }
            chapterService.cancelChapter(chapterId);
            redirectAttributes.addFlashAttribute("message", "Hủy chương thành công");
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        } catch (Exception e) {
            log.error("Error canceling chapter: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi hủy chương");
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        }
    }


    /**
     * Cập nhật trạng thái của các chương.
     */
    @PreAuthorize("hasAnyRole('STAFF')")
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
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        } catch (Exception e) {
            log.error("Error updating chapter status: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái");
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        }
    }

    /**
     * Xử lý logic lưu chương (tạo mới hoặc cập nhật).
     */
    private String handleChapterSave(
            Long subjectId,
            Chapter chapter,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model,
            boolean isEdit) {
        Subject subject = subjectService.getSubjectById(subjectId).orElse(null);
        if (subject == null) {
            log.warn("Subject not found: subjectId={}", subjectId);
            return "error/404";
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapter);
            model.addAttribute("isEdit", isEdit);
            return "staff/chapter/save";
        }

        try {
            chapter.setSubject(subject);
            if (isEdit) {
                chapterService.updateChapter(chapter);
            } else {
                chapterService.createChapter(chapter);
            }
            redirectAttributes.addFlashAttribute("message", isEdit ? "Cập nhật chương thành công" : "Tạo chương thành công");
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        } catch (ApplicationException e) {
            String field = e instanceof DuplicateNameException ? "chapterName" : null;
            bindingResult.rejectValue(field, "error.chapter", e.getMessage());
            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapter);
            model.addAttribute("isEdit", isEdit);
            return "staff/chapter/save";
        } catch (Exception e) {
            log.error("Error saving chapter: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi lưu chương");
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        }
    }
}