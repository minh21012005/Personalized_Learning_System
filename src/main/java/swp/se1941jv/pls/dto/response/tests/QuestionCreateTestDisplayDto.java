package swp.se1941jv.pls.dto.response.tests;

import lombok.Builder;
import lombok.Data;
import swp.se1941jv.pls.dto.request.AnswerOptionDto;

import java.util.List;

@Data
@Builder
public class QuestionCreateTestDisplayDto {
    private Long questionId;
    private String content;
    private String chapterName;
    private List<AnswerOptionDto> options;
}