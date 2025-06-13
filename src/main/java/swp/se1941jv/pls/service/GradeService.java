package swp.se1941jv.pls.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Grade;
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
        if (existingGrade != null && !existingGrade.getGradeId().equals(grade.getGradeId())) {
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

    public Page<Grade> getAllGrades(Pageable pageable) {
        return this.gradeRepository.findAll(pageable);
    }

    public Page<Grade> getFilteredGrades(String keyword, String isActive, Pageable pageable) {
        if (keyword != null && !keyword.trim().isEmpty() && isActive != null && !isActive.isEmpty()) {
            return gradeRepository.findByGradeNameContainingIgnoreCaseAndIsActive(
                    keyword, Boolean.parseBoolean(isActive), pageable);
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            return gradeRepository.findByGradeNameContainingIgnoreCase(keyword, pageable);
        } else if (isActive != null && !isActive.isEmpty()) {
            return gradeRepository.findByIsActive(Boolean.parseBoolean(isActive), pageable);
        } else {
            return gradeRepository.findAll(pageable);
        }
    }

    public Optional<Grade> getGradeById(Long id) {
        return gradeRepository.findById(id);
    }

    public void deleteGradeById(Long id) {
        gradeRepository.deleteById(id);
    }

    public List<Grade> getActiveGrades() {
        return gradeRepository.findByIsActiveTrue();
    }

    public List<Grade> getAllGradesIsActive() {
        return gradeRepository.findByIsActiveTrue(); // Chỉ lấy các Grade đang hoạt động
    }

}