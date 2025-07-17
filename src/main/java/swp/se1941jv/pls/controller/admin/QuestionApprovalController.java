package swp.se1941jv.pls.controller.admin;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.dto.request.AnswerOptionDto;
import swp.se1941jv.pls.dto.response.*;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.repository.*;
import swp.se1941jv.pls.service.QuestionService;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class QuestionApprovalController {

    private final GradeRepository gradeRepository;
    private final SubjectRepository subjectRepository;
    private final ChapterRepository chapterRepository;
    private final LessonRepository lessonRepository;
    private final LevelQuestionRepository levelQuestionRepository;
    private final QuestionBankRepository questionBankRepository;
    private final QuestionStatusRepository questionStatusRepository;
    private final QuestionService questionService;

    private static final Long PENDING_STATUS_ID = 1L; // Assuming status_id=1 is "Pending"
    private static final Long ACCEPTED_STATUS_ID = 2L; // Assuming status_id=2 is "Accepted"
    private static final Long REJECTED_STATUS_ID = 3L; // Assuming status_id=3 is "Rejected"

    @PreAuthorize("hasAnyRole('CONTENT_MANAGER','ADMIN')")
    @GetMapping("/admin/questions")
    public String listQuestionsForApproval(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "gradeId", required = false) Long gradeId,
            @RequestParam(value = "subjectId", required = false) Long subjectId,
            @RequestParam(value = "chapterId", required = false) Long chapterId,
            @RequestParam(value = "lessonId", required = false) Long lessonId,
            @RequestParam(value = "levelId", required = false) Long levelId,
            @RequestParam(value = "statusId", required = false) Long statusId,
            Model model) {

        int pageSize = 10;
        Pageable pageable = PageRequest.of(page - 1, pageSize);

        Page<QuestionBank> questionPage = questionService.findQuestionsByCreatorAndFilters(
                null, // No creator filter for content manager
                gradeId, subjectId, chapterId, lessonId, levelId, statusId, pageable);

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

        return "content-manager/question_contentmanager/approvalList";
    }

    @PreAuthorize("hasAnyRole('CONTENT_MANAGER','ADMIN')")
    @GetMapping("/admin/questions/{id}")
    public String viewQuestionDetail(@PathVariable Long id, Model model) {
        try {
            QuestionBank question = questionBankRepository.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Câu hỏi không tìm thấy."));

            List<AnswerOptionDto> options = questionService.getQuestionOptions(question);

            model.addAttribute("question", question);
            model.addAttribute("options", options);

            return "content-manager/question_contentmanager/questionDetail";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "content-manager/question_contentmanager/questionDetail";
        }
    }

    @PreAuthorize("hasAnyRole('CONTENT_MANAGER','ADMIN')")
    @PostMapping("/admin/questions/approve/{id}")
    public String approveQuestion(
            @PathVariable Long id,
            @RequestParam(value = "reason", required = false) String reason,
            Model model) {
        try {
            QuestionBank question = questionBankRepository.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Câu hỏi không tìm thấy."));

            QuestionStatus acceptedStatus = questionStatusRepository.findById(ACCEPTED_STATUS_ID)
                    .orElseThrow(() -> new RuntimeException("Trạng thái Accepted không tìm thấy."));
            question.setStatus(acceptedStatus);
            question.setActive(true);
            question.setReason(reason != null ? reason : "Approved without specific reason");
            questionBankRepository.save(question);

            return "redirect:/admin/questions?success=true";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/admin/questions";
        }
    }

    @PreAuthorize("hasAnyRole('CONTENT_MANAGER','ADMIN')")
    @PostMapping("/admin/questions/reject/{id}")
    public String rejectQuestion(
            @PathVariable Long id,
            @RequestParam(value = "reason", required = true) String reason,
            Model model) {
        try {
            if (reason == null || reason.trim().isEmpty()) {
                throw new IllegalArgumentException("Lý do từ chối là bắt buộc.");
            }

            QuestionBank question = questionBankRepository.findById(id)
                    .orElseThrow(() -> new IllegalArgumentException("Câu hỏi không tìm thấy."));

            QuestionStatus rejectedStatus = questionStatusRepository.findById(REJECTED_STATUS_ID)
                    .orElseThrow(() -> new RuntimeException("Trạng thái Rejected không tìm thấy."));
            question.setStatus(rejectedStatus);
            question.setActive(false);
            question.setReason(reason);
            questionBankRepository.save(question);

            return "redirect:/admin/questions?success=true";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "redirect:/admin/questions";
        }
    }
}