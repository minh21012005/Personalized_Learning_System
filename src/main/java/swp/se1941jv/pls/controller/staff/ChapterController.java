package swp.se1941jv.pls.controller.staff;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.dto.response.chapter.ChapterFormDTO;
import swp.se1941jv.pls.dto.response.chapter.ChapterListDTO;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.SubjectService;

@Slf4j
@Controller
@RequestMapping("/staff/subject/{subjectId}/chapters")
@RequiredArgsConstructor
public class ChapterController {

    private final SubjectService subjectService;
    private final ChapterService chapterService;

    @PreAuthorize("hasRole('STAFF')")
    @GetMapping
    public String showChapters(
            @PathVariable Long subjectId,
            @RequestParam(required = false) String chapterName,
            @RequestParam(required = false) Boolean status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortField,
            @RequestParam(defaultValue = "desc") String sortDir,
            Model model,
            HttpSession session) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                model.addAttribute("errorMessage", "subject.message.loginRequired");
                return "staff/chapter/show";
            }

            String adjustedSortField = sortField;
            if ("chapterId".equals(sortField)) {
                adjustedSortField = "chapterId";
            } else if ("chapterName".equals(sortField)) {
                adjustedSortField = "chapterName";
            } else {
                adjustedSortField = "createdAt";
            }

            Sort.Direction direction = sortDir.equalsIgnoreCase("asc") ? Sort.Direction.ASC : Sort.Direction.DESC;
            Page<ChapterListDTO> chapterPage = chapterService.findChaptersBySubjectId(
                    subjectId, chapterName, status, userId, PageRequest.of(page, size, Sort.by(direction, adjustedSortField)));

            model.addAttribute("subject", subjectService.getSubjectById(subjectId).orElse(null));
            model.addAttribute("chapterPage", chapterPage);
            model.addAttribute("chapters", chapterPage.getContent());
            model.addAttribute("chapterName", chapterName);
            model.addAttribute("status", status);
            model.addAttribute("currentPage", page);
            model.addAttribute("pageSize", size);
            model.addAttribute("sortField", sortField);
            model.addAttribute("sortDir", sortDir);
            model.addAttribute("reverseSortDir", sortDir.equals("asc") ? "desc" : "asc");
            return "staff/chapter/show";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "staff/chapter/show";
        } catch (Exception e) {
            log.error("Error fetching chapters: {}", e.getMessage(), e);
            model.addAttribute("errorMessage", "chapter.list.error");
            return "staff/chapter/show";
        }
    }

    @PreAuthorize("hasRole('STAFF')")
    @GetMapping("/new")
    public String showCreateChapterForm(
            @PathVariable Long subjectId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.loginRequired");
                return "redirect:/staff/subject/{subjectId}/chapters";
            }

            Subject subject = subjectService.getSubjectById(subjectId)
                    .orElseThrow(() -> new IllegalArgumentException("subject.message.notFound"));

            chapterService.validateStaffAccess(subjectId, userId);
            ChapterFormDTO chapterForm = new ChapterFormDTO();
            chapterForm.setSubjectId(subjectId);

            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapterForm);
            model.addAttribute("isEdit", false);
            return "staff/chapter/save";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/{subjectId}/chapters";
        } catch (Exception e) {
            log.error("Error showing chapter form: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "chapter.message.error.form");
            return "redirect:/staff/subject/{subjectId}/chapters";
        }
    }

    @PreAuthorize("hasRole('STAFF')")
    @GetMapping("/{chapterId}/edit")
    public String showEditChapterForm(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.loginRequired");
                return "redirect:/staff/subject/{subjectId}/chapters";
            }

            Subject subject = subjectService.getSubjectById(subjectId)
                    .orElseThrow(() -> new IllegalArgumentException("subject.message.notFound"));

            chapterService.validateStaffAccess(subjectId, userId);

            Chapter chapter = chapterService.getChapterById(chapterId)
                    .orElseThrow(() -> new IllegalArgumentException("chapter.message.notFound"));

            ChapterFormDTO chapterForm = new ChapterFormDTO();
            chapterForm.setChapterId(chapterId);
            chapterForm.setChapterName(chapter.getChapterName());
            chapterForm.setChapterDescription(chapter.getChapterDescription());
            chapterForm.setSubjectId(subjectId);

            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapterForm);
            model.addAttribute("isEdit", true);
            return "staff/chapter/save";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/{subjectId}/chapters";
        } catch (Exception e) {
            log.error("Error showing chapter form: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "chapter.message.error.form");
            return "redirect:/staff/subject/{subjectId}/chapters";
        }
    }

    @PreAuthorize("hasRole('STAFF')")
    @PostMapping
    public String createChapter(
            @PathVariable Long subjectId,
            @Valid @ModelAttribute("chapter") ChapterFormDTO chapterForm,
            BindingResult bindingResult,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            Model model) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.loginRequired");
                return "redirect:/staff/subject/{subjectId}/chapters";
            }

            if (bindingResult.hasErrors()) {
                model.addAttribute("subject", subjectService.getSubjectById(subjectId).orElse(null));
                model.addAttribute("isEdit", false);
                return "staff/chapter/save";
            }

            chapterForm.setSubjectId(subjectId);
            chapterService.createChapter(chapterForm, userId);
            redirectAttributes.addFlashAttribute("message", "chapter.message.created.success");
            return "redirect:/staff/subject/{subjectId}/chapters";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("subject", subjectService.getSubjectById(subjectId).orElse(null));
            model.addAttribute("isEdit", false);
            return "staff/chapter/save";
        } catch (Exception e) {
            log.error("Error creating chapter: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "chapter.message.error.create");
            return "redirect:/staff/subject/{subjectId}/chapters";
        }
    }

    @PreAuthorize("hasRole('STAFF')")
    @PostMapping("/{chapterId}")
    public String updateChapter(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @Valid @ModelAttribute("chapter") ChapterFormDTO chapterForm,
            BindingResult bindingResult,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            Model model) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.loginRequired");
                return "redirect:/staff/subject/{subjectId}/chapters";
            }

            if (bindingResult.hasErrors()) {
                model.addAttribute("subject", subjectService.getSubjectById(subjectId).orElse(null));
                model.addAttribute("isEdit", true);
                return "staff/chapter/save";
            }

            chapterForm.setSubjectId(subjectId);
            chapterForm.setChapterId(chapterId);
            chapterService.updateChapter(chapterForm, userId);
            redirectAttributes.addFlashAttribute("message", "chapter.message.updated.success");
            return "redirect:/staff/subject/{subjectId}/chapters";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("subject", subjectService.getSubjectById(subjectId).orElse(null));
            model.addAttribute("isEdit", true);
            return "staff/chapter/save";
        } catch (Exception e) {
            log.error("Error updating chapter: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "chapter.message.error.update");
            return "redirect:/staff/subject/{subjectId}/chapters";
        }
    }

//    @PreAuthorize("hasRole('STAFF')")
//    @PostMapping("/{chapterId}/delete")
//    public String deleteChapter(
//            @PathVariable Long subjectId,
//            @PathVariable Long chapterId,
//            HttpSession session,
//            RedirectAttributes redirectAttributes) {
//        try {
//            Long userId = (Long) session.getAttribute("id");
//            if (userId == null) {
//                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.loginRequired");
//                return "redirect:/staff/subject/{subjectId}/chapters";
//            }
//            chapterService.deleteChapter(chapterId, userId);
//            redirectAttributes.addFlashAttribute("message", "chapter.message.deleted.success");
//            return "redirect:/staff/subject/{subjectId}/chapters";
//        } catch (IllegalArgumentException e) {
//            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
//            return "redirect:/staff/subject/{subjectId}/chapters";
//        } catch (Exception e) {
//            log.error("Error deleting chapter: {}", e.getMessage(), e);
//            redirectAttributes.addFlashAttribute("errorMessage", "chapter.message.error.delete");
//            return "redirect:/staff/subject/{subjectId}/chapters";
//        }
//    }

    @PreAuthorize("hasRole('STAFF')")
    @PostMapping("/{chapterId}/toggle-hidden")
    public String toggleChapterHidden(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.loginRequired");
                return "redirect:/staff/subject/{subjectId}/chapters";
            }
            chapterService.toggleChapterHiddenStatus(chapterId, userId);
            redirectAttributes.addFlashAttribute("message", "Trạng thái ẩn của chương đã được cập nhật!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            log.error("Lỗi khi thay đổi trạng thái ẩn của chương ID {}: {}", chapterId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi thay đổi trạng thái ẩn của chương!");
        }
        return "redirect:/staff/subject/{subjectId}/chapters";
    }
}