package swp.se1941jv.pls.service;

import swp.se1941jv.pls.entity.Grade; // Đảm bảo import đúng Grade entity của bạn
import java.util.List;
import java.util.Optional;

public interface GradeService {
    List<Grade> getAllGrades(); // Phương thức này chúng ta cần cho SubjectController
    Optional<Grade> getGradeById(Long id);
    Grade saveGrade(Grade grade);
    void deleteGradeById(Long id);
    // Thêm các phương thức khác nếu bạn cần quản lý đầy đủ Grade
}