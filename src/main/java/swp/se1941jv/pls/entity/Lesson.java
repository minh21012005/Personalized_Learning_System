package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
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

    @Column(name = "lesson_name", columnDefinition = "NVARCHAR(255)")
    String lessonName;

    @Column(name = "lesson_description", columnDefinition = "NVARCHAR(255)")
    String lessonDescription;

    @Column(name = "video_src")
    String videoSrc;

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