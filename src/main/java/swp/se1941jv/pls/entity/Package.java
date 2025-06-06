package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "package")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Package extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "package_id")
    Long packageId;

    @Column(name = "name", columnDefinition = "NVARCHAR(255)")
    String name;

    @Column(name = "description", columnDefinition = "NVARCHAR(255)")
    String description;

    @Column(name = "price")
    Double price;

    @Column(name = "duration_days")
    Integer durationDays;

    @Column(name = "is_active")
    Boolean isActive;

    @OneToMany(mappedBy = "pkg")
    List<UserPackage> userPackages;

    @OneToMany(mappedBy = "pkg")
    List<PackageSubject> packageSubjects;

    @ManyToOne()
    @JoinColumn(name = "grade_id")
    Grade grade;
}