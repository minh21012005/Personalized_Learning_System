package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Entity
@Table(name = "grades")
// @Data
@Getter 
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString(exclude = {"subjects"}) 
@EqualsAndHashCode(exclude = {"subjects"})
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Grade {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "grade_id")
    Long gradeId;

    @Column(name = "grade_name", columnDefinition = "NVARCHAR(255)")
    String gradeName;

    @Column(name = "is_active")
    boolean isActive;

    @OneToMany(mappedBy = "grade")
    List<Subject> subjects;


}