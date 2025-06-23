package swp.se1941jv.pls.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserReponseDTO {
    Long userId;
    String fullName;
}
