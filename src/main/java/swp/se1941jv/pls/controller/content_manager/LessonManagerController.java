package swp.se1941jv.pls.controller.content_manager;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Slf4j
@Controller
@RequestMapping("/admin/lessons")
@RequiredArgsConstructor
public class LessonManagerController {

    @GetMapping
    public String getLessons(
            Model model,
            RedirectAttributes redirectAttributes
            ){

        return null;
    }
}
