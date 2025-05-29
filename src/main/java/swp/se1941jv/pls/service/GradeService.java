package swp.se1941jv.pls.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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

    public Grade saveGrade(Grade grade, String name, boolean active) {
        boolean isExist = this.gradeRepository.existsByGradeName(grade.getGradeName());
        if (isExist) {
            throw new IllegalArgumentException("Khối lớp: '" + name + "' đã tồn tại.");
        } else {
            grade.setGradeName(name);
            grade.setActive(active);
            return this.gradeRepository.save(grade);
        }
    }

    public Grade saveGrade(Grade grade) {
        boolean isExist = this.gradeRepository.existsByGradeName(grade.getGradeName());
        if (isExist) {
            throw new IllegalArgumentException("Khối lớp '" + grade.getGradeName() + "' đã tồn tại.");
        } else {
            return this.gradeRepository.save(grade);
        }
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

}
