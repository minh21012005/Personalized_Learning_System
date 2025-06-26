package swp.se1941jv.pls.dto.request;

import jakarta.validation.constraints.*;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;

@Data
public class CreateStudentRequest {
    @NotBlank(message = "Họ và tên không được để trống!")
    @Size(min = 2, max = 50, message = "Họ và tên phải có độ dài từ 2 đến 50 ký tự!")
    @Pattern(regexp = "^[\\p{L}\\s]+$", message = "Họ và tên chỉ được chứa chữ cái và dấu cách!")
    private String fullName;

    @NotBlank(message = "Email không được để trống!")
    @Email(message = "Email không hợp lệ!")
    private String email;

    @NotBlank(message = "Mật khẩu không được để trống!")
    @Size(min = 8, message = "Mật khẩu phải có ít nhất 8 ký tự!")
    private String password;

    @NotNull(message = "Ngày sinh không được để trống!")
    @Past(message = "Ngày sinh phải là một ngày trong quá khứ!")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate dob;

    @Pattern(regexp = "^(03[2-9]|05[6-9]|07[0-9]|08[1-9]|09[0-9])\\d{7}$", message = "Số điện thoại không hợp lệ! Phải bắt đầu bằng các đầu số Việt Nam hợp lệ và gồm đúng 10 chữ số.")
    private String phoneNumber;


}
