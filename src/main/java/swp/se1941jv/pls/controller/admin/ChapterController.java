package swp.se1941jv.pls.controller.admin;

import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.SubjectService;

import java.util.List;
import java.util.Optional;

@Controller
public class ChapterController {

    private final SubjectService subjectService;
    private final ChapterService chapterService;

    public ChapterController(SubjectService subjectService, ChapterService chapterService) {
        this.subjectService = subjectService;
        this.chapterService = chapterService;
    }

    @GetMapping("admin/subject/{id}")
    public String getDetailSubjectPage(
            Model model,
            @PathVariable("id") Long id) {
        Optional<Subject> subject = subjectService.getSubjectById(id);
        if (subject.isEmpty()) {
            return "error/404";
        }
        List<Chapter> chapters = chapterService.getChaptersBySubject(subject.get());

        model.addAttribute("subject", subject.get());
        model.addAttribute("chapters", chapters);
        model.addAttribute("newChapter", new Chapter());

        return "admin/chapter/show";
    }

    @GetMapping("admin/subject/{id}/save")
    public String saveChapterToSubjectPage(
            Model model,
            @PathVariable("id") Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId) {
        Optional<Subject> subjectOpt = subjectService.getSubjectById(subjectId);
        if (subjectOpt.isEmpty()) {
            return "error/404";
        }
        Subject subject = subjectOpt.get();

        Chapter chapter;
        boolean isEdit = chapterId != null;
        if (isEdit) {
            Optional<Chapter> chapterOpt = chapterService.getChapterByChapterId(chapterId);
            if (chapterOpt.isEmpty()) {
                return "error/404";
            }
            chapter = chapterOpt.get();
        } else {
            chapter = new Chapter();
        }

        model.addAttribute("subject", subject);
        model.addAttribute("chapter", chapter);
        model.addAttribute("isEdit", isEdit);
        return "admin/chapter/save";
    }

    @PostMapping("admin/subject/{id}/save")
    public String saveChapterToSubject(
            Model model,
            @PathVariable("id") Long subjectId,
            @Valid @ModelAttribute("chapter") Chapter chapter,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes) {
        Optional<Subject> subjectOpt = subjectService.getSubjectById(subjectId);
        if (subjectOpt.isEmpty()) {
            return "error/404";
        }
        Subject subject = subjectOpt.get();

        boolean isEdit = chapter.getChapterId() != null;
        Chapter existingChapter = null;
        if (isEdit) {
            Optional<Chapter> chapterOpt = chapterService.getChapterByChapterId(chapter.getChapterId());
            if (chapterOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Chương học không tồn tại!");
                return "redirect:/admin/subject/" + subjectId;
            }
            existingChapter = chapterOpt.get();
            if (!existingChapter.getChapterName().equals(chapter.getChapterName()) &&
                    chapterService.existsByChapterNameAndSubject(chapter.getChapterName(), subject)) {
                bindingResult.rejectValue("chapterName", "error.chapter", "Tên chương đã tồn tại trong môn học này");
            }
        } else {
            if (chapterService.existsByChapterNameAndSubject(chapter.getChapterName(), subject)) {
                bindingResult.rejectValue("chapterName", "error.chapter", "Tên chương đã tồn tại trong môn học này");
            }
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("subject", subject);
            model.addAttribute("isEdit", isEdit);
            return "admin/chapter/save";
        }

        try {
            if (isEdit) {
                existingChapter.setChapterName(chapter.getChapterName());
                existingChapter.setChapterDescription(chapter.getChapterDescription());
                chapterService.saveChapter(existingChapter);
                redirectAttributes.addFlashAttribute("successMessage", "Chỉnh sửa chương học thành công");
            } else {
                chapter.setSubject(subject);
                chapterService.saveChapter(chapter);
                redirectAttributes.addFlashAttribute("successMessage", "Thêm chương học thành công");
            }
        } catch (Exception e) {
            model.addAttribute("subject", subject);
            model.addAttribute("isEdit", isEdit);
            model.addAttribute("errorMessage", "Lỗi khi lưu chương học: " + e.getMessage());
            return "admin/chapter/save";
        }

        return "redirect:/admin/subject/" + subjectId;
    }
}