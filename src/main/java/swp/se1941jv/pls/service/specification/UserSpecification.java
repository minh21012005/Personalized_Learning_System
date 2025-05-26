package swp.se1941jv.pls.service.specification;

import org.springframework.data.jpa.domain.Specification;

import swp.se1941jv.pls.entity.User;

public class UserSpecification {
    public static Specification<User> hasRole(String roleName) {
        return (root, query, cb) -> {
            if (roleName == null || roleName.isEmpty()) {
                return cb.conjunction(); // không filter
            }
            return cb.equal(root.get("role").get("roleName"), roleName);
        };
    }
}
