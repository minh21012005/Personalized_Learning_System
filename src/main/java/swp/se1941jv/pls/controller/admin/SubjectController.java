package swp.se1941jv.pls.controller.admin;

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
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.GradeService;
import swp.se1941jv.pls.service.SubjectService;
import swp.se1941jv.pls.service.UploadService; // Import UploadService gốc của bạn

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

    private static final String ADMIN_LAYOUT_VIEW = "admin/subject/show";
    // Đặt tên thư mục con chính xác bạn đã tạo trong webapp/resources/img/
    private static final String SUBJECT_IMAGE_TARGET_FOLDER = "subjectImg";

    public SubjectController(SubjectService subjectService, GradeService gradeService, UploadService uploadService) {
        this.subjectService = subjectService;
        this.gradeService = gradeService;
        this.uploadService = uploadService;
    }

    private void addGradesToModel(Model model) {
        List<Grade> grades = gradeService.getAllGrades();
        model.addAttribute("grades", grades);
    }

    // Helper method để thêm các attribute chung cho form view
    private void addCommonAttributesForForm(Model model, String pageTitle, Subject subject) {
        addGradesToModel(model);
        model.addAttribute("subject", subject);
        model.addAttribute("pageTitle", pageTitle);
        model.addAttribute("viewName", "form_content");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
        model.addAttribute("customDateFormatter", formatter);
        model.addAttribute("subjectImageFolder", SUBJECT_IMAGE_TARGET_FOLDER); // Truyền tên thư mục ảnh
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
        Page<Subject> subjectPage = subjectService.getAllSubjects(filterName, filterGradeId, pageable);

        model.addAttribute("subjectPage", subjectPage);
        model.addAttribute("subjects", subjectPage.getContent());
        model.addAttribute("viewName", "list_content");
        model.addAttribute("filterName", filterName);
        model.addAttribute("filterGradeId", filterGradeId);
        addGradesToModel(model); // Cho dropdown filter
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("reverseSortDir", sortDir.equals("asc") ? "desc" : "asc");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
        model.addAttribute("customDateFormatter", formatter);
        model.addAttribute("subjectImageFolder", SUBJECT_IMAGE_TARGET_FOLDER); // Cho list_content.jsp
        return ADMIN_LAYOUT_VIEW;
    }

    @GetMapping("/new")
    public String showCreateSubjectForm(Model model) {
        addCommonAttributesForForm(model, "Create New Subject", new Subject());
        return ADMIN_LAYOUT_VIEW;
    }

    @PostMapping("/save")
    public String saveOrUpdateSubject(@Valid @ModelAttribute("subject") Subject subject,
                                      BindingResult result,
                                      @RequestParam("imageFile") MultipartFile imageFile,
                                      RedirectAttributes redirectAttributes,
                                      Model model) {
        String pageTitle = subject.getSubjectId() == null ? "Create New Subject" : "Edit Subject";

        if (result.hasErrors()) {
            addCommonAttributesForForm(model, pageTitle, subject);
            if (subject.getSubjectId() != null) {
                 subjectService.getSubjectById(subject.getSubjectId())
                    .ifPresent(existing -> model.addAttribute("currentSubjectImage", existing.getSubjectImage()));
            }
            return ADMIN_LAYOUT_VIEW;
        }

        String oldImageName = null;
        if (subject.getSubjectId() != null) { // Edit mode
            Optional<Subject> existingSubjectOpt = subjectService.getSubjectById(subject.getSubjectId());
            if (existingSubjectOpt.isPresent()) {
                oldImageName = existingSubjectOpt.get().getSubjectImage();
                // Nếu subjectImage từ form rỗng khi edit VÀ không có file mới được upload,
                // thì giữ lại tên ảnh cũ cho đối tượng subject.
                // Thẻ input ẩn cho subjectImage trong form có thể không được gửi nếu giá trị là null/empty.
                if (subject.getSubjectImage() == null && imageFile.isEmpty() && oldImageName != null) {
                    subject.setSubjectImage(oldImageName);
                }
            }
        }

        if (imageFile != null && !imageFile.isEmpty()) {
            // Có file mới được upload
            if (oldImageName != null && !oldImageName.isEmpty()) {
                // Xóa ảnh cũ trước khi lưu ảnh mới
                // Đảm bảo UploadService của bạn có phương thức deleteUploadedFile
                boolean deleted = uploadService.deleteUploadedFile(oldImageName, SUBJECT_IMAGE_TARGET_FOLDER);
                if (!deleted) {
                    logger.warn("Could not delete old image: {} in folder: {}. Continuing with new image upload.", oldImageName, SUBJECT_IMAGE_TARGET_FOLDER);
                }
            }
            String savedFileName = uploadService.handleSaveUploadFile(imageFile, SUBJECT_IMAGE_TARGET_FOLDER);
            if (savedFileName != null && !savedFileName.isEmpty()) {
                subject.setSubjectImage(savedFileName); // Gán tên file mới đã lưu
            } else {
                // Upload thất bại (UploadService trả về rỗng)
                addCommonAttributesForForm(model, pageTitle, subject);
                model.addAttribute("errorMessageGlobal", "Could not save image file. The file might be empty, invalid, or an upload error occurred.");
                // Giữ lại ảnh cũ trên form nếu đang edit và upload mới thất bại
                if (subject.getSubjectId() != null && oldImageName != null) {
                    subject.setSubjectImage(oldImageName); // Đặt lại ảnh cũ cho đối tượng subject
                    model.addAttribute("currentSubjectImage", oldImageName); // Và cho view để hiển thị
                }
                return ADMIN_LAYOUT_VIEW;
            }
        }
        // Nếu không có file mới khi edit, subject.subjectImage đã được gán là oldImageName ở trên (nếu nó null ban đầu).
        // Nếu tạo mới và không có file, subject.subjectImage sẽ là null.

        try {
            subjectService.saveSubject(subject); // Service chỉ nhận Subject
            redirectAttributes.addFlashAttribute("successMessage", "Subject saved successfully!");
            return "redirect:/admin/subject"; // Chuyển hướng về danh sách sau khi lưu
        } catch (Exception e) {
            logger.error("Error saving subject (ID: {}): {}", subject.getSubjectId(), e.getMessage(), e);
            addCommonAttributesForForm(model, pageTitle, subject);
            model.addAttribute("errorMessageGlobal", "Error saving subject: " + e.getMessage());
            // Hiển thị lại ảnh đang gắn với đối tượng subject (có thể là mới upload hoặc cũ)
            if (subject.getSubjectImage() != null) {
                 model.addAttribute("currentSubjectImage", subject.getSubjectImage());
            }
            return ADMIN_LAYOUT_VIEW;
        }
    }

    @GetMapping("/edit/{id}")
    public String showEditSubjectForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Subject> subjectOptional = subjectService.getSubjectById(id);
        if (subjectOptional.isPresent()) {
            Subject subjectToEdit = subjectOptional.get();
            addCommonAttributesForForm(model, "Edit Subject", subjectToEdit);
            // Không cần add currentSubjectImage ở đây nữa vì addCommonAttributesForForm
            // sẽ truyền subject object, và form_content.jsp sẽ dùng subject.subjectImage
            return ADMIN_LAYOUT_VIEW;
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Subject not found with ID: " + id);
            return "redirect:/admin/subject";
        }
    }

    @GetMapping("/delete/{id}")
    public String deleteSubject(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        Optional<Subject> subjectOpt = subjectService.getSubjectById(id);
        if (subjectOpt.isPresent()) {
            String imageName = subjectOpt.get().getSubjectImage();
            if (imageName != null && !imageName.isEmpty()) {
                // Đảm bảo UploadService của bạn có phương thức deleteUploadedFile
                boolean deleted = uploadService.deleteUploadedFile(imageName, SUBJECT_IMAGE_TARGET_FOLDER);
                if (!deleted) {
                    logger.warn("Could not delete image file {} for subject ID {} during delete operation.", imageName, id);
                    redirectAttributes.addFlashAttribute("warningMessage", "Subject data deleted, but its image might not have been removed from the server.");
                }
            }
        }

        try {
            subjectService.deleteSubjectById(id);
            redirectAttributes.addFlashAttribute("successMessage", "Subject deleted successfully!");
        } catch (Exception e) {
            logger.error("Error deleting subject ID {}: {}", id, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Error deleting subject. It might be in use or an unexpected error occurred.");
        }
        return "redirect:/admin/subject";
    }
}