package swp.se1941jv.pls.dto.response.tests;


import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class TestListDto {
    private Long testId;
    private String testName;
    private String subjectName;
    private String chapterName;
    private Integer durationTime;
    private String startAt;
    private String endAt;
    private String statusName;
    private String categoryName;
}