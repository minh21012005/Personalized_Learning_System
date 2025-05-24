package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "subjects")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Subject extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "subject_id")
    Long subjectId;

    @Column(name = "subject_name", columnDefinition = "NVARCHAR(255)")
    String subjectName;

    @Column(name = "subject_description", columnDefinition = "NVARCHAR(255)")
    String subjectDescription;

    @Column(name = "subject_image")
    String subjectImage;

    @Column(name = "status")
    String status;

    @OneToMany(mappedBy = "subject")
    List<PackageSubject> packageSubjects;

    @OneToMany(mappedBy = "subject")
    List<Chapter> chapters;

    @OneToMany(mappedBy = "subject")
    List<SubjectTest> subjectTests;

    @ManyToOne
    @JoinColumn(name = "grade_id")
    Grade grade;
}