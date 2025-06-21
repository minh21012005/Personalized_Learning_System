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
import swp.se1941jv.pls.dto.response.*;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.repository.*;
import swp.se1941jv.pls.service.PracticesService;
import swp.se1941jv.pls.service.QuestionService;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/practices")
@RequiredArgsConstructor
public class PracticeController {

    private final PracticesService practicesService;
    private final QuestionService questionService;

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

    @GetMapping("/subject")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String lessonSelection(@RequestParam("packageId") Long packageId,@RequestParam("subjectId") Long subjectId, Model model) {

        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        SubjectResponseDTO subject = practicesService.getSubjectDetail(packageId, subjectId);
        List<ChapterResponseDTO> chapters = practicesService.getChapters(subjectId);

        model.addAttribute("subject", subject);
        model.addAttribute("chapters", chapters);


        return "client/practice/LessonSelection";
    }

    @PostMapping("/start-practice")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String startPracticeWithLessons(
                                           @RequestParam(value = "timed", required = false) Boolean timed,
                                           @RequestParam(value = "questionCount", defaultValue = "30") Integer questionCount,
                                           @RequestParam(value = "timePerQuestion", defaultValue = "0") Integer timePerQuestion,
                                           @RequestParam(value = "allLessonIds", required = false) String allLessonIds,
                                           Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        // Parse allLessonIds into a List<Long> if provided
        List<Long> allLessonIdsList = (allLessonIds != null && !allLessonIds.isEmpty())
                ? Arrays.stream(allLessonIds.split(",")).map(Long::valueOf).collect(Collectors.toList())
                : new ArrayList<>();

//        // Generate initial 5 random questions
        List<QuestionDisplayDto> initialQuestions = practicesService.generateQuestionsFirst(allLessonIdsList);

        model.addAttribute("questions", initialQuestions);
        model.addAttribute("lessonIds", allLessonIds); // Selected lessonIds for immediate practice
        model.addAttribute("allLessonIds", allLessonIdsList); // All lessonIds for context
//        model.addAttribute("packageId", packageId);
        model.addAttribute("timed", timed != null && timed);
        model.addAttribute("questionCount", questionCount);
        model.addAttribute("timePerQuestion", timePerQuestion);
        model.addAttribute("userId", userId);

        return "client/practice/PracticeSession";
    }




}