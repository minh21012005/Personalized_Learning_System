package swp.se1941jv.pls.service;

import com.fasterxml.jackson.core.JsonProcessingException;
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
import swp.se1941jv.pls.dto.response.*;
import swp.se1941jv.pls.dto.response.practice.*;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.entity.keys.KeyUserPackage;
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
public class PracticesService {

    UserPackageRepository userPackageRepository;
    SubjectRepository subjectRepository;
    QuestionBankRepository questionBankRepository;
    QuestionService questionService;
    TestRepository testRepository;
    UserTestRepository userTestRepository;
    QuestionTestRepository questionTestRepository;
    UserRepository userRepository;
    AnswerHistoryTestRepository answerHistoryTestRepository;
    ConfigRepository configRepository;
    NotificationService notificationService;

    ObjectMapper objectMapper;

    private static final String QUESTION_GENERATION_CONFIG_KEY = "questionPracticeGenerate";

    private static final int QUESTIONS_PER_SET = 5;


    @PreAuthorize("hasAnyRole('STUDENT')")
    public List<PackagePracticeDTO> getPackagePractices() {

        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return new ArrayList<>();
        }


        List<UserPackage> userPackages = userPackageRepository.findByIdUserId(userId);

        if (userPackages.isEmpty()) {
            return new ArrayList<>();
        }

        List<PackagePracticeDTO> packagePractices = new ArrayList<>();

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        userPackages.stream()
                .filter(userPackage -> {
                    LocalDateTime endDate = userPackage.getEndDate();
                    return endDate == null || !endDate.isBefore(now);
                })
                .forEach(userPackage -> {
                    PackagePracticeDTO packagePractice = PackagePracticeDTO.builder()
                            .packageId(userPackage.getPkg().getPackageId())
                            .name(userPackage.getPkg().getName())
                            .description(userPackage.getPkg().getDescription())
                            .imageUrl(userPackage.getPkg().getImage())
                            .startDate(userPackage.getStartDate() != null ? userPackage.getStartDate().format(formatter) : null)
                            .endDate(userPackage.getEndDate() != null ? userPackage.getEndDate().format(formatter) : null)
                            .build();
                    packagePractices.add(packagePractice);
                });


        return packagePractices;
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public PackagePracticeDTO getPackageDetail(Long packageId) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return null;
        }
        KeyUserPackage keyUserPackage = KeyUserPackage.builder()
                .userId(userId)
                .packageId(packageId)
                .build();

        UserPackage userPackage = userPackageRepository.findById(keyUserPackage).orElse(null);

        List<SubjectResponseDTO> subjectResponseDTOS = new ArrayList<>();

//        get subjects from userPackage
        if (userPackage != null) {
            userPackage.getPkg().getPackageSubjects().stream().forEach(packageSubject -> {
                SubjectResponseDTO subjectResponseDTO = SubjectResponseDTO.builder()
                        .subjectId(packageSubject.getSubject().getSubjectId())
                        .subjectName(packageSubject.getSubject().getSubjectName())
                        .subjectDescription(packageSubject.getSubject().getSubjectDescription())
                        .subjectImage(packageSubject.getSubject().getSubjectImage())
                        .build();
                subjectResponseDTOS.add(subjectResponseDTO);
            });
        }


        return userPackage != null ? PackagePracticeDTO.builder()
                .packageId(userPackage.getPkg().getPackageId())
                .name(userPackage.getPkg().getName())
                .description(userPackage.getPkg().getDescription())
                .imageUrl(userPackage.getPkg().getImage())
                .startDate(userPackage.getStartDate() != null ? userPackage.getStartDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : null)
                .endDate(userPackage.getEndDate() != null ? userPackage.getEndDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : null)
                .listSubject(subjectResponseDTOS)

                .build() : null;
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public SubjectResponseDTO getSubjectDetail(Long packageId, Long subjectId) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return null;
        }

        KeyUserPackage keyUserPackage = KeyUserPackage.builder()
                .userId(userId)
                .packageId(packageId)
                .build();

        UserPackage userPackage = userPackageRepository.findById(keyUserPackage).orElse(null);

        if (userPackage == null) {
            return null;
        }

        return userPackage.getPkg().getPackageSubjects().stream()
                .filter(packageSubject -> packageSubject.getSubject().getSubjectId().equals(subjectId))
                .map(packageSubject -> SubjectResponseDTO.builder()
                        .subjectId(packageSubject.getSubject().getSubjectId())
                        .subjectName(packageSubject.getSubject().getSubjectName())
                        .subjectDescription(packageSubject.getSubject().getSubjectDescription())
                        .subjectImage(packageSubject.getSubject().getSubjectImage())
                        .build())
                .findFirst()
                .orElse(null);
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public List<ChapterResponseDTO> getChapters(Long subjectId) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return new ArrayList<>();
        }

        Subject subject = subjectRepository.findById(subjectId).orElse(null);

        List<ChapterResponseDTO> chapterResponseDTOS = new ArrayList<>();

        if (subject != null) {
            chapterResponseDTOS = subject.getChapters().stream()
                    .map(chapter -> ChapterResponseDTO.builder()
                            .chapterId(chapter.getChapterId())
                            .chapterName(chapter.getChapterName())
                            .chapterDescription(chapter.getChapterDescription())
                            .listLesson(chapter.getLessons().stream().map(lesson -> LessonResponseDTO.builder()
                                    .lessonId(lesson.getLessonId())
                                    .lessonName(lesson.getLessonName())
                                    .lessonDescription(lesson.getLessonDescription())
                                    .build()).collect(Collectors.toList()))

                            .build())
                    .collect(Collectors.toList());
        }


        return chapterResponseDTOS;
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public List<QuestionDisplayDto> generateQuestionsFirst(List<Long> lessonIds) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return new ArrayList<>();
        }

        // Fetch questions from the question bank based on lesson IDs
        List<QuestionBank> questions = questionBankRepository.findByLessonIdsIn(lessonIds);

        // Shuffle the questions to randomize them
        Collections.shuffle(questions);

        // Limit to the specified number of questions
        List<QuestionBank> selectedQuestions = questions.stream().limit(5).collect(Collectors.toList());

        return selectedQuestions.stream()
                .map(question -> {
                    try {
                        return QuestionDisplayDto.builder()
                                .questionId(question.getQuestionId())
                                .content(question.getContent())
                                .image(question.getImage())
                                .options(questionService.getQuestionOptions(question).stream()
                                        .map(AnswerOptionDto::getText)
                                        .collect(Collectors.toList()))
                                .build();
                    } catch (Exception e) {
                        // Log the error and return a default DTO or handle appropriately
                        return QuestionDisplayDto.builder()
                                .questionId(question.getQuestionId())
                                .content("Error loading question")
                                .image(null)
                                .options(new ArrayList<>())
                                .build();
                    }
                })
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public List<QuestionAnswerResDTO> checkResults(PracticeSubmissionDto submission, Long testId) {

        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return new ArrayList<>();
        }

        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found: " + userId));

        UserTest userTest = userTestRepository.findByTestIdUserId(testId, userId);

        AtomicInteger correctAnswersCount = new AtomicInteger();


        List<QuestionAnswerResDTO> questionAnswerResDTOS = new ArrayList<>();
        if (submission.getAnswers() != null) {
            submission.getAnswers().stream().forEach(questionAnswer -> {


                QuestionBank question = questionBankRepository.findById(questionAnswer.getQuestionId()).orElseThrow(() -> new RuntimeException("Question not found: " + questionAnswer.getQuestionId()));

                List<AnswerOptionDto> allOptions;
                try {
                    allOptions = questionService.getQuestionOptions(question);
                } catch (Exception e) {
                    throw new RuntimeException("Error fetching options for question: " + questionAnswer.getQuestionId(), e);
                }

                List<String> correctAnswers = allOptions.stream()
                        .filter(AnswerOptionDto::isCorrect)
                        .map(AnswerOptionDto::getText)
                        .collect(Collectors.toList());
                List<String> listAnswerSelected = questionAnswer.getSelectedAnswers();


                try {
                    answerHistoryTestRepository.save(AnswerHistoryTest.builder()
                            .question(question)
                            .userTest(userTest)
                            .answer(new ObjectMapper().writeValueAsString(listAnswerSelected))

                            .build());
                } catch (JsonProcessingException e) {
                    throw new RuntimeException(e);
                }


                boolean isCorrect = (listAnswerSelected != null) && (correctAnswers != null) && correctAnswers.containsAll(listAnswerSelected) && listAnswerSelected.containsAll(correctAnswers);
                if (isCorrect) {
                    correctAnswersCount.getAndIncrement();
                }

                QuestionAnswerResDTO questionAnswerResDTO = QuestionAnswerResDTO.builder()
                        .questionId(questionAnswer.getQuestionId())
                        .isCorrect(isCorrect)
                        .content(question.getContent())
                        .image(question.getImage())
                        .selectedAnswers(listAnswerSelected)
                        .correctAnswers(correctAnswers)
                        .answerOptions(allOptions.stream().map(AnswerOptionDto::getText).collect(Collectors.toList()))
                        .build();
                questionAnswerResDTOS.add(questionAnswerResDTO);


            });
        }

        // Update user test with the total correct answers
        userTest.setCorrectAnswers(userTest.getCorrectAnswers() + correctAnswersCount.get());
        userTest.setTimeEnd(LocalDateTime.now());
        userTestRepository.save(userTest);

        return questionAnswerResDTOS;
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public PracticeResponseDTO startPracticeWithLessons(List<Long> lessonIds) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return null;
        }

        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found: " + userId));

        // Generate initial 5 random questions
        List<QuestionDisplayDto> initialQuestions = generateQuestionsFirst(lessonIds);

        Test test = Test.builder()
                .startAt(LocalDateTime.now())
                .endAt(LocalDateTime.now())
                .testName("Practice Test - " + user.getFullName() + " - " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")))
                .build();
        test = testRepository.save(test);

        Test finalTest = test;
        userTestRepository.save(UserTest.builder()
                .test(finalTest)
                .timeStart(LocalDateTime.now())
                .timeEnd(LocalDateTime.now())
                .totalQuestions(initialQuestions.size())
                .correctAnswers(0) // Initially, no answers are correct
                .user(user)
                .build());
        initialQuestions.stream().forEach(question -> {
            QuestionBank questionBank = questionBankRepository.findById(question.getQuestionId())
                    .orElseThrow(() -> new RuntimeException("Question not found: " + question.getQuestionId()));

            QuestionTest questionTest = QuestionTest.builder()
                    .test(finalTest)
                    .question(questionBank)
                    .build();
            questionTestRepository.save(questionTest);
        });

        // Create a new practice response DTO
        PracticeResponseDTO practiceResponseDTO = PracticeResponseDTO.builder()
                .testId(test.getTestId())
                .userId(userId)
                .selectedLessonId(lessonIds != null ? lessonIds.stream().map(String::valueOf).collect(Collectors.joining(",")) : "")
                .questions(initialQuestions)
                .build();

        return practiceResponseDTO;
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public List<QuestionDisplayDto> generateNextQuestions(List<Long> lessonIds, Integer correctCount) {
        return generateQuestions(lessonIds, correctCount);
    }

    private List<QuestionDisplayDto> generateQuestions(List<Long> lessonIds, Integer correctCount) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null || lessonIds == null || lessonIds.isEmpty()) {
            return new ArrayList<>();
        }

        // Load configuration
        QuestionGenerationConfigDto config = loadGenerationConfig();
        Map<String, Integer> levelDistribution = getLevelDistribution(config, correctCount);

        // Generate questions based on level distribution
        List<QuestionBank> selectedQuestions = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : levelDistribution.entrySet()) {
            String level = entry.getKey();
            int count = entry.getValue();
            if (count > 0) {
                List<QuestionBank> questions = questionBankRepository
                        .findByLessonLessonIdInAndLevelQuestionLevelName(lessonIds, level);
                Collections.shuffle(questions);
                selectedQuestions.addAll(questions.stream().limit(count).toList());
            }
        }

        // Fallback: If not enough questions, fill with any active questions
        if (selectedQuestions.size() < QUESTIONS_PER_SET) {
            List<QuestionBank> fallbackQuestions = questionBankRepository.findByLessonIdsIn(lessonIds);
            Collections.shuffle(fallbackQuestions);
            int remaining = QUESTIONS_PER_SET - selectedQuestions.size();
            selectedQuestions.addAll(fallbackQuestions.stream()
                    .filter(q -> !selectedQuestions.contains(q))
                    .limit(remaining)
                    .toList());
        }

        // Shuffle the final set
        Collections.shuffle(selectedQuestions);

        return selectedQuestions.stream()
                .map(question -> {
                    try {
                        return QuestionDisplayDto.builder()
                                .questionId(question.getQuestionId())
                                .content(question.getContent())
                                .image(question.getImage())
                                .options(questionService.getQuestionOptions(question).stream()
                                        .map(AnswerOptionDto::getText)
                                        .collect(Collectors.toList()))
                                .build();
                    } catch (Exception e) {
                        return QuestionDisplayDto.builder()
                                .questionId(question.getQuestionId())
                                .content("Error loading question")
                                .image(null)
                                .options(new ArrayList<>())
                                .build();
                    }
                })
                .collect(Collectors.toList());
    }

    private QuestionGenerationConfigDto loadGenerationConfig() {
        Config config = configRepository.findByConfigKey(QUESTION_GENERATION_CONFIG_KEY)
                .orElseThrow(() -> new RuntimeException("Configuration not found: " + QUESTION_GENERATION_CONFIG_KEY));
        try {
            ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue(config.getConfigValue(), QuestionGenerationConfigDto.class);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to parse question generation config", e);
        }
    }

    private Map<String, Integer> getLevelDistribution(QuestionGenerationConfigDto config, Integer correctCount) {
        // Default distribution: all EASY
        Map<String, Integer> defaultDistribution = new HashMap<>();
        defaultDistribution.put("Dễ", QUESTIONS_PER_SET);
        defaultDistribution.put("Trung bình", 0);
        defaultDistribution.put("Khó", 0);

        if (config == null || config.getRules() == null) {
            return defaultDistribution;
        }

        for (QuestionGenerationConfigDto.Rule rule : config.getRules()) {
            if (correctCount >= rule.getCorrectCountMin() && correctCount <= rule.getCorrectCountMax()) {
                return rule.getLevels();
            }
        }

        return defaultDistribution;
    }


    @PreAuthorize("hasAnyRole('STUDENT')")
    public PracticeResponseDTO continuePracticeWithLessons(List<Long> lessonIds, Long testId, Integer correctCount) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return null;
        }

        UserTest userTest = userTestRepository.findByTestIdUserId(testId, userId);
        userTest.setTimeEnd(LocalDateTime.now());
        userTest.setTotalQuestions(userTest.getTotalQuestions() + QUESTIONS_PER_SET);
        userTestRepository.save(userTest);

        List<QuestionDisplayDto> nextQuestions = generateNextQuestions(lessonIds, correctCount);
        Test test = testRepository.findById(testId)
                .orElseThrow(() -> new RuntimeException("Test not found: " + testId));

        nextQuestions.forEach(question -> {
            QuestionBank questionBank = questionBankRepository.findById(question.getQuestionId())
                    .orElseThrow(() -> new RuntimeException("Question not found: " + question.getQuestionId()));

            QuestionTest questionTest = QuestionTest.builder()
                    .test(test)
                    .question(questionBank)
                    .build();
            questionTestRepository.save(questionTest);
        });

        return PracticeResponseDTO.builder()
                .testId(test.getTestId())
                .userId(userId)
                .selectedLessonId(lessonIds != null ? lessonIds.stream().map(String::valueOf).collect(Collectors.joining(",")) : "")
                .questions(nextQuestions)
                .build();
    }


    @PreAuthorize("hasAnyRole('STUDENT')")
    public TestHistoryDTO getTestHistory(Long testId) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            throw new RuntimeException("Không thể xác định người dùng hiện tại.");
        }

        UserTest userTest = userTestRepository.findByTestIdUserId(testId, userId);
        if (userTest == null) {
            throw new RuntimeException("Không tìm thấy lịch sử bài kiểm tra.");
        }

        List<AnswerHistoryTest> answerHistoryTests = answerHistoryTestRepository.findByUserTestId(userTest.getUserTestId());
        List<QuestionAnswerResDTO> answers = answerHistoryTests.stream().map(answerHistory -> {
            try {
                QuestionBank question = answerHistory.getQuestion();
                List<String> selectedAnswers = objectMapper.readValue(answerHistory.getAnswer(), List.class);
                List<AnswerOptionDto> allOptions = questionService.getQuestionOptions(question);
                List<String> correctAnswers = allOptions.stream()
                        .filter(AnswerOptionDto::isCorrect)
                        .map(AnswerOptionDto::getText)
                        .collect(Collectors.toList());
                boolean isCorrect = (selectedAnswers != null && correctAnswers != null) &&
                        correctAnswers.containsAll(selectedAnswers) && selectedAnswers.containsAll(correctAnswers);

                return QuestionAnswerResDTO.builder()
                        .questionId(question.getQuestionId())
                        .content(question.getContent())
                        .image(question.getImage())
                        .selectedAnswers(selectedAnswers)
                        .correctAnswers(correctAnswers)
                        .answerOptions(allOptions.stream().map(AnswerOptionDto::getText).collect(Collectors.toList()))
                        .isCorrect(isCorrect)
                        .build();
            } catch (Exception e) {
                return QuestionAnswerResDTO.builder()
                        .questionId(answerHistory.getQuestion().getQuestionId())
                        .content("Error loading answer")
                        .image(null)
                        .selectedAnswers(new ArrayList<>())
                        .correctAnswers(new ArrayList<>())
                        .answerOptions(new ArrayList<>())
                        .isCorrect(false)
                        .build();
            }
        }).collect(Collectors.toList());


        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss dd/MM/yyyy");

        return TestHistoryDTO.builder()
                .userTest(userTest)
                .testName(userTest.getTest().getTestName())
                .startTime(userTest.getTimeStart() != null ? userTest.getTimeStart().format(formatter) : "")
                .endTime(userTest.getTimeEnd() != null ? userTest.getTimeEnd().format(formatter) : "")
                .answers(answers)
                .build();
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    public Page<TestHistoryListDTO> getTestHistoryList(Long userId, LocalDate startDate, LocalDate endDate, int page, int size) {
        if (userId == null) {
            throw new RuntimeException("Không thể xác định người dùng hiện tại.");
        }
        Pageable pageable = PageRequest.of(page, size);

        // Chuyển LocalDate thành LocalDateTime
        LocalDateTime startDateTime = startDate != null ? startDate.atStartOfDay() : null;
        LocalDateTime endDateTime = endDate != null ? endDate.atTime(LocalTime.MAX) : null;

        Page<UserTest> userTestPage = userTestRepository.findByUserIdAndDateRange(userId, startDateTime, endDateTime, pageable);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
        List<TestHistoryListDTO> testHistoryList = userTestPage.getContent().stream()
                .map(userTest -> TestHistoryListDTO.builder()
                        .testId(userTest.getTest().getTestId())
                        .testName(userTest.getTest().getTestName())
                        .totalQuestions(userTest.getTotalQuestions())
                        .correctAnswers(userTest.getCorrectAnswers())
                        .startTime(userTest.getTimeStart() != null ? userTest.getTimeStart().format(formatter) : "")
                        .endTime(userTest.getTimeEnd() != null ? userTest.getTimeEnd().format(formatter) : "")
                        .build())
                .collect(Collectors.toList());

        return new PageImpl<>(testHistoryList, pageable, userTestPage.getTotalElements());
    }

}
