package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "question_bank")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class QuestionBank extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "question_id")
    Long questionId;

    @ManyToOne
    @JoinColumn(name = "lession_id")
    Lesson lesson;

    @Column(name = "content", columnDefinition = "NVARCHAR(255)")
    String content;

    @Column(name = "answer", columnDefinition = "NVARCHAR(255)")
    String answer;

    @Column(name = "status")
    String status;

    @ManyToOne
    @JoinColumn(name = "level_question_id")
    LevelQuestion levelQuestion;

    @OneToMany(mappedBy = "question")
    List<AnswerHistoryTest> answerHistories;

    @ManyToOne
    @JoinColumn(name = "question_type_id")
    QuestionType questionType;
}