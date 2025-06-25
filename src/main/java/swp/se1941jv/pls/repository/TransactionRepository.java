package swp.se1941jv.pls.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import swp.se1941jv.pls.entity.Transaction;
import swp.se1941jv.pls.entity.TransactionStatus;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long>, JpaSpecificationExecutor<Transaction> {

    boolean existsByTransferCode(String code);

    List<Transaction> findByUser_UserIdAndStatus(Long userId, TransactionStatus status);

    boolean existsByUser_UserIdAndPackages_PackageIdAndStatus(Long userId, Long packageId, TransactionStatus status);
}
