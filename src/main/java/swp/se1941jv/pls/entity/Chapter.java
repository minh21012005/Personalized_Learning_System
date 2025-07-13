package swp.se1941jv.pls.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "chapter")
//@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@ToString(exclude = {"subjectTests", "test", "lessons"})
public class Chapter extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chapter_id")
    Long chapterId;

    @NotBlank(message = "Tên chương không được để trống")
    @Size(min = 3, max = 100, message = "Tên chương phải có độ dài từ 3 đến 100 ký tự")
    @Column(name = "chapter_name", columnDefinition = "NVARCHAR(255)")
    String chapterName;

    @NotBlank(message = "Mô tả chương không được để trống")
    @Size(min = 10, max = 1000, message = "Mô tả chương phải có độ dài từ 10 đến 1000 ký tự")
    @Column(name = "chapter_description", columnDefinition = "TEXT")
    String chapterDescription;

    @Column(name = "status", columnDefinition = "BOOLEAN DEFAULT TRUE")
    Boolean status;

    @ManyToOne
    @JoinColumn(name = "subject_id")
    Subject subject;

    @ManyToOne
    @JoinColumn(name = "test_id")
    Test test;

    @OneToMany(mappedBy = "chapter")
    List<Lesson> lessons;

    @OneToMany(mappedBy = "chapter")
    List<SubjectTest> subjectTests;

    @OneToMany(mappedBy = "chapter")
    List<Test> tests;

}