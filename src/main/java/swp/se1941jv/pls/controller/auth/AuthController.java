package swp.se1941jv.pls.controller.auth;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AuthController {
    @GetMapping("/login")
    public String login(Model model) {
        return "client/auth/login";
    }

    @GetMapping("/access-deny")
    public String accessDenied(Model model) {
        return "client/auth/accessDeny";
    }

}
