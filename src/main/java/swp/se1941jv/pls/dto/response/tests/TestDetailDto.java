package swp.se1941jv.pls.dto.response.tests;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class TestDetailDto {
    private Long testId;
    private String testName;
    private Long subjectId;
    private String subjectName;
    private Long chapterId;
    private String chapterName;
    private Long lessonId;
    private String lessonName;
    private Integer durationTime;
    private Long maxAttempts;
    private String startAt;
    private String endAt;
    private Long statusId;
    private String statusName;
    private Boolean isOpen;
    private Long categoryId;
    private String categoryName;
    private List<QuestionCreateTestDisplayDto> questions;
    private String reason;

}