package swp.se1941jv.pls.dto.response.chapter;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ChapterListDTO {
    private Long chapterId;
    private String chapterName;
    private String chapterDescription;
    private Boolean status;
    private Boolean isHidden;
    private String subjectName;
    private Long userCreated;
    private String userFullName;
    private String createdAt;
}