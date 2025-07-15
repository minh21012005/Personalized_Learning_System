package swp.se1941jv.pls.dto.response.learningPageData;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Data;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Data
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class LearningPageDataDTO {
    Long subjectId;
    String subjectName;
    Long userId;
    Long packageId;
    List<LearningChapterDTO> chapters;
    LearningLessonDTO defaultLesson;
    LearningChapterDTO defaultChapter;
    List<LearningTestDTO> subjectTests;
}