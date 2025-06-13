package swp.se1941jv.pls.controller.admin;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
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

import jakarta.validation.Valid;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
@RequestMapping("/admin/subject/{subjectId}/chapters/{chapterId}/lessons")
public class LessonController {

    private final SubjectService subjectService;
    private final ChapterService chapterService;
    private final LessonService lessonService;
    private final FileUploadService fileUploadService;
    private final String YOUTUBE_API_KEY = "AIzaSyAa9qz9xeYVePrsXLVIJJuA3qAhW4YXwqY"; // Thay bằng API Key của bạn
    private final String YOUTUBE_API_URL = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id={videoId}&key={apiKey}";

    public LessonController(SubjectService subjectService, ChapterService chapterService, LessonService lessonService, FileUploadService fileUploadService) {
        this.subjectService = subjectService;
        this.chapterService = chapterService;
        this.lessonService = lessonService;
        this.fileUploadService = fileUploadService;
    }

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

        if (!chapter.getSubject().getSubjectId().equals(subjectId)) {
            return "error/404";
        }

        if (materialsTemp == null) {
            materialsTemp = new ArrayList<>();
        }

        // Trích xuất VIDEO_ID từ videoSrc
        String videoId = extractVideoId(lesson.getVideoSrc());
        if (videoId == null) {
            model.addAttribute("lesson", lesson);
            model.addAttribute("chapter", chapter);
            model.addAttribute("subject", subject);
            model.addAttribute("isEdit", lesson.getLessonId() != null);
            model.addAttribute("materialsTemp", materialsTemp);
            bindingResult.rejectValue("videoSrc", "error.lesson", "Đường dẫn video không hợp lệ");
            return "admin/lesson/save";
        }

        // Lấy thời lượng video từ YouTube API
        String videoTime = getVideoDuration(videoId);
        if (videoTime == null) {
            model.addAttribute("lesson", lesson);
            model.addAttribute("chapter", chapter);
            model.addAttribute("subject", subject);
            model.addAttribute("isEdit", lesson.getLessonId() != null);
            model.addAttribute("materialsTemp", materialsTemp);
            bindingResult.rejectValue("videoSrc", "error.lesson", "Không thể lấy thời lượng video. Video có thể là private hoặc không tồn tại.");
            return "admin/lesson/save";
        }

        // Lưu thời lượng vào videoTime
        lesson.setVideoTime(videoTime);

        // Xử lý file tải lên
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

    private String extractVideoId(String videoSrc) {
        if (videoSrc == null || videoSrc.isEmpty()) {
            return null;
        }
        // Regex để lấy VIDEO_ID từ youtube.com/embed/VIDEO_ID
        Pattern pattern = Pattern.compile("youtube\\.com/embed/([a-zA-Z0-9_-]{11})");
        Matcher matcher = pattern.matcher(videoSrc);
        return matcher.find() ? matcher.group(1) : null;
    }

    private String getVideoDuration(String videoId) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            String url = YOUTUBE_API_URL.replace("{videoId}", videoId).replace("{apiKey}", YOUTUBE_API_KEY);
            String response = restTemplate.getForObject(url, String.class);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode jsonNode = mapper.readTree(response);
            JsonNode items = jsonNode.get("items");

            if (items == null || items.size() == 0) {
                return null; // Video private, unlisted, hoặc không tồn tại
            }

            String duration = items.get(0).get("contentDetails").get("duration").asText();
            // Chuyển PT#H#M#S thành định dạng như "1 tiếng 30 phút 45 giây"
            Pattern pattern = Pattern.compile("PT(?:(\\d+)H)?(?:(\\d+)M)?(?:(\\d+)S)?");
            Matcher matcher = pattern.matcher(duration);
            if (matcher.matches()) {
                int hours = matcher.group(1) != null ? Integer.parseInt(matcher.group(1)) : 0;
                int minutes = matcher.group(2) != null ? Integer.parseInt(matcher.group(2)) : 0;
                int seconds = matcher.group(3) != null ? Integer.parseInt(matcher.group(3)) : 0;

                StringBuilder formattedDuration = new StringBuilder();
                if (hours > 0) {
                    formattedDuration.append(hours).append(" tiếng ");
                }
                if (minutes > 0 || hours > 0) { // Hiển thị phút nếu có giờ hoặc phút
                    formattedDuration.append(minutes).append(" phút ");
                }
                if (seconds > 0 || (hours == 0 && minutes == 0)) { // Hiển thị giây nếu có giây hoặc không có giờ/phút
                    formattedDuration.append(seconds).append(" giây");
                }
                return formattedDuration.toString().trim();
            }
            return null;
        } catch (Exception e) {
            return null; // Lỗi API hoặc network
        }
    }
}