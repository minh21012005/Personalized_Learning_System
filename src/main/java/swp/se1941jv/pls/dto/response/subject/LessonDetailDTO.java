package swp.se1941jv.pls.dto.response.subject;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
public class LessonDetailDTO {
    private Long lessonId;
    private String lessonName;
    private String lessonDescription;
    private Boolean status;
    private String videoSrc;
    private String videoTime;
    private String videoTitle;
    private String thumbnailUrl;
    private String createdAt;
    private String userCreatedFullName;
    private List<LessonMaterialDTO> lessonMaterials;

    @Getter
    @Setter
    @Builder
    public static class LessonMaterialDTO {
        private String fileName;
        private String filePath;
    }
}