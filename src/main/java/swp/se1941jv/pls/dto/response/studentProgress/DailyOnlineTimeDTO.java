package swp.se1941jv.pls.dto.response.studentProgress;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class DailyOnlineTimeDTO {
    private String date; // Ngày dưới dạng chuỗi
    private String timeFormatted; // Định dạng giờ:phút
    private Long totalMinutes; // Tổng phút
}