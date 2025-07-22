package swp.se1941jv.pls.controller.staff;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.dto.response.lesson.LessonFormDTO;
import swp.se1941jv.pls.dto.response.lesson.LessonListDTO;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.LessonMaterial;
import swp.se1941jv.pls.service.FileUploadService;
import swp.se1941jv.pls.service.LessonService;
import swp.se1941jv.pls.util.YouTubeApiClient;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Controller
@RequestMapping("/staff/subject/{subjectId}/chapters/{chapterId}/lessons")
@RequiredArgsConstructor
public class LessonController {

    private final LessonService lessonService;
    private final FileUploadService fileUploadService;
    private final YouTubeApiClient youTubeApiClient;

    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    @GetMapping
    public String showLessons(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @RequestParam(required = false) String lessonName,
            @RequestParam(required = false) Boolean status,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortField,
            @RequestParam(defaultValue = "desc") String sortDir,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục!");
                return "redirect:/staff/subject/" + subjectId + "/chapters";
            }

            String adjustedSortField = "createdAt";
            if ("lessonId".equals(sortField)) adjustedSortField = "lessonId";
            else if ("lessonName".equals(sortField)) adjustedSortField = "lessonName";

            Sort.Direction direction = sortDir.equalsIgnoreCase("asc") ? Sort.Direction.ASC : Sort.Direction.DESC;
            Page<LessonListDTO> lessonPage = lessonService.findLessonsByChapterId(chapterId, lessonName, status, userId, PageRequest.of(page, size, Sort.by(direction, adjustedSortField)));

            model.addAttribute("subjectId", subjectId);
            model.addAttribute("chapterId", chapterId);
            model.addAttribute("lessonPage", lessonPage);
            model.addAttribute("lessons", lessonPage.getContent());
            model.addAttribute("lessonName", lessonName);
            model.addAttribute("status", status);
            model.addAttribute("currentPage", page);
            model.addAttribute("pageSize", size);
            model.addAttribute("sortField", sortField);
            model.addAttribute("sortDir", sortDir);
            model.addAttribute("reverseSortDir", sortDir.equals("asc") ? "desc" : "asc");
            return "staff/lesson/show";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        } catch (Exception e) {
            log.error("Error fetching lessons: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi tải danh sách bài học!");
            return "redirect:/staff/subject/" + subjectId + "/chapters";
        }
    }

    @PreAuthorize("hasAnyRole('STAFF')")
    @GetMapping("/new")
    public String showCreateLessonForm(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục!");
                return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
            }

            lessonService.validateStaffAccess(chapterId,userId);

            LessonFormDTO lessonForm = new LessonFormDTO();
            lessonForm.setChapterId(chapterId);

            model.addAttribute("subjectId", subjectId);
            model.addAttribute("chapterId", chapterId);
            model.addAttribute("lesson", lessonForm);
            model.addAttribute("isEdit", false);
            return "staff/lesson/save";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (Exception e) {
            log.error("Error showing lesson form: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi hiển thị form tạo bài học!");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

    @PreAuthorize("hasAnyRole('STAFF')")
    @GetMapping("/{lessonId}/edit")
    public String showEditLessonForm(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @PathVariable Long lessonId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.loginRequired");
                return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
            }

            lessonService.validateStaffAccess(chapterId,userId);

            Lesson lesson = lessonService.getLessonById(lessonId)
                    .orElseThrow(() -> new IllegalArgumentException("lesson.message.notFound"));

            LessonFormDTO lessonForm = new LessonFormDTO();
            lessonForm.setLessonId(lessonId);
            lessonForm.setLessonName(lesson.getLessonName());
            lessonForm.setLessonDescription(lesson.getLessonDescription());
            lessonForm.setVideoSrc(lesson.getVideoSrc());
            lessonForm.setVideoTime(lesson.getVideoTime());
            lessonForm.setVideoTitle(lesson.getVideoTitle());
            lessonForm.setThumbnailUrl(lesson.getThumbnailUrl());
            lessonForm.setChapterId(chapterId);
            lessonForm.setLessonMaterials(lesson.getLessonMaterials().stream()
                    .map(material -> {
                        LessonFormDTO.LessonMaterialDTO materialDTO = new LessonFormDTO.LessonMaterialDTO();
                        materialDTO.setFileName(material.getFileName());
                        materialDTO.setFilePath(material.getFilePath());
                        return materialDTO;
                    }).collect(Collectors.toList()));

            model.addAttribute("subjectId", subjectId);
            model.addAttribute("chapterId", chapterId);
            model.addAttribute("lesson", lessonForm);
            model.addAttribute("isEdit", true);
            return "staff/lesson/save";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (Exception e) {
            log.error("Error showing lesson form: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "lesson.message.error.form");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    @PostMapping
    public String createLesson(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @Valid @ModelAttribute("lesson") LessonFormDTO lessonForm,
            BindingResult bindingResult,
            @RequestParam(value = "materialFiles", required = false) MultipartFile[] materialFiles,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            Model model) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.loginRequired");
                return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
            }

            if (materialFiles != null && materialFiles.length > 0) {
                if (materialFiles.length > 5) {
                    bindingResult.rejectValue("lessonMaterials", "error.maxFiles", "Tối đa 5 tệp tài liệu được phép!");
                }
                for (MultipartFile file : materialFiles) {
                    if (file != null && !file.isEmpty()) {
                        if (file.getSize() > 50 * 1024 * 1024) {
                            bindingResult.rejectValue("lessonMaterials", "error.fileSize", "Tệp không được vượt quá 50MB!");
                        }
                        String contentType = file.getContentType();
                        if (contentType == null || !Arrays.asList("application/pdf", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document").contains(contentType)) {
                            bindingResult.rejectValue("lessonMaterials", "error.fileType", "Chỉ hỗ trợ PDF hoặc Word!");
                        }
                    }
                }
            }

            if (bindingResult.hasErrors()) {
                model.addAttribute("subjectId", subjectId);
                model.addAttribute("chapterId", chapterId);
                model.addAttribute("isEdit", false);
                return "staff/lesson/save";
            }

            // Xử lý materialFiles và gán vào lessonForm.lessonMaterials
            if (materialFiles != null && materialFiles.length > 0) {
                List<LessonFormDTO.LessonMaterialDTO> materialDTOs = fileUploadService.handleSaveUploadFiles(materialFiles, "materials");
                lessonForm.setLessonMaterials(materialDTOs);
            }

            // Validate YouTube embed URL and get additional details
            String videoId = youTubeApiClient.extractVideoId(lessonForm.getVideoSrc());
            if (videoId == null) {
                bindingResult.rejectValue("videoSrc", "error.lesson", "Link video YouTube không hợp lệ");
                model.addAttribute("subjectId", subjectId);
                model.addAttribute("chapterId", chapterId);
                model.addAttribute("isEdit", false);
                return "staff/lesson/save";
            }
            try {
                lessonForm.setVideoTime(youTubeApiClient.getVideoDuration(videoId));
                lessonForm.setVideoTitle(youTubeApiClient.getVideoTitle(videoId));
                lessonForm.setThumbnailUrl(youTubeApiClient.getThumbnailUrl(videoId));
            } catch (Exception e) {
                lessonForm.setVideoTime("N/A");
                lessonForm.setVideoTitle("Unknown");
                lessonForm.setThumbnailUrl("");
            }

            lessonForm.setChapterId(chapterId);
            lessonService.createLesson(lessonForm, userId);
            redirectAttributes.addFlashAttribute("message", "Tạo bài học thành công!");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("subjectId", subjectId);
            model.addAttribute("chapterId", chapterId);
            model.addAttribute("isEdit", false);
            return "staff/lesson/save";
        } catch (Exception e) {
            log.error("Error creating lesson for chapterId={}, userId={}: {}", chapterId, session.getAttribute("id"), e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi tạo bài học!");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    @PostMapping("/{lessonId}")
    public String updateLesson(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @PathVariable Long lessonId,
            @Valid @ModelAttribute("lesson") LessonFormDTO lessonForm,
            BindingResult bindingResult,
            @RequestParam(value = "materialFiles", required = false) MultipartFile[] materialFiles,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            Model model) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.loginRequired");
                return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
            }

            if (materialFiles != null && materialFiles.length > 0) {
                if (materialFiles.length > 5) {
                    bindingResult.rejectValue("lessonMaterials", "error.maxFiles", "Tối đa 5 tệp tài liệu được phép!");
                }
                for (MultipartFile file : materialFiles) {
                    if (file != null && !file.isEmpty()) {
                        if (file.getSize() > 50 * 1024 * 1024) {
                            bindingResult.rejectValue("lessonMaterials", "error.fileSize", "Tệp không được vượt quá 50MB!");
                        }
                        String contentType = file.getContentType();
                        if (contentType == null || !Arrays.asList("application/pdf", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document").contains(contentType)) {
                            bindingResult.rejectValue("lessonMaterials", "error.fileType", "Chỉ hỗ trợ PDF hoặc Word!");
                        }
                    }
                }
            }

            if (bindingResult.hasErrors()) {
                model.addAttribute("subjectId", subjectId);
                model.addAttribute("chapterId", chapterId);
                model.addAttribute("isEdit", true);
                return "staff/lesson/save";
            }

            // Validate YouTube embed URL and get additional details
            String videoId = youTubeApiClient.extractVideoId(lessonForm.getVideoSrc());
            if (videoId == null) {
                bindingResult.rejectValue("videoSrc", "error.lesson", "Link video YouTube không hợp lệ");
                model.addAttribute("subjectId", subjectId);
                model.addAttribute("chapterId", chapterId);
                model.addAttribute("isEdit", true);
                return "staff/lesson/save";
            }
            try {
                lessonForm.setVideoTime(youTubeApiClient.getVideoDuration(videoId));
                lessonForm.setVideoTitle(youTubeApiClient.getVideoTitle(videoId));
                lessonForm.setThumbnailUrl(youTubeApiClient.getThumbnailUrl(videoId));
            } catch (Exception e) {
                log.warn("YouTube API failed for videoId {}: {}", videoId, e.getMessage());
                lessonForm.setVideoTime("N/A");
                lessonForm.setVideoTitle("Unknown");
                lessonForm.setThumbnailUrl("");
            }

            lessonForm.setLessonId(lessonId);
            lessonForm.setChapterId(chapterId);
            lessonService.updateLesson(lessonForm, userId, materialFiles);

            redirectAttributes.addFlashAttribute("message", "Cập nhật bài học thành công!");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("subjectId", subjectId);
            model.addAttribute("chapterId", chapterId);
            model.addAttribute("isEdit", true);
            return "staff/lesson/save";
        } catch (Exception e) {
            log.error("Error updating lesson for lessonId={}, userId={}: {}", lessonId, session.getAttribute("id"), e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật bài học!");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

//    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
//    @PostMapping("/{lessonId}/delete")
//    public String deleteLesson(
//            @PathVariable Long subjectId,
//            @PathVariable Long chapterId,
//            @PathVariable Long lessonId,
//            HttpSession session,
//            RedirectAttributes redirectAttributes) {
//        try {
//            Long userId = (Long) session.getAttribute("id");
//            if (userId == null) {
//                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.loginRequired");
//                return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
//            }
//            lessonService.deleteLesson(lessonId, userId);
//            redirectAttributes.addFlashAttribute("message", "Xóa bài học thành công!");
//            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
//        } catch (IllegalArgumentException e) {
//            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
//            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
//        } catch (Exception e) {
//            log.error("Error deleting lesson for lessonId={}, userId={}: {}", lessonId, session.getAttribute("id"), e.getMessage(), e);
//            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi xóa bài học!");
//            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
//        }
//    }

    @PreAuthorize("hasAnyRole('STAFF','ADMIN')")
    @GetMapping("/{lessonId}")
    public String showLessonDetail(
            @PathVariable Long subjectId,
            @PathVariable Long chapterId,
            @PathVariable Long lessonId,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục!");
                return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
            }

            Lesson lesson = lessonService.getLessonById(lessonId)
                    .orElseThrow(() -> new IllegalArgumentException("Bài học không tồn tại!"));

            LessonListDTO lessonDTO = lessonService.toLessonListDTO(lesson);

            model.addAttribute("subjectId", subjectId);
            model.addAttribute("chapterId", chapterId);
            model.addAttribute("lesson", lessonDTO);
            return "staff/lesson/detail";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        } catch (Exception e) {
            log.error("Error showing lesson detail for lessonId={}: {}", lessonId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi hiển thị chi tiết bài học!");
            return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
        }
    }

    @PostMapping("/{lessonId}/toggle-hidden")
    public String toggleLessonHidden(@PathVariable("subjectId") Long subjectId,
                                     @PathVariable("chapterId") Long chapterId,
                                     @PathVariable("lessonId") Long lessonId,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            lessonService.toggleLessonHiddenStatus(lessonId, userId);
            redirectAttributes.addFlashAttribute("successMessage", "Trạng thái ẩn của bài học đã được cập nhật!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi thay đổi trạng thái ẩn của bài học!");
        }
        return "redirect:/staff/subject/" + subjectId + "/chapters/" + chapterId + "/lessons";
    }

}