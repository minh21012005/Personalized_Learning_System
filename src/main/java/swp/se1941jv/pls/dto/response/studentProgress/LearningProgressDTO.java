package swp.se1941jv.pls.dto.response.studentProgress;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class LearningProgressDTO {
    private Long subjectId;
    private String subjectName;
    private Long completedLessons;
    private Long totalLessons;
    private Double progressPercentage;
    private String subjectImage;
    private Long packageId;
}