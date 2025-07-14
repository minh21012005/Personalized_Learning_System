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
    // Thông tin tổng quan môn học
    Long subjectId;
    String subjectName;

    // Thông tin người dùng và gói học (cần cho JS)
    Long userId;
    Long packageId;

    // Danh sách Chapter và Lesson
    List<LearningChapterDTO> chapters;

    // Lesson và Chapter mặc định để hiển thị lần đầu
    LearningLessonDTO defaultLesson;
    LearningChapterDTO defaultChapter;
}