package swp.se1941jv.pls.controller.client.practice;

import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.*;
import swp.se1941jv.pls.dto.response.practice.PracticeResponseDTO;
import swp.se1941jv.pls.dto.response.practice.PracticeSubmissionDto;
import swp.se1941jv.pls.dto.response.practice.QuestionAnswerResDTO;
import swp.se1941jv.pls.dto.response.practice.QuestionDisplayDto;
import swp.se1941jv.pls.service.PracticesService;
import swp.se1941jv.pls.service.QuestionService;

import java.util.*;
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
    public String lessonSelection(@RequestParam("packageId") Long packageId, @RequestParam("subjectId") Long subjectId, Model model) {

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
    public String startPracticeWithLessons(@RequestParam(value = "allLessonIds", required = false) String selectedLessonIds,
                                           Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        // Parse selectedLessonIds into a List<Long> if provided
        List<Long> selectedLessonIdList = (selectedLessonIds != null && !selectedLessonIds.isEmpty())
                ? Arrays.stream(selectedLessonIds.split(",")).map(Long::valueOf).collect(Collectors.toList())
                : new ArrayList<>();

        PracticeResponseDTO practiceResponse = practicesService.startPracticeWithLessons(selectedLessonIdList);


        model.addAttribute("testId", practiceResponse.getTestId());
        model.addAttribute("selectedLessonIds", practiceResponse.getSelectedLessonId());
        model.addAttribute("questions", practiceResponse.getQuestions());

        return "client/practice/PracticeSession";
    }

    @PostMapping("/submit-answers")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String submitAnswers(
            @ModelAttribute PracticeSubmissionDto submissionDto,
            Model model,
            @ModelAttribute("initialQuestions") List<QuestionDisplayDto> initialQuestions) {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null || !currentUserId.equals(submissionDto.getUserId())) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        submissionDto.getAnswers();

        List<QuestionAnswerResDTO> results = practicesService.checkResults(submissionDto);


        // Add attributes to model
//        model.addAttribute("questions", initialQuestions);
//        model.addAttribute("results", results);
//        model.addAttribute("correctCount", correctCount);
//        model.addAttribute("showResults", true); // Show results after submission
//        model.addAttribute("questionBackgrounds", questionBackgrounds);
//        model.addAttribute("questionAnswerStates", questionAnswerStates); // For JSP to display correct/incorrect states
//        model.addAttribute("lessonIds", submissionDto.getLessonIds());
//        model.addAttribute("allLessonIds", submissionDto.getAllLessonIds());
//        model.addAttribute("timed", submissionDto.getTimed() != null && submissionDto.getTimed());
//        model.addAttribute("questionCount", submissionDto.getQuestionCount());
//        model.addAttribute("timePerQuestion", submissionDto.getTimePerQuestion());
//        model.addAttribute("userId", submissionDto.getUserId());
//        model.addAttribute("currentIndex", (submissionDto.getCurrentIndex() != null ? submissionDto.getCurrentIndex() + 1 : 1));
//        model.addAttribute("canGoBack", submissionDto.getCurrentIndex() != null && submissionDto.getCurrentIndex() > 0);

        return "client/practice/PracticeSession";
    }


}