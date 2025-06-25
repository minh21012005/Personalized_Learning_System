package swp.se1941jv.pls.service;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.request.AnswerOptionDto;
import swp.se1941jv.pls.dto.response.*;
import swp.se1941jv.pls.dto.response.practice.PracticeResponseDTO;
import swp.se1941jv.pls.dto.response.practice.PracticeSubmissionDto;
import swp.se1941jv.pls.dto.response.practice.QuestionAnswerResDTO;
import swp.se1941jv.pls.dto.response.practice.QuestionDisplayDto;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.entity.keys.KeyUserPackage;
import swp.se1941jv.pls.repository.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
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
    public List<QuestionAnswerResDTO> checkResults(PracticeSubmissionDto submission) {
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

                boolean isCorrect = correctAnswers.containsAll(listAnswerSelected) && listAnswerSelected.containsAll(correctAnswers);

                QuestionAnswerResDTO questionAnswerResDTO = QuestionAnswerResDTO.builder()
                        .questionId(questionAnswer.getQuestionId())
                        .isCorrect(isCorrect)
                        .selectedAnswers(listAnswerSelected)
                        .correctAnswers(correctAnswers)
                        .answerOptions(allOptions.stream().map(AnswerOptionDto::getText).collect(Collectors.toList()))
                        .build();
                questionAnswerResDTOS.add(questionAnswerResDTO);


            });
        }

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
                .build();
        test = testRepository.save(test);

        Test finalTest = test;
        userTestRepository.save(UserTest.builder()
                .test(finalTest)
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

}
