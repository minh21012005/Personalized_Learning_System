package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import swp.se1941jv.pls.entity.keys.KeyPackageSubject;

@Entity
@Table(name = "package_subject")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PackageSubject {
    @EmbeddedId
    KeyPackageSubject id;

    @ManyToOne
    @MapsId("packageId")
    @JoinColumn(name = "package_id")
    Package pkg;

    @ManyToOne
    @MapsId("subjectId")
    @JoinColumn(name = "subject_id")
    Subject subject;
}