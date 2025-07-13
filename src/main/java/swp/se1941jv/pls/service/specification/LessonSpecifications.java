package swp.se1941jv.pls.service.specification;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import org.springframework.data.jpa.domain.Specification;
import swp.se1941jv.pls.entity.Lesson;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class LessonSpecifications {
    public static Specification<Lesson> hasChapterId(Long chapterId) {
        return (Root<Lesson> root , CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (chapterId == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("chapter").get("chapterId"), chapterId); //
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



    /**
     * Thêm specification cho subjectId thông qua chapter.
     */
    public static Specification<Lesson> hasSubjectId(Long subjectId) {
        return (Root<Lesson> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (subjectId == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("chapter").get("subject").get("subjectId"), subjectId);
        };
    }

    /**
     * Thêm specification cho userCreated thông qua chapter.
     */
    public static Specification<Lesson> hasUserCreated(Long userCreated) {
        return (Root<Lesson> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (userCreated == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("lesson").get("userCreated"), userCreated);
        };
    }

    /**
     * Thêm specification cho updatedAt giữa hai ngày.
     */
    public static Specification<Lesson> hasUpdatedAtBetween(LocalDate startDate, LocalDate endDate) {
        return (Root<Lesson> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (startDate == null && endDate == null) {
                return cb.conjunction();
            }
            if (startDate == null) {
                return cb.lessThanOrEqualTo(root.get("updatedAt"), endDate);
            }
            if (endDate == null) {
                return cb.greaterThanOrEqualTo(root.get("updatedAt"), startDate);
            }
            return cb.between(root.get("updatedAt"), startDate, endDate);
        };
    }
}
