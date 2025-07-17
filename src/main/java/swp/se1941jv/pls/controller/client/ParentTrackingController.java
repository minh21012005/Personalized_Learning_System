package swp.se1941jv.pls.controller.client;


import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.parentTracking.ParentChildOverviewDTO;
import swp.se1941jv.pls.dto.response.studentProgress.*;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.UserRepository;
import swp.se1941jv.pls.service.ParentStudentTrackingService;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class ParentTrackingController {

    @Autowired
    private final ParentStudentTrackingService parentStudentTrackingService;

    @Autowired
    private final UserRepository userRepository;

    @GetMapping("/parent/children")
    @PreAuthorize("hasRole('PARENT')")
    public String showChildrenOverview(Model model) {
        Long parentId = SecurityUtils.getCurrentUserId();
        if (parentId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        List<ParentChildOverviewDTO> children = parentStudentTrackingService.getChildrenOverview(parentId);
        model.addAttribute("children", children);
        return "client/parentTracking/childrenOverview";
    }

    @GetMapping("/parent/child/{childId}/learning")
    @PreAuthorize("hasRole('PARENT')")
    public String showChildLearningDetail(@PathVariable Long childId, Model model) {
        Long parentId = SecurityUtils.getCurrentUserId();
        if (parentId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

         User parent = userRepository.findById(parentId).orElseThrow(() -> new RuntimeException("Phụ huynh không tồn tại"));
         if (!parent.getChildren().stream().anyMatch(child -> child.getUserId().equals(childId))) {
             model.addAttribute("error", "Bạn không có quyền truy cập thông tin này.");
             return "redirect:/parent/children";
         }

        model.addAttribute("childId", childId);
        return "redirect:/parent/student-results?childId=" + childId; // Điều hướng đến endpoint mới
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

    // Điều hướng tới trang parentStudentResults.jsp
    @GetMapping("/parent/student-results")
    @PreAuthorize("hasRole('PARENT')")
    public String showStudentResults(@RequestParam("childId") Long childId,
                                     @RequestParam(value = "page", defaultValue = "0") int page,
                                     @RequestParam(value = "size", defaultValue = "10") int size,
                                     Model model) {
        Long parentId = SecurityUtils.getCurrentUserId();
        if (parentId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        // Kiểm tra quyền truy cập (giả định phụ huynh chỉ xem con của mình)
        // User parent = userRepository.findById(parentId).orElseThrow(() -> new RuntimeException("Phụ huynh không tồn tại"));
        // if (!parent.getChildren().stream().anyMatch(child -> child.getUserId().equals(childId))) {
        //     model.addAttribute("error", "Bạn không có quyền truy cập thông tin này.");
        //     return "redirect:/parent/children";
        // }

        model.addAttribute("childId", childId);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "client/parentTracking/parentStudentResults";
    }

    // API: /api/parent/recent-lessons (Bài học gần đây của con)
    @GetMapping("/api/parent/recent-lessons")
    @ResponseBody
    public ResponseEntity<ResponseData<RecentLessonDTO>> getRecentLessons(
            @RequestParam("childId") Long childId,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {
        List<RecentLessonDTO> lessons = parentStudentTrackingService.getRecentLessons(childId, page, size);
        Long total = parentStudentTrackingService.getTotalActivities(childId);
        return ResponseEntity.ok(new ResponseData<>(lessons, total));
    }

    // API: /api/parent/daily-online-time
    @GetMapping("/api/parent/daily-online-time")
    @ResponseBody
    public ResponseEntity<ResponseData<DailyOnlineTimeDTO>> getDailyOnlineTime(
            @RequestParam("childId") Long childId,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            @RequestParam(value = "timeRange", defaultValue = "day") String timeRange) {
        List<DailyOnlineTimeDTO> dailyTimes = parentStudentTrackingService.getDailyOnlineTime(childId, startDate, endDate, timeRange);
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

    // API: /api/parent/recent-tests
    @GetMapping("/api/parent/recent-tests")
    @ResponseBody
    public ResponseEntity<ResponseData<RecentTestDTO>> getRecentTests(
            @RequestParam("childId") Long childId,
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size) {
        List<RecentTestDTO> tests = parentStudentTrackingService.getRecentTests(childId, page, size);
        Long total = parentStudentTrackingService.getTotalTests(childId);
        return ResponseEntity.ok(new ResponseData<>(tests, total));
    }

    // API: /api/parent/learning-progress
    @GetMapping("/api/parent/learning-progress")
    @PreAuthorize("hasRole('PARENT')")
    @ResponseBody
    public ResponseEntity<LearningProgressResponseDTO> getLearningProgress(
            @RequestParam("childId") Long childId) {
        List<LearningProgressDTO> progressList = parentStudentTrackingService.getLearningProgress(childId);
        return ResponseEntity.ok(LearningProgressResponseDTO.builder()
                .data(progressList)
                .total((long) progressList.size())
                .build());
    }
}