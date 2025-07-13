package swp.se1941jv.pls.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.jpa.repository.Query;
import swp.se1941jv.pls.entity.UserPackage;
import swp.se1941jv.pls.entity.keys.KeyUserPackage;

import java.util.List;

public interface UserPackageRepository extends JpaRepository<UserPackage, KeyUserPackage> {


    long countByPkgPackageId(Long packageId);

    boolean existsByUser_UserIdAndPkg_PackageId(Long userId, Long packageId);

    List<UserPackage> findByUser_UserId(Long userId);

    List<UserPackage> findByPkg_PackageId(Long packageId);

    List<UserPackage> findByIdUserId(Long idUserId);

    Boolean existsByUser_UserIdAndPkg_PackageIdAndPkg_PackageSubjects_Subject_SubjectIdAndEndDateAfter(Long userId, Long packageId, Long subjectId, LocalDateTime now);

    boolean existsByPkg_PackageSubjects_Subject_SubjectId(Long subjectId);
}