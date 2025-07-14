package swp.se1941jv.pls.controller.staff;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashBoardStaffController {
    @GetMapping("/staff")
    public String getDashboard(Model model) {
        return "staff/dashboard/show";
    }
}
