package swp.se1941jv.pls.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;
import org.springframework.format.annotation.DateTimeFormat;
import swp.se1941jv.pls.entity.User;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class ChapterResponseDTO {
    Long chapterId;

    String chapterName;

    String chapterDescription;

    Boolean status;

    List<LessonResponseDTO> listLesson;

    ChapterStatusDTO chapterStatus;
    @Data
    @Builder
    @FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
    public static class ChapterStatusDTO {
        String statusCode;
        String description;
    }

    String subjectName;

    Long userCreated;

    String userFullName;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    LocalDateTime updatedAt;
}
