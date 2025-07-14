package swp.se1941jv.pls.controller.content_manager;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.controller.staff.TestStaffController;
import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.tests.QuestionCreateTestDisplayDto;
import swp.se1941jv.pls.dto.response.tests.TestDetailDto;
import swp.se1941jv.pls.dto.response.tests.TestListDto;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.TestStatus;
import swp.se1941jv.pls.service.TestContentService;
import swp.se1941jv.pls.service.TestStaffService;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/tests")
@RequiredArgsConstructor
public class TestContentController {
    private static final Logger logger = LoggerFactory.getLogger(TestStaffController.class);
    private final TestContentService testContentService;

    @GetMapping("/chapters")
    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
    @ResponseBody
    public List<ChapterResponseDTO> getChaptersBySubject(@RequestParam("subjectId") Long subjectId) {
        try {
            return testContentService.getChaptersBySubject(subjectId).stream()
                    .map(chapter -> ChapterResponseDTO.builder()
                            .chapterId(chapter.getChapterId())
                            .chapterName(chapter.getChapterName())
                            .build())
                    .collect(Collectors.toList());
        } catch (Exception e) {
            logger.error("Error fetching chapters for subjectId {}: {}", subjectId, e.getMessage(), e);
            throw new RuntimeException("Lỗi khi tải danh sách chương: " + e.getMessage());
        }
    }

    @GetMapping("/lessons")
    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
    @ResponseBody
    public List<LessonResponseDTO> getLessonsByChapter(@RequestParam("chapterId") Long chapterId) {
        try {
            return testContentService.getLessonsByChapter(chapterId);
        } catch (Exception e) {
            logger.error("Error fetching lessons for chapterId {}: {}", chapterId, e.getMessage(), e);
            throw new RuntimeException("Lỗi khi tải danh sách bài học: " + e.getMessage());
        }
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
    public String listTests(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId,
            @RequestParam(value = "testStatusId", required = false) Long statusId,
            @RequestParam(value = "startAt", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startAt,
            @RequestParam(value = "endAt", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endAt,
            Model model) {
        try {
            int pageSize = 10;
            Pageable pageable = PageRequest.of(page - 1, pageSize);
            Long creatorUserId = SecurityUtils.getCurrentUserId();

            if (creatorUserId == null) {
                model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
                return "content-manager/tests/ListTest";
            }

            Page<TestListDto> testPage = testContentService.findTestsFilters(
                    subjectId, chapterId,statusId, startAt, endAt, pageable);

            List<TestListDto> tests = testPage.getContent();
            int totalPages = testPage.getTotalPages();
            int currentPage = page;

            List<Subject> subjects = testContentService.getAllSubjects();
            List<Chapter> chapters = subjectId != null ? testContentService.getChaptersBySubject(subjectId) : new ArrayList<>();
            List<TestStatus> statuses = testContentService.getAllTestStatuses();

            model.addAttribute("tests", tests);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("currentPage", currentPage);
            model.addAttribute("subjects", subjects);
            model.addAttribute("chapters", chapters);
            model.addAttribute("subjectId", subjectId);
            model.addAttribute("chapterId", chapterId);
            model.addAttribute("statuses", statuses);
            model.addAttribute("startAt", startAt != null ? startAt.toString() : null);
            model.addAttribute("endAt", endAt != null ? endAt.toString() : null);

            return "content-manager/tests/ListTest";
        } catch (Exception e) {
            logger.error("Error fetching test list: {}", e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi tải danh sách bài kiểm tra: " + e.getMessage());
            return "content-manager/tests/ListTest";
        }
    }

    @GetMapping("/details/{testId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
    public String viewTestDetails(@PathVariable("testId") Long testId, Model model) {
        try {
            // Assuming you have a method to fetch test details
            TestDetailDto testDetail = testContentService.getTestDetails(testId);
            model.addAttribute("test", testDetail);
            return "content-manager/tests/TestDetail";
        } catch (Exception e) {
            logger.error("Error fetching test details for testId {}: {}", testId, e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi tải chi tiết bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }


    @PostMapping("/approve/{testId}")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public String approveTest(@PathVariable("testId") Long testId, Model model) {
        try {
            testContentService.approveTest(testId);
            return "redirect:/admin/tests";
        } catch (Exception e) {
            logger.error("Error approving test {}: {}", testId, e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi phê duyệt bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }

    @PostMapping("/reject/{testId}")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public String rejectTest(@PathVariable("testId") Long testId, Model model) {
        try {
            testContentService.rejectTest(testId);
            return "redirect:/admin/tests";
        } catch (Exception e) {
            logger.error("Error rejecting test {}: {}", testId, e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi từ chối bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }
}
