package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import swp.se1941jv.pls.entity.Cart;
import swp.se1941jv.pls.entity.CartPackage;
import swp.se1941jv.pls.entity.Package;

@Repository
public interface CartPackageRepository extends JpaRepository<CartPackage, Long> {
    CartPackage findByCartAndPkg(Cart cart, Package pkg);
}
