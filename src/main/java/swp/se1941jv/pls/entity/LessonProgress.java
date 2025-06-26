package swp.se1941jv.pls.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.proxy.HibernateProxy;
import swp.se1941jv.pls.entity.keys.KeyLessonUser;

import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "lesson_progress")
@Getter
@Setter
@ToString
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class LessonProgress {

    @EmbeddedId
    KeyLessonUser id;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    User user;

    @ManyToOne
    @MapsId("lessonId")
    @JoinColumn(name = "lesson_id")
    Lesson lesson;

    @Column(name = "watched_time", nullable = false)
    Integer watchedTime;

    @Column(name = "is_completed", nullable = false)
    Boolean isCompleted;

    @Column(name = "updated_at")
    LocalDateTime updatedAt;




}