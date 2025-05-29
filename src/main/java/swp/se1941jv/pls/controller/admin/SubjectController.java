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
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Subject;
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

    private static final String ADMIN_LAYOUT_VIEW = "admin/subject/show";
    private static final String SUBJECT_IMAGE_TARGET_FOLDER = "subjectImg";

    public SubjectController(SubjectService subjectService, GradeService gradeService, UploadService uploadService) {
        this.subjectService = subjectService;
        this.gradeService = gradeService;
        this.uploadService = uploadService;
    }

    private void addGradesToModelForFilter(Model model) {
        List<Grade> grades = gradeService.getAllGrades();
        model.addAttribute("gradesForFilter", grades);
    }

    private void addActiveGradesToModelForForm(Model model) {
        List<Grade> activeGrades = gradeService.getActiveGrades();
        model.addAttribute("grades", activeGrades);
    }

    private void populateFormModel(Model model, String pageTitle, Subject subject) {
        addActiveGradesToModelForForm(model);
        model.addAttribute("subject", subject);
        model.addAttribute("pageTitle", pageTitle);
        model.addAttribute("viewName", "form_content");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
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
        Sort.Direction direction = sortDir.equalsIgnoreCase(Sort.Direction.ASC.name()) ? Sort.Direction.ASC
                : Sort.Direction.DESC;
        Sort sortOrder = Sort.by(direction, sortField);
        Pageable pageable = PageRequest.of(page, size, sortOrder);
        Page<Subject> subjectPage = subjectService.getAllSubjects(filterName, filterGradeId, pageable);

        model.addAttribute("subjectPage", subjectPage);
        model.addAttribute("subjects", subjectPage.getContent());
        model.addAttribute("viewName", "list_content");
        model.addAttribute("filterName", filterName);
        model.addAttribute("filterGradeId", filterGradeId);
        addGradesToModelForFilter(model); // Grades cho filter dropdown
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("sortField", sortField);
        model.addAttribute("sortDir", sortDir);
        model.addAttribute("reverseSortDir", sortDir.equals("asc") ? "desc" : "asc");
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
        model.addAttribute("customDateFormatter", formatter);
        model.addAttribute("subjectImageFolder", SUBJECT_IMAGE_TARGET_FOLDER);
        return ADMIN_LAYOUT_VIEW;
    }

    @GetMapping("/new")
    public String showCreateSubjectForm(Model model) {
        populateFormModel(model, "Create New Subject", new Subject());
        return ADMIN_LAYOUT_VIEW;
    }

    @PostMapping("/save")
    public String saveOrUpdateSubject(@Valid @ModelAttribute("subject") Subject subject,
            BindingResult result,
            @RequestParam("imageFile") MultipartFile imageFile,
            RedirectAttributes redirectAttributes,
            Model model) {
        String pageTitle = subject.getSubjectId() == null ? "Create New Subject" : "Edit Subject";

        if (subject.getGrade() != null && subject.getGrade().getGradeId() != null) {
            Optional<Grade> selectedGradeOpt = gradeService.getGradeById(subject.getGrade().getGradeId());
            if (selectedGradeOpt.isPresent()) {
                if (!selectedGradeOpt.get().isActive()) {
                    result.addError(new FieldError("subject", "grade",
                            subject.getGrade().getGradeId(),
                            false,
                            new String[] { "NotActive.subject.grade" },
                            null,
                            "Selected Grade is not active. Please choose an active Grade."));
                }
            } else {
                result.addError(new FieldError("subject", "grade",
                        subject.getGrade().getGradeId(),
                        false, new String[] { "NonExistent.subject.grade" }, null,
                        "Selected Grade does not exist."));
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
            subjectService.saveSubject(subject);
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
    public String showEditSubjectForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Subject> subjectOptional = subjectService.getSubjectById(id);
        if (subjectOptional.isPresent()) {
            Subject subjectToEdit = subjectOptional.get();
            populateFormModel(model, "Edit Subject", subjectToEdit);
            return ADMIN_LAYOUT_VIEW;
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "subject.message.notFound");
            return "redirect:/admin/subject";
        }
    }

    @GetMapping("/delete/{id}")
    public String deleteSubject(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        Optional<Subject> subjectOpt = subjectService.getSubjectById(id);
        if (subjectOpt.isPresent()) {
            String imageName = subjectOpt.get().getSubjectImage();
            if (imageName != null && !imageName.isEmpty()) {
                boolean deleted = uploadService.deleteUploadedFile(imageName, SUBJECT_IMAGE_TARGET_FOLDER);
                if (!deleted) {
                    logger.warn("Could not delete image file {} for subject ID {} during delete operation.", imageName,
                            id);
                    redirectAttributes.addFlashAttribute("warningMessage", "subject.message.warn.imageNotDeleted");
                }
            }
        }

        try {
            subjectService.deleteSubjectById(id);
            redirectAttributes.addFlashAttribute("successMessage", "subject.message.deleted.success");
        } catch (Exception e) {
            logger.error("Error deleting subject ID {}: {}", id, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "subject.message.error.delete");
        }
        return "redirect:/admin/subject";
    }
}