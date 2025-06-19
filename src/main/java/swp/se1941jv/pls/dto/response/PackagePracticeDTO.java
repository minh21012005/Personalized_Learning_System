package swp.se1941jv.pls.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PackagePracticeDTO {
    private Long packageId;
    private String name;
    private String description;
    private String imageUrl;
    private String startDate;
    private String endDate;
}
