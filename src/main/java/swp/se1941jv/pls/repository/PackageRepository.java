package swp.se1941jv.pls.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.PackageStatus;

import org.springframework.data.jpa.domain.Specification;

import java.util.List;

@Repository
public interface PackageRepository extends JpaRepository<Package, Long> {

    boolean existsByName(String name);

    boolean existsByNameIgnoreCase(String name);

    Page<Package> findByNameContainingIgnoreCaseAndStatus(String name, PackageStatus status, Pageable pageable);

    Page<Package> findByNameContainingIgnoreCase(String name, Pageable pageable);

    Page<Package> findByStatus(PackageStatus status, Pageable pageable);

    Page<Package> findAll(Pageable pageable);

    Page<Package> findByGradeGradeIdAndStatus(Long gradeId, PackageStatus status, Pageable pageable);

    Page<Package> findByGradeGradeIdAndNameContainingIgnoreCase(Long gradeId, String name, Pageable pageable);

    Page<Package> findByGradeGradeId(Long gradeId, Pageable pageable);

    Page<Package> findByGradeGradeIdAndStatusAndNameContainingIgnoreCase(Long gradeId, PackageStatus status,
            String name, Pageable pageable);


    Page<Package> findAll(Specification<Package> spec, Pageable pageable);

    List<Package> findAllByIsActiveTrue();


    @Query("SELECT p FROM Package p WHERE p.packageId IN :ids AND p.isActive = true")
    List<Package> findAllActiveByIds(@Param("ids") List<Long> ids);
}
