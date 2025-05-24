package swp.se1941jv.pls.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class SubjectController {
    @GetMapping("/admin/subject")
    public String getSubjectPage() {
        return "admin/subject/show";
    }
}
