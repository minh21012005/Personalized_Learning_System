package swp.se1941jv.pls.dto.response.practice;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class PracticeSubmissionDto {
    private String lessonIds;
    private Long userId;
    private String allLessonIds;
    private Boolean timed;
    private Integer questionCount;
    private Integer timePerQuestion;
    private Integer currentIndex;
    private List<QuestionAnswerDto> answers;
}
