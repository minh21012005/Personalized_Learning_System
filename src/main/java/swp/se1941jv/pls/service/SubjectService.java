package swp.se1941jv.pls.service;

import org.springframework.data.domain.Page; // Thêm import này
import org.springframework.data.domain.Pageable; // Thêm import này

import java.io.IOException;
//import java.util.List;
import java.util.Optional;

//import org.springframework.web.multipart.MultipartFile;

import swp.se1941jv.pls.entity.Subject;



public interface SubjectService {
    //List<Subject> getAllSubjects();
    Page<Subject> getAllSubjects(String filterName, Long filterGradeId, Pageable pageable);
    Optional<Subject> getSubjectById(Long id);
    
    void deleteSubjectById(Long id); 
    Subject saveSubject(Subject subject) throws IOException;
}