package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Grade; // Đảm bảo import đúng Grade entity của bạn

@Repository
public interface GradeRepository extends JpaRepository<Grade, Long> {
    // Spring Data JPA sẽ tự động cung cấp các phương thức CRUD cơ bản.
    // Bạn có thể thêm các phương thức query tùy chỉnh ở đây nếu cần.
}