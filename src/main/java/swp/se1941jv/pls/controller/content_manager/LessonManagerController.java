package swp.se1941jv.pls.controller.content_manager;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.SubjectResponseDTO;
import swp.se1941jv.pls.dto.response.UserResponseDTO;
import swp.se1941jv.pls.service.ChapterService;
import swp.se1941jv.pls.service.LessonService;
import swp.se1941jv.pls.service.SubjectService;
import swp.se1941jv.pls.service.UserService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/admin/lessons")
@RequiredArgsConstructor
public class LessonManagerController {

    private final LessonService lessonService;
    private final SubjectService subjectService;
    private final UserService userService;
    private final ChapterService chapterService;

    /**
     * Render JSP ban đầu cho quản lý bài học.
     */
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping
    public String showLessons(
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId,
            @RequestParam(value = "lessonStatus", required = false) String lessonStatus,
            @RequestParam(value = "status", required = false) Boolean status,
            @RequestParam(value = "startDate", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(value = "endDate", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(value = "userCreated", required = false) Long userCreated,
            @RequestParam(value = "page", defaultValue = "0") int page,
            Model model) {
        try {
            // Lấy danh sách môn học
            List<SubjectResponseDTO> subjects = subjectService.findAllSubjects().stream()
                    .map(subject -> SubjectResponseDTO.builder()
                            .subjectId(subject.getSubjectId())
                            .subjectName(subject.getSubjectName())
                            .build())
                    .toList();

            // Lấy danh sách người dùng CONTENT_MANAGER
            List<UserResponseDTO> contentManagers = userService.findContentManagers().stream()
                    .map(user -> UserResponseDTO.builder()
                            .userId(user.getUserId())
                            .fullName(user.getFullName())
                            .build())
                    .toList();

            // Lấy danh sách bài học với bộ lọc và sắp xếp theo updatedAt
            Page<LessonResponseDTO> lessons = lessonService.findLessonsByFilters(
                    subjectId, chapterId, lessonStatus, status, startDate, endDate, userCreated, page, 20, Sort.by(Sort.Direction.DESC, "updatedAt"));

            model.addAttribute("subjects", subjects);
            model.addAttribute("contentManagers", contentManagers);
            model.addAttribute("lessons", lessons.getContent());
            model.addAttribute("currentPage", page);
            model.addAttribute("totalPages", lessons.getTotalPages());
            model.addAttribute("totalItems", lessons.getTotalElements());
            model.addAttribute("subjectId", subjectId);
            model.addAttribute("chapterId", chapterId);
            model.addAttribute("lessonStatus", lessonStatus);
            model.addAttribute("status", status);
            model.addAttribute("startDate", startDate);
            model.addAttribute("endDate", endDate);
            model.addAttribute("userCreated", userCreated);

            return "content-manager/lesson/show";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "content-manager/lesson/show";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Lỗi khi tải trang quản lý bài học");
            return "content-manager/lesson/show";
        }
    }

    /**
     * Xử lý cập nhật trạng thái bài học và redirect về endpoint GET /admin/lessons với trạng thái bộ lọc.
     */
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/{lessonId}/update-status")
    public String updateLessonStatus(
            @PathVariable Long lessonId,
            @RequestParam("newStatus") String newStatus,
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId,
            @RequestParam(value = "lessonStatus", required = false) String lessonStatus,
            @RequestParam(value = "status", required = false) Boolean status,
            @RequestParam(value = "startDate", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDateTime startDate,
            @RequestParam(value = "endDate", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDateTime endDate,
            @RequestParam(value = "userCreated", required = false) Long userCreated,
            @RequestParam(value = "page", required = false) Integer page,
            RedirectAttributes redirectAttributes) {
        try {
            switch (newStatus.toUpperCase()) {
                case "APPROVED":
                    lessonService.approveLesson(lessonId);
                    redirectAttributes.addFlashAttribute("successMessage", "Phê duyệt bài học thành công");
                    break;
                case "REJECTED":
                    lessonService.rejectLesson(lessonId);
                    redirectAttributes.addFlashAttribute("successMessage", "Từ chối bài học thành công");
                    break;
                default:
                    throw new IllegalArgumentException("Trạng thái không hợp lệ: " + newStatus);
            }

            // Xây dựng query string từ các tham số filter
            String queryString = buildQueryString(subjectId, chapterId, lessonStatus, status, startDate, endDate, userCreated, page);

            // Redirect về endpoint GET /admin/lessons với trạng thái bộ lọc
            return "redirect:/admin/lessons" + (queryString.isEmpty() ? "" : "?" + queryString);
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            String queryString = buildQueryString(subjectId, chapterId, lessonStatus, status, startDate, endDate, userCreated, page);
            return "redirect:/admin/lessons" + (queryString.isEmpty() ? "" : "?" + queryString);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái bài học");
            String queryString = buildQueryString(subjectId, chapterId, lessonStatus, status, startDate, endDate, userCreated, page);
            return "redirect:/admin/lessons" + (queryString.isEmpty() ? "" : "?" + queryString);
        }
    }

    /**
     * Xem chi tiết một bài học.
     */
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/{lessonId}/detail")
    public String showLessonDetail(@PathVariable Long lessonId, Model model) {
        try {
            // Lấy thông tin chi tiết bài học đầy đủ từ service
            LessonResponseDTO lesson = lessonService.getFullLessonResponseById(lessonId);
            if (lesson == null) {
                throw new IllegalArgumentException("Không tìm thấy bài học với ID: " + lessonId);
            }

            model.addAttribute("lesson", lesson);
            return "content-manager/lesson/detail";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/lessons";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Lỗi khi tải chi tiết bài học");
            return "redirect:/admin/lessons";
        }
    }

    /**
     * Xây dựng query string từ các tham số filter.
     */
    private String buildQueryString(Long subjectId, Long chapterId, String lessonStatus, Boolean status, LocalDateTime startDate, LocalDateTime endDate, Long userCreated, Integer page) {
        List<String> params = new ArrayList<>();
        if (subjectId != null) params.add("subjectId=" + subjectId);
        if (chapterId != null) params.add("chapterId=" + chapterId);
        if (lessonStatus != null && !lessonStatus.isEmpty()) params.add("lessonStatus=" + lessonStatus);
        if (status != null) params.add("status=" + status);
        if (startDate != null) params.add("startDate=" + startDate.toLocalDate());
        if (endDate != null) params.add("endDate=" + endDate.toLocalDate());
        if (userCreated != null) params.add("userCreated=" + userCreated);
        if (page != null) params.add("page=" + page);

        return String.join("&", params);
    }
}