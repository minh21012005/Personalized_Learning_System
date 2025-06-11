package swp.se1941jv.pls.controller.admin;

import com.fasterxml.jackson.core.type.TypeReference;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.exception.lesson.DuplicateLessonNameException;
import swp.se1941jv.pls.exception.lesson.LessonNotFoundException;
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
        List<Lesson> lessons = lessonService.findLessonsByChapterId(chapterId);
        model.addAttribute("subject", subject.get());
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

    /**
     * Xử lý lưu hoặc cập nhật bài học.
     *
     * @param subjectId         ID của môn học
     * @param chapterId         ID của chương
     * @param lesson            Bài học cần lưu
     * @param bindingResult     Kết quả validation
     * @param materialFiles     Các file tài liệu được tải lên
     * @param materialsTemp     Danh sách tên file tài liệu hiện có
     * @param redirectAttributes Để truyền thông báo
     * @param model             Model để truyền dữ liệu đến JSP
     * @return Redirect hoặc tên view JSP
     */
    @PostMapping("/save")
    public String handleSaveLesson(
            @PathVariable("subjectId") Long subjectId,
            @PathVariable("chapterId") Long chapterId,
            @Valid @ModelAttribute("lesson") Lesson lesson,
            BindingResult bindingResult,
            @RequestParam("materialFiles") MultipartFile[] materialFiles,
            @RequestParam(value = "materialsTemp", required = false) List<String> materialsTemp,
            RedirectAttributes redirectAttributes,
            Model model) {
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        Chapter chapter = chapterService.findChapterById(chapterId).orElse(null);
        if (subject.isEmpty() || chapter == null) {
            return "error/404";
        }

        // Kiểm tra nếu chapter không thuộc về subject
        if (!chapter.getSubject().getSubjectId().equals(subjectId)) {
            return "error/404";
        }

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
        lesson.setChapter(chapter);

        try {
            lessonService.saveLesson(lesson);
            redirectAttributes.addFlashAttribute("message", "Lưu bài học thành công");
        } catch (DuplicateLessonNameException e) {
            model.addAttribute("lesson", lesson);
            model.addAttribute("chapter", chapter);
            model.addAttribute("subject", subject);
            model.addAttribute("isEdit", lesson.getLessonId() != null);
            model.addAttribute("materialsTemp", materialsTemp);
            bindingResult.rejectValue("lessonName", "error.lesson", e.getMessage());
            return "admin/lesson/save";
        } catch (LessonNotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi lưu bài học");
        }
        return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
    }


    /**
     * Cập nhật trạng thái của các bài học.
     *
     * @param subjectId         ID của môn học
     * @param chapterId         ID của chương
     * @param lessonIds         Danh sách ID của các bài học
     * @param redirectAttributes Để truyền thông báo
     * @return Redirect
     */
    @PostMapping("/update-status")
    public String updateLessonsStatus(
            @PathVariable("subjectId") Long subjectId,
            @PathVariable("chapterId") Long chapterId,
            @RequestParam("lessonIds") List<Long> lessonIds,
            RedirectAttributes redirectAttributes) {
        Optional<Subject> subject = subjectService.getSubjectById(subjectId);
        Chapter chapter = chapterService.findChapterById(chapterId).orElse(null);
        if (subject.isEmpty() || chapter == null) {
            return "error/404";
        }

        try {
            lessonService.toggleLessonsStatus(lessonIds);
            redirectAttributes.addFlashAttribute("message", "Cập nhật trạng thái thành công");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái");
        }
        return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
    }
}