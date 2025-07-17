package swp.se1941jv.pls.controller.client.tests;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.tests.TestHistoryDTO;
import swp.se1941jv.pls.dto.response.tests.TestHistoryListDTO;
import swp.se1941jv.pls.dto.response.tests.TestSubmissionDto;
import swp.se1941jv.pls.service.TestStudentService;

import java.time.LocalDate;
import java.util.Map;

@Controller
@RequestMapping("/tests")
@RequiredArgsConstructor
public class TestStudentController {

    private final TestStudentService testStudentService;
    private final ObjectMapper objectMapper;

    private String handleError(Model model, String errorMessage) {
        model.addAttribute("errorMessage", errorMessage);
        return "client/test/error"; // Redirect to the new error page
    }

    @GetMapping("/{testId}/{packageId}")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String startTest(@PathVariable Long testId, @PathVariable Long packageId, Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        try {
            Map<String, Object> testData = testStudentService.startOrResumeTest(testId, packageId, userId);
            Long userTestId = (Long) testData.get("userTestId");
            return "redirect:/tests/userTest/" + userTestId; // Redirect to new endpoint
        } catch (Exception e) {
            return handleError(model, "Lỗi khi tải bài kiểm tra: " + e.getMessage());
        }
    }

    @GetMapping("/userTest/{userTestId}")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String showTestPage(@PathVariable Long userTestId, Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        try {
            Map<String, Object> testData = testStudentService.getTestData(userTestId, userId);
            model.addAttribute("testId", testData.get("testId"));
            model.addAttribute("questions", testData.get("questions"));
            model.addAttribute("remainingTime", testData.get("remainingTime"));
            model.addAttribute("userTestId", userTestId);
            model.addAttribute("testName", testData.get("testName"));
            model.addAttribute("savedAnswers", testData.get("savedAnswers"));
            return "client/test/TestPage";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi tải bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }

    @PostMapping("/save-answers/{userTestId}")
    @PreAuthorize("hasAnyRole('STUDENT')")
    @ResponseBody
    public String saveAnswers(@PathVariable Long userTestId, @RequestBody TestSubmissionDto submission) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return "{\"error\": \"Không thể xác định người dùng hiện tại.\"}";
        }

        try {
            testStudentService.saveTemporaryAnswers(userTestId, submission.getAnswers());
            return "{\"success\": true}";
        } catch (Exception e) {
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }

    @PostMapping("/submit/{userTestId}")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String submitTest(@PathVariable Long userTestId, @RequestBody String submissionData, Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        try {
            TestSubmissionDto submission = objectMapper.readValue(submissionData, TestSubmissionDto.class);
            Map<String, Object> result = testStudentService.submitTest(userTestId, submission);
            model.addAttribute("results", result.get("results"));
            model.addAttribute("correctCount", result.get("correctCount"));
            model.addAttribute("totalQuestions", result.get("totalQuestions"));
            model.addAttribute("userTestId", userTestId);
            return "client/test/TestResult";
        } catch (Exception e) {
            return handleError(model, "Lỗi khi nộp bài: " + e.getMessage());
        }
    }

    @GetMapping("/history")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String showTestHistoryList(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(value = "startDate", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam(value = "endDate", required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate,
            Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        try {
            Page<TestHistoryListDTO> testHistoryPage = testStudentService.getTestHistoryList(userId, startDate, endDate, page, size);
            model.addAttribute("testHistoryPage", testHistoryPage);
            model.addAttribute("currentPage", page);
            model.addAttribute("pageSize", size);
            model.addAttribute("startDate", startDate != null ? startDate.toString() : "");
            model.addAttribute("endDate", endDate != null ? endDate.toString() : "");
            return "client/test/TestHistory";
        } catch (Exception e) {
            return handleError(model, "Lỗi khi lấy danh sách lịch sử bài kiểm tra: " + e.getMessage());
        }
    }

    @GetMapping("/history/{userTestId}")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String showTestHistoryDetail(@PathVariable Long userTestId, Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        try {
            TestHistoryDTO history = testStudentService.getTestHistory(userTestId);
            model.addAttribute("history", history);
            return "client/test/TestHistoryDetail";
        } catch (Exception e) {
            return handleError(model, "Lỗi khi lấy chi tiết lịch sử: " + e.getMessage());
        }
    }
}