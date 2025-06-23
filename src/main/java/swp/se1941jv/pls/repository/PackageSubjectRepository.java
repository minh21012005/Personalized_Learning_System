package swp.se1941jv.pls.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import swp.se1941jv.pls.entity.PackageSubject;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.keys.KeyPackageSubject;

public interface PackageSubjectRepository extends JpaRepository<PackageSubject, KeyPackageSubject> {
        @Query("SELECT ps.subject FROM PackageSubject ps WHERE ps.pkg.packageId = :packageId AND (ps.subject.subjectName LIKE '%' || :keyword || '%' OR :keyword IS NULL) AND ps.subject.isActive = true")
        List<Subject> findSubjectsByPackageIdAndKeyword(@Param("packageId") Long packageId,
                        @Param("keyword") String keyword);

        @Query("SELECT ps.subject FROM PackageSubject ps WHERE ps.pkg.packageId = :packageId AND ps.subject.isActive = true")
        List<Subject> findSubjectsByPackageId(@Param("packageId") Long packageId);

        void deleteByPkg_PackageId(Long packageId);

        PackageSubject findByPkg_PackageIdAndSubject_SubjectId(Long packageId, Long subjectId);
}