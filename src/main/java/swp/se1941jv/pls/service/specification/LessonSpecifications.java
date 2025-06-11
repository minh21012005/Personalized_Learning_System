package swp.se1941jv.pls.service.specification;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import org.springframework.data.jpa.domain.Specification;
import swp.se1941jv.pls.entity.Lesson;

public class LessonSpecifications {
    public static Specification<Lesson> hasChapterId(Long chapterId) {
        return (Root<Lesson> root , CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (chapterId == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("chapter").get("id"), chapterId);
        };
    }
}
