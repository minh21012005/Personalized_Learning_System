package swp.se1941jv.pls.service.specification;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import org.springframework.data.jpa.domain.Specification;
import swp.se1941jv.pls.entity.Chapter;

import java.time.LocalDateTime;

public class ChapterSpecifications {

    public static Specification<Chapter> hasSubjectId(Long subjectId) {
        return (Root<Chapter> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (subjectId == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("subject").get("subjectId"), subjectId);
        };
    }

    public static Specification<Chapter> hasName(String chapterName) {
        return (Root<Chapter> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (chapterName == null || chapterName.trim().isEmpty()) {
                return cb.conjunction();
            }
            return cb.like(cb.lower(root.get("chapterName")), "%" + chapterName.toLowerCase() + "%");
        };
    }

    public static Specification<Chapter> hasStatus(Boolean status) {
        return (Root<Chapter> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (status == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("status"), status);
        };
    }

    public static Specification<Chapter> hasChapterStatus(String chapterStatus) {
        return (Root<Chapter> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (chapterStatus == null || chapterStatus.trim().isEmpty()) {
                return cb.conjunction();
            }
            try {
                Chapter.ChapterStatus status = Chapter.ChapterStatus.valueOf(chapterStatus.toUpperCase());
                return cb.equal(root.get("chapterStatus"), status);
            } catch (IllegalArgumentException e) {
                return cb.conjunction(); // Bỏ qua nếu trạng thái không hợp lệ
            }
        };
    }

    public static Specification<Chapter> hasUpdatedAtBetween(LocalDateTime startDate, LocalDateTime endDate) {
        return (Root<Chapter> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (startDate == null && endDate == null) {
                return cb.conjunction();
            }
            if (startDate != null && endDate != null) {
                return cb.between(root.get("updatedAt"), startDate, endDate);
            }
            if (startDate != null) {
                return cb.greaterThanOrEqualTo(root.get("updatedAt"), startDate);
            }
            return cb.lessThanOrEqualTo(root.get("updatedAt"), endDate);
        };
    }

    public static Specification<Chapter> hasUserCreated(Long userCreated) {
        return (Root<Chapter> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            if (userCreated == null) {
                return cb.conjunction();
            }
            return cb.equal(root.get("userCreated"), userCreated);
        };
    }
}