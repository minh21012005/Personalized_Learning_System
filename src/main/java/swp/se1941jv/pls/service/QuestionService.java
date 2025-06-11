package swp.se1941jv.pls.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import swp.se1941jv.pls.dto.request.AnswerOptionDto;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.repository.*;

import java.util.ArrayList;
import java.util.List;

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
    private final UploadService uploadService;
    private final ObjectMapper objectMapper;

    private static final String UPLOAD_DIR = "question_bank";

    public QuestionBank saveQuestion(QuestionBank question, List<String> optionTexts, List<Boolean> isCorrectList, MultipartFile imageFile) throws Exception {
        // Validate mandatory fields
        if (question.getGrade() == null || question.getGrade().getGradeId() == null) {
            throw new IllegalArgumentException("Khối lượng là bắt buộc.");
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

        // Set default values if not provided
        if (question.getAnswer() == null) {
            question.setAnswer("");
        }

        // Set question type (assuming multiple-choice type has ID 1)
        QuestionType questionType = questionTypeRepository.findById(1L)
                .orElseThrow(() -> new RuntimeException("Loại câu hỏi không tìm thấy."));
        question.setQuestionType(questionType);

        // Handle image upload using UploadService
        if (imageFile != null && !imageFile.isEmpty()) {
            String fileName = uploadService.handleSaveUploadFile(imageFile, UPLOAD_DIR);
            if (fileName.isEmpty()) {
                throw new RuntimeException("Không thể tải lên hình ảnh.");
            }
            question.setImage(fileName);
        } // Retain existing image if no new file is uploaded

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
}