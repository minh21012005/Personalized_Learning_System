package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_test")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserTest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_test_id")
    Long userTestId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    User user;

    @ManyToOne
    @JoinColumn(name = "test_id")
    Test test;

    @ManyToOne
    @JoinColumn(name = "package_id")
    Package pkg;

    @Column(name = "time_start")
    LocalDateTime timeStart;

    @Column(name = "time_end")
    LocalDateTime timeEnd;

    @Column(name = "total_questions")
    Integer totalQuestions;

    @Column(name = "correct_answers")
    Integer correctAnswers;
}