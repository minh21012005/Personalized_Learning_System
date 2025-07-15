package swp.se1941jv.pls.repository;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.entity.UserTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserTestRepository extends JpaRepository<UserTest, Long> {
    @Query("SELECT ut FROM UserTest ut WHERE ut.test.testId = ?1 and ut.user.userId = ?2")
    List<UserTest> findByTestIdUserId(Long testId, Long userId);

    @Query("SELECT ut FROM UserTest ut WHERE ut.user.userId = :userId " +
            "AND (:categoryId IS NULL OR ut.test.testCategory.testCategoryId = :categoryId) " +
            "AND (:startDate IS NULL OR ut.timeStart >= :startDate) " +
            "AND (:endDate IS NULL OR ut.timeStart <= :endDate) " +
            "ORDER BY ut.timeStart DESC")
    Page<UserTest> findByUserIdAndDateRange(
            @Param("userId") Long userId,
            @Param("categoryId") Long categoryId,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            Pageable pageable);

    @Query("SELECT ut FROM UserTest ut WHERE ut.user.userId = :userId " +
            "AND (:categoryId IS NULL OR ut.test.testCategory.testCategoryId != :categoryId) " +
            "AND (:startDate IS NULL OR ut.timeStart >= :startDate) " +
            "AND (:endDate IS NULL OR ut.timeStart <= :endDate) " +
            "ORDER BY ut.timeStart DESC")
    Page<UserTest> findTestByUserIdAndDateRange(
            @Param("userId") Long userId,
            @Param("categoryId") Long categoryId,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate,
            Pageable pageable);


    @Transactional
    void deleteUserTestByUserTestId(Long userTestId);


    Page<UserTest> findByUserUserIdOrderByTimeEndDesc(Long userId, Pageable pageable);

    long countByUserUserId(Long userId);
}
