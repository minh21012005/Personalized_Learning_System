package swp.se1941jv.pls.service.specification;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import org.springframework.data.jpa.domain.Specification;
import swp.se1941jv.pls.entity.Subject;

public class SubjectSpecifications {
    public static Specification<Subject> hasStatus(Boolean status) {
        return (Root<Subject> root , CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (status == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("status"), status);
        };
    }
}
