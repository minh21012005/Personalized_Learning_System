package swp.se1941jv.pls.dto.response.homepage;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PackageHomeDTO {
    String imageUrl;
    String name;
    String description;
}
