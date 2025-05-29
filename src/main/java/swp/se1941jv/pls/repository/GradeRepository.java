package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Grade;
import java.util.List;

@Repository
public interface GradeRepository extends JpaRepository<Grade, Long> {
List<Grade> findByIsActiveTrue();
List<Grade> findByIsActiveFalse();
}