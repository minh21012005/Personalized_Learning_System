package swp.se1941jv.pls.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import swp.se1941jv.pls.config.SecurityUtils;

import swp.se1941jv.pls.dto.request.AnswerOptionDto;
import swp.se1941jv.pls.dto.response.practice.QuestionAnswerResDTO;
import swp.se1941jv.pls.dto.response.practice.QuestionDisplayDto;
import swp.se1941jv.pls.dto.response.tests.TestHistoryDTO;
import swp.se1941jv.pls.dto.response.tests.TestHistoryListDTO;
import swp.se1941jv.pls.dto.response.tests.TestSubmissionDto;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.repository.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TestStudentService {

    TestRepository testRepository;
    UserTestRepository userTestRepository;
    QuestionTestRepository questionTestRepository;
    AnswerHistoryTestRepository answerHistoryTestRepository;
    QuestionBankRepository questionBankRepository;
    PackageRepository packageRepository;
    UserRepository userRepository;
    QuestionService questionService;
    ObjectMapper objectMapper;

    @PreAuthorize("hasAnyRole('STUDENT')")
    public Map<String, Object> startOrResumeTest(Long testId, Long packageId, Long userId) {
        Test test = testRepository.findById(testId)
                .orElseThrow(() -> new IllegalArgumentException("Bài kiểm tra không tìm thấy: " + testId));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Người dùng không tìm thấy: " + userId));

        Package currentPkg = packageId != null ? packageRepository.findById(packageId).orElseThrow(
                () -> new IllegalArgumentException("Gói bài kiểm tra không tìm thấy: " + packageId)
        ) : null;

        List<Package> packages = new ArrayList<>();
        user.getUserPackages().stream()
                .forEach(up -> {
                    if (up.getEndDate() != null && up.getEndDate().isAfter(LocalDateTime.now())) packages.add(up.getPkg());
                });

        if (packages.stream().noneMatch(pkg -> pkg.getPackageId().equals(packageId))) {
            throw new IllegalStateException("Người dùng không có quyền truy cập vào gói bài kiểm tra này.");
        }

        List<Subject> subjects = currentPkg.getPackageSubjects().stream().map(PackageSubject::getSubject).collect(Collectors.toList());
        if (!subjects.contains(test.getSubject())) {
            throw new IllegalStateException("Bài kiểm tra không thuộc về gói bài kiểm tra này.");
        }

        if( !test.getIsOpen()) {
            throw new IllegalStateException("Bài kiểm tra đã đóng.");
        }

        // Kiểm tra thời gian hợp lệ
        LocalDateTime now = LocalDateTime.now();
        if (test.getStartAt() != null && test.getEndAt() != null && (now.isBefore(test.getStartAt()) || now.isAfter(test.getEndAt()))) {
            throw new IllegalStateException("Bài kiểm tra không thể thực hiện vào thời điểm này.");
        }

        List<UserTest> userTests = userTestRepository.findByTestIdUserId(testId, userId);

        if (test.getMaxAttempts() != null && userTests.size() >= test.getMaxAttempts()) {
            throw new IllegalStateException("Bạn đã vượt quá số lần làm bài kiểm tra tối đa cho bài kiểm tra này.");
        }



        UserTest newUserTest = UserTest.builder()
                .test(test)
                .user(user)
                .timeStart(LocalDateTime.now()) // Reset thời gian bắt đầu
                .totalQuestions((int) questionTestRepository.countByTestId(testId))
                .correctAnswers(0)
                .pkg(currentPkg)
                .build();
        UserTest userTest = userTestRepository.save(newUserTest);


        // Kiểm tra thời gian còn lại
        LocalDateTime endTime = userTest.getTimeStart().plusMinutes(test.getDurationTime());
        if (LocalDateTime.now().isAfter(endTime)) {
            submitTestAutomatically(userTest);
            throw new IllegalStateException("Thời gian làm bài đã hết.");
        }

        long remainingTime = java.time.Duration.between(LocalDateTime.now(), endTime).getSeconds();

        // Tải danh sách câu hỏi
        List<QuestionTest> questionTests = questionTestRepository.findByTestId(testId);
        List<QuestionDisplayDto> questions = questionTests.stream()
                .map(qt -> {
                    QuestionBank q = qt.getQuestion();
                    try {
                        List<AnswerOptionDto> options = questionService.getQuestionOptions(q);
                        return QuestionDisplayDto.builder()
                                .questionId(q.getQuestionId())
                                .content(q.getContent())
                                .image(q.getImage())
                                .options(options.stream().map(AnswerOptionDto::getText).collect(Collectors.toList()))
                                .build();
                    } catch (Exception e) {
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        // Lấy đáp án tạm thời từ AnswerHistoryTest
        List<AnswerHistoryTest> tempAnswers = answerHistoryTestRepository.findByUserTestId(userTest.getUserTestId());
        Map<Long, List<String>> savedAnswers = tempAnswers.stream()
                .collect(Collectors.toMap(
                        ta -> ta.getQuestion().getQuestionId(),
                        ta -> {
                            try {
                                return objectMapper.readValue(ta.getAnswer(), new TypeReference<List<String>>() {
                                });
                            } catch (Exception e) {
                                return new ArrayList<>();
                            }
                        }
                ));

        Map<String, Object> data = new HashMap<>();
        data.put("questions", questions);
        data.put("remainingTime", remainingTime);
        data.put("userTestId", userTest.getUserTestId());
        data.put("testName", test.getTestName());
        data.put("savedAnswers", savedAnswers);
        return data;
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public Map<String, Object> getTestData(Long userTestId, Long userId) {
        UserTest userTest = userTestRepository.findById(userTestId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy dữ liệu bài kiểm tra: " + userTestId));
        if (!userTest.getUser().getUserId().equals(userId)) {
            throw new IllegalStateException("Bạn không có quyền truy cập bài kiểm tra này.");
        }
        if (userTest.getTimeEnd() != null) {
            throw new IllegalStateException("Bài kiểm tra đã được nộp.");
        }

        Test test = userTest.getTest();
        if (!test.getIsOpen()) {
            throw new IllegalStateException("Bài kiểm tra đã đóng.");
        }

        LocalDateTime now = LocalDateTime.now();
        if (test.getStartAt() != null && test.getEndAt() != null && (now.isBefore(test.getStartAt()) || now.isAfter(test.getEndAt()))) {
            throw new IllegalStateException("Bài kiểm tra không thể thực hiện vào thời điểm này.");
        }

        LocalDateTime endTime = userTest.getTimeStart().plusMinutes(test.getDurationTime());
        if (LocalDateTime.now().isAfter(endTime)) {
            submitTestAutomatically(userTest);
            throw new IllegalStateException("Thời gian làm bài đã hết.");
        }

        long remainingTime = java.time.Duration.between(LocalDateTime.now(), endTime).getSeconds();

        List<QuestionTest> questionTests = questionTestRepository.findByTestId(test.getTestId());
        List<QuestionDisplayDto> questions = questionTests.stream()
                .map(qt -> {
                    QuestionBank q = qt.getQuestion();
                    try {
                        List<AnswerOptionDto> options = questionService.getQuestionOptions(q);
                        return QuestionDisplayDto.builder()
                                .questionId(q.getQuestionId())
                                .content(q.getContent())
                                .image(q.getImage())
                                .options(options.stream().map(AnswerOptionDto::getText).collect(Collectors.toList()))
                                .build();
                    } catch (Exception e) {
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        List<AnswerHistoryTest> tempAnswers = answerHistoryTestRepository.findByUserTestId(userTestId);
        Map<Long, List<String>> savedAnswers = tempAnswers.stream()
                .collect(Collectors.toMap(
                        ta -> ta.getQuestion().getQuestionId(),
                        ta -> {
                            try {
                                return objectMapper.readValue(ta.getAnswer(), new TypeReference<List<String>>() {
                                });
                            } catch (Exception e) {
                                return new ArrayList<>();
                            }
                        }
                ));

        Map<String, Object> data = new HashMap<>();
        data.put("testId", test.getTestId());
        data.put("questions", questions);
        data.put("remainingTime", remainingTime);
        data.put("userTestId", userTestId);
        data.put("testName", test.getTestName());
        data.put("savedAnswers", savedAnswers);
        return data;
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public void saveTemporaryAnswers(Long userTestId, List<TestSubmissionDto.QuestionAnswer> answers) {
        UserTest userTest = userTestRepository.findById(userTestId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy dữ liệu bài kiểm tra."));

        // Xóa các đáp án cũ trong AnswerHistoryTest
        answerHistoryTestRepository.deleteByUserTestId(userTest.getUserTestId());

        // Tính số câu trả lời đúng
        AtomicInteger correctCount = new AtomicInteger(0);
        answers.forEach(answer -> {
            try {

                QuestionBank question = questionBankRepository.findById(answer.getQuestionId())
                        .orElseThrow(() -> new IllegalArgumentException("Câu hỏi không tìm thấy: " + answer.getQuestionId()));
                List<AnswerOptionDto> options;
                try {
                    options = questionService.getQuestionOptions(question);
                } catch (Exception e) {
                    throw new RuntimeException("Lỗi khi lấy đáp án.");
                }
                List<String> correctAnswers = options.stream()
                        .filter(AnswerOptionDto::isCorrect)
                        .map(AnswerOptionDto::getText)
                        .collect(Collectors.toList());
                boolean isCorrect = answer.getSelectedAnswers().size() == correctAnswers.size() &&
                        answer.getSelectedAnswers().containsAll(correctAnswers) &&
                        correctAnswers.containsAll(answer.getSelectedAnswers());
                if (isCorrect) correctCount.incrementAndGet();

                // Lưu đáp án vào AnswerHistoryTest
                answerHistoryTestRepository.save(AnswerHistoryTest.builder()
                        .userTest(userTest)
                        .question(question)
                        .answer(objectMapper.writeValueAsString(answer.getSelectedAnswers()))
                        .build());

            } catch (JsonProcessingException e) {
                throw new RuntimeException("Lỗi khi lưu đáp án tạm thời: " + e.getMessage());
            }
        });

        // Cập nhật số câu đúng vào UserTest
        userTest.setCorrectAnswers(correctCount.get());
        userTestRepository.save(userTest);
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public Map<String, Object> submitTest(Long userTestId, TestSubmissionDto submission) {
        UserTest userTest = userTestRepository.findById(userTestId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy dữ liệu bài kiểm tra."));

        if (userTest.getTimeEnd() != null) {
            throw new IllegalStateException("Bài kiểm tra đã được nộp.");
        }

        // Xóa các đáp án cũ trong AnswerHistoryTest
        answerHistoryTestRepository.deleteByUserTestId(userTest.getUserTestId());

        AtomicInteger correctCount = new AtomicInteger(0);
        List<QuestionAnswerResDTO> results = submission.getAnswers().stream()
                .map(answer -> {
                    QuestionBank question = questionBankRepository.findById(answer.getQuestionId())
                            .orElseThrow(() -> new IllegalArgumentException("Câu hỏi không tìm thấy: " + answer.getQuestionId()));
                    List<AnswerOptionDto> options;
                    try {
                        options = questionService.getQuestionOptions(question);
                    } catch (Exception e) {
                        throw new RuntimeException("Lỗi khi lấy đáp án.");
                    }
                    List<String> correctAnswers = options.stream()
                            .filter(AnswerOptionDto::isCorrect)
                            .map(AnswerOptionDto::getText)
                            .collect(Collectors.toList());
                    List<String> selected = answer.getSelectedAnswers() != null ? answer.getSelectedAnswers() : new ArrayList<>();
                    boolean isCorrect = selected.size() == correctAnswers.size() &&
                            selected.containsAll(correctAnswers) && correctAnswers.containsAll(selected);
                    if (isCorrect) correctCount.incrementAndGet();

                    try {
                        answerHistoryTestRepository.save(AnswerHistoryTest.builder()
                                .userTest(userTest)
                                .question(question)
                                .answer(objectMapper.writeValueAsString(selected))
                                .build());
                    } catch (JsonProcessingException e) {
                        throw new RuntimeException("Lỗi khi lưu đáp án.");
                    }

                    return QuestionAnswerResDTO.builder()
                            .questionId(answer.getQuestionId())
                            .content(question.getContent())
                            .image(question.getImage())
                            .selectedAnswers(selected)
                            .correctAnswers(correctAnswers)
                            .answerOptions(options.stream().map(AnswerOptionDto::getText).collect(Collectors.toList()))
                            .isCorrect(isCorrect)
                            .build();
                }).collect(Collectors.toList());

        userTest.setCorrectAnswers(correctCount.get());
        userTest.setTimeEnd(LocalDateTime.now());
        userTestRepository.save(userTest);

        Map<String, Object> result = new HashMap<>();
        result.put("results", results);
        result.put("correctCount", correctCount.get());
        result.put("totalQuestions", userTest.getTotalQuestions());
        return result;
    }

    private void submitTestAutomatically(UserTest userTest) {
        Long userId = userTest.getUser().getUserId();
        Long testId = userTest.getTest().getTestId();
        List<AnswerHistoryTest> tempAnswers = answerHistoryTestRepository.findByUserTestId(userTest.getUserTestId());
        List<TestSubmissionDto.QuestionAnswer> answers = tempAnswers.stream()
                .map(ta -> {
                    try {
                        return new TestSubmissionDto.QuestionAnswer(
                                ta.getQuestion().getQuestionId(),
                                objectMapper.readValue(ta.getAnswer(), new TypeReference<List<String>>() {
                                })
                        );
                    } catch (Exception e) {
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
        TestSubmissionDto submission = new TestSubmissionDto();
        submission.setTestId(testId);
        submission.setAnswers(answers);
        submitTest(userTest.getUserTestId(), submission);
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public Page<TestHistoryListDTO> getTestHistoryList(Long userId, LocalDate startDate, LocalDate endDate, int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        LocalDateTime startDateTime = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endDateTime = endDate != null ? endDate.atTime(LocalTime.MAX) : null;

        Page<UserTest> userTestPage = userTestRepository.findTestByUserIdAndDateRange(userId,1L, startDateTime, endDateTime, pageable);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
        List<TestHistoryListDTO> list = userTestPage.getContent().stream()
                .map(ut -> TestHistoryListDTO.builder()
                        .testId(ut.getTest().getTestId())
                        .testName(ut.getTest().getTestName())
                        .totalQuestions(ut.getTotalQuestions())
                        .correctAnswers(ut.getCorrectAnswers())
                        .startTime(ut.getTimeStart() != null ? ut.getTimeStart().format(formatter) : "")
                        .endTime(ut.getTimeEnd() != null ? ut.getTimeEnd().format(formatter) : "")
                        .userTestId(ut.getUserTestId())
                        .build())
                .collect(Collectors.toList());

        return new PageImpl<>(list, pageable, userTestPage.getTotalElements());
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public TestHistoryDTO getTestHistory(Long userTestId) {
        UserTest userTest = userTestRepository.findById(userTestId)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy lịch sử bài kiểm tra."));

        List<AnswerHistoryTest> answers = answerHistoryTestRepository.findByUserTestId(userTest.getUserTestId());
        List<QuestionAnswerResDTO> resDTOs = answers.stream()
                .map(a -> {
                    try {
                        QuestionBank q = a.getQuestion();
                        List<String> selected = objectMapper.readValue(a.getAnswer(), new TypeReference<List<String>>() {
                        });
                        List<AnswerOptionDto> options = questionService.getQuestionOptions(q);
                        List<String> correct = options.stream()
                                .filter(AnswerOptionDto::isCorrect)
                                .map(AnswerOptionDto::getText)
                                .collect(Collectors.toList());
                        boolean isCorrect = selected.size() == correct.size() &&
                                selected.containsAll(correct) && correct.containsAll(selected);
                        return QuestionAnswerResDTO.builder()
                                .questionId(q.getQuestionId())
                                .content(q.getContent())
                                .image(q.getImage())
                                .selectedAnswers(selected)
                                .correctAnswers(correct)
                                .answerOptions(options.stream().map(AnswerOptionDto::getText).collect(Collectors.toList()))
                                .isCorrect(isCorrect)
                                .build();
                    } catch (Exception e) {
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");
        return TestHistoryDTO.builder()
                .userTest(userTest)
                .testName(userTest.getTest().getTestName())
                .startTime(userTest.getTimeStart() != null ? userTest.getTimeStart().format(formatter) : "")
                .endTime(userTest.getTimeEnd() != null ? userTest.getTimeEnd().format(formatter) : "")
                .answers(resDTOs)
                .build();
    }
}