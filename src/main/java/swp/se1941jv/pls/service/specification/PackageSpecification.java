package swp.se1941jv.pls.service.specification;

import java.util.List;

import org.springframework.data.jpa.domain.Specification;

import swp.se1941jv.pls.entity.Package;

public class PackageSpecification {
    public static Specification<Package> findPackageWithFilters(String course, List<String> grades,
            List<String> subjects) {
        Specification<Package> spec = Specification.where(null);

        spec = spec.and((root, query, cb) -> cb.isTrue(root.get("isActive")));

        if (course != null && !course.isEmpty()) {
            spec = spec.and(
                    (root, query, cb) -> cb.like(cb.lower(root.get("name")), "%" + course.toLowerCase() + "%"));
        }

        if (grades != null && !grades.isEmpty()) {
            spec = spec.and(
                    (root, query, cb) -> root.join("grade").get("gradeId").in(grades));
        }

        if (subjects != null && !subjects.isEmpty()) {
            spec = spec.and((root, query, cb) -> root.join("packageSubjects")
                    .join("subject")
                    .get("subjectId")
                    .in(subjects));
        }

        return spec;
    }
}
