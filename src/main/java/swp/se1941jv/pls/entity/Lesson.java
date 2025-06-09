package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "lessons")
@Data
@EqualsAndHashCode(callSuper = true)
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Lesson extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "lesson_id")
    Long lessonId;

    @NotBlank(message = "Lesson name cannot be blank")
    @Size(max = 255, message = "Lesson name must not exceed 255 characters")
    @Column(name = "lesson_name", columnDefinition = "NVARCHAR(255)")
    String lessonName;

    @Column(name = "lesson_description", columnDefinition = "NVARCHAR(255)")
    String lessonDescription;

    @Column(name = "status", columnDefinition = "BOOLEAN DEFAULT TRUE")
    Boolean status;

    @Column(name = "video_src")
    String videoSrc;

    @Column(name = "materials_json", columnDefinition = "TEXT")
    private String materialsJson;


    @ManyToOne
    @JoinColumn(name = "chapter_id")
    Chapter chapter;

    @ManyToOne
    @JoinColumn(name = "test_id")
    Test test;

    @OneToMany(mappedBy = "lesson")
    List<QuestionBank> questions;

    @OneToMany(mappedBy = "lesson")
    List<SubjectTest> subjectTests;
}