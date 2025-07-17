package swp.se1941jv.pls.dto.response.studentProgress;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class RecentTestDTO {
    private Long testId;
    private String testName;
    private Double score; // Điểm trên thang 10
    private String timeEnd; // Ngày hoàn thành dưới dạng chuỗi
}