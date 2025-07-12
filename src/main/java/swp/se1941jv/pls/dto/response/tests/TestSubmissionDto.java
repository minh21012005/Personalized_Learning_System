package swp.se1941jv.pls.dto.response.tests;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class TestSubmissionDto {
    private Long testId;
    private List<QuestionAnswer> answers;

    @Getter
    @Setter
    @AllArgsConstructor
    public static class QuestionAnswer {
        private Long questionId;
        private List<String> selectedAnswers;


    }
}