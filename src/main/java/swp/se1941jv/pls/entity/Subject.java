package swp.se1941jv.pls.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "subjects")
// @Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString(exclude = { "packageSubjects", "chapters", "subjectTests", "grade","statusHistories","assignments" })
@EqualsAndHashCode(exclude = { "packageSubjects", "chapters", "subjectTests", "grade" })
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Subject extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "subject_id")
    Long subjectId;

    @NotBlank(message = "Tên môn học không được để trống!")
    @Size(min = 2, max = 255, message = "Tên môn học phải từ 2 đến 255 ký tự.")
    @Column(name = "subject_name", columnDefinition = "NVARCHAR(255)")
    String subjectName;

    @Column(name = "subject_description", columnDefinition = "NVARCHAR(255)")
    String subjectDescription;

    @Column(name = "subject_image")
    String subjectImage;

    @Column(name = "is_active")
    Boolean isActive;

    @OneToMany(mappedBy = "subject")
    List<PackageSubject> packageSubjects;

    @OneToMany(mappedBy = "subject")
    List<Chapter> chapters;

    @OneToMany(mappedBy = "subject")
    List<Test> tests;

    @ManyToOne
    @JoinColumn(name = "grade_id")
    Grade grade;

    @OneToMany(mappedBy = "subject")
    List<SubjectStatusHistory> statusHistories;

    @OneToMany(mappedBy = "subject")
    List<SubjectAssignment> assignments;
}