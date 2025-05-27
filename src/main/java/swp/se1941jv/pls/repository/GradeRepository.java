package swp.se1941jv.pls.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import swp.se1941jv.pls.entity.Grade;

public interface GradeRepository extends JpaRepository<Grade, Long> {
    List<Grade> findByIsActive(boolean isActive);

    Grade findByGradeName(String gradeName);

    Page<Grade> findByGradeNameContainingIgnoreCaseAndIsActive(String gradeName, boolean isActive, Pageable pageable);

    Page<Grade> findByGradeNameContainingIgnoreCase(String gradeName, Pageable pageable);

    Page<Grade> findByIsActive(boolean isActive, Pageable pageable);

}
