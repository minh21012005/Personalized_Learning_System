package swp.se1941jv.pls.controller.admin;

import com.fasterxml.jackson.core.type.TypeReference;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.FileUploadService;
import swp.se1941jv.pls.service.LessonService;
import swp.se1941jv.pls.service.SubjectService;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.validation.Valid;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/subject/{subjectId}/chapters/{chapterId}/lessons")
public class LessonController {

    private final SubjectService subjectService;
    private final ChapterService chapterService;
    private final LessonService lessonService;
    private final FileUploadService fileUploadService;

    public LessonController(SubjectService subjectService, ChapterService chapterService, LessonService lessonService, FileUploadService fileUploadService) {
        this.subjectService = subjectService;
        this.chapterService = chapterService;
        this.lessonService = lessonService;
        this.fileUploadService = fileUploadService;
    }

    /**
     * Hiển thị trang danh sách bài học của một chương.
     *
     * @param subjectId ID của môn học
     * @param chapterId ID của chương
     * @param model     Model để truyền dữ liệu đến JSP
     * @return Tên view JSP hoặc redirect
     */
    @GetMapping
    public String showLessons(
            @PathVariable("subjectId") Long subjectId,
            @PathVariable("chapterId") Long chapterId,
            Model model) {
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        Chapter chapter = chapterService.findChapterById(chapterId).orElse(null);
        if (subject.isEmpty() || chapter == null) {
            return "error/404";
        }
        List<Lesson> lessons = lessonService.findLessons(chapterId);
        model.addAttribute("subject", subject);
        model.addAttribute("chapter", chapter);
        model.addAttribute("lessons", lessons);
        return "admin/lesson/show";
    }

    /**
     * Hiển thị form tạo hoặc cập nhật bài học.
     *
     * @param subjectId ID của môn học
     * @param chapterId ID của chương
     * @param lessonId  ID của bài học (tùy chọn, để chỉnh sửa)
     * @param model     Model để truyền dữ liệu đến JSP
     * @param redirectAttributes Để truyền thông báo lỗi
     * @return Tên view JSP hoặc redirect
     */
    @GetMapping("/save")
    public String showSaveLessonForm(
            @PathVariable("subjectId") Long subjectId,
            @PathVariable("chapterId") Long chapterId,
            @RequestParam(value = "lessonId", required = false) Long lessonId,
            Model model,
            RedirectAttributes redirectAttributes) {
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        Chapter chapter = chapterService.findChapterById(chapterId).orElse(null);
        if (subject.isEmpty() || chapter == null) {
            return "error/404";
        }

        // Kiểm tra nếu chapter không thuộc về subject
        if (!chapter.getSubject().getSubjectId().equals(subjectId)) {
            return "error/404";
        }

        Lesson lesson = (lessonId != null) ? lessonService.findLessonById(lessonId)
                .orElse(null) : new Lesson();
        if (lessonId != null && lesson == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Bài học không tồn tại");
            return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }

        // Kiểm tra nếu chapter có tồn tại và không thuộc về chapter
        if (!lesson.getChapter().getChapterId().equals(chapterId)) {
            return "error/404";
        }


        List<String> materialsTemp = new ArrayList<>();
        ObjectMapper mapper = new ObjectMapper();
        try {
            if (lesson.getMaterialsJson() != null && !lesson.getMaterialsJson().isEmpty()) {
                materialsTemp = mapper.readValue(lesson.getMaterialsJson(), new TypeReference<List<String>>() {});
            }
        } catch (Exception e) {
            materialsTemp = new ArrayList<>();
        }
        model.addAttribute("subject", subject);
        model.addAttribute("chapter", chapter);
        model.addAttribute("lesson", lesson);
        model.addAttribute("materialsTemp", materialsTemp);
        model.addAttribute("isEdit", lessonId != null);
        return "admin/lesson/save";
    }

    @PostMapping("/admin/subject/{subjectId}/chapters/{chapterId}/lessons/save")
    public String saveLesson(
            @PathVariable("subjectId") Long subjectId,
            @PathVariable("chapterId") Long chapterId,
            @ModelAttribute("lesson") @Valid Lesson lesson,
            BindingResult result,
            @RequestParam("materialFiles") MultipartFile[] materialFiles,
            @RequestParam(value = "materialsTemp", required = false) List<String> materialsTemp,
            RedirectAttributes redirectAttributes,
            Model model) {
        // Kiểm tra subject và chapter
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        Optional<Chapter> chapter = chapterService.findChapterById(chapterId);

        if (subject.isEmpty() || chapter.isEmpty()) {
            return "error/404";
        }

        // Nếu có lỗi validation, trả về form
        if (result.hasErrors()) {
            model.addAttribute("subject", subject.get());
            model.addAttribute("chapter", chapter.get());
            model.addAttribute("lesson", lesson);
            return "admin/lesson/save";
        }

        lesson.setChapter(chapter.get());

        // Khởi tạo danh sách materialsTemp nếu null
        if (materialsTemp == null) {
            materialsTemp = new ArrayList<>();
        }

        // Xử lý file tải lên bằng FileUploadService
        List<String> savedFileNames = fileUploadService.handleSaveUploadFiles(materialFiles, "taiLieu");
        materialsTemp.addAll(savedFileNames);

        // Serialize materialsTemp to materialsJson
        ObjectMapper mapper = new ObjectMapper();
        try {
            lesson.setMaterialsJson(mapper.writeValueAsString(materialsTemp));
        } catch (Exception e) {
            lesson.setMaterialsJson("[]");
        }

        // Lưu bài học
        lessonService.saveLesson(lesson);

        redirectAttributes.addFlashAttribute("successMessage", "Lưu bài học thành công!");
        return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
    }

    @PostMapping("admin/subject/{subjectId}/chapters/{chapterId}/lessons/update-status")
    public String updateLessonStatus(
            @PathVariable("subjectId") Long subjectId,
            @PathVariable("chapterId") Long chapterId,
            @RequestParam("lessonIds") List<Long> lessonIds,
            RedirectAttributes redirectAttributes
    ) {
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        Optional<Chapter> chapter = chapterService.findChapterById(chapterId);
        if (subject.isEmpty() || chapter.isEmpty()) {
            return "error/404";
        }
        try {
            lessonService.updateLessonsStatus(lessonIds);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái bài học thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
        }

        return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
    }
}