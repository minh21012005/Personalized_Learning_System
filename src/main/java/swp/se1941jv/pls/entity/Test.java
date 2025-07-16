package swp.se1941jv.pls.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import swp.se1941jv.pls.service.QuestionService;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "test")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Test extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "test_id")
    Long testId;

    @Column(name = "test_name", columnDefinition = "NVARCHAR(255)")
    String testName;

    @Column(name = "duration_time")
    Integer durationTime;

    @Column(name = "start_at")
    LocalDateTime startAt;

    @Column(name = "end_at")
    LocalDateTime endAt;

    @Column(name = "is_open")
    Boolean isOpen; // New field to track open/closed status

    @OneToOne
    @JoinColumn(name = "lesson_id")
    @JsonIgnoreProperties("test")
    private Lesson lesson;

    @ManyToOne
    @JoinColumn(name = "test_status_id")
    TestStatus testStatus;

    @ManyToOne
    @JoinColumn(name = "chapter_id")
    Chapter chapter;

    @ManyToOne
    @JoinColumn(name = "subject_id")
    Subject subject;

    @OneToMany(mappedBy = "test")
    List<UserTest> userTests;

    @Transient
    private List<QuestionBank> randomQuestions;

    @ManyToOne
    @JoinColumn(name = "test_category_id")
    TestCategory testCategory;

    @Column(name = "max_attempts")
    Long maxAttempts;

    @Column(name = "reason")
    private String reason;

}