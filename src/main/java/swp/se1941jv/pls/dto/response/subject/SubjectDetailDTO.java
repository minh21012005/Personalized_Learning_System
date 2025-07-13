package swp.se1941jv.pls.dto.response.subject;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
public class SubjectDetailDTO {
    private Long subjectId;
    private String subjectName;
    private String subjectDescription;
    private String subjectImage;
    private Boolean isActive;
    private String gradeName;
    private String status;
    private String createdAt;
    private String updatedAt;
    private String assignedToFullName;
    private String submittedByFullName;
    private String feedback;
    private List<ChapterDetailDTO> chapters;
}