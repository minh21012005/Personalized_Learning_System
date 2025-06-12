package swp.se1941jv.pls.dto.response;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class QuestionDisplayDto {
    private Long questionId;
    private String content;
    private String image;
    private List<String> options; // List of options with only text
}
