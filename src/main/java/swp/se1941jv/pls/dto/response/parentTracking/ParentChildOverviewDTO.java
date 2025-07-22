package swp.se1941jv.pls.dto.response.parentTracking;


import lombok.AccessLevel;
import lombok.Builder;
import lombok.Data;
import lombok.experimental.FieldDefaults;

@Data
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ParentChildOverviewDTO {
    Long userId;
    String fullName;
    String dob; // Thay đổi từ LocalDate thành String
    String avatar;
}