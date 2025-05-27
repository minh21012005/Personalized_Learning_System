package swp.se1941jv.pls.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import swp.se1941jv.pls.entity.Subject;

import swp.se1941jv.pls.repository.SubjectRepository;

@Service
public class SubjectService {
    private final SubjectRepository subjectRepository;

    public SubjectService(SubjectRepository subjectRepository) {
        this.subjectRepository = subjectRepository;
    }

    public List<Subject> getSubjectsByGradeId(Long gradeId, boolean isActive) {
        return subjectRepository.findByGradeIdAndIsActive(gradeId, isActive);
    }
}