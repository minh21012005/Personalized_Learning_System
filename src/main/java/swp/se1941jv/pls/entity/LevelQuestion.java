package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "level_question")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class LevelQuestion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "level_question_id")
    Long levelQuestionId;

    @Column(name = "level_question_name", columnDefinition = "NVARCHAR(255)")
    String levelQuestionName;

    @Column(name = "level_question_description", columnDefinition = "NVARCHAR(255)")
    String levelQuestionDescription;

    @OneToMany(mappedBy = "levelQuestion")
    List<QuestionBank> questions;
}