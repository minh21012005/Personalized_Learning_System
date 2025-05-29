package swp.se1941jv.pls.service.impl;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.repository.SubjectRepository;
import swp.se1941jv.pls.service.SubjectService;

import java.util.Optional;
@Service
public class SubjectServiceImpl implements SubjectService {

    private final SubjectRepository subjectRepository;

    public SubjectServiceImpl(SubjectRepository subjectRepository) {
        this.subjectRepository = subjectRepository;
    }

    @Override
    public Page<Subject> getAllSubjects(String filterName, Long filterGradeId, Pageable pageable) {
        String searchName = (filterName != null && filterName.trim().isEmpty()) ? null : filterName;
        return subjectRepository.findByFilter(searchName, filterGradeId, pageable);
    }

    @Override
    public Optional<Subject> getSubjectById(Long id) {
        return subjectRepository.findById(id);
    }

    @Override
    public Subject saveSubject(Subject subject) {
        return subjectRepository.save(subject);
    }

    @Override
    public void deleteSubjectById(Long id) {
        subjectRepository.deleteById(id);
    }
}