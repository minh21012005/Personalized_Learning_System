package swp.se1941jv.pls.dto.response.subject;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder

//Chứa subjectId và subjectName để hiển thị trong form giao việc (assign_content.jsp).
public class SubjectAssignDTO {
    private Long subjectId;
    private String subjectName;
}