package swp.se1941jv.pls.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import swp.se1941jv.pls.entity.Transaction;
import swp.se1941jv.pls.entity.TransactionStatus;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long>, JpaSpecificationExecutor<Transaction> {

        boolean existsByTransferCode(String code);

        List<Transaction> findByUser_UserIdAndStatus(Long userId, TransactionStatus status);

        // boolean existsByUser_UserIdAndPackages_PackageIdAndStatus(Long userId, Long
        // packageId, TransactionStatus status);
        @Query("""
                            SELECT COUNT(t) > 0 FROM Transaction t
                            JOIN t.packages p
                            WHERE p.packageId = :packageId
                              AND t.status = :status
                              AND (:userId = t.user.userId OR :userId = t.student.userId)
                        """)
        boolean existsByUserOrStudentIdAndPackageAndStatus(
                        @Param("userId") Long userId,
                        @Param("packageId") Long packageId,
                        @Param("status") TransactionStatus status);

        List<Transaction> findByStatusAndConfirmedAtAfter(TransactionStatus status, LocalDateTime confirmedAt);
}
