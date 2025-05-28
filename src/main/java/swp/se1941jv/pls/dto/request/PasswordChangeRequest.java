package swp.se1941jv.pls.dto.request;

public class PasswordChangeRequest {
    private String oldPassword;
    private String newPassword;

    // Getter for oldPassword
    public String getOldPassword() {
        return oldPassword;
    }

    // Setter for oldPassword
    public void setOldPassword(String oldPassword) {
        this.oldPassword = oldPassword;
    }

    // Getter for newPassword
    public String getNewPassword() {
        return newPassword;
    }

    // Setter for newPassword
    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }
}