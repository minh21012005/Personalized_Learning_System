package swp.se1941jv.pls.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import swp.se1941jv.pls.config.SecurityUtils;
import swp.se1941jv.pls.dto.request.AnswerOptionDto;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.repository.*;

import jakarta.persistence.criteria.Predicate;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuestionService {

    private final QuestionBankRepository questionBankRepository;
    private final GradeRepository gradeRepository;
    private final SubjectRepository subjectRepository;
    private final ChapterRepository chapterRepository;
    private final LessonRepository lessonRepository;
    private final LevelQuestionRepository levelQuestionRepository;
    private final QuestionTypeRepository questionTypeRepository;
    private final QuestionStatusRepository questionStatusRepository;
    private final UploadService uploadService;
    private final ObjectMapper objectMapper;

    private static final String UPLOAD_DIR = "question_bank";
    private static final Long PENDING_STATUS_ID = 1L; // Assuming status_id=1 is "Pending"

    public QuestionBank saveQuestion(QuestionBank question, List<String> optionTexts, List<Boolean> isCorrectList, MultipartFile imageFile) throws Exception {
        // Validate mandatory fields
        if (question.getGrade() == null || question.getGrade().getGradeId() == null) {
            throw new IllegalArgumentException("Khối là bắt buộc.");
        }
        if (question.getSubject() == null || question.getSubject().getSubjectId() == null) {
            throw new IllegalArgumentException("Môn học là bắt buộc.");
        }
        if (question.getChapter() == null || question.getChapter().getChapterId() == null) {
            throw new IllegalArgumentException("Chương là bắt buộc.");
        }
        if (question.getLesson() == null || question.getLesson().getLessonId() == null) {
            throw new IllegalArgumentException("Bài học là bắt buộc.");
        }
        if (question.getLevelQuestion() == null || question.getLevelQuestion().getLevelQuestionId() == null) {
            throw new IllegalArgumentException("Mức độ là bắt buộc.");
        }

        // Validate question content
        if (question.getContent() == null || question.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung câu hỏi không được để trống.");
        }

        // Validate options: at least 2 options, at least 1 correct, at most n-1 correct, no empty options
        if (optionTexts == null || optionTexts.size() < 2) {
            throw new IllegalArgumentException("Phải có ít nhất 2 đáp án.");
        }
        for (String option : optionTexts) {
            if (option == null || option.trim().isEmpty()) {
                throw new IllegalArgumentException("Đáp án không được để trống.");
            }
        }
        if (isCorrectList == null || isCorrectList.isEmpty()) {
            throw new IllegalArgumentException("Phải có ít nhất một đáp án đúng.");
        }
        long correctCount = isCorrectList.stream().filter(Boolean::booleanValue).count();
        if (correctCount < 1) {
            throw new IllegalArgumentException("Phải có ít nhất một đáp án đúng.");
        }
        if (correctCount >= optionTexts.size()) {
            throw new IllegalArgumentException("Chỉ được phép có tối đa " + (optionTexts.size() - 1) + " đáp án đúng.");
        }

        // Set question type (assuming multiple-choice type has ID 1)
        QuestionType questionType = questionTypeRepository.findById(1L)
                .orElseThrow(() -> new RuntimeException("Loại câu hỏi không tìm thấy."));
        question.setQuestionType(questionType);

        // Set initial status to Pending
        QuestionStatus pendingStatus = questionStatusRepository.findById(PENDING_STATUS_ID)
                .orElseThrow(() -> new RuntimeException("Trạng thái Pending không tìm thấy."));
        question.setStatus(pendingStatus);


        // Handle image upload using UploadService
        if (imageFile != null && !imageFile.isEmpty()) {
            String fileName = uploadService.handleSaveUploadFile(imageFile, UPLOAD_DIR);
            if (fileName.isEmpty()) {
                throw new RuntimeException("Không thể tải lên hình ảnh.");
            }
            question.setImage(fileName);
        }

        // Prepare options as JSON
        List<AnswerOptionDto> options = new ArrayList<>();
        for (int i = 0; i < optionTexts.size(); i++) {
            AnswerOptionDto option = new AnswerOptionDto();
            option.setText(optionTexts.get(i));
            option.setCorrect(isCorrectList.get(i));
            options.add(option);
        }
        try {
            String optionsJson = objectMapper.writeValueAsString(options);
            question.setOptions(optionsJson);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Lỗi khi chuyển đổi đáp án sang JSON.", e);
        }

        // Save the question
        return questionBankRepository.save(question);
    }

    public String saveImage(MultipartFile imageFile) throws Exception {
        if (imageFile != null && !imageFile.isEmpty()) {
            return uploadService.handleSaveUploadFile(imageFile, UPLOAD_DIR);
        }
        return null;
    }


    public Page<QuestionBank> findQuestionsByCreatorAndFilters(
            Long creatorUserId,
            Long gradeId,
            Long subjectId,
            Long chapterId,
            Long lessonId,
            Long levelId,
            Long statusId,
            Pageable pageable) {

        Specification<QuestionBank> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (creatorUserId != null) {
                predicates.add(cb.equal(root.get("userCreated"), creatorUserId));
            }
            if (gradeId != null) {
                predicates.add(cb.equal(root.get("grade").get("gradeId"), gradeId));
            }
            if (subjectId != null) {
                predicates.add(cb.equal(root.get("subject").get("subjectId"), subjectId));
            }
            if (chapterId != null) {
                predicates.add(cb.equal(root.get("chapter").get("chapterId"), chapterId));
            }
            if (lessonId != null) {
                predicates.add(cb.equal(root.get("lesson").get("lessonId"), lessonId));
            }
            if (levelId != null) {
                predicates.add(cb.equal(root.get("levelQuestion").get("levelQuestionId"), levelId));
            }
            if (statusId != null) {
                predicates.add(cb.equal(root.get("status").get("statusId"), statusId));
            }

            query.orderBy(cb.desc(root.get("questionId")));

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        return questionBankRepository.findAll(spec, pageable);
    }

    public List<AnswerOptionDto> getQuestionOptions(QuestionBank question) throws Exception {
        if (question.getOptions() == null || question.getOptions().isEmpty()) {
            return new ArrayList<>();
        }
        try {
            return objectMapper.readValue(question.getOptions(), new TypeReference<List<AnswerOptionDto>>() {
            });
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Lỗi khi chuyển đổi đáp án sang JSON.", e);
        }
    }


    /**
     * Kiểm tra xem các đáp án được chọn có đúng hay không dựa trên questionId.
     * @param questionId ID của câu hỏi
     * @param selectedAnswers Danh sách các đáp án được người dùng chọn
     * @return true nếu tất cả đáp án được chọn khớp với đáp án đúng, false nếu không
     */
    public boolean checkAnswers(Long questionId, List<String> selectedAnswers) {
        // Lấy câu hỏi từ cơ sở dữ liệu
        QuestionBank question = questionBankRepository.findById(questionId)
                .orElseThrow(() -> new RuntimeException("Câu hỏi không tồn tại với ID: " + questionId));

        // Lấy danh sách các đáp án đúng từ JSON
        List<AnswerOptionDto> correctOptions = null;
        try {
            correctOptions = getQuestionOptions(question).stream()
                    .filter(AnswerOptionDto::isCorrect)
                    .collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        // Chuyển danh sách đáp án đúng sang danh sách text để so sánh
        List<String> correctAnswerTexts = correctOptions.stream()
                .map(AnswerOptionDto::getText)
                .collect(Collectors.toList());

        // Kiểm tra nếu danh sách đáp án chọn khớp với đáp án đúng (có thể có thứ tự khác nhau)
        if (selectedAnswers == null || selectedAnswers.isEmpty()) {
            return correctAnswerTexts.isEmpty(); // Nếu không chọn gì, đúng khi không có đáp án đúng
        }

        // Sắp xếp cả hai danh sách để so sánh không phụ thuộc thứ tự
        List<String> sortedSelected = new ArrayList<>(selectedAnswers);
        List<String> sortedCorrect = new ArrayList<>(correctAnswerTexts);
        Collections.sort(sortedSelected);
        Collections.sort(sortedCorrect);

        return sortedSelected.equals(sortedCorrect);
    }

    public QuestionBank updateQuestion(QuestionBank question, List<String> optionTexts, List<Boolean> isCorrectList, MultipartFile imageFile, String existingImage) throws Exception {
        // Validate mandatory fields
        if (question.getGrade() == null || question.getGrade().getGradeId() == null) {
            throw new IllegalArgumentException("Khối là bắt buộc.");
        }
        if (question.getSubject() == null || question.getSubject().getSubjectId() == null) {
            throw new IllegalArgumentException("Môn học là bắt buộc.");
        }
        if (question.getChapter() == null || question.getChapter().getChapterId() == null) {
            throw new IllegalArgumentException("Chương là bắt buộc.");
        }
        if (question.getLesson() == null || question.getLesson().getLessonId() == null) {
            throw new IllegalArgumentException("Bài học là bắt buộc.");
        }
        if (question.getLevelQuestion() == null || question.getLevelQuestion().getLevelQuestionId() == null) {
            throw new IllegalArgumentException("Mức độ là bắt buộc.");
        }

        // Validate question content
        if (question.getContent() == null || question.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung câu hỏi không được để trống.");
        }

        // Validate options: at least 2 options, at least 1 correct, at most n-1 correct, no empty options
        if (optionTexts == null || optionTexts.size() < 2) {
            throw new IllegalArgumentException("Phải có ít nhất 2 đáp án.");
        }
        for (String option : optionTexts) {
            if (option == null || option.trim().isEmpty()) {
                throw new IllegalArgumentException("Đáp án không được để trống.");
            }
        }
        if (isCorrectList == null || isCorrectList.isEmpty()) {
            throw new IllegalArgumentException("Phải có ít nhất một đáp án đúng.");
        }
        long correctCount = isCorrectList.stream().filter(Boolean::booleanValue).count();
        if (correctCount < 1) {
            throw new IllegalArgumentException("Phải có ít nhất một đáp án đúng.");
        }
        if (correctCount >= optionTexts.size()) {
            throw new IllegalArgumentException("Chỉ được phép có tối đa " + (optionTexts.size() - 1) + " đáp án đúng.");
        }


        // Handle image upload or retain existing
        if (imageFile != null && !imageFile.isEmpty()) {
            String fileName = uploadService.handleSaveUploadFile(imageFile, UPLOAD_DIR);
            if (fileName.isEmpty()) {
                throw new RuntimeException("Không thể tải lên hình ảnh.");
            }
            question.setImage(fileName);
        } else {
            question.setImage(existingImage);
        }

        // Prepare options as JSON
        List<AnswerOptionDto> options = new ArrayList<>();
        for (int i = 0; i < optionTexts.size(); i++) {
            AnswerOptionDto option = new AnswerOptionDto();
            option.setText(optionTexts.get(i));
            option.setCorrect(isCorrectList.get(i));
            options.add(option);
        }
        try {
            String optionsJson = objectMapper.writeValueAsString(options);
            question.setOptions(optionsJson);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Lỗi khi chuyển đổi đáp án sang JSON.", e);
        }

        QuestionStatus pendingStatus = questionStatusRepository.findById(PENDING_STATUS_ID)
                .orElseThrow(() -> new RuntimeException("Trạng thái Pending không tìm thấy."));
        question.setStatus(pendingStatus);

        // Save the updated question
        return questionBankRepository.save(question);
    }

    public void deleteQuestion(Long id) throws Exception {
        QuestionBank question = questionBankRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Câu hỏi không tìm thấy."));
        Long currentUserId = SecurityUtils.getCurrentUserId();
        if (currentUserId == null || !currentUserId.equals(question.getUserCreated())) {
            throw new IllegalArgumentException("Bạn không có quyền xóa câu hỏi này.");
        }
        if (!"Pending".equals(question.getStatus().getStatusName())) {
            throw new IllegalStateException("Chỉ có thể xóa câu hỏi ở trạng thái Đang xử lý.");
        }
        questionBankRepository.delete(question);
    }
}
