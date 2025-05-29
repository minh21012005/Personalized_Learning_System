package swp.se1941jv.pls.dto.request;


import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;
import org.springframework.format.annotation.DateTimeFormat;
import swp.se1941jv.pls.service.validator.RegisterChecked;
import swp.se1941jv.pls.service.validator.StrongPassword;


@RegisterChecked
public class RegisterDTO {

    @Size(min = 3, message = "Họ và tên phải có ít nhất 3 kí tự!")
    private String fullName;

    @Email(message = "Email không hợp lệ!", regexp = "^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$")
    private String email;

    @NotNull
    @StrongPassword
    private String password;

    private String confirmPassword;

    @Pattern(regexp = "^(03[2-9]|05[6-9]|07[0-9]|08[1-9]|09[0-9])\\d{7}$", message = "Số điện thoại không hợp lệ! Phải bắt đầu bằng các đầu số Việt Nam hợp lệ và gồm đúng 10 chữ số.")
    private String phoneNumber;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @NotNull(message = "Ngày sinh không được để trống!")
    @Past(message = "Ngày sinh phải trong quá khứ!")
    private LocalDate dob;

    @NotNull(message = "Vui lòng chọn vai trò!")
    private String role;

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}