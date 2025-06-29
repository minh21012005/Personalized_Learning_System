package swp.se1941jv.pls.controller.staff;

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
import java.util.Arrays;

@Slf4j
@Controller
@RequestMapping("/staff/subject/{subjectId}/chapters/{chapterId}/lessons")
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
            Subject subject = validateSubjectAndChapter(subjectId, chapterId);
            Chapter chapter = chapterService.getChapterById(chapterId).orElse(null);
            List<LessonResponseDTO> lessons = lessonService.findLessonsByChapterId(chapterId, lessonName, status);

            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapter);
            model.addAttribute("lessons", lessons);
            return "staff/lesson/show";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        } catch (Exception e) {
            log.error("Error fetching lessons: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi lấy danh sách bài học");
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        }
    }

    /**
     * Hiển thị form tạo bài học mới.
     */
    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    @GetMapping("/new")
    public String showCreateLessonForm(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Subject subject = validateSubjectAndChapter(subjectId, chapterId);
            Chapter chapter = chapterService.getChapterById(chapterId).orElse(null);

            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapter);
            model.addAttribute("lesson", new Lesson());
            model.addAttribute("materialsTemp", new ArrayList<String>());
            model.addAttribute("isEdit", false);
            return "staff/lesson/save";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (Exception e) {
            log.error("Error showing create lesson form: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi hiển thị form tạo bài học");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

    /**
     * Xử lý tạo bài học mới.
     */
    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    @PostMapping
    public String createLesson(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @Valid @ModelAttribute("lesson") Lesson lesson,
            BindingResult bindingResult,
            @RequestParam MultipartFile[] materialFiles,
            @RequestParam(required = false) List<String> materialsTemp,
            RedirectAttributes redirectAttributes,
            Model model) {
        return handleLessonSave(subjectId, chapterId, lesson, bindingResult, materialFiles, materialsTemp, redirectAttributes, model, false);
    }

    /**
     * Hiển thị form chỉnh sửa bài học.
     */
    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    @GetMapping("/{lessonId}/edit")
    public String showEditLessonForm(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @PathVariable Long lessonId,
            Model model,
            RedirectAttributes redirectAttributes) {
        try {
            Subject subject = validateSubjectAndChapter(subjectId, chapterId);
            Chapter chapter = chapterService.getChapterById(chapterId).orElse(null);
            Lesson lesson = lessonService.getLessonById(lessonId).orElse(null);

            if (lesson == null) {
                log.warn("Lesson not found: lessonId={}", lessonId);
                redirectAttributes.addFlashAttribute("errorMessage", "Bài học không tồn tại");
                return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
            }

            List<String> materialsTemp = parseMaterialsJson(lesson.getMaterialsJson());
            model.addAttribute("subject", subject);
            model.addAttribute("chapter", chapter);
            model.addAttribute("lesson", lesson);
            model.addAttribute("materialsTemp", materialsTemp);
            model.addAttribute("isEdit", true);
            return "staff/lesson/save";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (Exception e) {
            log.error("Error showing edit lesson form: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi hiển thị form chỉnh sửa bài học");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

    /**
     * Xử lý cập nhật bài học.
     */
    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    @PostMapping("/{lessonId}")
    public String updateLesson(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @PathVariable Long lessonId,
            @Valid @ModelAttribute("lesson") Lesson lesson,
            BindingResult bindingResult,
            @RequestParam MultipartFile[] materialFiles,
            @RequestParam(required = false) List<String> materialsTemp,
            RedirectAttributes redirectAttributes,
            Model model) {
        lesson.setLessonId(lessonId);
        return handleLessonSave(subjectId, chapterId, lesson, bindingResult, materialFiles, materialsTemp, redirectAttributes, model, true);
    }

    /**
     * Xử lý nộp bài học (chuyển trạng thái từ DRAFT sang PENDING).
     */
    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    @PostMapping("/{lessonId}/submit")
    public String submitLesson(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @PathVariable Long lessonId,
            RedirectAttributes redirectAttributes) {
        try {
            Subject subject = validateSubjectAndChapter(subjectId, chapterId);
            lessonService.submitLesson(lessonId);
            redirectAttributes.addFlashAttribute("message", "Nộp bài học thành công");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (Exception e) {
            log.error("Error submitting lesson: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi nộp bài học");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

    /**
     * Cập nhật trạng thái của các bài học.
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
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (ApplicationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (Exception e) {
            log.error("Error updating lesson status: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

    /**
     * Xử lý logic lưu bài học (tạo mới hoặc cập nhật).
     */
    private String handleLessonSave(
            Long subjectId,
            Long chapterId,
            Lesson lesson,
            BindingResult bindingResult,
            MultipartFile[] materialFiles,
            List<String> materialsTemp,
            RedirectAttributes redirectAttributes,
            Model model,
            boolean isEdit) {
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

            // Xử lý file upload, chỉ khi có file hợp lệ
            List<String> uploadedFiles = new ArrayList<>();
            if (materialFiles != null && materialFiles.length > 0) {
                // Lọc bỏ các file rỗng
                List<MultipartFile> validFiles = Arrays.stream(materialFiles)
                        .filter(file -> !file.isEmpty())
                        .toList();
                if (!validFiles.isEmpty()) {
                    uploadedFiles = fileUploadService.handleSaveUploadFiles(validFiles.toArray(new MultipartFile[0]), "taiLieu");
                    if (uploadedFiles.isEmpty()) {
                        bindingResult.reject("error.lesson", "Không thể tải lên tài liệu. Vui lòng kiểm tra định dạng file (PDF, DOC, DOCX).");
                        return prepareSaveForm(subject, chapter, lesson, materials, model);
                    }
                }
            }
            materials.addAll(uploadedFiles);

            lesson.setVideoTime(videoTime);
            lesson.setMaterialsJson(objectMapper.writeValueAsString(materials));
            lesson.setChapter(chapter);

            if (!isEdit) {
                lesson.setLessonStatus(Lesson.LessonStatus.DRAFT);
                if (lesson.getStatus() == null) {
                    lesson.setStatus(true); // Đảm bảo trạng thái mặc định
                }
            }

            if (isEdit) {
                lessonService.updateLesson(lesson);
            } else {
                lessonService.createLesson(lesson);
            }

            redirectAttributes.addFlashAttribute("message", isEdit ? "Cập nhật bài học thành công" : "Tạo bài học thành công");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (ApplicationException e) {
            String field = e instanceof DuplicateNameException ? "lessonName" : null;
            bindingResult.rejectValue(field, "error.lesson", e.getMessage());
            return prepareSaveForm(subject, chapter, lesson, materials, model);
        } catch (Exception e) {
            log.error("Error saving lesson: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi lưu bài học");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

    /**
     * Chuẩn bị dữ liệu cho form khi có lỗi.
     */
    private String prepareSaveForm(Subject subject, Chapter chapter, Lesson lesson, List<String> materials, Model model) {
        model.addAttribute("subject", subject);
        model.addAttribute("chapter", chapter);
        model.addAttribute("lesson", lesson);
        model.addAttribute("materialsTemp", materials);
        model.addAttribute("isEdit", lesson.getLessonId() != null);
        return "staff/lesson/save";
    }

    /**
     * Kiểm tra tính hợp lệ của subject và chapter.
     */
    private Subject validateSubjectAndChapter(Long subjectId, Long chapterId) {
        Subject subject = subjectService.getSubjectById(subjectId).orElse(null);
        Chapter chapter = chapterService.getChapterById(chapterId).orElse(null);
        if (subject == null || chapter == null || !chapter.getSubject().getSubjectId().equals(subjectId)) {
            throw new ApplicationException("ERROR","Môn học hoặc chương không hợp lệ");
        }
        return subject;
    }

    /**
     * Parse materialsJson thành List<String>.
     */
    private List<String> parseMaterialsJson(String materialsJson) {
        try {
            if (materialsJson != null && !materialsJson.isEmpty()) {
                return objectMapper.readValue(materialsJson, new TypeReference<List<String>>() {});
            }
        } catch (Exception e) {
            log.warn("Failed to parse materialsJson: {}", e.getMessage());
        }
        return new ArrayList<>();
    }
}