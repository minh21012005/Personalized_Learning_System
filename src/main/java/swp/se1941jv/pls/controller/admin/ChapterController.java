package swp.se1941jv.pls.controller.admin;

import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
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

    @GetMapping("admin/subject/{id}/chapters")
    public String getDetailSubjectPage(
            Model model,
            @PathVariable("id") Long id,
            @RequestParam(value = "page", required = false, defaultValue = "1") Optional<String> page,
            @RequestParam(value = "size", required = false, defaultValue = "10") Optional<String> size,
            @RequestParam(value = "chapterName") Optional<String> chapterName,
            @RequestParam(value = "status") Optional<Boolean> status

    ) {
        Optional<Subject> subject = subjectService.getSubjectById(id);
        if (subject.isEmpty()) {
            return "error/404";
        }

        int pageNumber;
        try {
            pageNumber = page.map(Integer::parseInt).orElse(1);
        } catch (Exception e) {
            pageNumber = 1;
        }

        int pageSize;
        try {
            pageSize = size.map(Integer::parseInt).orElse(10);
        } catch (Exception e) {
            pageSize = 1;
        }

        Pageable pageable = PageRequest.of(pageNumber - 1, pageSize, Sort.by(Sort.Direction.DESC, "chapterId"));

        // Lấy giá trị status
        Boolean chapterStatus = status.orElse(null); // null nghĩa là không lọc theo status
        String searchName = chapterName.orElse(""); // Chuỗi rỗng nghĩa là không lọc theo tên


        Page<Chapter> chapters = chapterService.findChapters(id,searchName, chapterStatus,pageable);


            // Truyền dữ liệu vào model để hiển thị trên JSP
        model.addAttribute("subject", subject.get());
        model.addAttribute("chapters", chapters.getContent());
        model.addAttribute("currentPage", pageNumber);
        model.addAttribute("totalPages", chapters.getTotalPages());
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("chapterName", searchName);
        model.addAttribute("status", chapterStatus);

        return "admin/chapter/show";
    }

    @GetMapping("admin/subject/{id}/chapters/save")
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

    @PostMapping("admin/subject/{id}/chapters/save")
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