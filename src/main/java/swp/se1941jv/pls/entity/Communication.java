package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import java.util.List;

@Entity
@Table(name = "Communication")
@Data
@EqualsAndHashCode(callSuper = true, exclude = {"parentComment", "replies","user"})
@ToString(callSuper = true, exclude = {"parentComment", "replies","user"})
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)

public class Communication extends BaseEntity{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lesson_id", nullable = false)
    Lesson lesson;

    @Column(name = "content", nullable = false, columnDefinition = "TEXT")
    String content;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_comment_id")
    Communication parentComment;

    @OneToMany(mappedBy = "parentComment", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List<Communication> replies;

    @ManyToOne(fetch = FetchType.LAZY)
     @JoinColumn(
            name = "user_created",
            referencedColumnName = "user_id",
            insertable = false,
            updatable = false
     )
     private User user;


}
