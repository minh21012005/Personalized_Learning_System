package swp.se1941jv.pls.dto.response.practice;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class TestHistoryListDTO {
    private Long testId;
    private String testName;
    private Integer totalQuestions;
    private Integer correctAnswers;
    private String startTime;
    private String endTime;
}