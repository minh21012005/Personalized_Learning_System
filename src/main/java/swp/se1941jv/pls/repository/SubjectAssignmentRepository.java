package swp.se1941jv.pls.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.SubjectAssignment;

import java.util.Optional;

@Repository
public interface SubjectAssignmentRepository extends JpaRepository<SubjectAssignment, Long> {
    Optional<SubjectAssignment> findBySubjectSubjectId(Long subjectId);
    boolean existsBySubjectSubjectId(Long subjectId);

    @Query("SELECT sa FROM SubjectAssignment sa WHERE sa.user.userId = :userId " +
            "AND (:subjectName IS NULL OR LOWER(sa.subject.subjectName) LIKE LOWER(CONCAT('%', :subjectName, '%'))) " +
            "ORDER BY sa.assignedAt DESC" )
    Page<SubjectAssignment> findByUserUserIdAndSubjectSubjectNameContainingIgnoreCase(
            @Param("userId") Long userId,
            @Param("subjectName") String subjectName,
            Pageable pageable);
}