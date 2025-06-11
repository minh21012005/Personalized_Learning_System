package swp.se1941jv.pls.controller.admin;

import jakarta.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.exception.Chapter.ChapterNotFoundException;
import swp.se1941jv.pls.exception.Chapter.DuplicateChapterNameException;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.SubjectService;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/subject/{id}/chapters")
public class ChapterController {

    private final SubjectService subjectService;
    private final ChapterService chapterService;

    public ChapterController(SubjectService subjectService, ChapterService chapterService) {
        this.subjectService = subjectService;
        this.chapterService = chapterService;
    }


    /**
     * Hiển thị trang danh sách chương của một môn học.
     *
     * @param id ID của môn học
     * @param chapterName Tên chương để lọc (tùy chọn)
     * @param status Trạng thái để lọc (tùy chọn)
     * @param model Model để truyền dữ liệu đến JSP
     * @return Tên view JSP
     */
    @GetMapping
    public String getDetailSubjectPage(
            @PathVariable("id") Long id,
            @RequestParam(value = "chapterName", required = false) String chapterName,
            @RequestParam(value = "status", required = false) Boolean status,
            Model model) {
        Optional<Subject> subject = subjectService.getSubjectById(id);
        if (subject.isEmpty()) {
            return "error/404";
        }
        List<Chapter> chapters = chapterService.findChapters(id, chapterName, status);
        model.addAttribute("subject", subject.get());
        model.addAttribute("chapters", chapters);
        model.addAttribute("chapterName", chapterName);
        model.addAttribute("status", status);
        return "admin/chapter/show";
    }

    /**
     * Hiển thị form tạo hoặc cập nhật chương.
     *
     * @param subjectId ID của môn học
     * @param chapterId ID của chương (tùy chọn, để chỉnh sửa)
     * @param model Model để truyền dữ liệu đến JSP
     * @param redirectAttributes Để truyền thông báo lỗi
     * @return Tên view JSP hoặc redirect
     */
    @GetMapping("/save")
    public String saveChapterToSubjectPage(
            @PathVariable("id") Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId,
            Model model,
            RedirectAttributes redirectAttributes) {
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        if (subject.isEmpty()) {
            return "error/404";
        }
        Chapter chapter;
        if (chapterId != null) {
            chapter = chapterService.findChapterById(chapterId)
                    .orElse(null);
            if (chapter == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Chương không tồn tại");
                return "redirect:/admin/subject/" + subjectId + "/chapters";
            }
        } else {
            chapter = new Chapter();
        }
        model.addAttribute("subject", subject);
        model.addAttribute("chapter", chapter);
        model.addAttribute("isEdit", chapterId != null);
        return "admin/chapter/save";
    }

    /**
     * Xử lý lưu hoặc cập nhật chương.
     *
     * @param subjectId ID của môn học
     * @param chapter Chương cần lưu
     * @param bindingResult Kết quả validation
     * @param redirectAttributes Để truyền thông báo
     * @param model Model để truyền dữ liệu đến JSP
     * @return Redirect hoặc tên view JSP
     */
    @PostMapping("/save")
    public String saveChapterToSubject(
            @PathVariable("id") Long subjectId,
            @Valid @ModelAttribute("chapter") Chapter chapter,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model) {
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        if (subject.isEmpty()) {
            return "error/404";
        }
        try {
            chapterService.saveChapter(chapter, subject.get());
            redirectAttributes.addFlashAttribute("message", "Lưu chương thành công");
        } catch (DuplicateChapterNameException e) {
            model.addAttribute("chapter", chapter);
            model.addAttribute("subject", subject);
            model.addAttribute("isEdit", chapter.getChapterId() != null);
            bindingResult.rejectValue("chapterName", "error.chapter", e.getMessage());
            return "admin/chapter/save";
        } catch (ChapterNotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/subject/" + subjectId + "/chapters";
        }
        return "redirect:/admin/subject/" + subjectId + "/chapters";
    }


    @PostMapping("admin/subject/{id}/chapters/update-status")
    public String updateChapterStatus(
            @PathVariable("id") Long subjectId,
            @RequestParam("chapterIds") List<Long> chapterIds,
            RedirectAttributes redirectAttributes
    ) {
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        if (subject.isEmpty()) {
            return "error/404";
        }

        try {
            chapterService.updateChaptersStatus(chapterIds);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái chương học thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
        }

        return "redirect:/admin/subject/" + subjectId + "/chapters";
    }
}