package swp.se1941jv.pls.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import swp.se1941jv.pls.entity.Grade;

public interface GradeRepository extends JpaRepository<Grade, Long> {
    List<Grade> findByIsActive(boolean isActive);

    Grade findByGradeName(String gradeName);

}
