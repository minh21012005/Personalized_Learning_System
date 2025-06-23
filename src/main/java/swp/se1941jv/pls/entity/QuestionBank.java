package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "question_bank")
@Data
@Getter
@Setter
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
    @JoinColumn(name = "lesson_id")
    Lesson lesson;

    @ManyToOne
    @JoinColumn(name = "subject_id")
    Subject subject;

    @ManyToOne
    @JoinColumn(name = "chapter_id")
    Chapter chapter;

    @ManyToOne
    @JoinColumn(name = "grade_id")
    Grade grade;

    @Column(name = "content", columnDefinition = "TEXT")
    String content;

    @Column(name = "image", columnDefinition = "TEXT")
    String image;

    @Column(name = "options", columnDefinition = "TEXT")
    String options;

    @Column(name = "active")
    boolean active;

    @Column(name = "display_at_end_of_lesson")
    boolean displayAtEndOfLesson;

    @ManyToOne
    @JoinColumn(name = "level_question_id")
    LevelQuestion levelQuestion;

    @OneToMany(mappedBy = "question")
    List<AnswerHistoryTest> answerHistories;

    @ManyToOne
    @JoinColumn(name = "question_type_id")
    QuestionType questionType;

    @ManyToOne
    @JoinColumn(name = "status_id")
    QuestionStatus status;

    @OneToMany(mappedBy = "question")
    List<QuestionTest> questionTests;


}