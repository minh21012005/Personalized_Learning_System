package swp.se1941jv.pls.dto.response.practice;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class QuestionAnswerResDTO {
    Long questionId;
    boolean isCorrect;
    String content;
    String image;
    List<String> selectedAnswers;
    List<String> correctAnswers;
    List<String> answerOptions;
}
