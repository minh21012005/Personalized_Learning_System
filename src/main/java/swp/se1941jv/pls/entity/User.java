package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

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
    String email;

    @Column(name = "password", nullable = false)
    String password;

    @Column(name = "is_active")
    Boolean isActive;

    @Column(name = "full_name", columnDefinition = "NVARCHAR(255)")
    String fullName;

    @Column(name = "avatar")
    String avatar;

    @Column(name = "dob")
    LocalDate dob;

    @Column(name = "phone_number")
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

//    public boolean hasRole(String roleName) {
//        return this.role != null && this.role.getRoleName().equals(roleName);
//    }
}