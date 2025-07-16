package swp.se1941jv.pls.controller.client;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.studentProgress.*;
import swp.se1941jv.pls.service.StudentResultService;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Controller
public class StudentResultController {

    private final StudentResultService studentResultService;

    public StudentResultController(StudentResultService studentResultService) {
        this.studentResultService = studentResultService;
    }

    // Class wrapper để trả về dữ liệu và tổng số
    public static class ResponseData<T> {
        private List<T> data;
        private Long total;

        public ResponseData(List<T> data, Long total) {
            this.data = data;
            this.total = total;
        }

        public List<T> getData() {
            return data;
        }

        public Long getTotal() {
            return total;
        }
    }

    // Điều hướng tới trang results.jsp
    @GetMapping("/results")
    public String showResults(@RequestParam(value = "page", defaultValue = "0") int page,
                              @RequestParam(value = "size", defaultValue = "10") int size,
                              Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }
        model.addAttribute("userId", userId);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "client/studentResult/result";
    }

    // API: /api/recent-lessons (Bài học gần đây)
    @GetMapping("/api/recent-lessons")
    @ResponseBody
    public ResponseEntity<ResponseData<RecentLessonDTO>> getRecentLessons(
            @RequestParam("userId") Long userId,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {
        List<RecentLessonDTO> lessons = studentResultService.getRecentLessons(userId, page, size);
        Long total = studentResultService.getTotalActivities(userId);
        return ResponseEntity.ok(new ResponseData<>(lessons, total));
    }

    // API: /api/daily-online-time
    @GetMapping("/api/daily-online-time")
    @ResponseBody
    public ResponseEntity<ResponseData<DailyOnlineTimeDTO>> getDailyOnlineTime(
            @RequestParam("userId") Long userId,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "timeRange", defaultValue = "day") String timeRange) {
        List<DailyOnlineTimeDTO> dailyTimes = studentResultService.getDailyOnlineTime(userId, startDate, endDate, timeRange);
        Long total;
        if ("month".equalsIgnoreCase(timeRange)) {
            LocalDate start = startDate != null ? LocalDate.parse(startDate).withDayOfMonth(1) : LocalDate.now().minusMonths(6).withDayOfMonth(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate).withDayOfMonth(1) : LocalDate.now().withDayOfMonth(1);
            total = (long) ChronoUnit.MONTHS.between(start, end) + 1;
        } else if ("year".equalsIgnoreCase(timeRange)) {
            LocalDate start = startDate != null ? LocalDate.parse(startDate).withDayOfYear(1) : LocalDate.now().minusYears(1).withDayOfYear(1);
            LocalDate end = endDate != null ? LocalDate.parse(endDate).withDayOfYear(1) : LocalDate.now().withDayOfYear(1);
            total = (long) ChronoUnit.YEARS.between(start, end) + 1;
        } else {
            total = (long) (endDate != null ? LocalDate.parse(endDate).toEpochDay() - LocalDate.parse(startDate != null ? startDate : LocalDate.now().minusDays(6).toString()).toEpochDay() + 1 : 7);
        }
        return ResponseEntity.ok(new ResponseData<>(dailyTimes, total));
    }

    // API: /api/recent-tests
    @GetMapping("/api/recent-tests")
    @ResponseBody
    public ResponseEntity<ResponseData<RecentTestDTO>> getRecentTests(
            @RequestParam("userId") Long userId,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {
        List<RecentTestDTO> tests = studentResultService.getRecentTests(userId, page, size);
        Long total = studentResultService.getTotalTests(userId);
        return ResponseEntity.ok(new ResponseData<>(tests, total));
    }

    // API: /api/learning-progress
    @GetMapping("/api/learning-progress")
    @PreAuthorize("hasAnyRole('STUDENT')")
    @ResponseBody
    public ResponseEntity<LearningProgressResponseDTO> getLearningProgress(
            @RequestParam("userId") Long userId) {
        List<LearningProgressDTO> progressList = studentResultService.getLearningProgress(userId);
        return ResponseEntity.ok(LearningProgressResponseDTO.builder()
                .data(progressList)
                .total((long) progressList.size())
                .build());
    }
}