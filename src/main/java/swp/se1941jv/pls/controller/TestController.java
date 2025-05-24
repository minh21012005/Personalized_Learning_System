package swp.se1941jv.pls.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TestController {
    @RequestMapping("/")
    public String getHomePage(Model model) {
        return "hello";
    }

    @GetMapping("/admin")
    public String getIndex() {
        return "admin/dashboard/show";
    }
}
