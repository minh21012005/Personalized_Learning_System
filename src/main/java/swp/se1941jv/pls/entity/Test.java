package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

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

    @ManyToOne
    @JoinColumn(name = "test_status_id")
    TestStatus testStatus;

    @OneToMany(mappedBy = "test")
    List<Chapter> chapters;

    @OneToMany(mappedBy = "test")
    List<Lesson> lessons;

    @OneToMany(mappedBy = "test")
    List<SubjectTest> subjectTests;

    @OneToMany(mappedBy = "test")
    List<UserTest> userTests;

    @OneToMany(mappedBy = "test")
    List<AnswerHistoryTest> answerHistories;

    @ManyToOne
    @JoinColumn(name = "test_category_id")
    TestCategory testCategory;

}