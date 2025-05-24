package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import swp.se1941jv.pls.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByEmail(String email);
}