package swp.se1941jv.pls.service;

import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.repository.GradeRepository;

import java.util.List;
import java.util.Optional;

@Service
public class GradeService {
    private final GradeRepository gradeRepository;


    public GradeService(GradeRepository gradeRepository) {
        this.gradeRepository = gradeRepository;
    }

    
    public List<Grade> getAllGrades() {
        return gradeRepository.findAll();
    }

    
    public Optional<Grade> getGradeById(Long id) {
        return gradeRepository.findById(id);
    }

    
    public Grade saveGrade(Grade grade) {
        return gradeRepository.save(grade);
    }

    
    public void deleteGradeById(Long id) {
        gradeRepository.deleteById(id);
    }

    
    public List<Grade> getActiveGrades() {
        return gradeRepository.findByIsActiveTrue();
    }

}