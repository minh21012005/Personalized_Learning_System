package swp.se1941jv.pls.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class ChapterResponseDTO {
    Long chapterId;

    String chapterName;

    String chapterDescription;

    Boolean status;


}
