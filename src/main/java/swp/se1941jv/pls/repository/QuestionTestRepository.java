package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.QuestionTest;

@Repository
public interface QuestionTestRepository extends JpaRepository<QuestionTest, Long> {
}
