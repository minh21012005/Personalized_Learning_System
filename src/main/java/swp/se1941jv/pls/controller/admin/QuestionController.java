
package swp.se1941jv.pls.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.response.*;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.repository.*;
import swp.se1941jv.pls.service.QuestionService;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class QuestionController {

    private final GradeRepository gradeRepository;
    private final SubjectRepository subjectRepository;
    private final ChapterRepository chapterRepository;
    private final LessonRepository lessonRepository;
    private final LevelQuestionRepository levelQuestionRepository;
    private final QuestionBankRepository questionBankRepository;
    private final QuestionStatusRepository questionStatusRepository;
    private final QuestionService questionService;

    @PreAuthorize("hasAnyRole('STAFF')")
    @GetMapping("/staff/questions/create-question")
    public String showCreateQuestionForm(Model model) {
        List<Grade> grades = gradeRepository.findByIsActiveTrue()
                .stream()
                .map(grade -> Grade.builder()
                        .gradeId(grade.getGradeId())
                        .gradeName(grade.getGradeName())
                        .build())
                .collect(Collectors.toList());
        List<SubjectResponseDTO> subjects = new ArrayList<>();
        List<ChapterResponseDTO> chapters = new ArrayList<>();
        List<LessonResponseDTO> lessons = new ArrayList<>();
        List<LevelQuestionResponseDTO> levels = levelQuestionRepository.findAll().stream()
                .map(levelQuestion -> LevelQuestionResponseDTO.builder()
                        .levelQuestionId(levelQuestion.getLevelQuestionId())
                        .levelQuestionName(levelQuestion.getLevelQuestionName())
                        .build())
                .collect(Collectors.toList());

        model.addAttribute("question", new QuestionBank());
        model.addAttribute("grades", grades);
        model.addAttribute("subjects", subjects);
        model.addAttribute("chapters", chapters);
        model.addAttribute("lessons", lessons);
        model.addAttribute("levels", levels);

        if (model.containsAttribute("success")) {
            model.addAttribute("success", "Câu hỏi đã được tạo thành công!");
        }

        return "admin/question/createQuestion";
    }

    @PreAuthorize("hasAnyRole('STAFF')")
    @PostMapping("/staff/questions/create-question")
    public String createQuestion(
            @ModelAttribute("question") QuestionBank question,
            BindingResult bindingResult,
            @RequestParam("gradeId") Long gradeId,
            @RequestParam("subjectId") Long subjectId,
            @RequestParam("chapterId") Long chapterId,
            @RequestParam("lessonId") Long lessonId,
            @RequestParam(value = "options", required = false) List<String> options,
            @RequestParam(value = "isCorrect", required = false) List<String> isCorrectValues,
            @RequestParam("image") MultipartFile imageFile,
            Model model) {

        try {
            Grade grade = gradeRepository.findById(gradeId)
                    .orElseThrow(() -> new IllegalArgumentException("Khối không tìm thấy."));
            Subject subject = subjectRepository.findById(subjectId)
                    .orElseThrow(() -> new IllegalArgumentException("Môn học không tìm thấy."));
            Chapter chapter = chapterRepository.findById(chapterId)
                    .orElseThrow(() -> new IllegalArgumentException("Chương không tìm thấy."));
            Lesson lesson = lessonRepository.findById(lessonId)
                    .orElseThrow(() -> new IllegalArgumentException("Bài học không tìm thấy."));
            LevelQuestion levelQuestion = levelQuestionRepository.findById(question.getLevelQuestion().getLevelQuestionId())
                    .orElseThrow(() -> new IllegalArgumentException("Mức độ không tìm thấy."));

            question.setGrade(grade);
            question.setSubject(subject);
            question.setChapter(chapter);
            question.setLesson(lesson);
            question.setLevelQuestion(levelQuestion);

            if (options == null) {
                options = new ArrayList<>();
            }

            List<Boolean> isCorrectList = new ArrayList<>();
            if (isCorrectValues != null) {
                for (int i = 0; i < options.size(); i++) {
                    boolean isCorrect = isCorrectValues.contains(String.valueOf(i));
                    isCorrectList.add(isCorrect);
                }
            } else {
                for (int i = 0; i < options.size(); i++) {
                    isCorrectList.add(false);
                }
            }

            questionService.saveQuestion(question, options, isCorrectList, imageFile);
            model.addAttribute("success", "Câu hỏi đã được tạo thành công!");
            List<Grade> grades = gradeRepository.findByIsActiveTrue()
                    .stream()
                    .map(g -> Grade.builder()
                            .gradeId(g.getGradeId())
                            .gradeName(g.getGradeName())
                            .build())
                    .collect(Collectors.toList());
            List<SubjectResponseDTO> subjects = new ArrayList<>();
            List<ChapterResponseDTO> chapters = new ArrayList<>();
            List<LessonResponseDTO> lessons = new ArrayList<>();
            List<LevelQuestionResponseDTO> levels = levelQuestionRepository.findAll().stream()
                    .map(lv -> LevelQuestionResponseDTO.builder()
                            .levelQuestionId(lv.getLevelQuestionId())
                            .levelQuestionName(lv.getLevelQuestionName())
                            .build())
                    .collect(Collectors.toList());

            model.addAttribute("question", new QuestionBank());
            model.addAttribute("grades", grades);
            model.addAttribute("subjects", subjects);
            model.addAttribute("chapters", chapters);
            model.addAttribute("lessons", lessons);
            model.addAttribute("levels", levels);

            return "admin/question/createQuestion";
        } catch (Exception e) {
            // Repopulate model attributes for form retention
            List<GradeResponseDTO> grades = gradeRepository.findByIsActiveTrue()
                    .stream()
                    .map(grade -> GradeResponseDTO.builder()
                            .gradeId(grade.getGradeId())
                            .gradeName(grade.getGradeName())
                            .build())
                    .collect(Collectors.toList());

            // Fetch subjects, chapters, and lessons based on submitted IDs
            List<SubjectResponseDTO> subjects = gradeId != null ? subjectRepository.findByGradeIdAndIsActive(gradeId, true)
                    .stream()
                    .map(subject -> SubjectResponseDTO.builder()
                            .subjectId(subject.getSubjectId())
                            .subjectName(subject.getSubjectName())
                            .build())
                    .collect(Collectors.toList()) : new ArrayList<>();

            List<ChapterResponseDTO> chapters = subjectId != null ? chapterRepository.findBySubjectIdAndIsActive(subjectId, true)
                    .stream()
                    .map(chapter -> ChapterResponseDTO.builder()
                            .chapterId(chapter.getChapterId())
                            .chapterName(chapter.getChapterName())
                            .build())
                    .collect(Collectors.toList()) : new ArrayList<>();

            List<LessonResponseDTO> lessons = chapterId != null ? lessonRepository.findByChapterIdAndIsActive(chapterId, true)
                    .stream()
                    .map(lesson -> LessonResponseDTO.builder()
                            .lessonId(lesson.getLessonId())
                            .lessonName(lesson.getLessonName())
                            .build())
                    .collect(Collectors.toList()) : new ArrayList<>();

            List<LevelQuestionResponseDTO> levels = levelQuestionRepository.findAll().stream()
                    .map(levelQuestion -> LevelQuestionResponseDTO.builder()
                            .levelQuestionId(levelQuestion.getLevelQuestionId())
                            .levelQuestionName(levelQuestion.getLevelQuestionName())
                            .build())
                    .collect(Collectors.toList());

            model.addAttribute("grades", grades);
            model.addAttribute("subjects", subjects);
            model.addAttribute("chapters", chapters);
            model.addAttribute("lessons", lessons);
            model.addAttribute("levels", levels);
            model.addAttribute("submittedGradeId", gradeId);
            model.addAttribute("submittedSubjectId", subjectId);
            model.addAttribute("submittedChapterId", chapterId);
            model.addAttribute("submittedLessonId", lessonId);
            model.addAttribute("submittedOptions", options);
            List<Boolean> isCorrectList = new ArrayList<>();
            if (isCorrectValues != null) {
                for (int i = 0; i < options.size(); i++) {
                    boolean isCorrect = isCorrectValues.contains(String.valueOf(i));
                    isCorrectList.add(isCorrect);
                }
            } else {
                for (int i = 0; i < options.size(); i++) {
                    isCorrectList.add(false);
                }
            }
            model.addAttribute("submittedIsCorrect", isCorrectList);
            model.addAttribute("error", e.getMessage());

            return "admin/question/createQuestion";
        }
    }

    @PreAuthorize("hasAnyRole('STAFF')")
    @GetMapping("/staff/questions")
    public String listQuestions(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "gradeId", required = false) Long gradeId,
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId,
            @RequestParam(value = "lessonId", required = false) Long lessonId,
            @RequestParam(value = "levelId", required = false) Long levelId,
            @RequestParam(value = "statusId", required = false) Long statusId,
            Authentication authentication,
            Model model) {

        int pageSize = 10; // Number of questions per page
        Pageable pageable = PageRequest.of(page - 1, pageSize);
        Long creatorUserId = SecurityUtils.getCurrentUserId(); // Get current user's ID

        if (creatorUserId == null) {
            model.addAttribute("error", "Không thể xác định người dùng hiện tại.");
            return "admin/question/questionList";
        }

        Page<QuestionBank> questionPage = questionService.findQuestionsByCreatorAndFilters(
                creatorUserId, gradeId, subjectId, chapterId, lessonId, levelId, statusId, pageable);

        List<QuestionBank> questions = questionPage.getContent();
        int totalPages = questionPage.getTotalPages();
        int currentPage = page;

        // Populate filter dropdowns
        List<GradeResponseDTO> grades = gradeRepository.findByIsActiveTrue()
                .stream()
                .map(grade -> GradeResponseDTO.builder()
                        .gradeId(grade.getGradeId())
                        .gradeName(grade.getGradeName())
                        .build())
                .collect(Collectors.toList());

        List<SubjectResponseDTO> subjects = gradeId != null ? subjectRepository.findByGradeIdAndIsActive(gradeId, true)
                .stream()
                .map(subject -> SubjectResponseDTO.builder()
                        .subjectId(subject.getSubjectId())
                        .subjectName(subject.getSubjectName())
                        .build())
                .collect(Collectors.toList()) : new ArrayList<>();

        List<ChapterResponseDTO> chapters = subjectId != null ? chapterRepository.findBySubjectIdAndIsActive(subjectId, true)
                .stream()
                .map(chapter -> ChapterResponseDTO.builder()
                        .chapterId(chapter.getChapterId())
                        .chapterName(chapter.getChapterName())
                        .build())
                .collect(Collectors.toList()) : new ArrayList<>();

        List<LessonResponseDTO> lessons = chapterId != null ? lessonRepository.findByChapterIdAndIsActive(chapterId, true)
                .stream()
                .map(lesson -> LessonResponseDTO.builder()
                        .lessonId(lesson.getLessonId())
                        .lessonName(lesson.getLessonName())
                        .build())
                .collect(Collectors.toList()) : new ArrayList<>();

        List<LevelQuestionResponseDTO> levels = levelQuestionRepository.findAll().stream()
                .map(levelQuestion -> LevelQuestionResponseDTO.builder()
                        .levelQuestionId(levelQuestion.getLevelQuestionId())
                        .levelQuestionName(levelQuestion.getLevelQuestionName())
                        .build())
                .collect(Collectors.toList());

        List<QuestionStatus> statuses = questionStatusRepository.findAll();

        model.addAttribute("questions", questions);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("grades", grades);
        model.addAttribute("subjects", subjects);
        model.addAttribute("chapters", chapters);
        model.addAttribute("lessons", lessons);
        model.addAttribute("levels", levels);
        model.addAttribute("statuses", statuses);

        return "admin/question/questionList";
    }

    @PreAuthorize("hasAnyRole('STAFF')")
    @GetMapping("/api/subjects-by-grade/{gradeId}")
    @ResponseBody
    public List<SubjectResponseDTO> getSubjectsByGrade(@PathVariable Long gradeId) {
        return subjectRepository.findByGradeIdAndIsActive(gradeId, true)
                .stream()
                .map(subject -> SubjectResponseDTO.builder()
                        .subjectId(subject.getSubjectId())
                        .subjectName(subject.getSubjectName())
                        .build())
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAnyRole('STAFF')")
    @GetMapping("/api/chapters-by-subject/{subjectId}")
    @ResponseBody
    public List<ChapterResponseDTO> getChaptersBySubject(@PathVariable Long subjectId) {
        return chapterRepository.findBySubjectIdAndIsActive(subjectId, true)
                .stream()
                .map(chapter -> ChapterResponseDTO.builder()
                        .chapterId(chapter.getChapterId())
                        .chapterName(chapter.getChapterName())
                        .build())
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAnyRole('STAFF')")
    @GetMapping("/api/lessons-by-chapter/{chapterId}")
    @ResponseBody
    public List<LessonResponseDTO> getLessonsByChapter(@PathVariable Long chapterId) {
        return lessonRepository.findByChapterIdAndIsActive(chapterId, true)
                .stream()
                .map(lesson -> LessonResponseDTO.builder()
                        .lessonId(lesson.getLessonId())
                        .lessonName(lesson.getLessonName())
                        .build())
                .collect(Collectors.toList());
    }

    @PreAuthorize("hasAnyRole('STAFF')")
    @GetMapping("/api/grades")
    @ResponseBody
    public List<GradeResponseDTO> getAllGrades() {
        return gradeRepository.findByIsActiveTrue()
                .stream()
                .map(grade -> GradeResponseDTO.builder()
                        .gradeId(grade.getGradeId())
                        .gradeName(grade.getGradeName())
                        .build())
                .collect(Collectors.toList());
    }
}