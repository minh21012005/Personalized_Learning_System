package swp.se1941jv.pls.controller.staff;


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
import swp.se1941jv.pls.dto.response.ChapterResponseDTO;
import swp.se1941jv.pls.dto.response.practice.QuestionDisplayDto;
import swp.se1941jv.pls.dto.response.tests.QuestionCreateTestDisplayDto;
import swp.se1941jv.pls.dto.response.tests.TestDetailDto;
import swp.se1941jv.pls.dto.response.tests.TestListDto;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.TestStaffService;


import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/tests")
@RequiredArgsConstructor
public class TestStaffController {

    private static final Logger logger = LoggerFactory.getLogger(TestStaffController.class);

    private final TestStaffService testStaffService;

    @GetMapping("/create")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public String showCreateTestForm(Model model) {
        try {
            model.addAttribute("subjects", testStaffService.getAllSubjects());
            model.addAttribute("testStatuses", testStaffService.getAllTestStatuses());
            model.addAttribute("testCategories", testStaffService.getAllTestCategories());
            model.addAttribute("questions", new ArrayList<>());
            return "staff/tests/CreateTest";
        } catch (Exception e) {
            logger.error("Error loading create test form: {}", e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi tải form tạo bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/chapters")
    @PreAuthorize("hasAnyRole('ADMIN')")
    @ResponseBody
    public List<ChapterResponseDTO> getChaptersBySubject(@RequestParam("subjectId") Long subjectId) {
        try {
            return testStaffService.getChaptersBySubject(subjectId).stream()
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

    @GetMapping("/questions")
    @PreAuthorize("hasAnyRole('ADMIN')")
    @ResponseBody
    public List<QuestionCreateTestDisplayDto> getQuestionsBySubjectAndChapter(
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId) {
        try {
            return testStaffService.getQuestionsBySubjectAndChapter(subjectId, chapterId);
        } catch (Exception e) {
            logger.error("Error fetching questions for subjectId {} and chapterId {}: {}", subjectId, chapterId, e.getMessage(), e);
            throw new RuntimeException("Lỗi khi tải danh sách câu hỏi: " + e.getMessage());
        }
    }

    @PostMapping("/save")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public String saveTest(
            @RequestParam("testName") String testName,
            @RequestParam("durationTime") Integer durationTime,
            @RequestParam("startAt") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startAt,
            @RequestParam("endAt") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endAt,
            @RequestParam("testStatusId") Long testStatusId,
            @RequestParam("testCategoryId") Long testCategoryId,
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId,
            @RequestParam(value = "questionIds", required = false) List<Long> questionIds,
            Model model) {
        try {
            testStaffService.createTest(testName, durationTime, startAt, endAt, testStatusId, testCategoryId, subjectId, chapterId, questionIds);
            return "redirect:/admin/tests";
        } catch (Exception e) {
            logger.error("Error creating test: {}", e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi tạo bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @GetMapping
    public String listTests(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId,
            @RequestParam(value = "startAt", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startAt,
            @RequestParam(value = "endAt", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endAt,
            Model model) {
        try {
            int pageSize = 10;
            Pageable pageable = PageRequest.of(page - 1, pageSize);
            Long creatorUserId = SecurityUtils.getCurrentUserId();

            if (creatorUserId == null) {
                model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
                return "staff/tests/ListTest";
            }

            Page<TestListDto> testPage = testStaffService.findTestsByCreatorAndFilters(
                    creatorUserId, subjectId, chapterId, startAt, endAt, pageable);

            List<TestListDto> tests = testPage.getContent();
            int totalPages = testPage.getTotalPages();
            int currentPage = page;

            List<Subject> subjects = testStaffService.getAllSubjects();
            List<Chapter> chapters = subjectId != null ? testStaffService.getChaptersBySubject(subjectId) : new ArrayList<>();

            model.addAttribute("tests", tests);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("currentPage", currentPage);
            model.addAttribute("subjects", subjects);
            model.addAttribute("chapters", chapters);
            model.addAttribute("subjectId", subjectId);
            model.addAttribute("chapterId", chapterId);
            model.addAttribute("startAt", startAt != null ? startAt.toString() : null);
            model.addAttribute("endAt", endAt != null ? endAt.toString() : null);

            return "staff/tests/ListTest";
        } catch (Exception e) {
            logger.error("Error fetching test list: {}", e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi tải danh sách bài kiểm tra: " + e.getMessage());
            return "staff/tests/ListTest";
        }
    }
}