package swp.se1941jv.pls.dto.request;

import lombok.Data;
import swp.se1941jv.pls.entity.Communication.CommentStatus;

@Data
public class UpdateStatusRequest {
    private CommentStatus commentStatus;
}
