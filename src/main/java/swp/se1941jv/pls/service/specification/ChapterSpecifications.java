package swp.se1941jv.pls.service.specification;

import jakarta.persistence.criteria.CriteriaQuery;
import org.springframework.data.jpa.domain.Specification;
import swp.se1941jv.pls.entity.Chapter;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.Root;

public class ChapterSpecifications {

    public static Specification<Chapter> hasSubjectId(Long subjectId) {
        return (Root<Chapter> root ,CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (subjectId == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("subject").get("id"), subjectId);
        };
    }

    public static Specification<Chapter> hasName(String chapterName) {
        return (Root<Chapter> root ,CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (chapterName == null || chapterName.isEmpty()) {
                return cb.conjunction();
            }
            return cb.like(cb.lower(root.get("chapterName")), "%" + chapterName.toLowerCase() + "%");
        };
    }

    public static Specification<Chapter> hasStatus(Boolean status) {
        return (Root<Chapter> root ,CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (status == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("status"), status);
        };
    }
}
