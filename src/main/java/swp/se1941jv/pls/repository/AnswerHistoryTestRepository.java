package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.entity.AnswerHistoryTest;

import java.util.List;

@Repository
public interface AnswerHistoryTestRepository extends JpaRepository<AnswerHistoryTest, Long> {
    @Query("SELECT ah FROM AnswerHistoryTest ah WHERE ah.userTest.userTestId = ?1")
    List<AnswerHistoryTest> findByUserTestId(Long userTestId);

    @Modifying
    @Transactional
    @Query("DELETE FROM AnswerHistoryTest ah WHERE ah.userTest.userTestId = ?1")
    void deleteByUserTestId(Long userTestId);

}
