package swp.se1941jv.pls.service;


import java.io.IOException;
import java.util.List;
import java.util.Optional;

import org.springframework.web.multipart.MultipartFile;

import swp.se1941jv.pls.entity.Subject;



public interface SubjectService {
    List<Subject> getAllSubjects();
    Optional<Subject> getSubjectById(Long id);
    
    void deleteSubjectById(Long id); // Thêm hàm delete cho tiện
    Subject saveSubject(Subject subject, MultipartFile imageFile) throws IOException;
}