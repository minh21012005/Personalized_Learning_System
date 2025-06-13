package swp.se1941jv.pls.controller.client.lesson;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
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
import java.util.stream.Collectors;

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
     * Hiển thị trang tổng quan của môn học với chapter và lesson đầu tiên.
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
            // Lọc chỉ lấy chapterId và chapterName từ listChapter
            List<ChapterResponseDTO> simplifiedChapters = subjectResponse.getListChapter().stream()
                    .map(chapter -> ChapterResponseDTO.builder()
                            .chapterId(chapter.getChapterId())
                            .chapterName(chapter.getChapterName())
                            .build())
                    .toList();
            subjectResponse = SubjectResponseDTO.builder()
                    .subjectId(subjectResponse.getSubjectId())
                    .subjectName(subjectResponse.getSubjectName())
                    .subjectDescription(subjectResponse.getSubjectDescription())
                    .subjectImage(subjectResponse.getSubjectImage())
                    .isActive(subjectResponse.getIsActive())
                    .listChapter(simplifiedChapters)
                    .build();
            // Lấy chapter và lesson đầu tiên
            ChapterResponseDTO firstChapter = simplifiedChapters.stream().findFirst().map(chapter ->
                    chapterService.getChapterResponseById(chapter.getChapterId(), subjectId)).orElse(null);
            LessonResponseDTO firstLesson = firstChapter != null ? firstChapter.getListLesson().stream().findFirst().orElse(null) : null;

            model.addAttribute("subject", subjectResponse);
            model.addAttribute("chapter", firstChapter);
            model.addAttribute("lesson", firstLesson);
            model.addAttribute("chapters", simplifiedChapters);
        } catch (SubjectNotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/";
        } catch (ChapterNotFoundException | InvalidChapterException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/subject/" + subjectId;
        }
        return "client/lesson/show";
    }

    /**
     * Lấy chi tiết chapter qua API cho AJAX.
     *
     * @param chapterId ID của chương
     * @param subjectId ID của môn học
     * @return ChapterResponseDTO dưới dạng JSON
     */
    @GetMapping("/api/chapters/{chapterId}")
    @ResponseBody
    public ChapterResponseDTO getChapterDetails(
            @PathVariable("chapterId") Long chapterId,
            @RequestParam("subjectId") Long subjectId) {
        try {
            return chapterService.getChapterResponseById(chapterId, subjectId);
        } catch (ChapterNotFoundException | InvalidChapterException e) {
            throw new RuntimeException(e.getMessage()); // Xử lý ngoại lệ qua HTTP status
        }
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