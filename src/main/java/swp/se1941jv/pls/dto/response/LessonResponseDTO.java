package swp.se1941jv.pls.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Data;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class LessonResponseDTO {
    Long lessonId;
    String lessonName;
    String lessonDescription;
    String videoSrc;
    String videoTime;
    Boolean status;
    LessonStatusDTO lessonStatus;
    List<String> materials;
    Long chapterId;
    String chapterName;
    String userFullName;
    String updatedAt;
    String subjectName;

    @Data
    @Builder
    @FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
    public static class LessonStatusDTO {
        String statusCode;
        String description;
    }
}