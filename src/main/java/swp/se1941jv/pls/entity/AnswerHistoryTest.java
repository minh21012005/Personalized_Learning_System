package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Table(name = "answer_history_test")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class AnswerHistoryTest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "answer_history_id")
    Long answerHistoryId;

    @ManyToOne
    @JoinColumn(name = "user_test_id")
    UserTest userTest;

    @ManyToOne
    @JoinColumn(name = "question_id")
    QuestionBank question;

    @Column(name = "answer", columnDefinition = "TEXT")
    String answer;
}