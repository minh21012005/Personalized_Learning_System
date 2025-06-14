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
    public static Specification<Lesson> hasName(String lessonName) {
        return (Root<Lesson> root ,CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (lessonName == null || lessonName.isEmpty()) {
                return cb.conjunction();
            }
            return cb.like(cb.lower(root.get("lessonName")), "%" + lessonName.toLowerCase() + "%");
        };
    }

    public static Specification<Lesson> hasStatus(Boolean status) {
        return (Root<Lesson> root ,CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (status == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("status"), status);
        };
    }
}
