package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank; // Cho chuỗi không được rỗng và không chỉ chứa khoảng trắng
import jakarta.validation.constraints.NotEmpty; // Cho chuỗi không được rỗng
import jakarta.validation.constraints.NotNull; // Cho đối tượng không được null
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
@ToString(exclude = { "packageSubjects", "chapters", "subjectTests", "grade" })
@EqualsAndHashCode(exclude = { "packageSubjects", "chapters", "subjectTests", "grade" })
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Subject extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "subject_id")
    Long subjectId;

    @NotBlank(message = "Tên môn học không được để trống!") // Không được rỗng và không chỉ chứa khoảng trắng
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
    List<SubjectTest> subjectTests;

    @NotNull(message = "Bạn phải chọn một Lớp!")
    @ManyToOne
    @JoinColumn(name = "grade_id")
    Grade grade;

}