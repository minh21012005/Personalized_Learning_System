package swp.se1941jv.pls.service;

import swp.se1941jv.pls.entity.Grade;
import java.util.List;
import java.util.Optional;

public interface GradeService {
    List<Grade> getAllGrades();
    List<Grade> getActiveGrades();
    Optional<Grade> getGradeById(Long id);
    Grade saveGrade(Grade grade);
    void deleteGradeById(Long id);
}