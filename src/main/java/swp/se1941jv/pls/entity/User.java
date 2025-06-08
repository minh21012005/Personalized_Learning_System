package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

@Entity
@Table(name = "user")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class User extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    Long userId;

    @Column(name = "email", nullable = false, unique = true)
    @NotBlank(message = "Email không được để trống!")
    @Email(message = "Email không hợp lệ!")
    String email;

    @Column(name = "password", nullable = false)
    @Size(min = 8, message = "Mật khẩu phải có ít nhất 8 kí tự!")
    @NotBlank(message = "Mật khẩu không được để trống hoặc chỉ chứa khoảng trắng!")
    String password;

    @Column(name = "is_active")
    Boolean isActive;

    @Column(name = "email_verify")
    Boolean emailVerify;

    @Column(name = "full_name", columnDefinition = "NVARCHAR(255)")
    @NotBlank(message = "Tên không được để trống!")
    @Size(min = 2, max = 50, message = "Tên phải có độ dài từ 2 đến 50 ký tự!")
    @Pattern(regexp = "^[\\p{L}\\s]+$", message = "Tên chỉ được chứa chữ cái và dấu cách!")
    private String fullName;

    @Column(name = "avatar")
    String avatar;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Column(name = "dob")
    @NotNull(message = "Ngày sinh ko được để trống!")
    @Past(message = "Ngày sinh phải trong quá khứ!")
    LocalDate dob;

    @Column(name = "phone_number", nullable = false, unique = true)
    @NotBlank(message = "Số điện thoại không được để trống!")
    @Pattern(regexp = "^(03[2-9]|05[6-9]|07[0-9]|08[1-9]|09[0-9])\\d{7}$", message = "Số điện thoại không hợp lệ! Phải bắt đầu bằng các đầu số Việt Nam hợp lệ và gồm đúng 10 chữ số.")
    private String phoneNumber;

    @ManyToOne
    @JoinColumn(name = "parent_id")
    User parent;

    @OneToMany(mappedBy = "parent")
    List<User> children;

    @OneToMany(mappedBy = "user")
    List<UserPackage> userPackages;

    @ManyToOne
    @JoinColumn(name = "role_name")
    Role role;

    @OneToOne(mappedBy = "user")
    Cart cart;

    @OneToMany(mappedBy = "user")
    List<UserNotification> userNotifications;

    @OneToMany(mappedBy = "user")
    List<UserTest> userTests;

    @OneToMany(mappedBy = "user")
    List<AnswerHistoryTest> answerHistories;

    @OneToMany(mappedBy = "userCreated")
    List<Transaction> transactions;

    @Column(name = "reset_password_token")
    String resetPasswordToken;

    @Column(name = "reset_password_token_expiry")
    LocalDateTime resetPasswordTokenExpiry;

    @Column(name = "email_verify_token")
    String emailVerifyToken;

    @Column(name = "email_verify_token_expiry")
    LocalDateTime emailVerifyTokenExpiry;

    // public boolean hasRole(String roleName) {
    // return this.role != null && this.role.getRoleName().equals(roleName);
    // }
}