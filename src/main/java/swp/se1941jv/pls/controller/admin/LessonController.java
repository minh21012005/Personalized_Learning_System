package swp.se1941jv.pls.controller.admin;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.LessonService;
import swp.se1941jv.pls.service.SubjectService;

import java.util.Optional;

@Controller
public class LessonController {

    private final SubjectService subjectService;
    private final ChapterService chapterService;
    private final LessonService lessonService;

    public LessonController(SubjectService subjectService, ChapterService chapterService, LessonService lessonService) {
        this.subjectService = subjectService;
        this.chapterService = chapterService;
        this.lessonService = lessonService;
    }

    @GetMapping("admin/subject/{subjectId}/chapters/{chapterId}/lessons")
    public String getDetailChapterPage(
            Model model,
            @PathVariable("subjectId") Long subjectId,
            @PathVariable("chapterId") Long chapterId,
            @RequestParam(value = "page", required = false, defaultValue = "1") Optional<String> page,
            @RequestParam(value = "size", required = false, defaultValue = "10") Optional<String> size
    ){
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        if (subject.isEmpty()) {
            return "error/404";
        }

        Optional<Chapter> chapter = chapterService.getChapterByChapterId(chapterId);
        if (chapter.isEmpty()) {
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
            pageSize = size.map(Integer::parseInt).orElse(1);
        } catch (Exception e) {
            pageSize = 1;
        }

        Pageable pageable = PageRequest.of(pageNumber - 1, pageSize, Sort.by(Sort.Direction.DESC, "lessonId"));
        Page<Lesson> lessons = lessonService.findLessons(chapterId,pageable);
        // Truyền dữ liệu vào model để hiển thị trên JSP
        model.addAttribute("chapter", chapter.get());
        model.addAttribute("lessons", lessons.getContent());
        model.addAttribute("subject", subject.get());
        model.addAttribute("currentPage", pageNumber);
        model.addAttribute("totalPages", lessons.getTotalPages());
        model.addAttribute("pageSize", pageSize);

        return "admin/lesson/show";
    }

    @GetMapping("admin/subject/{subjectId}/chapters/{chapterId}/lessons/save")
    public String saveLessonToChapterPage(
            Model model,
            @PathVariable("subjectId") Long subjectId,
            @PathVariable("chapterId") Long chapterId,
            @RequestParam(value = "lessonId", required = false) Long lessonId) {
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        if (subject.isEmpty()) {
            return "error/404";
        }

        Optional<Chapter> chapter = chapterService.getChapterByChapterId(chapterId);
        if (chapter.isEmpty()) {
            return "error/404";
        }

        Lesson lesson;
        boolean isEdit = lessonId != null;
        if (isEdit) {
            Optional<Lesson> lessonOpt = lessonService.findLesson(lessonId);
            if (lessonOpt.isEmpty()) {
                return "error/404";
            }
            lesson = lessonOpt.get();
        } else {
            lesson = new Lesson();
        }

        model.addAttribute("subject", subject.get());
        model.addAttribute("chapter", chapter.get());
        model.addAttribute("lesson", lesson);
        model.addAttribute("isEdit", isEdit);
        return "admin/lesson/save";
    }

    @PostMapping("admin/subject/{subjectId}/chapters/{chapterId}/lessons/save")
    public String saveLessonToChapter(
            @PathVariable("subjectId") Long subjectId,
            @PathVariable("chapterId") Long chapterId,
            @ModelAttribute("lesson")  Lesson lesson,
            @RequestParam("materialFiles") MultipartFile[] materialFiles,
            @RequestParam(value = "lessonId", required = false) Long lessonId) {
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        if (subject.isEmpty()) {
            return "error/404";
        }

        Optional<Chapter> chapter = chapterService.getChapterByChapterId(chapterId);
        if (chapter.isEmpty()) {
            return "error/404";
        }


        return "admin/lesson/save";
    }
}
