package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "question_type")
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class QuestionType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "question_type_id")
    Long questionTypeId;

    @Column(name = "question_type_name", columnDefinition = "NVARCHAR(255)")
    String questionTypeName;

    @Column(name = "question_type_description", columnDefinition = "NVARCHAR(255)")
    String questionTypeDescription;

    @OneToMany(mappedBy = "questionType")
    List<QuestionBank> questionBanks;

}