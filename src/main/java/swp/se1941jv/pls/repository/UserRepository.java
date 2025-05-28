package swp.se1941jv.pls.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import swp.se1941jv.pls.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {
    User findByEmail(String email);

    List<User> findAll();

    Page<User> findAll(Pageable pageable);

    Page<User> findAll(Specification<User> spec, Pageable pageable);

    boolean existsByEmail(String email);

    boolean existsByPhoneNumber(String phone);

    boolean existsByEmailAndUserIdNot(String email, Long userId);

    boolean existsByPhoneNumberAndUserIdNot(String phoneNumber, Long userId);

}