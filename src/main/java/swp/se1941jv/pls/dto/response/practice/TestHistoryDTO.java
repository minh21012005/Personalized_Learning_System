package swp.se1941jv.pls.dto.response.practice;

import lombok.Builder;
import lombok.Data;
import swp.se1941jv.pls.entity.UserTest;

import java.util.Date;
import java.util.List;

@Data
@Builder
public class TestHistoryDTO {
    private UserTest userTest;
    private String testName;
    private String startTime;
    private String endTime;
    private List<QuestionAnswerResDTO> answers;
}