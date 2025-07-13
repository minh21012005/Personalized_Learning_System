package swp.se1941jv.pls.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
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

import jakarta.persistence.criteria.Predicate;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TestStaffService {

    SubjectRepository subjectRepository;
    QuestionBankRepository questionBankRepository;
    TestRepository testRepository;
    TestStatusRepository testStatusRepository;
    TestCategoryRepository testCategoryRepository;
    ChapterRepository chapterRepository;
    SubjectTestRepository subjectTestRepository;
    QuestionTestRepository questionTestRepository;
    ObjectMapper objectMapper;
    LessonRepository lessonRepository;

    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
    public List<Subject> getAllSubjects() {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
        }
        return subjectRepository.findAll();
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
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

    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
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

    @PreAuthorize("hasAnyRole('ADMIN','STAFF')")
    public List<QuestionCreateTestDisplayDto> getQuestionsBySubjectAndChapter(Long subjectId, Long chapterId) {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
        }
        if (subjectId == null && chapterId == null) {
            throw new IllegalArgumentException("Phải chọn ít nhất một môn học hoặc chương.");
        }
        List<QuestionBank> questions;
        if (chapterId != null) {
            chapterRepository.findById(chapterId)
                    .orElseThrow(() -> new IllegalArgumentException("Chương không tìm thấy: " + chapterId));
            questions = questionBankRepository.findByLessonChapterChapterId(chapterId);
        } else if (subjectId != null) {
            subjectRepository.findById(subjectId)
                    .orElseThrow(() -> new IllegalArgumentException("Môn học không tìm thấy: " + subjectId));
            questions = questionBankRepository.findByLessonChapterSubjectSubjectId(subjectId);
        } else {
            return new ArrayList<>();
        }

        return questions.stream().map(question -> {
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
        }).collect(Collectors.toList());
    }

    @PreAuthorize("hasAnyRole('ADMIN','STAFF')")
    public List<TestStatus> getAllTestStatuses() {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
        }
        return testStatusRepository.findAll();
    }

    @PreAuthorize("hasAnyRole('ADMIN','STAFF')")
    public List<TestCategory> getAllTestCategories() {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
        }
        return testCategoryRepository.findAll();
    }

//    @PreAuthorize("hasAnyRole('ADMIN')")
//    public Test createTest(String testName, Integer durationTime, LocalDateTime startAt, LocalDateTime endAt,
//                           Long testStatusId, Long testCategoryId, Long subjectId, Long chapterId, List<Long> questionIds) {
//        Long currentUserId = SecurityUtils.getCurrentUserId();
//        if (currentUserId == null) {
//            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
//        }
//
//        // Validate mandatory fields
//        if (testName == null || testName.trim().isEmpty()) {
//            throw new IllegalArgumentException("Tên bài kiểm tra là bắt buộc.");
//        }
//        if (durationTime == null || durationTime < 1) {
//            throw new IllegalArgumentException("Thời gian phải lớn hơn 0 phút.");
//        }
//        if (startAt == null) {
//            throw new IllegalArgumentException("Thời gian bắt đầu là bắt buộc.");
//        }
//        if (endAt == null) {
//            throw new IllegalArgumentException("Thời gian kết thúc là bắt buộc.");
//        }
//        if (endAt.isBefore(startAt) || endAt.isEqual(startAt)) {
//            throw new IllegalArgumentException("Thời gian kết thúc phải sau thời gian bắt đầu.");
//        }
//        if (testStatusId == null) {
//            throw new IllegalArgumentException("Trạng thái là bắt buộc.");
//        }
//        if (testCategoryId == null) {
//            throw new IllegalArgumentException("Danh mục là bắt buộc.");
//        }
//        if (subjectId == null && chapterId == null) {
//            throw new IllegalArgumentException("Phải chọn ít nhất một môn học hoặc chương.");
//        }
//        if (questionIds == null || questionIds.isEmpty()) {
//            throw new IllegalArgumentException("Phải chọn ít nhất một câu hỏi.");
//        }
//
//        // Validate entities
//        TestStatus testStatus = testStatusRepository.findById(testStatusId)
//                .orElseThrow(() -> new IllegalArgumentException("Trạng thái không tìm thấy: " + testStatusId));
//        TestCategory testCategory = testCategoryRepository.findById(testCategoryId)
//                .orElseThrow(() -> new IllegalArgumentException("Danh mục không tìm thấy: " + testCategoryId));
//
//        Chapter chapter = null;
//        if (chapterId != null) {
//            chapter = chapterRepository.findById(chapterId)
//                    .orElseThrow(() -> new IllegalArgumentException("Chương không tìm thấy: " + chapterId));
//            if (chapter.getSubject() == null) {
//                throw new IllegalArgumentException("Chương không thuộc về môn học nào.");
//            }
//        }
//        Subject subject = null;
//        if (subjectId != null) {
//            subject = subjectRepository.findById(subjectId)
//                    .orElseThrow(() -> new IllegalArgumentException("Môn học không tìm thấy: " + subjectId));
//        }
//
//        // Create Test
//        Test test = Test.builder()
//                .testName(testName)
//                .durationTime(durationTime)
//                .startAt(startAt)
//                .endAt(endAt)
//                .testStatus(testStatus)
//                .testCategory(testCategory)
//                .chapter(chapter)
//                .subject(subject)
//                .build();
//        test = testRepository.save(test);
//
//        // Link to Subject
//        if (subjectId != null) {
//
//            SubjectTest subjectTest = SubjectTest.builder()
//                    .test(test)
//                    .subject(subject)
//                    .build();
//            subjectTestRepository.save(subjectTest);
//        }
//
//        // Link to Questions
//        for (Long questionId : questionIds) {
//            QuestionBank question = questionBankRepository.findById(questionId)
//                    .orElseThrow(() -> new IllegalArgumentException("Câu hỏi không tìm thấy: " + questionId));
//            QuestionTest questionTest = QuestionTest.builder()
//                    .test(test)
//                    .question(question)
//                    .build();
//            questionTestRepository.save(questionTest);
//        }
//
//        return test;
//    }

    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
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
                                new TypeReference<List<AnswerOptionDto>>() {}
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
                .startAt(test.getStartAt() != null ? test.getStartAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")) : null)
                .endAt(test.getEndAt() != null ? test.getEndAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")) : null)
                .statusId(test.getTestStatus() != null ? test.getTestStatus().getTestStatusId() : null)
                .statusName(test.getTestStatus() != null ? test.getTestStatus().getTestStatusName() : "Chưa xác định")
                .isOpen(test.getIsOpen() != null ? test.getIsOpen() : false)
                .categoryId(test.getTestCategory() != null ? test.getTestCategory().getTestCategoryId() : null)
                .categoryName(test.getTestCategory() != null ? test.getTestCategory().getName() : "Chưa xác định")
                .questions(questions)
                .build();
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
    @Transactional
    public Test createTest(String testName, Integer durationTime, LocalDateTime startAt, LocalDateTime endAt,
                           Long testStatusId, Long testCategoryId, Long subjectId, Long chapterId, Long lessonId,
                           List<Long> questionIds, Boolean isOpen, boolean isDraft) {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
        }

        // Validate mandatory fields
        if (testName == null || testName.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên bài kiểm tra là bắt buộc.");
        }
        if (durationTime == null || durationTime < 1) {
            throw new IllegalArgumentException("Thời gian phải lớn hơn 0 phút.");
        }
        if (startAt == null) {
            throw new IllegalArgumentException("Thời gian bắt đầu là bắt buộc.");
        }
        if (endAt == null) {
            throw new IllegalArgumentException("Thời gian kết thúc là bắt buộc.");
        }
        if (endAt.isBefore(startAt) || endAt.isEqual(startAt)) {
            throw new IllegalArgumentException("Thời gian kết thúc phải sau thời gian bắt đầu.");
        }
        if (testStatusId == null) {
            throw new IllegalArgumentException("Trạng thái là bắt buộc.");
        }
        if (testCategoryId == null) {
            throw new IllegalArgumentException("Danh mục là bắt buộc.");
        }
        if (subjectId == null && chapterId == null && lessonId == null) {
            throw new IllegalArgumentException("Phải chọn ít nhất một môn học, chương hoặc bài học.");
        }
        if (questionIds == null || questionIds.isEmpty()) {
            throw new IllegalArgumentException("Phải chọn ít nhất một câu hỏi.");
        }

        // Validate entities
        TestStatus testStatus = testStatusRepository.findById(testStatusId)
                .orElseThrow(() -> new IllegalArgumentException("Trạng thái không tìm thấy: " + testStatusId));
        TestCategory testCategory = testCategoryRepository.findById(testCategoryId)
                .orElseThrow(() -> new IllegalArgumentException("Danh mục không tìm thấy: " + testCategoryId));

        Subject subject = null;
        if (subjectId != null) {
            subject = subjectRepository.findById(subjectId)
                    .orElseThrow(() -> new IllegalArgumentException("Môn học không tìm thấy: " + subjectId));
        }

        Chapter chapter = null;
        if (chapterId != null) {
            chapter = chapterRepository.findById(chapterId)
                    .orElseThrow(() -> new IllegalArgumentException("Chương không tìm thấy: " + chapterId));
            if (chapter.getSubject() == null) {
                throw new IllegalArgumentException("Chương không thuộc về môn học nào.");
            }
        }

        Lesson lesson = null;
        if (lessonId != null) {
            lesson = lessonRepository.findById(lessonId)
                    .orElseThrow(() -> new IllegalArgumentException("Bài học không tìm thấy: " + lessonId));
            if (lesson.getChapter() == null) {
                throw new IllegalArgumentException("Bài học không thuộc về chương nào.");
            }
        }

        // Create Test
        Test test = Test.builder()
                .testName(testName)
                .durationTime(durationTime)
                .startAt(startAt)
                .endAt(endAt)
                .isOpen(isOpen != null ? isOpen : false)
                .testStatus(testStatus)
                .testCategory(testCategory)
                .chapter(chapter)
                .subject(subject)
                .lesson(lesson)
                .build();
        test = testRepository.save(test);

        // Link to Subject
        if (subjectId != null) {
            SubjectTest subjectTest = SubjectTest.builder()
                    .test(test)
                    .subject(subject)
                    .build();
            subjectTestRepository.save(subjectTest);
        }

        // Link to Questions
        for (Long questionId : questionIds) {
            QuestionBank question = questionBankRepository.findById(questionId)
                    .orElseThrow(() -> new IllegalArgumentException("Câu hỏi không tìm thấy: " + questionId));
            QuestionTest questionTest = QuestionTest.builder()
                    .test(test)
                    .question(question)
                    .build();
            questionTestRepository.save(questionTest);
        }

        return test;
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @Transactional
    public void approveTest(Long testId) {
        Test test = testRepository.findById(testId)
                .orElseThrow(() -> new IllegalArgumentException("Bài kiểm tra không tìm thấy: " + testId));
        TestStatus approvedStatus = testStatusRepository.findByTestStatusName("Chấp nhận")
                .orElseThrow(() -> new IllegalArgumentException("Trạng thái 'Chấp nhận' không tồn tại."));
        test.setTestStatus(approvedStatus);
        test.setIsOpen(true); // Automatically open the test upon approval
        testRepository.save(test);
    }

    @PreAuthorize("hasAnyRole('ADMIN')")
    @Transactional
    public void rejectTest(Long testId) {
        Test test = testRepository.findById(testId)
                .orElseThrow(() -> new IllegalArgumentException("Bài kiểm tra không tìm thấy: " + testId));
        TestStatus rejectedStatus = testStatusRepository.findByTestStatusName("Từ chối")
                .orElseThrow(() -> new IllegalArgumentException("Trạng thái 'Từ chối' không tồn tại."));
        test.setTestStatus(rejectedStatus);
        test.setIsOpen(false); // Automatically close the test upon rejection
        testRepository.save(test);
    }

    // Add method to find TestStatus by name
    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
    public TestStatus findTestStatusByName(String statusName) {
        return testStatusRepository.findByTestStatusName(statusName)
                .orElseThrow(() -> new IllegalArgumentException("Trạng thái '" + statusName + "' không tồn tại."));
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'STAFF')")
    public Page<TestListDto> findTestsByCreatorAndFilters(Long creatorUserId, Long subjectId, Long chapterId,
                                                          LocalDateTime startAt, LocalDateTime endAt, Pageable pageable) {
        Specification<Test> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            // Filter by subjectId via SubjectTest
            if (subjectId != null) {
                Join<Test, SubjectTest> subjectTestJoin = root.join("subjectTests", JoinType.LEFT);
                predicates.add(cb.equal(subjectTestJoin.get("subject").get("subjectId"), subjectId));
            }

            // Filter by chapterId
            if (chapterId != null) {
                predicates.add(cb.equal(root.get("chapter").get("chapterId"), chapterId));
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

            // Sort by testId descending
            query.orderBy(cb.desc(root.get("testId")));

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<Test> testPage = testRepository.findAll(spec, pageable);

        return testPage.map(test -> TestListDto.builder()
                .testId(test.getTestId())
                .testName(test.getTestName())
                .durationTime(test.getDurationTime())
                .startAt(test.getStartAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")))
                .endAt(test.getEndAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")))
                .statusName(test.getTestStatus() != null ? test.getTestStatus().getTestStatusName() : "Chưa xác định")
                .categoryName(test.getTestCategory() != null ? test.getTestCategory().getName() : "Chưa xác định")
                .chapterName(test.getChapter() != null ? test.getChapter().getChapterName() : null)
                .subjectName(test.getSubject() != null ? test.getSubject().getSubjectName() : null)
                .build());
    }

    @PreAuthorize("hasAnyRole('STAFF', 'ADMIN')")
    public Test createTestForLesson(String testName, Long testStatusId, Long testCategoryId, Long subjectId, Long chapterId, List<Long> questionIds) {
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null) {
            throw new IllegalStateException("Không thể xác định người dùng hiện tại.");
        }

        // Validate mandatory fields
        if (testName == null || testName.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên bài kiểm tra là bắt buộc.");
        }
        if (testStatusId == null) {
            throw new IllegalArgumentException("Trạng thái là bắt buộc.");
        }
        if (testCategoryId == null) {
            throw new IllegalArgumentException("Danh mục là bắt buộc.");
        }
        if (subjectId == null && chapterId == null) {
            throw new IllegalArgumentException("Phải chọn ít nhất một môn học hoặc chương.");
        }

        // Validate entities
        TestStatus testStatus = testStatusRepository.findById(testStatusId)
                .orElseThrow(() -> new IllegalArgumentException("Trạng thái không tìm thấy: " + testStatusId));
        TestCategory testCategory = testCategoryRepository.findById(testCategoryId)
                .orElseThrow(() -> new IllegalArgumentException("Danh mục không tìm thấy: " + testCategoryId));

        Chapter chapter = null;
        if (chapterId != null) {
            chapter = chapterRepository.findById(chapterId)
                    .orElseThrow(() -> new IllegalArgumentException("Chương không tìm thấy: " + chapterId));
            if (chapter.getSubject() == null) {
                throw new IllegalArgumentException("Chương không thuộc về môn học nào.");
            }
        }
        Subject subject = null;
        if (subjectId != null) {
            subject = subjectRepository.findById(subjectId)
                    .orElseThrow(() -> new IllegalArgumentException("Môn học không tìm thấy: " + subjectId));
        }

        // Create Test
        Test test = Test.builder()
                .testName(testName)
                .durationTime(null)
                .startAt(null)
                .endAt(null)
                .testStatus(testStatus)
                .testCategory(testCategory)
                .chapter(chapter)
                .subject(subject)
                .build();
        test = testRepository.save(test);

        // Link to Subject
        if (subjectId != null) {
            SubjectTest subjectTest = SubjectTest.builder()
                    .test(test)
                    .subject(subject)
                    .build();
            subjectTestRepository.save(subjectTest);
        }

        // Link to Questions
        if (questionIds != null && !questionIds.isEmpty()) {
            for (Long questionId : questionIds) {
                QuestionBank question = questionBankRepository.findById(questionId)
                        .orElseThrow(() -> new IllegalArgumentException("Câu hỏi không tìm thấy: " + questionId));
                QuestionTest questionTest = QuestionTest.builder()
                        .test(test)
                        .question(question)
                        .build();
                questionTestRepository.save(questionTest);
            }
        }

        return test;
    }




}