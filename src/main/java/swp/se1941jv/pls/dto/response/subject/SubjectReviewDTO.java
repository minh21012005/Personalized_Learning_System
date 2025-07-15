package swp.se1941jv.pls.dto.response.subject;

import lombok.*;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder

//Chứa subjectId, subjectName, submittedByFullName, submittedAt, status để hiển thị trong form duyệt (review_content.jsp).
public class SubjectReviewDTO {
    private Long subjectId;
    private String subjectName;
    private String submittedByFullName;
    private LocalDateTime submittedAt;
    private String status;
}