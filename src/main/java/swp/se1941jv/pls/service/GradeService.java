package swp.se1941jv.pls.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.GradeRepository;

@Service
public class GradeService {
    private final GradeRepository gradeRepository;

    public GradeService(GradeRepository gradeRepository) {
        this.gradeRepository = gradeRepository;

    }

    public List<Grade> getByStatus(boolean isActive) {
        return this.gradeRepository.findByIsActive(isActive);
    }

    public List<Grade> getAllGrades() {
        return this.gradeRepository.findAll();
    }

    public Grade saveGrade(Grade grade) {
        Grade existingGrade = gradeRepository.findByGradeName(grade.getGradeName());
        if (existingGrade != null) {
            throw new IllegalArgumentException("Grade name '" + grade.getGradeName() + "' already exists.");
        }

        return this.gradeRepository.save(grade);
    }

    public void deleteById(long gradeId) {
        this.gradeRepository.deleteById(gradeId);
    }

    public Optional<Grade> findById(long gradeId) {
        return this.gradeRepository.findById(gradeId);
    }

}
