package swp.se1941jv.pls.dto.response.lesson;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.List;

@Data
public class LessonFormDTO {
    private Long lessonId;

    @NotBlank(message = "Tên bài học không được để trống")
    @Size(min = 3, max = 255, message = "Tên bài học phải từ 3 đến 255 ký tự")
    private String lessonName;

    @NotBlank(message = "Mô tả bài học không được để trống")
    @Size(min = 10, max = 1000, message = "Mô tả bài học phải từ 10 đến 1000 ký tự")
    private String lessonDescription;

    @NotBlank(message = "Link video không được để trống")
    private String videoSrc;

    private String videoTime;

    private String videoTitle;

    private String thumbnailUrl;

    private List<LessonMaterialDTO> lessonMaterials;

    @NotNull(message = "ID chương không được để trống")
    private Long chapterId;

    private List<Long> questionIds;

    @Data
    public static class LessonMaterialDTO {
        private String fileName;
        private String filePath;
    }
}