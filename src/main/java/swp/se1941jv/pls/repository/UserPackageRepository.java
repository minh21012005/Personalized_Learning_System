package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import swp.se1941jv.pls.entity.UserPackage;
import swp.se1941jv.pls.entity.keys.KeyUserPackage;

import java.util.List;

public interface UserPackageRepository extends JpaRepository<UserPackage, KeyUserPackage> {
    long countByPkgPackageId(Long packageId);

    List<UserPackage> findByIdUserId(Long idUserId);
}