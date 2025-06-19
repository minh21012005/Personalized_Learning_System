package swp.se1941jv.pls.controller.client.practice;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.request.AnswerOptionDto;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.PackagePracticeDTO;
import swp.se1941jv.pls.dto.response.QuestionDisplayDto;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.repository.*;
import swp.se1941jv.pls.service.PracticesService;
import swp.se1941jv.pls.service.QuestionService;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/practices")
@RequiredArgsConstructor
public class PracticeController {

    private final PracticesService practicesService;


    @GetMapping
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String showPackagedPractices(Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        List<PackagePracticeDTO> packagePractices = practicesService.getPackagePractices();
        model.addAttribute("packagePractices", packagePractices);

        return "client/practice/Practices";
    }

    @GetMapping("/start")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String showPackageDetail(@RequestParam("packageId") Long packageId, Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        PackagePracticeDTO packagePractice = practicesService.getPackageDetail(packageId);

        model.addAttribute("packagePractice", packagePractice);
        model.addAttribute("subjects", packagePractice.getListSubject());

        return "client/practice/PackageDetail";
    }
}