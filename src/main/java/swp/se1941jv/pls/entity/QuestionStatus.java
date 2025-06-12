package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Table(name = "question_status")
@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class QuestionStatus {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "status_id")
    Long statusId;

    @Column(name = "status_name", nullable = false, unique = true)
    String statusName;

    @Column(name = "description")
    String description;
}