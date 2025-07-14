package swp.se1941jv.pls.dto.response.chapter;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ChapterFormDTO {
    private Long chapterId;

    @NotBlank(message = "Tên chương không được để trống")
    @Size(min = 3, max = 100, message = "Tên chương phải từ 3 đến 100 ký tự.")
    private String chapterName;

    @NotBlank(message = "Mô tả chương không được để trống.")
    @Size(min = 10, max = 1000, message = "Mô tả chương phải từ 10 đến 1000 ký tự.")
    private String chapterDescription;

    @NotNull(message = "chapter.subjectId.notNull")
    private Long subjectId;
}