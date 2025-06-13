package swp.se1941jv.pls.controller.client.lesson;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.SubjectResponseDTO;
import swp.se1941jv.pls.exception.chapter.ChapterNotFoundException;
import swp.se1941jv.pls.exception.chapter.InvalidChapterException;
import swp.se1941jv.pls.exception.lesson.LessonNotFoundException;
import swp.se1941jv.pls.exception.subject.SubjectNotFoundException;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.LessonService;
import swp.se1941jv.pls.service.SubjectService;

import java.util.List;

/**
 * Controller xử lý các yêu cầu từ phía client liên quan đến bài học.
 */
@Controller
public class ClientLessonController {

    private final SubjectService subjectService;
    private final ChapterService chapterService;
    private final LessonService lessonService;

    @Autowired
    public ClientLessonController(SubjectService subjectService, ChapterService chapterService, LessonService lessonService) {
        this.subjectService = subjectService;
        this.chapterService = chapterService;
        this.lessonService = lessonService;
    }

    /**
     * Hiển thị trang tổng quan của môn học với danh sách chapter và lesson.
     *
     * @param subjectId ID của môn học
     * @param model     Model để truyền dữ liệu đến JSP
     * @param redirectAttributes Để truyền thông báo lỗi
     * @return Tên view JSP hoặc redirect
     */
    @GetMapping("/subject/{subjectId}")
    public String viewSubject(
            @PathVariable("subjectId") Long subjectId,
            Model model,
            RedirectAttributes redirectAttributes) {
        SubjectResponseDTO subjectResponse;
        try {
            subjectResponse = subjectService.getSubjectResponseById(subjectId);
            // Lấy danh sách chapter với chapterId, chapterName và danh sách lesson
            List<ChapterResponseDTO> chapters = subjectResponse.getListChapter().stream()
                    .map(chapter -> {
                        List<LessonResponseDTO> simplifiedLessons = lessonService.getActiveLessonsResponseByChapterId(chapter.getChapterId());
                        return ChapterResponseDTO.builder()
                                .chapterId(chapter.getChapterId())
                                .chapterName(chapter.getChapterName())
                                .listLesson(simplifiedLessons)
                                .build();
                    })
                    .toList();

            // Lấy lesson đầu tiên của chapter đầu tiên (nếu có) để hiển thị mặc định
            LessonResponseDTO defaultLesson = chapters.stream()
                    .filter(chapter -> !chapter.getListLesson().isEmpty())
                    .findFirst()
                    .flatMap(chapter -> chapter.getListLesson().stream().findFirst())
                    .map(lesson -> lessonService.getActiveLessonResponseById(lesson.getLessonId()))
                    .orElse(null);

            // Lấy chapter chứa lesson mặc định
            ChapterResponseDTO defaultChapter = chapters.stream()
                    .filter(chapter -> chapter.getListLesson().stream()
                            .anyMatch(lesson -> defaultLesson != null && lesson.getLessonId().equals(defaultLesson.getLessonId())))
                    .findFirst()
                    .orElse(null);

            model.addAttribute("subject", subjectResponse);
            model.addAttribute("chapters", chapters);
            model.addAttribute("chapter", defaultChapter);
            model.addAttribute("lesson", defaultLesson);
        } catch (SubjectNotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/";
        } catch (ChapterNotFoundException | InvalidChapterException | LessonNotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/subject/" + subjectId;
        }
        return "client/lesson/show";
    }

    /**
     * Lấy chi tiết lesson qua API cho AJAX.
     *
     * @param lessonId ID của bài học
     * @return LessonResponseDTO dưới dạng JSON
     */
    @GetMapping("/api/lessons/{lessonId}")
    @ResponseBody
    public LessonResponseDTO getLessonDetails(@PathVariable("lessonId") Long lessonId) {
        try {
            return lessonService.getActiveLessonResponseById(lessonId);
        } catch (LessonNotFoundException e) {
            throw new RuntimeException(e.getMessage()); // Xử lý ngoại lệ qua HTTP status
        }
    }
}