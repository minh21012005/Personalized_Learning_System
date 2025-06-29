package swp.se1941jv.pls.dto.response.learningPageData;


import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Data;
import lombok.experimental.FieldDefaults;
import swp.se1941jv.pls.dto.response.learningPageData.LearningLessonDTO;

import java.util.List;

@Data
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class LearningChapterDTO {
    Long chapterId;
    String chapterName;
    String chapterDescription; // Giữ lại nếu bạn muốn hiển thị mô tả chương
    List<LearningLessonDTO> listLesson;
}