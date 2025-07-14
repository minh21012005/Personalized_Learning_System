package swp.se1941jv.pls.dto.response.subject;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;

@Data
@AllArgsConstructor
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class SubjectListDTO {
    private Long subjectId;
    private String subjectName;
    private String subjectDescription;
    private String subjectImage;
    private Boolean isActive;
    private String gradeName;
    private String createdAt;
    private String updatedAt;
    private String assignedAt;
    private String assignedByFullName;
    private String status;
    private String assignedToFullName;
    private String submittedByFullName;
    private String feedback;
}