package swp.se1941jv.pls.controller.client;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomePageController {

    @GetMapping("/")
    public String getHomePage(Model model) {
        return "client/homepage/show";
    }

    @GetMapping("/student")
    public String getStudentHomePage(Model model) {
        return "client/homepage/show";
    }
}
