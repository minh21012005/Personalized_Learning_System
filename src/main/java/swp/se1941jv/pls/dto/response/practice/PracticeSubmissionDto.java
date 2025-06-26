package swp.se1941jv.pls.dto.response.practice;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class PracticeSubmissionDto {
    private String selectedLessonIds;
    private Long testId;
    private Long currentQuestionIndex;
    private List<QuestionAnswerDto> answers;
}
