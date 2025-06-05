package swp.se1941jv.pls.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import swp.se1941jv.pls.entity.PackageSubject;
import swp.se1941jv.pls.entity.keys.KeyPackageSubject;

public interface PackageSubjectRepository extends JpaRepository<PackageSubject, KeyPackageSubject> {

}