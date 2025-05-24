package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import swp.se1941jv.pls.entity.Role;

public interface RoleRepository extends JpaRepository<Role, String> {
}
