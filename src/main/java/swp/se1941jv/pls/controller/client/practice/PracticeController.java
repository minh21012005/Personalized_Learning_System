package swp.se1941jv.pls.controller.client.practice;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.request.AnswerOptionDto;
import swp.se1941jv.pls.dto.response.LessonResponseDTO;
import swp.se1941jv.pls.dto.response.QuestionDisplayDto;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.repository.*;
import swp.se1941jv.pls.service.QuestionService;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/practice")
@RequiredArgsConstructor
public class PracticeController {

    private final SubjectRepository subjectRepository;
    private final ChapterRepository chapterRepository;
    private final LessonRepository lessonRepository;
    private final LevelQuestionRepository levelQuestionRepository;
    private final QuestionBankRepository questionBankRepository;
    private final UserTestRepository userTestRepository;
    private final AnswerHistoryTestRepository answerHistoryRepository;
    private final QuestionService questionService;
    private final TestRepository testRepository;
    private final SubjectTestRepository subjectTestRepository;
    private final QuestionTestRepository questionTestRepository;
    private final UserRepository userRepository;
    private final TestStatusRepository testStatusRepository;
    private final TestCategoryRepository testCategoryRepository;

    @PreAuthorize("hasAnyRole('STUDENT')")
    @GetMapping("/start")
    public String showPracticeForm(Model model) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        List<Subject> subjects = subjectRepository.findAll();
        List<Chapter> chapters = chapterRepository.findAll();
        List<Lesson> lessons = lessonRepository.findAll();
        List<LevelQuestion> levels = levelQuestionRepository.findAll();
        model.addAttribute("subjects", subjects);
        model.addAttribute("chapters", chapters);
        model.addAttribute("lessons", lessons);
        model.addAttribute("levels", levels);
        model.addAttribute("userTest", new UserTest());
        return "client/practice/practiceForm";
    }

    @PreAuthorize("hasAnyRole('STUDENT')")
    @GetMapping("/start-practice")
    public String startPractice(
            @RequestParam("subjectId") Long subjectId,
            @RequestParam("lessonIds") List<Long> lessonIds,
            @RequestParam("levelIds") List<Long> levelIds,
            @RequestParam("questionCount") int questionCount,
            @ModelAttribute UserTest userTest,
            Model model) {

        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "redirect:/login";
        }

        if (lessonIds.isEmpty() || levelIds.isEmpty()) {
            model.addAttribute("error", "Vui lòng chọn ít nhất một bài học và một cấp độ.");
            return "client/practice/practiceForm";
        }

        if (subjectId == null) {
            model.addAttribute("error", "Vui lòng chọn một môn học.");
            return "client/practice/practiceForm";
        }

        for (Long lessonId : lessonIds) {
            Lesson lesson = lessonRepository.findById(lessonId)
                    .orElseThrow(() -> new IllegalArgumentException("Lesson not found"));
            if (!lesson.getChapter().getSubject().getSubjectId().equals(subjectId)) {
                model.addAttribute("error", "Bài học không thuộc môn học đã chọn.");
                return "client/practice/practiceForm";
            }
        }

        int duration = 60;

        Test test = Test.builder()
                .testName("Practice Test - " + LocalDateTime.now())
                .durationTime(duration)
                .startAt(LocalDateTime.now())
                .endAt(LocalDateTime.now().plusMinutes(duration))
                .testStatus(testStatusRepository.findById(1L).orElseThrow(() -> new RuntimeException("Pending status not found")))
                .testCategory(testCategoryRepository.findById(1L).orElseThrow(() -> new RuntimeException("Default category not found")))
                .build();
        test = testRepository.save(test);

        for (Long lessonId : lessonIds) {
            Lesson lesson = lessonRepository.findById(lessonId)
                    .orElseThrow(() -> new IllegalArgumentException("Lesson not found"));
            SubjectTest subjectTest = SubjectTest.builder()
                    .test(test)
                    .subject(lesson.getChapter().getSubject())
                    .chapter(lesson.getChapter())
                    .lesson(lesson)
                    .build();
            subjectTestRepository.save(subjectTest);
        }

        try {
            test.generateRandomQuestions(questionService, subjectId, new ArrayList<>(), lessonIds, levelIds, questionCount);
        } catch (Exception e) {
            model.addAttribute("error", "Không đủ câu hỏi phù hợp với tiêu chí đã chọn. Vui lòng thử lại.");
            return "client/practice/practiceForm";
        }
        List<QuestionBank> questions = test.getRandomQuestions();
        for (int i = 0; i < questions.size(); i++) {
            QuestionTest questionTest = QuestionTest.builder()
                    .test(test)
                    .question(questions.get(i))
                    .build();
            questionTestRepository.save(questionTest);
        }

        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));
        userTest.setUser(user);
        userTest.setTest(test);
        userTest.setTimeStart(LocalDateTime.now());
        userTest.setTimeEnd(LocalDateTime.now().plusMinutes(duration));
//        userTest.setCurrentQuestionIndex(0);
        userTest = userTestRepository.save(userTest);

        List<QuestionDisplayDto> displayQuestions = questions.stream()
                .map(question -> {
                    List<AnswerOptionDto> options;
                    try {
                        options = questionService.getQuestionOptions(question);
                    } catch (Exception e) {
                        throw new RuntimeException("Error retrieving question options for question ID: " + question.getQuestionId(), e);
                    }
                    return QuestionDisplayDto.builder()
                            .questionId(question.getQuestionId())
                            .content(question.getContent())
                            .image(question.getImage())
                            .options(options.stream().map(AnswerOptionDto::getText).collect(Collectors.toList()))
                            .build();
                })
                .collect(Collectors.toList());

        model.addAttribute("test", test);
        model.addAttribute("questions", displayQuestions);
        model.addAttribute("userTest", userTest);
        return "client/practice/practiceTest";
    }

//    @PostMapping("/submit-answer")
//    @PreAuthorize("hasAnyRole('STUDENT')")
//    public ResponseEntity<?> submitAnswer(
//            @RequestParam Long questionId,
//            @RequestParam String answer,
//            @RequestParam Long userTestId) {
//
//        Long userId = SecurityUtils.getCurrentUserId();
//        if (userId == null) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Không thể xác định người dùng.");
//        }
//
//        UserTest userTest = userTestRepository.findById(userTestId)
//                .orElseThrow(() -> new IllegalArgumentException("UserTest không tồn tại."));
//
//        if (!userTest.getUser().getUserId().equals(userId)) {
//            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Không có quyền truy cập.");
//        }
//
//        QuestionBank question = questionBankRepository.findById(questionId)
//                .orElseThrow(() -> new IllegalArgumentException("Câu hỏi không tồn tại."));
//
//        AnswerHistoryTest answerHistory = AnswerHistoryTest.builder()
//                .userTest(userTest)
//                .question(question)
//                .answer(answer)
//                .createdAt(LocalDateTime.now())
//                .build();
//        answerHistoryRepository.save(answerHistory);
//
//        int nextIndex = userTest.getCurrentQuestionIndex() + 1;
//        List<QuestionTest> questionTests = questionTestRepository.findByTestId(userTest.getTest().getTestId());
//        if (nextIndex < questionTests.size()) {
//            userTest.setCurrentQuestionIndex(nextIndex);
//            userTestRepository.save(userTest);
//            return ResponseEntity.ok("Đáp án đã được lưu.");
//        } else {
//            return ResponseEntity.ok(Map.of("redirect", "/practice/finish?userTestId=" + userTestId));
//        }
//    }

//    @GetMapping("/finish")
//    @PreAuthorize("hasAnyRole('STUDENT')")
//    public String finishPractice(@RequestParam Long userTestId, Model model) {
//        Long userId = SecurityUtils.getCurrentUserId();
//        if (userId == null) {
//            model.addAttribute("error", "Không thể xác định người dùng.");
//            return "redirect:/login";
//        }
//
//        UserTest userTest = userTestRepository.findById(userTestId)
//                .orElseThrow(() -> new IllegalArgumentException("UserTest không tồn tại."));
//
//        if (!userTest.getUser().getUserId().equals(userId)) {
//            model.addAttribute("error", "Không có quyền truy cập.");
//            return "redirect:/";
//        }
//
//        List<AnswerHistoryTest> answers = answerHistoryRepository.findByUserTestId(userTestId);
//        model.addAttribute("userTest", userTest);
//        model.addAttribute("answers", answers);
//        return "client/practice/practiceResult";
//    }

    @GetMapping("/api/lessons-by-subject/{subjectId}")
    @ResponseBody
    public List<LessonResponseDTO> getLessonsBySubjectAndChapters(@PathVariable Long subjectId) {
        return lessonRepository.findBySubjectId(subjectId, true)
                .stream()
                .map(lesson -> LessonResponseDTO.builder()
                        .lessonId(lesson.getLessonId())
                        .lessonName(lesson.getLessonName())
                        .build())
                .collect(Collectors.toList());
    }
}