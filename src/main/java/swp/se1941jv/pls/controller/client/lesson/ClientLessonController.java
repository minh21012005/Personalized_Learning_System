package swp.se1941jv.pls.controller.client.lesson;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.SubjectResponseDTO;
import swp.se1941jv.pls.exception.ApplicationException;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.LessonService;
import swp.se1941jv.pls.service.SubjectService;

import java.util.List;

/**
 * Controller xử lý các yêu cầu từ phía client liên quan đến bài học.
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class ClientLessonController {

    private final SubjectService subjectService;
    private final ChapterService chapterService;
    private final LessonService lessonService;

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
        try {
            SubjectResponseDTO subject = subjectService.getSubjectResponseById(subjectId);

            // Lấy danh sách chapter với chapterId, chapterName và danh sách lesson active
            List<ChapterResponseDTO> chapters = subject.getListChapter().stream()
                    .map(chapter -> {
                        List<LessonResponseDTO> activeLessons = lessonService.findLessonsByChapterId(
                                chapter.getChapterId(), null, true);
                        return ChapterResponseDTO.builder()
                                .chapterId(chapter.getChapterId())
                                .chapterName(chapter.getChapterName())
                                .listLesson(activeLessons)
                                .build();
                    })
                    .toList();

            // Lấy lesson đầu tiên của chapter đầu tiên (nếu có) để hiển thị mặc định
            LessonResponseDTO defaultLesson = chapters.stream()
                    .filter(chapter -> !chapter.getListLesson().isEmpty())
                    .findFirst()
                    .flatMap(chapter -> chapter.getListLesson().stream().findFirst())
                    .orElse(null);

            // Lấy chapter chứa lesson mặc định
            ChapterResponseDTO defaultChapter = chapters.stream()
                    .filter(chapter -> chapter.getListLesson().contains(defaultLesson))
                    .findFirst()
                    .orElse(null);

            model.addAttribute("subject", subject);
            model.addAttribute("chapters", chapters);
            model.addAttribute("chapter", defaultChapter);
            model.addAttribute("lesson", defaultLesson);
            return "client/lesson/show";
        } catch (ApplicationException e) {
            log.warn("Error viewing subject: subjectId={}, message={}", subjectId, e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/";
        } catch (Exception e) {
            log.error("Unexpected error viewing subject: subjectId={}", subjectId, e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi hiển thị môn học");
            return "redirect:/";
        }
    }

    /**
     * Lấy chi tiết lesson qua API cho AJAX.
     *
     * @param lessonId ID của bài học
     * @return LessonResponseDTO dưới dạng JSON
     * @throws ApplicationException nếu bài học không tồn tại hoặc không active
     */
    @GetMapping("/api/lessons/{lessonId}")
    @ResponseBody
    public LessonResponseDTO getLessonDetails(@PathVariable("lessonId") Long lessonId) {
        try {
            LessonResponseDTO lesson = lessonService.getLessonResponseById(lessonId);
            if (!lesson.getStatus()) {
                throw new ApplicationException("NOT_FOUND", "Bài học không active");
            }
            return lesson;
        } catch (ApplicationException e) {
            log.warn("Error fetching lesson details: lessonId={}, message={}", lessonId, e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("Unexpected error fetching lesson details: lessonId={}", lessonId, e);
            throw new ApplicationException("FETCH_ERROR", "Lỗi khi lấy chi tiết bài học", e);
        }
    }
}