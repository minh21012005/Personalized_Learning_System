package swp.se1941jv.pls.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/admin/communications")
@RequiredArgsConstructor
public class CommunicationViewController {
    @GetMapping
    public String showCommunicationHubPage(Model model) {
        model.addAttribute("activePage", "communication");
        return "admin/communication/communication-hub";
    }
}
