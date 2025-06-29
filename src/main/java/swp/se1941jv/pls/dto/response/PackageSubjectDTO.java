package swp.se1941jv.pls.dto.response;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class PackageSubjectDTO {
    private Long packageId;
    private String name;
    private String description;
    private String imageUrl;
    private String startDate;
    private String endDate;
    private List<SubjectResponseDTO> listSubject;
}
