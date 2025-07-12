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

    @GetMapping("/{testId}")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String startTest(@PathVariable Long testId, Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        try {
            Map<String, Object> testData = testStudentService.startOrResumeTest(testId, userId);
            model.addAttribute("testId", testId);
            model.addAttribute("questions", testData.get("questions"));
            model.addAttribute("remainingTime", testData.get("remainingTime"));
            model.addAttribute("userTestId", testData.get("userTestId"));
            model.addAttribute("testName", testData.get("testName"));
            model.addAttribute("savedAnswers", testData.get("savedAnswers"));
            return "client/test/TestPage";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi bắt đầu bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }

    @PostMapping("/save-answers/{testId}")
    @PreAuthorize("hasAnyRole('STUDENT')")
    @ResponseBody
    public String saveAnswers(@PathVariable Long testId, @RequestBody TestSubmissionDto submission) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return "{\"error\": \"Không thể xác định người dùng hiện tại.\"}";
        }

        try {
            testStudentService.saveTemporaryAnswers(testId, userId, submission.getAnswers());
            return "{\"success\": true}";
        } catch (Exception e) {
            return "{\"error\": \"" + e.getMessage() + "\"}";
        }
    }

    @PostMapping("/submit/{testId}")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String submitTest(@PathVariable Long testId, @RequestBody String submissionData, Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        try {
            TestSubmissionDto submission = objectMapper.readValue(submissionData, TestSubmissionDto.class);
            Map<String, Object> result = testStudentService.submitTest(testId, userId, submission);
            model.addAttribute("results", result.get("results"));
            model.addAttribute("correctCount", result.get("correctCount"));
            model.addAttribute("totalQuestions", result.get("totalQuestions"));
            model.addAttribute("testId", testId);
            return "client/test/TestResult";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi nộp bài: " + e.getMessage());
            return "error";
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
            model.addAttribute("error", "Lỗi khi lấy danh sách lịch sử bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/history/{testId}")
    @PreAuthorize("hasAnyRole('STUDENT')")
    public String showTestHistoryDetail(@PathVariable Long testId, Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        try {
            TestHistoryDTO history = testStudentService.getTestHistory(testId, userId);
            model.addAttribute("history", history);
            return "client/test/TestHistoryDetail";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi khi lấy chi tiết lịch sử: " + e.getMessage());
            return "error";
        }
    }
}