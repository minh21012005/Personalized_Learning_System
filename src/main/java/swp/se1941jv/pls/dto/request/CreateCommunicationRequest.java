package swp.se1941jv.pls.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class CreateCommunicationRequest {
    @NotBlank(message = "Content cannot be blank")
    private String content;
    private Long parentId;
}
