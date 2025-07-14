package swp.se1941jv.pls.dto.response.subject;



import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@Builder
public class ChapterDetailDTO {
    private Long chapterId;
    private String chapterName;
    private String chapterDescription;
    private Boolean status;
    private String createdAt;
    private String userCreatedFullName;
    private List<LessonDetailDTO> lessons;
}