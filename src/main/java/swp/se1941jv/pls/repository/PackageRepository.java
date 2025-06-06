package swp.se1941jv.pls.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.User;

@Repository
public interface PackageRepository extends JpaRepository<Package, Long> {
    Page<Package> findAll(Pageable pageable);

    Page<Package> findAll(Specification<Package> spec, Pageable pageable);
}
