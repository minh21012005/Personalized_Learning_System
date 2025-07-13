package swp.se1941jv.pls.dto.response.subject;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class SubjectFormDTO {
    private Long subjectId;

    @NotBlank(message = "Tên môn học không được để trống!")
    @Size(min = 2, max = 255, message = "Tên môn học phải từ 2 đến 255 ký tự.")
    private String subjectName;

    @Size(max = 255, message = "Mô tả không được vượt quá 255 ký tự.")
    private String subjectDescription;

    private String subjectImage;

    private Boolean isActive;

    @NotNull(message = "Phải chọn khối lớp.")
    private Long gradeId;
}