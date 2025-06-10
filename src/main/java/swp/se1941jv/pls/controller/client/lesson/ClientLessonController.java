package swp.se1941jv.pls.controller.client.lesson;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.LessonService;
import swp.se1941jv.pls.service.SubjectService;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
public class ClientLessonController {
    private SubjectService subjectService;
    private ChapterService chapterService;
    private LessonService lessonService;

    public ClientLessonController(SubjectService subjectService, ChapterService chapterService, LessonService lessonService) {
        this.subjectService = subjectService;
        this.chapterService = chapterService;
        this.lessonService = lessonService;
    }

    @GetMapping("/subject/{subjectId}/chapters/{chapterId}/lessons/{lessonId}")
    public String viewLesson(
            @PathVariable("subjectId") Long subjectId,
            @PathVariable("chapterId") Long chapterId,
            @PathVariable("lessonId") Long lessonId,
            Model model) {
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        if (subject.isEmpty()) {
            return "error/404";
        }

        // Lấy chapter có status = true
        Optional<Chapter> chapter = chapterService.getChapterByChapterIdAndStatusTrue(chapterId);
        if (chapter.isEmpty() || !chapter.get().getSubject().getSubjectId().equals(subjectId)) {
            return "error/404";
        }

        // Lấy lesson có status = true
        Optional<Lesson> lesson = lessonService.getLessonByIdAndStatusTrue(lessonId);
        if (lesson.isEmpty() || !lesson.get().getChapter().getChapterId().equals(chapterId)) {
            return "error/404";
        }

        // Lấy danh sách chapters có status = true
        List<Chapter> chapters = chapterService.getChaptersBySubjectIdAndStatusTrue(subjectId);

        // Parse materialsJson thành danh sách
        List<String> materials = new ArrayList<>();
        try {
            if (lesson.get().getMaterialsJson() != null && !lesson.get().getMaterialsJson().isEmpty()) {
                ObjectMapper mapper = new ObjectMapper();
                materials = mapper.readValue(lesson.get().getMaterialsJson(), new TypeReference<List<String>>() {});
            }
        } catch (JsonProcessingException e) {
            materials = new ArrayList<>();
        }

        // Thêm các đối tượng vào model
        model.addAttribute("subject", subject.get());
        model.addAttribute("chapter", chapter.get());
        model.addAttribute("lesson", lesson.get());
        model.addAttribute("chapters", chapters);
        model.addAttribute("materials", materials);

        return "client/lesson/show";
    }
}
