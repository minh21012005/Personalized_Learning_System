package swp.se1941jv.pls.dto.request;

import jakarta.validation.constraints.NotNull;
import swp.se1941jv.pls.service.validator.StrongPassword;

public class ResetPasswordDTO {

    @NotNull
    @StrongPassword
    private String password;

    private String confirmPassword;

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
}