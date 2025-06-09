package swp.se1941jv.pls.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Package;
import org.springframework.data.jpa.domain.Specification;

import java.util.List;

@Repository
public interface PackageRepository extends JpaRepository<Package, Long> {

    boolean existsByName(String name);

    // Lọc theo keyword và isActive
    Page<Package> findByNameContainingIgnoreCaseAndIsActive(String name, boolean active, Pageable pageable);

    // Lọc theo keyword (không có isActive)
    Page<Package> findByNameContainingIgnoreCase(String name, Pageable pageable);

    // Lọc theo isActive (không có keyword)
    Page<Package> findByIsActive(boolean active, Pageable pageable);

    // Trả về tất cả (không lọc theo keyword hoặc isActive)
    Page<Package> findAll(Pageable pageable);

    Page<Package> findByGradeGradeIdAndIsActive(Long gradeId, boolean active, Pageable pageable);

    Page<Package> findByGradeGradeIdAndNameContainingIgnoreCase(Long gradeId, String name, Pageable pageable);

    Page<Package> findByGradeGradeId(Long gradeId, Pageable pageable);

    Page<Package> findByGradeGradeIdAndIsActiveAndNameContainingIgnoreCase(Long gradeId, boolean active, String name,
            Pageable pageable);

    // Truy vấn nâng cao với Specification
    Page<Package> findAll(Specification<Package> spec, Pageable pageable);

    List<Package> findAllByIsActiveTrue();

    /**
     * Tìm tất cả Package theo danh sách ID VÀ đang active (isActive = true).
     * Dùng cho createNotification (targetType="PACKAGE").
     * 
     * @param ids danh sách Package ID
     * @return danh sách Package phù hợp
     */
    @Query("SELECT p FROM Package p WHERE p.packageId IN :ids AND p.isActive = true")
    List<Package> findAllActiveByIds(@Param("ids") List<Long> ids); // Đổi tên để rõ ràng hơn
}
