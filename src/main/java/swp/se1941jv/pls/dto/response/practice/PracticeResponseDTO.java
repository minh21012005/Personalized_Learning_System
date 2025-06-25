package swp.se1941jv.pls.dto.response.practice;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class PracticeResponseDTO {
    private Long testId;
    private Long userId;
    private String selectedLessonId;
    List<QuestionDisplayDto> questions;
}
