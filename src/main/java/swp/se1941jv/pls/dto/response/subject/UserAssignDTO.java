package swp.se1941jv.pls.dto.response.subject;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder

//Chứa userId, fullName, email để hiển thị trong dropdown Staff trong assign_content.jsp.
public class UserAssignDTO {
    private Long userId;
    private String fullName;
    private String email;
}