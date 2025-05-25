package swp.se1941jv.pls.repository;

import javax.security.auth.Subject;

import org.springframework.data.jpa.repository.JpaRepository;

public interface SubjectRepository extends JpaRepository<Subject, Long> {

}
