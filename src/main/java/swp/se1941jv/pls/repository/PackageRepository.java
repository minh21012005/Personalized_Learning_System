package swp.se1941jv.pls.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import swp.se1941jv.pls.entity.Package;

public interface PackageRepository extends JpaRepository<Package, Long> {
    boolean existsByName(String name);

    // Lọc theo keyword và isActive
    Page<Package> findByNameContainingIgnoreCaseAndActive(String name, boolean active, Pageable pageable);

    // Lọc theo keyword (không có isActive)
    Page<Package> findByNameContainingIgnoreCase(String name, Pageable pageable);

    // Lọc theo isActive (không có keyword)
    Page<Package> findByActive(boolean active, Pageable pageable);

    // Trả về tất cả (không lọc theo keyword hoặc isActive)
    Page<Package> findAll(Pageable pageable);

}
