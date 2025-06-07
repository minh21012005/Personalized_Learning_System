package swp.se1941jv.pls.controller.admin;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.validation.Valid;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.SubjectService;
import swp.se1941jv.pls.service.GradeService;
import swp.se1941jv.pls.service.PackageService;

@Controller
public class PackageController {
    private final SubjectService subjectService;
    private final PackageService packageService;
    private final GradeService gradeService;

    public PackageController(SubjectService subjectService, PackageService packageService, GradeService gradeService) {
        this.subjectService = subjectService;
        this.packageService = packageService;
        this.gradeService = gradeService;

    }

    @GetMapping("/admin/package/create")
    public String getCreatePackage(Model model) {
        List<Subject> subjects = this.subjectService.findAllSubjects();
        List<Grade> grades = this.gradeService.getAllGradesIsActive();
        model.addAttribute("grades", grades);
        model.addAttribute("subjects", subjects);
        model.addAttribute("newPackage", new Package());
        return "admin/package/create";
    }

    @PostMapping("/admin/package/create")
    public String createPackage(
            @ModelAttribute("newPackage") @Valid Package newPackage,
            BindingResult bindingResult,
            @RequestParam(value = "subjects", required = false) List<Long> subjectIds,
            Model model) {
        List<Subject> subjects = this.subjectService.findAllSubjects();
        if (bindingResult.hasErrors()) {
            model.addAttribute("subjects", subjects);
            return "admin/package/create";
        }
        if (this.packageService.existsByName(newPackage.getName())) {
            model.addAttribute("subjects", subjects);
            bindingResult.rejectValue("name", "error.newPackage", "Tên đã được sử dụng!");
            return "admin/package/create";
        }
        List<Long> validSubjectIds = subjects.stream().map(Subject::getSubjectId).collect(Collectors.toList());
        if (subjectIds.stream().anyMatch(id -> !validSubjectIds.contains(id))) {
            bindingResult.rejectValue("subjects", "error.newPackage", "Một hoặc nhiều môn học không hợp lệ!");
            return "admin/package/create";
        }

        // Lưu Package và mối quan hệ Package-Subject
        this.packageService.savePackageWithSubjects(newPackage, subjectIds);

        return "redirect:/admin/grade";
    }

}