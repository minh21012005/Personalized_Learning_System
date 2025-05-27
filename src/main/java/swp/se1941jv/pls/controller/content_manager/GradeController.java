package swp.se1941jv.pls.controller.content_manager;

import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.GradeService;
import swp.se1941jv.pls.service.SubjectService;

@Controller
public class GradeController {
    private final GradeService gradeService;
    private final SubjectService subjectService;

    public GradeController(GradeService gradeService, SubjectService subjectService) {
        this.gradeService = gradeService;
        this.subjectService = subjectService;

    }

    @GetMapping("/content-manager/grade")
    public String getGradePage(Model model) {
        List<Grade> grades = this.gradeService.getAllGrades();
        model.addAttribute("grades", grades);
        return "content-manager/grade/show";
    }

    @RequestMapping("/content-manager/grade/create")
    public String getCreateUserPage(Model model) {

        model.addAttribute("newGrade", new Grade());
        return "content-manager/grade/create";
    }

    @PostMapping("/content-manager/grade/create")
    public String postCreateUserPage(Model model, @ModelAttribute("newGrade") Grade newGrade) {
        try {
            this.gradeService.saveGrade(newGrade);
            return "redirect:/content-manager/grade";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("newGrade", newGrade);
            return "content-manager/grade/create";
        }

    }

    @RequestMapping(value = "/content-manager/grade/delete/{gradeId}")
    public String deleteUser(Model model, @PathVariable long gradeId) {

        model.addAttribute("gradeId", gradeId);

        model.addAttribute("newGrade", new Grade());
        return "content-manager/grade/delete";
    }

    @PostMapping(value = "/content-manager/grade/delete")
    public String postDeleteUser(Model model, @ModelAttribute("newGrade") Grade grade) {

        this.gradeService.deleteById(grade.getGradeId());
        return "redirect:/content-manager/grade";
    }

    @GetMapping(value = "/content-manager/grade/view/{gradeId}")
    public String viewSubjectsByGrade(Model model, @PathVariable long gradeId) {
        try {
            Grade grade = this.gradeService.findById(gradeId)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy khối lớp"));
            List<Subject> subjects = subjectService.getSubjectsByGradeId(gradeId, true);

            if (!grade.isActive()) {
                model.addAttribute("warning", "⚠ Khối lớp này đã ngừng hoạt động. Dữ liệu chỉ để tham khảo.");
            }

            model.addAttribute("grade", grade);
            model.addAttribute("subjects", subjects);
        } catch (IllegalArgumentException ex) {
            model.addAttribute("errorMessage", ex.getMessage());
            model.addAttribute("grade", null);
            model.addAttribute("subjects", Collections.emptyList());
        }
        return "content-manager/grade/view";
    }
}
