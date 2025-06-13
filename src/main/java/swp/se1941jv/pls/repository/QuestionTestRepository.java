package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.QuestionTest;

import java.util.List;

@Repository
public interface QuestionTestRepository extends JpaRepository<QuestionTest, Long> {

    @Query("SELECT qt FROM QuestionTest qt WHERE qt.test.testId = ?1")
    List<QuestionTest> findByTestId(Long testId);

}
