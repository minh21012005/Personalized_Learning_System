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
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.tests.QuestionCreateTestDisplayDto;
import swp.se1941jv.pls.dto.response.tests.TestDetailDto;
import swp.se1941jv.pls.dto.response.tests.TestListDto;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.TestStatus;
import swp.se1941jv.pls.service.TestStaffService;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/staff/tests")
@RequiredArgsConstructor
public class TestStaffController {

    private static final Logger logger = LoggerFactory.getLogger(TestStaffController.class);
    private final TestStaffService testStaffService;

    @GetMapping("/create")
    @PreAuthorize("hasAnyRole('STAFF')")
    public String showCreateTestForm(Model model) {
        try {
            model.addAttribute("subjects", testStaffService.getAllSubjects());
//            model.addAttribute("testStatuses", testStaffService.getAllTestStatuses());
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
    @PreAuthorize("hasAnyRole('STAFF')")
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

    @GetMapping("/lessons")
    @PreAuthorize("hasAnyRole( 'STAFF')")
    @ResponseBody
    public List<LessonResponseDTO> getLessonsByChapter(@RequestParam("chapterId") Long chapterId) {
        try {
            return testStaffService.getLessonsByChapter(chapterId);
        } catch (Exception e) {
            logger.error("Error fetching lessons for chapterId {}: {}", chapterId, e.getMessage(), e);
            throw new RuntimeException("Lỗi khi tải danh sách bài học: " + e.getMessage());
        }
    }

    @GetMapping("/questions")
    @PreAuthorize("hasAnyRole( 'STAFF')")
    @ResponseBody
    public List<QuestionCreateTestDisplayDto> getQuestionsBySubjectAndChapter(
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId,
            @RequestParam(value = "lessonId", required = false) Long lessonId) {
        try {
            return testStaffService.getQuestionsBySubjectAndChapter(subjectId, chapterId, lessonId);
        } catch (Exception e) {
            logger.error("Error fetching questions for subjectId {} and chapterId {}: {}", subjectId, chapterId, e.getMessage(), e);
            throw new RuntimeException("Lỗi khi tải danh sách câu hỏi: " + e.getMessage());
        }
    }

    @PostMapping("/save")
    @PreAuthorize("hasAnyRole( 'STAFF')")
    public String saveTest(
            @RequestParam("testName") String testName,
            @RequestParam("durationTime") Integer durationTime,
            @RequestParam(value = "maxAttempts", required = false) Long maxAttempts,
            @RequestParam(value = "startAt", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startAt,
            @RequestParam(value = "endAt", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endAt,
            @RequestParam("testCategoryId") Long testCategoryId,
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId,
            @RequestParam(value = "lessonId", required = false) Long lessonId,
            @RequestParam(value = "questionIds", required = false) List<Long> questionIds,
            @RequestParam(value = "isOpen", defaultValue = "false") Boolean isOpen,
            @RequestParam("action") String action,
            Model model) {
        try {
            testStaffService.createTest(testName, durationTime, maxAttempts, startAt, endAt, testCategoryId,
                    subjectId, chapterId, lessonId, questionIds, isOpen, "saveDraft".equals(action));
            return "redirect:/staff/tests";
        } catch (Exception e) {
            logger.error("Error creating test: {}", e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi tạo bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping
    @PreAuthorize("hasAnyRole( 'STAFF')")
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

    @GetMapping("/details/{testId}")
    @PreAuthorize("hasAnyRole( 'STAFF')")
    public String viewTestDetails(@PathVariable("testId") Long testId, Model model) {
        try {
            // Assuming you have a method to fetch test details
            TestDetailDto testDetail = testStaffService.getTestDetails(testId);
            model.addAttribute("test", testDetail);
            return "staff/tests/TestDetail";
        } catch (Exception e) {
            logger.error("Error fetching test details for testId {}: {}", testId, e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi tải chi tiết bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/edit/{testId}")
    @PreAuthorize("hasAnyRole( 'STAFF')")
    public String showEditTestForm(@PathVariable("testId") Long testId, Model model) {
        try {
            TestDetailDto test = testStaffService.getTestDetails(testId);
            if(test.getStatusName().equals("Đang Xử Lý") || test.getStatusName().equals("Chấp Nhận")) {
                model.addAttribute("error", "Bài kiểm tra đang được phê duyệt không thể chỉnh sửa.");
                return "error";
            }
            model.addAttribute("test", test);
            model.addAttribute("subjects", testStaffService.getAllSubjects());
            model.addAttribute("testStatuses", testStaffService.getAllTestStatuses());
            model.addAttribute("testCategories", testStaffService.getAllTestCategories());
            List<Chapter> chapters = test.getSubjectId() != null ? testStaffService.getChaptersBySubject(test.getSubjectId()) : new ArrayList<>();
            model.addAttribute("chapters", chapters);
            List<LessonResponseDTO> lessons = test.getChapterId() != null ? testStaffService.getLessonsByChapter(test.getChapterId()) : new ArrayList<>();
            model.addAttribute("lessons", lessons);
            return "staff/tests/EditTest";
        } catch (Exception e) {
            logger.error("Error loading edit test form for testId {}: {}", testId, e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi tải form chỉnh sửa bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }

    @PostMapping("/edit")
    @PreAuthorize("hasAnyRole( 'STAFF')")
    public String editTest(
            @RequestParam("testId") Long testId,
            @RequestParam("testName") String testName,
            @RequestParam("durationTime") Integer durationTime,
            @RequestParam(value = "maxAttempts", required = false) Long maxAttempts,
            @RequestParam(value = "startAt", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startAt,
            @RequestParam(value = "endAt", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endAt,
            @RequestParam("testCategoryId") Long testCategoryId,
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId,
            @RequestParam(value = "lessonId", required = false) Long lessonId,
            @RequestParam(value = "questionIds", required = false) List<Long> questionIds,
            @RequestParam(value = "isOpen", defaultValue = "false") Boolean isOpen,
            @RequestParam("action") String action,
            Model model) {
        try {
            Long statusId = "requestApproval".equals(action) ?
                    testStaffService.findTestStatusByName("Đang xử lý").getTestStatusId() :
                    testStaffService.findTestStatusByName("Nháp").getTestStatusId();

            testStaffService.updateTest(testId, testName, durationTime, maxAttempts, startAt, endAt, statusId, testCategoryId,
                    subjectId, chapterId, lessonId, questionIds, isOpen);
            return "redirect:/staff/tests";
        } catch (Exception e) {
            logger.error("Error updating test {}: {}", testId, e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi cập nhật bài kiểm tra: " + e.getMessage());
            return "error";
        }
    }
}