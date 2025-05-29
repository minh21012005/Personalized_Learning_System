package swp.se1941jv.pls.service;

import org.springframework.data.domain.Page; // Thêm import này
import org.springframework.data.domain.Pageable; // Thêm import này

import java.io.IOException;
//import java.util.List;
import java.util.Optional;

//import org.springframework.web.multipart.MultipartFile;

import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.repository.SubjectRepository;

@Service
public class SubjectService {
    private final SubjectRepository subjectRepository;

    public SubjectService(SubjectRepository subjectRepository) {
        this.subjectRepository = subjectRepository;
    }


    public Page<Subject> getAllSubjects(String filterName, Long filterGradeId, Pageable pageable) {
        String searchName = (filterName != null && filterName.trim().isEmpty()) ? null : filterName;
        return subjectRepository.findByFilter(searchName, filterGradeId, pageable);
    }


    public Optional<Subject> getSubjectById(Long id) {
        return subjectRepository.findById(id);
    }


    public Subject saveSubject(Subject subject) {
        return subjectRepository.save(subject);
    }


    public void deleteSubjectById(Long id) {
        subjectRepository.deleteById(id);
    }
}