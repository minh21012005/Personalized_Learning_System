package swp.se1941jv.pls.dto.response.practice;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PracticeSubmissionDto {
    private String selectedLessonIds;
    private Long testId;
    private Long currentQuestionIndex;
    private List<QuestionAnswerDto> answers;
}
