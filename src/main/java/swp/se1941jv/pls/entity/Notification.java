package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "notifications")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Notification extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notification_id")
    Long notificationId;

    @Column(name = "content", columnDefinition = "NVARCHAR(255)")
    String content;

    @Column(name = "is_read")
    Boolean isRead;

    @OneToMany(mappedBy = "notification")
    List<UserNotification> userNotifications;
}