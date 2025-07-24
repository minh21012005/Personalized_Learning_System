package swp.se1941jv.pls.controller.client;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import swp.se1941jv.pls.service.HomePageService;

@Controller
@RequiredArgsConstructor
public class HomePageController {

    private final HomePageService homePageService;

    @GetMapping("/")
    public String getHomePage(Model model) {
        model.addAttribute("latestPackages", homePageService.getPackageHomeDTOs());

        return "client/homepage/show";
    }

}
