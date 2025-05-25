package swp.se1941jv.pls.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class GradeController {
    @GetMapping("/admin/grade")
    public String getGardePage() {
        return "admin/grade/show";
    }
}
