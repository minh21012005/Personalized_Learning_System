package swp.se1941jv.pls.service.impl;


import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.repository.GradeRepository;
import swp.se1941jv.pls.service.GradeService;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class GradeServiceImpl implements GradeService {

    private final GradeRepository gradeRepository;


    public GradeServiceImpl(GradeRepository gradeRepository) {
        this.gradeRepository = gradeRepository;
    }

    @Override
    public List<Grade> getAllGrades() {
        return gradeRepository.findAll();
    }

    @Override
    public Optional<Grade> getGradeById(Long id) {
        return gradeRepository.findById(id);
    }

    @Override
    public Grade saveGrade(Grade grade) {
        return gradeRepository.save(grade);
    }

    @Override
    public void deleteGradeById(Long id) {
        gradeRepository.deleteById(id);
    }

    @Override
    public List<Grade> getActiveGrades() {
         return gradeRepository.findByIsActiveTrue();
    }


}