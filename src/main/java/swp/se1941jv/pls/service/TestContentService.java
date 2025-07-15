package swp.se1941jv.pls.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.criteria.Predicate;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.request.AnswerOptionDto;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.tests.QuestionCreateTestDisplayDto;
import swp.se1941jv.pls.dto.response.tests.TestDetailDto;
import swp.se1941jv.pls.dto.response.tests.TestListDto;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.repository.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TestContentService {

    SubjectRepository subjectRepository;
    QuestionBankRepository questionBankRepository;
    TestRepository testRepository;
    TestStatusRepository testStatusRepository;
    TestCategoryRepository testCategoryRepository;
    ChapterRepository chapterRepository;
    QuestionTestRepository questionTestRepository;
    ObjectMapper objectMapper;
    LessonRepository lessonRepository;

    @PreAuthorize("hasAnyRole('ADMIN', 'CONTENT_MANAGER')")
    public List<Subject> getAllSubjects() {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
        }
        return subjectRepository.findAll();
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'CONTENT_MANAGER')")
    public List<Chapter> getChaptersBySubject(Long subjectId) {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
        }
        if (subjectId == null) {
            throw new IllegalArgumentException("Môn học là bắt buộc.");
        }
        Subject subject = subjectRepository.findById(subjectId)
                .orElseThrow(() -> new IllegalArgumentException("Môn học không tìm thấy: " + subjectId));
        return subject.getChapters();
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'CONTENT_MANAGER')")
    public List<LessonResponseDTO> getLessonsByChapter(Long chapterId) {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
        }
        if (chapterId == null) {
            throw new IllegalArgumentException("Chương là bắt buộc.");
        }
        Chapter chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new IllegalArgumentException("Chương không tìm thấy: " + chapterId));
        return lessonRepository.findByChapter(chapter).stream().map(lesson -> {
            return LessonResponseDTO.builder()
                    .lessonId(lesson.getLessonId())
                    .lessonName(lesson.getLessonName())
                    .status(lesson.getStatus())
                    .build();
        }).collect(Collectors.toList());
    }


    @PreAuthorize("hasAnyRole('ADMIN','CONTENT_MANAGER')")
    public List<TestStatus> getAllTestStatuses() {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
        }
        return testStatusRepository.findAll();
    }

    @PreAuthorize("hasAnyRole('ADMIN','CONTENT_MANAGER')")
    public List<TestCategory> getAllTestCategories() {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
        }
        return testCategoryRepository.findAll();
    }

    @PreAuthorize("hasAnyRole('ADMIN','CONTENT_MANAGER')")
    public TestDetailDto getTestDetails(Long testId) {
        Test test = testRepository.findById(testId)
                .orElseThrow(() -> new IllegalArgumentException("Bài kiểm tra không tìm thấy: " + testId));

        List<QuestionCreateTestDisplayDto> questions = questionTestRepository.findByTestId(testId)
                .stream()
                .map(questionTest -> {
                    QuestionBank question = questionTest.getQuestion();
                    try {
                        List<AnswerOptionDto> options = objectMapper.readValue(
                                question.getOptions(),
                                new TypeReference<List<AnswerOptionDto>>() {
                                }
                        );
                        String chapterName = question.getLesson() != null && question.getLesson().getChapter() != null
                                ? question.getLesson().getChapter().getChapterName()
                                : null;
                        return QuestionCreateTestDisplayDto.builder()
                                .questionId(question.getQuestionId())
                                .content(question.getContent())
                                .chapterName(chapterName)
                                .options(options)
                                .build();
                    } catch (Exception e) {
                        throw new RuntimeException("Lỗi khi xử lý đáp án câu hỏi ID: " + question.getQuestionId(), e);
                    }
                })
                .collect(Collectors.toList());

        return TestDetailDto.builder()
                .testId(test.getTestId())
                .testName(test.getTestName())
                .subjectId(test.getSubject() != null ? test.getSubject().getSubjectId() : null)
                .subjectName(test.getSubject() != null ? test.getSubject().getSubjectName() : null)
                .chapterId(test.getChapter() != null ? test.getChapter().getChapterId() : null)
                .chapterName(test.getChapter() != null ? test.getChapter().getChapterName() : null)
                .lessonId(test.getLesson() != null ? test.getLesson().getLessonId() : null)
                .lessonName(test.getLesson() != null ? test.getLesson().getLessonName() : null)
                .durationTime(test.getDurationTime())
                .maxAttempts(test.getMaxAttempts())
                .startAt(test.getStartAt() != null ? test.getStartAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")) : null)
                .endAt(test.getEndAt() != null ? test.getEndAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")) : null)
                .statusId(test.getTestStatus() != null ? test.getTestStatus().getTestStatusId() : null)
                .statusName(test.getTestStatus() != null ? test.getTestStatus().getTestStatusName() : "Chưa xác định")
                .isOpen(test.getIsOpen() != null ? test.getIsOpen() : false)
                .categoryId(test.getTestCategory() != null ? test.getTestCategory().getTestCategoryId() : null)
                .categoryName(test.getTestCategory() != null ? test.getTestCategory().getName() : "Chưa xác định")
                .questions(questions)
                .reason(test.getReason())
                .build();
    }

    @PreAuthorize("hasAnyRole('ADMIN','CONTENT_MANAGER')")
    @Transactional
    public void approveTest(Long testId, String reason) {
        Test test = testRepository.findById(testId)
                .orElseThrow(() -> new IllegalArgumentException("Bài kiểm tra không tìm thấy: " + testId));
        if (reason == null || reason.trim().isEmpty()) {
            throw new IllegalArgumentException("Lý do phê duyệt là bắt buộc.");
        }
        TestStatus approvedStatus = testStatusRepository.findByTestStatusName("Chấp nhận")
                .orElseThrow(() -> new IllegalArgumentException("Trạng thái 'Chấp nhận' không tồn tại."));
        test.setTestStatus(approvedStatus);
        test.setIsOpen(true);
        test.setReason(reason); // Store the reason
        testRepository.save(test);
    }

    @PreAuthorize("hasAnyRole('ADMIN','CONTENT_MANAGER')")
    @Transactional
    public void rejectTest(Long testId, String reason) {
        Test test = testRepository.findById(testId)
                .orElseThrow(() -> new IllegalArgumentException("Bài kiểm tra không tìm thấy: " + testId));
        if (reason == null || reason.trim().isEmpty()) {
            throw new IllegalArgumentException("Lý do từ chối là bắt buộc.");
        }
        TestStatus rejectedStatus = testStatusRepository.findByTestStatusName("Từ chối")
                .orElseThrow(() -> new IllegalArgumentException("Trạng thái 'Từ chối' không tồn tại."));
        test.setTestStatus(rejectedStatus);
        test.setIsOpen(false);
        test.setReason(reason); // Store the reason
        testRepository.save(test);
    }

    @PreAuthorize("hasAnyRole('ADMIN','CONTENT_MANAGER')")
    public Page<TestListDto> findTestsFilters( Long subjectId, Long chapterId, Long testStatusId,
                                                          LocalDateTime startAt, LocalDateTime endAt, Pageable pageable) {
        Specification<Test> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            // Filter by subjectId
            if (subjectId != null) {
                predicates.add(cb.equal(root.get("subject").get("subjectId"), subjectId));
            }

            // Filter by chapterId
            if (chapterId != null) {
                predicates.add(cb.equal(root.get("chapter").get("chapterId"), chapterId));
            }

            // Filter by statusId
            if (testStatusId != null) {
                predicates.add(cb.equal(root.get("testStatus").get("testStatusId"), testStatusId));
            }

            // Filter by startAt
            if (startAt != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("startAt"), startAt));
            }

            // Filter by endAt
            if (endAt != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("endAt"), endAt));
            }

            predicates.add(cb.notEqual(root.get("testCategory").get("testCategoryId"), 1L));
            predicates.add(cb.notEqual(root.get("testStatus").get("testStatusId"), 1L));

            // Sort by testId descending
            query.orderBy(cb.desc(root.get("testId")));

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<Test> testPage = testRepository.findAll(spec, pageable);

        return testPage.map(test -> TestListDto.builder()
                .testId(test.getTestId())
                .testName(test.getTestName())
                .durationTime(test.getDurationTime())
                .maxAttempts(test.getMaxAttempts())
                .startAt(test.getStartAt() != null ? test.getStartAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : null)
                .endAt(test.getEndAt() != null ? test.getEndAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : null)
                .statusName(test.getTestStatus() != null ? test.getTestStatus().getTestStatusName() : "Chưa xác định")
                .categoryName(test.getTestCategory() != null ? test.getTestCategory().getName() : "Chưa xác định")
                .chapterName(test.getChapter() != null ? test.getChapter().getChapterName() : null)
                .subjectName(test.getSubject() != null ? test.getSubject().getSubjectName() : null)
                .isOpen(test.getIsOpen() != null ? test.getIsOpen() : false)
                .reason(test.getReason())
                .build());
    }




}