package swp.se1941jv.pls.controller.admin;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.ui.Model;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.service.GradeService;

@Controller
public class GradeController {
    private final GradeService gradeService;

    public GradeController(GradeService gradeService) {
        this.gradeService = gradeService;

    }

    @GetMapping("/admin/grade")
    public String getGradePage(Model model) {
        List<Grade> grades = this.gradeService.getAllGrades();
        model.addAttribute("grades", grades);
        return "admin/grade/show";
    }

    @RequestMapping("/admin/grade/create")
    public String getCreateUserPage(Model model) {

        model.addAttribute("newGrade", new Grade());
        return "admin/grade/create";
    }

    @PostMapping("/admin/grade/create")
    public String postCreateUserPage(Model model, @ModelAttribute("newGrade") Grade newGrade) {
        try {
            this.gradeService.saveGrade(newGrade);
            return "redirect:/admin/grade";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("newGrade", newGrade);
            return "admin/grade/create";
        }

    }
}
