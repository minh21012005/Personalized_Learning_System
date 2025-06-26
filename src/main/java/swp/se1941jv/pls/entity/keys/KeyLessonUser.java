package swp.se1941jv.pls.entity.keys;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Embeddable
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class KeyLessonUser implements Serializable {
    @Column(name = "user_id", nullable = false)
    Long userId;

    @Column(name = "lesson_id", nullable = false)
    Long lessonId;
}
