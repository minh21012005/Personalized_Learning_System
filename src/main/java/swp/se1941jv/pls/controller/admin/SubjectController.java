package swp.se1941jv.pls.controller.admin;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.dto.response.subject.*;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.repository.UserRepository;
import swp.se1941jv.pls.service.GradeService;
import swp.se1941jv.pls.service.SubjectService;
import swp.se1941jv.pls.service.UploadService;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/subject")
public class SubjectController {
    private static final Logger logger = LoggerFactory.getLogger(SubjectController.class);

    private final SubjectService subjectService;
    private final GradeService gradeService;
    private final UploadService uploadService;
    private final UserRepository userRepository;
    private static final String ADMIN_LAYOUT_VIEW = "admin/subject/show";
    private static final String SUBJECT_IMAGE_TARGET_FOLDER = "subjectImg";

    public SubjectController(SubjectService subjectService, GradeService gradeService, UploadService uploadService, UserRepository userRepository) {
        this.subjectService = subjectService;
        this.gradeService = gradeService;
        this.uploadService = uploadService;
        this.userRepository = userRepository;
    }

    private void addGradesToModelForFilter(Model model) {
        List<Grade> grades = gradeService.getAllGrades();
        model.addAttribute("gradesForFilter", grades);
    }

    private void addActiveGradesToModelForForm(Model model) {
        List<Grade> activeGrades = gradeService.getActiveGrades();
        model.addAttribute("grades", activeGrades);
    }

    private void populateFormModel(Model model, String pageTitle, SubjectFormDTO subject) {
        addActiveGradesToModelForForm(model);
        model.addAttribute("subject", subject);
        model.addAttribute("pageTitle", pageTitle);
        model.addAttribute("viewName", "form_content");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
        model.addAttribute("customDateFormatter", formatter);
        model.addAttribute("subjectImageFolder", SUBJECT_IMAGE_TARGET_FOLDER);
    }

    @GetMapping
    public String listSubjects(Model model,
                               @RequestParam(name = "filterName", required = false) String filterName,
                               @RequestParam(name = "filterGradeId", required = false) Long filterGradeId,
                               @RequestParam(name = "page", defaultValue = "0") int page,
                               @RequestParam(name = "size", defaultValue = "10") int size,
                               @RequestParam(name = "sortField", defaultValue = "createdAt") String sortField,
                               @RequestParam(name = "sortDir", defaultValue = "desc") String sortDir) {
        Sort.Direction direction = sortDir.equalsIgnoreCase(Sort.Direction.ASC.name()) ? Sort.Direction.ASC : Sort.Direction.DESC;
        Sort sortOrder = Sort.by(direction, sortField);
        Pageable pageable = PageRequest.of(page, size, sortOrder);
        Page<SubjectListDTO> subjectPage = subjectService.getAllSubjectsWithDTO(filterName, filterGradeId, pageable);

        model.addAttribute("subjectPage", subjectPage);
        model.addAttribute("subjects", subjectPage.getContent());
        model.addAttribute("viewName", "list_content");
        model.addAttribute("filterName", filterName);
        model.addAttribute("filterGradeId", filterGradeId);
        addGradesToModelForFilter(model);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("reverseSortDir", sortDir.equals("asc") ? "desc" : "asc");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
        model.addAttribute("customDateFormatter", formatter);
        model.addAttribute("subjectImageFolder", SUBJECT_IMAGE_TARGET_FOLDER);
        return ADMIN_LAYOUT_VIEW;
    }

    @GetMapping("/pending")
    public String listPendingSubjects(Model model,
                                      @RequestParam(name = "filterName", required = false) String filterName,
                                      @RequestParam(name = "submittedByName", required = false) String submittedByName,
                                      @RequestParam(name = "page", defaultValue = "0") int page,
                                      @RequestParam(name = "size", defaultValue = "10") int size,
                                      HttpSession session) {
        Long userId = (Long) session.getAttribute("id");
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại!"));
        if (!"CONTENT_MANAGER".equals(user.getRole().getRoleName())) {
            return "redirect:/admin/subject";
        }

        // Sử dụng Pageable mặc định, sắp xếp đã được xử lý trong query
        Pageable pageable = PageRequest.of(page, size);
        Page<SubjectListDTO> subjectPage = subjectService.getPendingSubjectsWithDTO(filterName, submittedByName, pageable);

        model.addAttribute("subjectPage", subjectPage);
        model.addAttribute("subjects", subjectPage.getContent());
        model.addAttribute("viewName", "pending_list");
        model.addAttribute("filterName", filterName);
        model.addAttribute("submittedByName", submittedByName);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
        model.addAttribute("customDateFormatter", formatter);
        model.addAttribute("subjectImageFolder", SUBJECT_IMAGE_TARGET_FOLDER);
        return "admin/subject/pendingList";
    }

    @GetMapping("/new")
    public String showCreateSubjectForm(Model model) {
        populateFormModel(model, "Tạo môn học mới", new SubjectFormDTO());
        return ADMIN_LAYOUT_VIEW;
    }

    @PostMapping("/save")
    public String saveOrUpdateSubject(@Valid @ModelAttribute("subject") SubjectFormDTO subject,
                                      BindingResult result,
                                      @RequestParam("imageFile") MultipartFile imageFile,
                                      RedirectAttributes redirectAttributes,
                                      HttpSession session,
                                      Model model) {
        String pageTitle = subject.getSubjectId() == null ? "Create New Subject" : "Edit Subject";

        if (subject.getGradeId() != null) {
            Optional<Grade> selectedGradeOpt = gradeService.getGradeById(subject.getGradeId());
            if (selectedGradeOpt.isPresent()) {
                if (!selectedGradeOpt.get().isActive()) {
                    result.addError(new FieldError("subject", "gradeId",
                            subject.getGradeId(),
                            false,
                            new String[] { "NotActive.subject.grade" },
                            null,
                            "Khối lớp được chọn không hoạt động. Vui lòng chọn khối lớp hoạt động."));
                }
            } else {
                result.addError(new FieldError("subject", "gradeId",
                        subject.getGradeId(),
                        false, new String[] { "NonExistent.subject.grade" }, null,
                        "Khối lớp được chọn không tồn tại."));
            }
        }

        if (result.hasErrors()) {
            populateFormModel(model, pageTitle, subject);
            if (subject.getSubjectId() != null) {
                subjectService.getSubjectById(subject.getSubjectId())
                        .ifPresent(existing -> model.addAttribute("currentSubjectImage", existing.getSubjectImage()));
            }
            return ADMIN_LAYOUT_VIEW;
        }

        String oldImageName = null;
        if (subject.getSubjectId() != null) {
            Optional<Subject> existingSubjectOpt = subjectService.getSubjectById(subject.getSubjectId());
            if (existingSubjectOpt.isPresent()) {
                oldImageName = existingSubjectOpt.get().getSubjectImage();
                if (subject.getSubjectImage() == null && imageFile.isEmpty() && oldImageName != null) {
                    subject.setSubjectImage(oldImageName);
                }
            }
        }

        if (imageFile != null && !imageFile.isEmpty()) {
            if (oldImageName != null && !oldImageName.isEmpty()) {
                uploadService.deleteUploadedFile(oldImageName, SUBJECT_IMAGE_TARGET_FOLDER);
            }
            String savedFileName = uploadService.handleSaveUploadFile(imageFile, SUBJECT_IMAGE_TARGET_FOLDER);
            if (savedFileName != null && !savedFileName.isEmpty()) {
                subject.setSubjectImage(savedFileName);
            } else {
                populateFormModel(model, pageTitle, subject);
                model.addAttribute("errorMessageGlobal",
                        "Could not save image file. The file might be empty, invalid, or an upload error occurred.");
                if (subject.getSubjectId() != null && oldImageName != null) {
                    subject.setSubjectImage(oldImageName);
                    model.addAttribute("currentSubjectImage", oldImageName);
                }
                return ADMIN_LAYOUT_VIEW;
            }
        }

        try {
            Long userId = (Long) session.getAttribute("id");
            subjectService.saveSubjectWithDTO(subject, userId);
            redirectAttributes.addFlashAttribute("successMessage", "subject.message.saved.success");
            return "redirect:/admin/subject";
        } catch (Exception e) {
            logger.error("Error saving subject (ID: {}): {}", subject.getSubjectId(), e.getMessage(), e);
            populateFormModel(model, pageTitle, subject);
            model.addAttribute("errorMessageGlobal", "subject.message.error.save");
            if (subject.getSubjectImage() != null) {
                model.addAttribute("currentSubjectImage", subject.getSubjectImage());
            }
            return ADMIN_LAYOUT_VIEW;
        }
    }

    @GetMapping("/edit/{id}")
    public String showEditSubjectForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
        try {
            Long userId = (Long) session.getAttribute("id");
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại!"));
            if (!"CONTENT_MANAGER".equals(user.getRole().getRoleName())) {
                redirectAttributes.addFlashAttribute("errorMessage", "Chỉ có Content Manager mới có thể chỉnh sửa môn học!");
                return "redirect:/admin/subject";
            }

            Optional<SubjectFormDTO> subjectOptional = subjectService.getSubjectFormDTOById(id);
            if (subjectOptional.isPresent()) {
                SubjectFormDTO subjectToEdit = subjectOptional.get();
                populateFormModel(model, "Sửa môn học", subjectToEdit);
                model.addAttribute("currentSubjectImage", subjectToEdit.getSubjectImage());
                // Thêm thông tin về SubjectAssignment nếu có
                Optional<SubjectAssignment> assignmentOpt = subjectService.getAssignmentBySubjectId(id);
                assignmentOpt.ifPresent(assignment -> model.addAttribute("assignedTo", assignment.getUser().getFullName()));
                return ADMIN_LAYOUT_VIEW;
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.notFound");
                return "redirect:/admin/subject";
            }
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/subject";
        }
    }

    @GetMapping("/revert/{id}")
    public String revertToDraft(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            subjectService.revertToDraftByContentManager(id, userId);
            redirectAttributes.addFlashAttribute("successMessage", "Môn học đã được chuyển trạng thái duyệt thành công");
            return "redirect:/admin/subject";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/subject";
        } catch (Exception e) {
            logger.error("Lỗi khi chuyển trạng thái môn học ID {} về DRAFT: {}", id, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi chuyển trạng thái duyệt của môn học");
            return "redirect:/admin/subject";
        }
    }

    @GetMapping("/delete/{id}")
    public String deleteSubject(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            Optional<Subject> subjectOpt = subjectService.getSubjectById(id);
            if (subjectOpt.isPresent()) {
                String imageName = subjectOpt.get().getSubjectImage();
                if (imageName != null && !imageName.isEmpty()) {
                    boolean deleted = uploadService.deleteUploadedFile(imageName, SUBJECT_IMAGE_TARGET_FOLDER);
                    if (!deleted) {
                        logger.warn("Không thể xóa file hình ảnh {} cho môn học ID {}.", imageName, id);
                        redirectAttributes.addFlashAttribute("warningMessage", "subject.message.warn.imageNotDeleted");
                    }
                }
            }

            subjectService.deleteSubjectByIdWithChecks(id, userId);
            redirectAttributes.addFlashAttribute("successMessage", "subject.message.deleted.success");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            logger.error("Lỗi khi xóa môn học ID {}: {}", id, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "subject.message.error.delete");
        }
        return "redirect:/admin/subject";
    }

    @GetMapping("/assign/{id}")
    public String showAssignSubjectForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<SubjectAssignDTO> subjectOptional = subjectService.getSubjectAssignDTOById(id);
        if (!subjectOptional.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "subject.message.notFound");
            return "redirect:/admin/subject";
        }

        SubjectAssignDTO subject = subjectOptional.get();
        Optional<SubjectStatusHistory> latestStatus = subjectService.getLatestSubjectStatus(id);
        if (latestStatus.isEmpty() || latestStatus.get().getStatus() != SubjectStatusHistory.SubjectStatus.DRAFT) {
            redirectAttributes.addFlashAttribute("errorMessage", "subject.message.notDraft");
            return "redirect:/admin/subject";
        }


        List<UserAssignDTO> staffs = subjectService.getStaffWithDTO();
        if (staffs.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "subject.message.noContentCreators");
            return "redirect:/admin/subject";
        }

        model.addAttribute("subject", subject);
        model.addAttribute("contentCreators", staffs);
        model.addAttribute("assignment", new SubjectAssignment());
        model.addAttribute("pageTitle", "Giao môn học");
        model.addAttribute("viewName", "assign_content");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
        model.addAttribute("customDateFormatter", formatter);
        return ADMIN_LAYOUT_VIEW;
    }

    @PostMapping("/assign")
    public String assignSubject(@RequestParam("subjectId") Long subjectId,
                                @RequestParam("userId") Long userId,
                                @RequestParam(value = "assignmentFeedback", required = false) String assignmentFeedback,
                                RedirectAttributes redirectAttributes,
                                HttpSession session) {
        try {
            Long contentManagerId = (Long) session.getAttribute("id");
            subjectService.assignSubject(subjectId, userId, contentManagerId, assignmentFeedback);
            redirectAttributes.addFlashAttribute("successMessage", "subject.message.assigned.success");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            logger.error("Lỗi khi giao môn học ID {} cho user ID {}: {}", subjectId, userId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "subject.message.error.assign");
        }
        return "redirect:/admin/subject";
    }

    @GetMapping("/review/{id}")
    public String showReviewSubjectForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<SubjectReviewDTO> subjectOptional = subjectService.getSubjectReviewDTOById(id);
        if (!subjectOptional.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Môn học không tồn tại!");
            return "redirect:/admin/subject";
        }

        SubjectReviewDTO subject = subjectOptional.get();
        if (!"PENDING".equals(subject.getStatus())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Môn học không ở trạng thái PENDING!");
            return "redirect:/admin/subject";
        }

        model.addAttribute("subject", subject);
        model.addAttribute("pageTitle", "Duyệt môn học");
        model.addAttribute("viewName", "review_content");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
        model.addAttribute("customDateFormatter", formatter);
        return ADMIN_LAYOUT_VIEW;
    }

    @PostMapping("/review")
    public String reviewSubject(@RequestParam("subjectId") Long subjectId,
                                @RequestParam("status") String status,
                                @RequestParam(value = "feedback", required = false) String feedback,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        try {
            Long reviewerId = (Long) session.getAttribute("id");
            subjectService.reviewSubject(subjectId, status, feedback, reviewerId);
            redirectAttributes.addFlashAttribute("successMessage", "Duyệt môn học thành công!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            logger.error("Lỗi khi duyệt môn học ID {}: {}", subjectId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi duyệt môn học!");
        }
        return "redirect:/admin/subject/pending";
    }

    @GetMapping("/{subjectId}/detail")
    public String showSubjectDetail(@PathVariable("subjectId") Long subjectId, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<SubjectDetailDTO> subjectDetailOpt = subjectService.getSubjectDetailDTOById(subjectId);
            if (subjectDetailOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "subject.message.notFound");
                return "redirect:/admin/subject";
            }

            model.addAttribute("subjectDetail", subjectDetailOpt.get());
            model.addAttribute("viewName", "subject_detail");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
            model.addAttribute("customDateFormatter", formatter);
            model.addAttribute("subjectImageFolder", SUBJECT_IMAGE_TARGET_FOLDER);
            return ADMIN_LAYOUT_VIEW;
        } catch (Exception e) {
            logger.error("Lỗi khi lấy chi tiết môn học ID {}: {}", subjectId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "subject.message.error.detail");
            return "redirect:/admin/subject";
        }
    }

    @GetMapping("/{subjectId}/chapters/{chapterId}/detail")
    public String showChapterDetail(@PathVariable("subjectId") Long subjectId, @PathVariable("chapterId") Long chapterId, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<ChapterDetailDTO> chapterDetailOpt = subjectService.getChapterDetailDTOById(chapterId, subjectId);
            if (chapterDetailOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "chapter.message.notFound");
                return "redirect:/admin/subject/" + subjectId + "/detail";
            }

            model.addAttribute("subjectId", subjectId);
            model.addAttribute("chapterDetail", chapterDetailOpt.get());
            model.addAttribute("viewName", "chapter_detail");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
            model.addAttribute("customDateFormatter", formatter);
            return ADMIN_LAYOUT_VIEW;
        }catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "lesson.message.error.detail");
            return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/detail";
        }catch (Exception e) {
            logger.error("Lỗi khi lấy chi tiết chương ID {}: {}", chapterId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "chapter.message.error.detail");
            return "redirect:/admin/subject/" + subjectId + "/detail";
        }
    }

    @GetMapping("/{subjectId}/chapters/{chapterId}/lessons/{lessonId}/detail")
    public String showLessonDetail(@PathVariable("subjectId") Long subjectId, @PathVariable("chapterId") Long chapterId, @PathVariable("lessonId") Long lessonId, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<LessonDetailDTO> lessonDetailOpt = subjectService.getLessonDetailDTOById(lessonId, chapterId, subjectId);
            if (lessonDetailOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "lesson.message.notFound");
                return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/detail";
            }

            model.addAttribute("subjectId", subjectId);
            model.addAttribute("chapterId", chapterId);
            model.addAttribute("lessonDetail", lessonDetailOpt.get());
            model.addAttribute("viewName", "lesson_detail");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm dd-MM-yyyy");
            model.addAttribute("customDateFormatter", formatter);
            return ADMIN_LAYOUT_VIEW;
        }catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "lesson.message.error.detail");
            return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/detail";
        }
        catch (Exception e) {
            logger.error("Lỗi khi lấy chi tiết bài học ID {}: {}", lessonId, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "lesson.message.error.detail");
            return "redirect:/admin/subject/" + subjectId + "/chapters/" + chapterId + "/detail";
        }
    }

    @GetMapping("/publish/{id}")
    public String publishSubject(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("id");
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new IllegalArgumentException("Người dùng không tồn tại!"));
            if (!"CONTENT_MANAGER".equals(user.getRole().getRoleName())) {
                redirectAttributes.addFlashAttribute("errorMessage", "Chỉ có Content Manager mới có thể xuất bản môn học!");
                return "redirect:/admin/subject";
            }
            subjectService.publishSubject(id);
            redirectAttributes.addFlashAttribute("successMessage", "subject.message.published.success");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            logger.error("Lỗi khi xuất bản môn học ID {}: {}", id, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "subject.message.error.publish");
        }
        return "redirect:/admin/subject";
    }
}