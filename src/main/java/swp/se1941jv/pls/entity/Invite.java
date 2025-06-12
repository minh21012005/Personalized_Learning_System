package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Entity
@Table(name = "invite")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Invite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id", nullable = false)
    @NotNull(message = "Parent cannot be null")
    User parent;

    @Column(name = "student_email", nullable = false)
    @NotBlank(message = "Student email cannot be blank")
    @Email(message = "Student email must be valid")
    String studentEmail;

    @Column(name = "invite_code", nullable = false, unique = true)
    @NotBlank(message = "Invite code cannot be blank")
    String inviteCode;

    @Column(name = "created_at", nullable = false)
    @NotNull(message = "Created at cannot be null")
    LocalDateTime createdAt;

    @Column(name = "expires_at", nullable = false)
    @NotNull(message = "Expires at cannot be null")
    LocalDateTime expiresAt;

    @Column(name = "used", nullable = false)
    @NotNull(message = "Used status cannot be null")
    Boolean isUsed = false;
}