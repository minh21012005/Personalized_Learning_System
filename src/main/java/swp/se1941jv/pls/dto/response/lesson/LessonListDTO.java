package swp.se1941jv.pls.dto.response.lesson;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class LessonListDTO {
    private Long lessonId;
    private String lessonName;
    private String lessonDescription;
    private String videoSrc;
    private String videoTime;
    private String videoTitle;
    private String thumbnailUrl;
    private Boolean status;
    private List<LessonMaterialDTO> lessonMaterials;
    private Long chapterId;
    private String chapterName;
    private String userFullName;
    private String createdAt;

    @Data
    @Builder
    public static class LessonMaterialDTO {
        private String fileName;
        private String filePath;
    }
}