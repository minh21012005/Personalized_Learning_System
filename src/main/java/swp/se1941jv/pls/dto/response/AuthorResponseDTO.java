package swp.se1941jv.pls.dto.response;

import lombok.Builder;
import lombok.Data;
import swp.se1941jv.pls.entity.User;

@Data
@Builder
public class AuthorResponseDTO {
    private Long id;
    private String name;
    private String avatarUrl;

    public static AuthorResponseDTO fromEntity(User user) {
        if (user == null) {
            return AuthorResponseDTO.builder()
                    .id(-1L)
                    .name("Deleted User")
                    .avatarUrl(null)
                    .build();
        }

    return AuthorResponseDTO.builder()
                .id(user.getUserId())
                .name(user.getFullName())
                .avatarUrl(user.getAvatar())
                .build();
     }
}