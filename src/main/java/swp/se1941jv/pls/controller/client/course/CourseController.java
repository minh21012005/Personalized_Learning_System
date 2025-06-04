package swp.se1941jv.pls.controller.client.course;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class CourseController {

    @GetMapping("/course")
    public String getListCoursesPage(Model model) {
        return "client/course/show";
    }

    @GetMapping("/course/detail/{id}")
    public String getDetailCoursePage(@PathVariable("id") long id) {
        return "client/course/detail";
    }

    @GetMapping("/subject/detail/{id}")
    public String getDetailSubjectPage(@PathVariable("id") long id) {
        return "client/subject/detail";
    }

    @GetMapping("cart")
    public String getCartPage() {
        return "client/cart/show";
    }
}
