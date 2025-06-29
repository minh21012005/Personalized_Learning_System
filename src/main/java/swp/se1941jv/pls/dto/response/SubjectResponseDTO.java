package swp.se1941jv.pls.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Data;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Data
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@JsonInclude(JsonInclude.Include.NON_NULL)

public class SubjectResponseDTO {
    Long subjectId;

    String subjectName;

    String subjectDescription;

    String subjectImage;

    Boolean isActive;

    Long numberOfLessons;

    Long numberOfCompletedLessons;

    List<ChapterResponseDTO> listChapter;
}
