package swp.se1941jv.pls.controller.admin;

import jakarta.validation.Valid; // Sử dụng jakarta.validation cho Spring Boot 3+
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import swp.se1941jv.pls.entity.Grade; // Import Grade entity của bạn
import swp.se1941jv.pls.entity.Subject; // Import Subject entity của bạn
import swp.se1941jv.pls.service.GradeService; // Import GradeService của bạn
import swp.se1941jv.pls.service.SubjectService;
import jakarta.servlet.http.HttpServletRequest; // Import SubjectService của bạn

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/subject")
public class SubjectController {

    private final SubjectService subjectService;
    private final GradeService gradeService;

    // Tên file layout chung
    private static final String ADMIN_LAYOUT_VIEW = "admin/subject/show"; // File show.jsp của bạn

    public SubjectController(SubjectService subjectService, GradeService gradeService) {
        this.subjectService = subjectService;
        this.gradeService = gradeService;
    }

    private void addGradesToModel(Model model) {
        List<Grade> grades = gradeService.getAllGrades();
        model.addAttribute("grades", grades);
    }

    // 1. View list subjects
    @GetMapping
    public String listSubjects(Model model) {
        model.addAttribute("subjects", subjectService.getAllSubjects());
        model.addAttribute("pageTitle", "Manage Subjects");
        model.addAttribute("viewName", "list_content"); // Tên file nội dung

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm");
        model.addAttribute("customDateFormatter", formatter);
        return ADMIN_LAYOUT_VIEW; // Trả về layout chung
    }

    // 2. Show form to create new subject
    @GetMapping("/new")
    public String showCreateSubjectForm(Model model) {
        model.addAttribute("subject", new Subject());
        addGradesToModel(model);
        model.addAttribute("pageTitle", "Create New Subject");
        model.addAttribute("viewName", "form_content"); // Tên file nội dung
        return ADMIN_LAYOUT_VIEW; // Trả về layout chung
    }

    // 3. Handle submission for creating or updating subject
    @PostMapping("/save")
    public String saveOrUpdateSubject(@Valid @ModelAttribute("subject") Subject subject,
            BindingResult result,
            @RequestParam("imageFile") MultipartFile imageFile,
            RedirectAttributes redirectAttributes,
            Model model) {

        if (result.hasErrors()) {
            addGradesToModel(model);
            model.addAttribute("pageTitle", subject.getSubjectId() == null ? "Create New Subject" : "Edit Subject");
            if (subject.getSubjectId() != null) { // Chỉ khi edit
                subjectService.getSubjectById(subject.getSubjectId())
                        .ifPresent(existingSubject -> model.addAttribute("currentSubjectImage",
                                existingSubject.getSubjectImage()));
            }
            model.addAttribute("viewName", "form_content");
            return ADMIN_LAYOUT_VIEW; // Quay lại layout với form và lỗi
        }

        try {
            subjectService.saveSubject(subject, imageFile);
            redirectAttributes.addFlashAttribute("successMessage", "Subject saved successfully!");
            return "redirect:/admin/subject"; // Redirect về trang danh sách
        } catch (IOException e) {
            addGradesToModel(model);
            model.addAttribute("pageTitle", subject.getSubjectId() == null ? "Create New Subject" : "Edit Subject");
            model.addAttribute("errorMessageGlobal", "Could not save image file: " + e.getMessage());
            if (subject.getSubjectId() != null) {
                subjectService.getSubjectById(subject.getSubjectId())
                        .ifPresent(existingSubject -> model.addAttribute("currentSubjectImage",
                                existingSubject.getSubjectImage()));
            }
            model.addAttribute("viewName", "form_content");
            return ADMIN_LAYOUT_VIEW;
        } catch (Exception e) {
            addGradesToModel(model);
            model.addAttribute("pageTitle", subject.getSubjectId() == null ? "Create New Subject" : "Edit Subject");
            model.addAttribute("errorMessageGlobal", "Error saving subject: " + e.getMessage());
            if (subject.getSubjectId() != null) {
                subjectService.getSubjectById(subject.getSubjectId())
                        .ifPresent(existingSubject -> model.addAttribute("currentSubjectImage",
                                existingSubject.getSubjectImage()));
            }
            model.addAttribute("viewName", "form_content");
            return ADMIN_LAYOUT_VIEW;
        }
    }

    // 4. Show form to edit an existing subject
    @GetMapping("/edit/{id}")
    public String showEditSubjectForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Subject> subjectOptional = subjectService.getSubjectById(id);
        if (subjectOptional.isPresent()) {
            model.addAttribute("subject", subjectOptional.get());
            addGradesToModel(model);
            model.addAttribute("pageTitle", "Edit Subject");
            model.addAttribute("viewName", "form_content");
            return ADMIN_LAYOUT_VIEW;
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Subject not found with ID: " + id);
            return "redirect:/admin/subject";
        }
    }

    // 5. Handle delete subject - Vẫn redirect như cũ
    @GetMapping("/delete/{id}")
    public String deleteSubject(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            subjectService.deleteSubjectById(id);
            redirectAttributes.addFlashAttribute("successMessage", "Subject deleted successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Error deleting subject. It might be in use or an unexpected error occurred.");
        }
        return "redirect:/admin/subject";
    }
}