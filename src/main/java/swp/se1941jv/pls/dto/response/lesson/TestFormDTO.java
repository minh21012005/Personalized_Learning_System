package swp.se1941jv.pls.dto.response.lesson;



import lombok.Data;

import java.util.List;

@Data
public class TestFormDTO {
    private Long testId;
    private List<QuestionDTO> questions;

    @Data
    public static class QuestionDTO {
        private Long questionId;
        private String content;
    }
}