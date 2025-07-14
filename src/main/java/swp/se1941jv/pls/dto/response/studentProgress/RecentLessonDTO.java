package swp.se1941jv.pls.dto.response.studentProgress;


import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class RecentLessonDTO {
    private Long lessonId;
    private String lessonName; // Tên bài học gần đây
    private String lastUpdated; // Ngày học gần đây dưới dạng chuỗi
    private Boolean isCompleted; // Trạng thái hoàn thành
}