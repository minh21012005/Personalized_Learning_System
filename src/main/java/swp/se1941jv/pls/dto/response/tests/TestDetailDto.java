package swp.se1941jv.pls.dto.response.tests;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class TestDetailDto {
    private Long testId;
    private String testName;
    private String subjectName;
    private String chapterName;
    private Integer durationTime;
    private String startAt;
    private String endAt;
    private String statusName;
    private String categoryName;
    private List<QuestionCreateTestDisplayDto> questions;
}