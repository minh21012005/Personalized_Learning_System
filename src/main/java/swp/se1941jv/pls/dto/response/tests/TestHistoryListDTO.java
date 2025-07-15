package swp.se1941jv.pls.dto.response.tests;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class TestHistoryListDTO {
    private Long testId;
    private Long userTestId;
    private String testName;
    private int totalQuestions;
    private int correctAnswers;
    private String startTime;
    private String endTime;
}