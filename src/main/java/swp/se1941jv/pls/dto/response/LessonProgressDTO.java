package swp.se1941jv.pls.dto.response;

import lombok.AccessLevel;
import lombok.Builder;
import lombok.Data;
import lombok.experimental.FieldDefaults;

@Data
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class LessonProgressDTO {

    Long id;

    Long userId;

    Long lessonId;

    Long subjectId;

    Long packageId;

    Integer watchedTime;

    Boolean isCompleted;
}