package swp.se1941jv.pls.dto.response.practice;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class QuestionAnswerDto {
    private Long questionId;
    private List<String> selectedAnswers;
}
