package swp.se1941jv.pls.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserResponseDTO {
    Long userId;
    String fullName;
}
