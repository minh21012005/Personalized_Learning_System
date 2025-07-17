package swp.se1941jv.pls.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
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
@ToString(exclude = {"questions", "subjectTests", "test", "chapter", "lessonMaterials"})
public class Lesson extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "lesson_id")
    Long lessonId;

    @NotBlank(message = "Tên bài học không được để trống")
    @Size(min = 3, max = 255, message = "Tên bài học phải từ 3 đến 255 ký tự")
    @Column(name = "lesson_name", columnDefinition = "NVARCHAR(255)")
    String lessonName;

    @NotBlank(message = "Mô tả bài học không được để trống")
    @Size(min = 10, max = 1000, message = "Mô tả bài học phải từ 10 đến 1000 ký tự")
    @Column(name = "lesson_description", columnDefinition = "TEXT")
    String lessonDescription;

    @Column(name = "status", columnDefinition = "BOOLEAN DEFAULT FALSE")
    Boolean status;

    @Column(name = "is_hidden", columnDefinition = "BOOLEAN DEFAULT FALSE")
    Boolean isHidden;

    @NotBlank(message = "Link video không được để trống")
    @Column(name = "video_src")
    String videoSrc;

    @Column(name = "video_time")
    String videoTime;

    @Column(name = "video_title")
    String videoTitle;

    @Column(name = "thumbnail_url")
    String thumbnailUrl;

    @ManyToOne
    @JoinColumn(name = "chapter_id")
    Chapter chapter;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "test_id", unique = true)
    private Test test;

    @OneToMany(mappedBy = "lesson", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LessonMaterial> lessonMaterials;

    @OneToMany(mappedBy = "lesson")
    List<QuestionBank> questions;

//    @OneToMany(mappedBy = "lesson")
//    List<SubjectTest> subjectTests;
}