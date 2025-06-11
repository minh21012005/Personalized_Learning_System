package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.QuestionBank;

@Repository
public interface QuestionBankRepository extends JpaRepository<QuestionBank, Long>, JpaSpecificationExecutor<QuestionBank> {
}