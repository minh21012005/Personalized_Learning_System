package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.SubjectStatusHistory;

import java.util.List;
import java.util.Optional;

@Repository
public interface SubjectStatusHistoryRepository extends JpaRepository<SubjectStatusHistory, Long> {

    Optional<SubjectStatusHistory> findBySubjectSubjectId(Long subjectId);
}