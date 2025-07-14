package swp.se1941jv.pls.dto.response.studentProgress;

import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class LearningProgressResponseDTO {
    private List<LearningProgressDTO> data;
    private Long total;
}