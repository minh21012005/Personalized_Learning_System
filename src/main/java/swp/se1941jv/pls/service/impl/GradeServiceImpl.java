package swp.se1941jv.pls.service.impl;


import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Grade; // Đảm bảo import đúng Grade entity của bạn
import swp.se1941jv.pls.repository.GradeRepository; // Import GradeRepository
import swp.se1941jv.pls.service.GradeService; // Import GradeService interface

import java.util.List;
import java.util.Optional;

@Service
public class GradeServiceImpl implements GradeService {

    private final GradeRepository gradeRepository;


    public GradeServiceImpl(GradeRepository gradeRepository) {
        this.gradeRepository = gradeRepository;
    }

    @Override
    public List<Grade> getAllGrades() {
        return gradeRepository.findAll(); // Lấy tất cả các Grade từ repository
    }

    @Override
    public Optional<Grade> getGradeById(Long id) {
        return gradeRepository.findById(id);
    }

    @Override
    public Grade saveGrade(Grade grade) {
        // Bạn có thể thêm logic xử lý trước khi lưu ở đây nếu cần
        return gradeRepository.save(grade);
    }

    @Override
    public void deleteGradeById(Long id) {
        gradeRepository.deleteById(id);
    }

    // Triển khai các phương thức khác nếu có
}