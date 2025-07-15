package swp.se1941jv.pls.dto.response.tests;

import lombok.Builder;
import lombok.Getter;
import swp.se1941jv.pls.dto.response.practice.QuestionAnswerResDTO;
import swp.se1941jv.pls.entity.UserTest;

import java.util.List;

@Getter
@Builder
public class TestHistoryDTO {
    private UserTest userTest;
    private String testName;
    private String startTime;
    private String endTime;
    private List<QuestionAnswerResDTO> answers;
}