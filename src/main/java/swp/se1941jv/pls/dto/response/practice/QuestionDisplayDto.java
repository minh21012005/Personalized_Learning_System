package swp.se1941jv.pls.dto.response.practice;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class QuestionDisplayDto {
    private Long questionId;
    private String content;
    private String image;
    private String levelQuestionName;
    private List<String> options; // List of options with only text
}
