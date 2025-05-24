package swp.se1941jv.pls.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import swp.se1941jv.pls.entity.Grade;

public interface GradeRepository extends JpaRepository<Grade, Long> {
    List<Grade> findByStatus(String status);

    Grade findByGradeName(String gradeName);
}
