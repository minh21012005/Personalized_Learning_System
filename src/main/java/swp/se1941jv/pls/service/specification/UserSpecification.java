package swp.se1941jv.pls.service.specification;

import org.springframework.data.jpa.domain.Specification;

import swp.se1941jv.pls.entity.User;

public class UserSpecification {

    public static Specification<User> findUsersWithFilters(String roleName, String fullName) {
        Specification<User> spec = Specification.where(null);

        if (roleName != null && !roleName.isEmpty()) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("role").get("roleName"), roleName));
        }

        if (fullName != null && !fullName.isEmpty()) {
            spec = spec.and(
                    (root, query, cb) -> cb.like(cb.lower(root.get("fullName")), "%" + fullName.toLowerCase() + "%"));
        }

        return spec;
    }

}
