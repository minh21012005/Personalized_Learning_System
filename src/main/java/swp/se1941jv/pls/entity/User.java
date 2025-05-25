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
import swp.se1941jv.pls.service.validator.Adult;

import java.time.LocalDate;
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

    @Column(name = "full_name", columnDefinition = "NVARCHAR(255)")
    @NotBlank(message = "Tên không được để trống!")
    String fullName;

    @Column(name = "avatar")
    String avatar;

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Column(name = "dob")
    @NotNull(message = "Ngày sinh ko được để trống!")
    @Past(message = "Ngày sinh phải trong quá khứ!")
    @Adult
    LocalDate dob;

    @Column(name = "phone_number", nullable = false, unique = true)
    @NotBlank(message = "Số điện thoại không được để trống!")
    @Pattern(regexp = "^0\\d{9}$", message = "Số điện thoại phải bắt đầu bằng 0 và gồm đúng 10 chữ số!")
    String phoneNumber;

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

    @OneToMany(mappedBy = "user")
    List<UserNotification> userNotifications;

    @OneToMany(mappedBy = "user")
    List<UserTest> userTests;

    @OneToMany(mappedBy = "user")
    List<AnswerHistoryTest> answerHistories;

    @OneToMany(mappedBy = "userCreated")
    List<Transaction> transactions;

    // public boolean hasRole(String roleName) {
    // return this.role != null && this.role.getRoleName().equals(roleName);
    // }
}