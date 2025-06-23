package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import swp.se1941jv.pls.entity.keys.KeyUserPackage;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_package")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserPackage {
    @EmbeddedId
    KeyUserPackage id;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    User user;

    @ManyToOne
    @MapsId("packageId")
    @JoinColumn(name = "package_id")
    Package pkg;

    @Column(name = "start_date")
    LocalDateTime startDate;

    @Column(name = "end_date")
    LocalDateTime endDate;
}