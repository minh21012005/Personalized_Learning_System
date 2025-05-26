package swp.se1941jv.pls.controller.admin.ControllerAdvice;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.ui.Model;

@ControllerAdvice(annotations = Controller.class)
public class AdminControllerAdvice {

    @ModelAttribute
    public void setActivePage(HttpServletRequest request, Model model) {
        String uri = request.getRequestURI();

        if (uri.startsWith("/admin/user")) {
            model.addAttribute("activePage", "user");
        } else if (uri.startsWith("/admin/grade")) {
            model.addAttribute("activePage", "grade");
        } else if (uri.startsWith("/admin/subject")) {
            model.addAttribute("activePage", "subject");
        } else if (uri.equals("/admin")) {
            model.addAttribute("activePage", "dashboard");
        } else {
            model.addAttribute("activePage", ""); // không chọn gì
        }
    }
}