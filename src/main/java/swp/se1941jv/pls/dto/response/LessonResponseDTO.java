package swp.se1941jv.pls.dto.response;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Data;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Data
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class LessonResponseDTO {
    Long lessonId;

    String lessonName;

    String lessonDescription;

    String videoSrc;

    Boolean status;

    List<String> materials;
}
