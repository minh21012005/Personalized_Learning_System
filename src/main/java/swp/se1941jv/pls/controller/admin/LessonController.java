package swp.se1941jv.pls.controller.admin;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.dto.response.SubjectResponseDTO;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.exception.ApplicationException;
import swp.se1941jv.pls.exception.DuplicateNameException;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.LessonService;
import swp.se1941jv.pls.service.SubjectService;
import swp.se1941jv.pls.service.FileUploadService;
import swp.se1941jv.pls.util.YouTubeApiClient;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/admin/subject/{subjectId}/chapters/{chapterId}/lessons")
@RequiredArgsConstructor
public class LessonController {

    private final SubjectService subjectService;
    private final ChapterService chapterService;
    private final LessonService lessonService;
    private final FileUploadService fileUploadService;
    private final YouTubeApiClient youTubeApiClient;
    private final ObjectMapper objectMapper;

    /**
     * Hiển thị danh sách bài học của một chương.
     *
     * @param subjectId ID của môn học
     * @param chapterId ID của chương
     * @param lessonName Tên bài học để lọc (tùy chọn)
     * @param status Trạng thái để lọc (tùy chọn)
     * @param model Model để truyền dữ liệu đến JSP
     * @param redirectAttributes Để truyền thông báo lỗi
     * @return Tên view JSP hoặc redirect
     */
    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    @GetMapping
    public String showLessons(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @RequestParam(required = false) String lessonName,
            @RequestParam(required = false) Boolean status,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            SubjectResponseDTO subject = subjectService.getSubjectResponseById(subjectId);
            ChapterResponseDTO chapter = chapterService.getChapterResponseById(chapterId, subjectId);

            if (subject == null || chapter == null) {
                log.warn("Subject or Chapter not found: subjectId={}, chapterId={}", subjectId, chapterId);
                return "error/404";
            }

            List<LessonResponseDTO> lessons = lessonService.findLessonsByChapterId(chapterId, lessonName, status);
            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapter);
            model.addAttribute("lessons", lessons);
            return "admin/lesson/show";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/subject/" + subjectId + "/chapters";
        } catch (Exception e) {
            log.error("Error fetching lessons: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi lấy danh sách bài học");
            return "redirect:/admin/subject/" + subjectId + "/chapters";
        }
    }

    /**
     * Hiển thị form tạo hoặc chỉnh sửa bài học.
     *
     * @param subjectId ID của môn học
     * @param chapterId ID của chương
     * @param lessonId ID của bài học (tùy chọn, để chỉnh sửa)
     * @param model Model để truyền dữ liệu đến JSP
     * @param redirectAttributes Để truyền thông báo lỗi
     * @return Tên view JSP hoặc redirect
     */
    @GetMapping("/save")
    public String showSaveLessonForm(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @RequestParam(required = false) Long lessonId,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Subject subject = subjectService.getSubjectById(subjectId).orElse(null);
            Chapter chapter = chapterService.getChapterById(chapterId).orElse(null);

            if (subject == null || chapter == null || !chapter.getSubject().getSubjectId().equals(subjectId)) {
                log.warn("Invalid subject or chapter: subjectId={}, chapterId={}", subjectId, chapterId);
                return "error/404";
            }

            Lesson lesson = lessonId != null ? lessonService.getLessonById(lessonId).orElse(null) : new Lesson();
            if (lessonId != null && lesson == null) {
                log.warn("Lesson not found: lessonId={}", lessonId);
                redirectAttributes.addFlashAttribute("errorMessage", "Bài học không tồn tại");
                return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
            }

            // Parse materialsJson to materialsTemp if editing
            List<String> materialsTemp = new ArrayList<>();
            if (lessonId != null && lesson.getMaterialsJson() != null && !lesson.getMaterialsJson().isEmpty()) {
                try {
                    materialsTemp = objectMapper.readValue(lesson.getMaterialsJson(), new TypeReference<>() {});
                } catch (Exception e) {
                    log.warn("Failed to parse materialsJson for lessonId={}: {}", lessonId, e.getMessage());
                }
            }

            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapter);
            model.addAttribute("lesson", lesson);
            model.addAttribute("materialsTemp", materialsTemp);
            model.addAttribute("isEdit", lessonId != null);
            return "admin/lesson/save";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (Exception e) {
            log.error("Error showing lesson form: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi hiển thị form bài học");
            return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

    /**
     * Xử lý lưu hoặc cập nhật bài học.
     *
     * @param subjectId ID của môn học
     * @param chapterId ID của chương
     * @param lesson Entity chứa thông tin bài học
     * @param bindingResult Kết quả validation
     * @param materialFiles Các file tài liệu upload
     * @param materialsTemp Danh sách tài liệu tạm (tùy chọn)
     * @param redirectAttributes Để truyền thông báo
     * @param model Model để truyền dữ liệu đến JSP
     * @return Redirect hoặc tên view JSP
     */
    @PostMapping("/save")
    public String handleSaveLesson(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @Valid @ModelAttribute("lesson") Lesson lesson,
            BindingResult bindingResult,
            @RequestParam MultipartFile[] materialFiles,
            @RequestParam(required = false) List<String> materialsTemp,
            RedirectAttributes redirectAttributes,
            Model model) {
        Subject subject = subjectService.getSubjectById(subjectId).orElse(null);
        Chapter chapter = chapterService.getChapterById(chapterId).orElse(null);

        if (subject == null || chapter == null || !chapter.getSubject().getSubjectId().equals(subjectId)) {
            log.warn("Invalid subject or chapter: subjectId={}, chapterId={}", subjectId, chapterId);
            return "error/404";
        }

        List<String> materials = materialsTemp != null ? new ArrayList<>(materialsTemp) : new ArrayList<>();

        if (bindingResult.hasErrors()) {
            return prepareSaveForm(subject, chapter, lesson, materials, model);
        }

        try {
            // Validate video URL và lấy duration
            String videoId = youTubeApiClient.extractVideoId(lesson.getVideoSrc());
            if (videoId == null) {
                bindingResult.rejectValue("videoSrc", "error.lesson", "Đường dẫn video không hợp lệ");
                return prepareSaveForm(subject, chapter, lesson, materials, model);
            }

            String videoTime = youTubeApiClient.getVideoDuration(videoId);
            if (videoTime == null) {
                bindingResult.rejectValue("videoSrc", "error.lesson", "Không thể lấy thời lượng video");
                return prepareSaveForm(subject, chapter, lesson, materials, model);
            }

            // Xử lý file upload
            List<String> uploadedFiles = fileUploadService.handleSaveUploadFiles(materialFiles, "taiLieu");
            if (materialFiles.length > 0 && uploadedFiles.isEmpty()) {
                bindingResult.reject("error.lesson", "Không thể tải lên tài liệu. Vui lòng kiểm tra định dạng file (PDF, DOC, DOCX).");
                return prepareSaveForm(subject, chapter, lesson, materials, model);
            }
            materials.addAll(uploadedFiles);

            lesson.setVideoTime(videoTime);
            lesson.setMaterialsJson(objectMapper.writeValueAsString(materials));
            lesson.setChapter(chapter);

            lessonService.saveLesson(lesson);
            redirectAttributes.addFlashAttribute("message", "Lưu bài học thành công");
            return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (ApplicationException e) {
            String field = e instanceof DuplicateNameException ? "lessonName" : null;
            bindingResult.rejectValue(field, "error.lesson", e.getMessage());
            return prepareSaveForm(subject, chapter, lesson, materials, model);
        } catch (Exception e) {
            log.error("Error saving lesson: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi lưu bài học");
            return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

    /**
     * Cập nhật trạng thái của các bài học.
     *
     * @param subjectId ID của môn học
     * @param chapterId ID của chương
     * @param lessonIds Danh sách ID bài học
     * @param redirectAttributes Để truyền thông báo
     * @return Redirect
     */
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/update-status")
    public String updateLessonsStatus(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @RequestParam List<Long> lessonIds,
            RedirectAttributes redirectAttributes) {
        try {
            SubjectResponseDTO subject = subjectService.getSubjectResponseById(subjectId);
            ChapterResponseDTO chapter = chapterService.getChapterResponseById(chapterId, subjectId);

            if (subject == null || chapter == null) {
                log.warn("Subject or Chapter not found: subjectId={}, chapterId={}", subjectId, chapterId);
                return "error/404";
            }

            lessonService.toggleLessonsStatus(lessonIds);
            redirectAttributes.addFlashAttribute("message", "Cập nhật trạng thái thành công");
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            log.error("Error updating lesson status: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái");
        }
        return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
    }

    private String prepareSaveForm(Subject subject, Chapter chapter, Lesson lesson, List<String> materials, Model model) {
        model.addAttribute("subject", subject);
        model.addAttribute("chapter", chapter);
        model.addAttribute("lesson", lesson);
        model.addAttribute("materialsTemp", materials);
        model.addAttribute("isEdit", lesson.getLessonId() != null);
        return "admin/lesson/save";
    }
}