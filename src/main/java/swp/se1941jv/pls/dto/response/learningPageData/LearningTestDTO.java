package swp.se1941jv.pls.dto.response.learningPageData;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Data;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Data
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class LearningTestDTO {
    Long testId;
    String testName;
    Integer durationTime;
    String testCategoryName;
    Boolean isCompleted;
    LocalDateTime startAt;
    LocalDateTime endAt;
}