//package swp.se1941jv.pls.controller.content_manager;
//
//import lombok.RequiredArgsConstructor;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.data.domain.Page;
//import org.springframework.format.annotation.DateTimeFormat;
//import org.springframework.security.access.prepost.PreAuthorize;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.servlet.mvc.support.RedirectAttributes;
//import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
//import swp.se1941jv.pls.dto.response.LessonResponseDTO;
//import swp.se1941jv.pls.dto.response.SubjectResponseDTO;
//import swp.se1941jv.pls.dto.response.UserResponseDTO;
//import swp.se1941jv.pls.service.ChapterService;
//import swp.se1941jv.pls.service.LessonService;
//import swp.se1941jv.pls.service.SubjectService;
//import swp.se1941jv.pls.service.UserService;
//
//import java.time.LocalDateTime;
//import java.util.List;
//
//@Slf4j
//@Controller
//@RequestMapping("/admin/chapters")
//@RequiredArgsConstructor
//public class ChapterManagerController {
//
//    private final ChapterService chapterService;
//    private final SubjectService subjectService;
//    private final UserService userService;
//    private final LessonService lessonService;
//
//    /**
//     * Render JSP ban đầu cho quản lý chương.
//     */
//    @PreAuthorize("hasRole('ADMIN')")
//    @GetMapping
//    public String showChapters(
//            @RequestParam(value = "subjectId", required = false) Long subjectId,
//            @RequestParam(value = "chapterStatus", required = false) String chapterStatus,
//            @RequestParam(value = "status", required = false) Boolean status,
//            @RequestParam(value = "startDate", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDateTime startDate,
//            @RequestParam(value = "endDate", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDateTime endDate,
//            @RequestParam(value = "userCreated", required = false) Long userCreated,
//            @RequestParam(value = "page", defaultValue = "0") int page,
//            Model model) {
//        try {
//            // Lấy danh sách môn học
//            List<SubjectResponseDTO> subjects = subjectService.findAllSubjects().stream()
//                    .map(subject -> SubjectResponseDTO.builder()
//                            .subjectId(subject.getSubjectId())
//                            .subjectName(subject.getSubjectName())
//                            .build())
//                    .toList();
//
//            // Lấy danh sách người dùng CONTENT_MANAGER
//            List<UserResponseDTO> contentManagers = userService.findContentManagers().stream()
//                    .map(user -> UserResponseDTO.builder()
//                            .userId(user.getUserId())
//                            .fullName(user.getFullName())
//                            .build())
//                    .toList();
//
//            // Lấy danh sách chương với bộ lọc
//            Page<ChapterResponseDTO> chapters = chapterService.findChaptersByChapterStatus(
//                    subjectId, chapterStatus, status, startDate, endDate, userCreated, page, 20);
//
//            model.addAttribute("subjects", subjects);
//            model.addAttribute("contentManagers", contentManagers);
//            model.addAttribute("chapters", chapters.getContent());
//            model.addAttribute("currentPage", page);
//            model.addAttribute("totalPages", chapters.getTotalPages());
//            model.addAttribute("totalItems", chapters.getTotalElements());
//            model.addAttribute("subjectId", subjectId);
//            model.addAttribute("chapterStatus", chapterStatus);
//            model.addAttribute("status", status);
//            model.addAttribute("startDate", startDate);
//            model.addAttribute("endDate", endDate);
//            model.addAttribute("userCreated", userCreated);
//
//            return "content-manager/chapter/show";
//        } catch (IllegalArgumentException e) {
//            log.error("Error fetching initial chapters: {}", e.getMessage(), e);
//            model.addAttribute("errorMessage", e.getMessage());
//            return "content-manager/chapter/show";
//        } catch (Exception e) {
//            log.error("Unexpected error: {}", e.getMessage(), e);
//            model.addAttribute("errorMessage", "Lỗi khi tải trang quản lý chương");
//            return "content-manager/chapter/show";
//        }
//    }
//
//    /**
//     * Xử lý cập nhật trạng thái chương và redirect về JSP.
//     */
//    @PreAuthorize("hasRole('ADMIN')")
//    @PostMapping("/{chapterId}/update-status")
//    public String updateChapterStatus(
//            @PathVariable Long chapterId,
//            @RequestParam("newStatus") String newStatus,
//            RedirectAttributes redirectAttributes) {
//        try {
//            switch (newStatus.toUpperCase()) {
//                case "APPROVED":
//                    chapterService.approveChapter(chapterId);
//                    redirectAttributes.addFlashAttribute("successMessage", "Phê duyệt chương thành công");
//                    break;
//                case "REJECTED":
//                    chapterService.rejectChapter(chapterId);
//                    redirectAttributes.addFlashAttribute("successMessage", "Từ chối chương thành công");
//                    break;
//                default:
//                    throw new IllegalArgumentException("Trạng thái không hợp lệ: " + newStatus);
//            }
//            return "redirect:/admin/chapters";
//        } catch (IllegalArgumentException e) {
//            log.error("Error updating chapter status: {}", e.getMessage(), e);
//            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
//            return "redirect:/admin/chapters";
//        } catch (Exception e) {
//            log.error("Unexpected error: {}", e.getMessage(), e);
//            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật trạng thái chương");
//            return "redirect:/admin/chapters";
//        }
//    }
//
//    /**
//     * Xem chi tiết một chapter.
//     */
//    @PreAuthorize("hasRole('ADMIN')")
//    @GetMapping("/{chapterId}/detail")
//    public String showChapterDetail(@PathVariable Long chapterId, Model model) {
//        try {
//            // Lấy thông tin chi tiết chapter dưới dạng DTO từ ChapterService
//            ChapterResponseDTO chapterResponse = chapterService.getChapterResponseByChapterId(chapterId);
//            if (chapterResponse == null) {
//                throw new IllegalArgumentException("Không tìm thấy chương với ID: " + chapterId);
//            }
//            // Lấy danh sách bài học có trạng thái APPROVED
//            List<LessonResponseDTO> lessons = lessonService.getApprovedLessonsByChapterId(chapterId);
//
//            model.addAttribute("chapter", chapterResponse);
//            model.addAttribute("lessons", lessons);
//            return "content-manager/chapter/detail";
//        } catch (IllegalArgumentException e) {
//            log.error("Error fetching chapter detail: {}", e.getMessage(), e);
//            model.addAttribute("errorMessage", e.getMessage());
//            return "redirect:/admin/chapters";
//        } catch (Exception e) {
//            log.error("Unexpected error: {}", e.getMessage(), e);
//            model.addAttribute("errorMessage", "Lỗi khi tải chi tiết chương");
//            return "redirect:/admin/chapters";
//        }
//    }
//}