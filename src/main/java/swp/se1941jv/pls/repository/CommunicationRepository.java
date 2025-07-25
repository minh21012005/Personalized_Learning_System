package swp.se1941jv.pls.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Communication;
import swp.se1941jv.pls.entity.Communication.CommentStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface CommunicationRepository extends JpaRepository<Communication, Long> {

       @Query(value = "SELECT c.id FROM Communication c " +
                     "WHERE c.parentComment IS NULL " +
                     "AND (:status IS NULL OR c.commentStatus = :status) " +
                     "AND (:keyword IS NULL OR LOWER(c.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
                     "AND (CAST(:startDate AS timestamp) IS NULL OR c.createdAt >= :startDate) " +
                     "AND (CAST(:endDate AS timestamp) IS NULL OR c.createdAt <= :endDate)")
       Page<Long> findRootCommunicationIds(@Param("status") CommentStatus status,
                     @Param("keyword") String keyword,
                     @Param("startDate") LocalDateTime startDate,
                     @Param("endDate") LocalDateTime endDate,
                     Pageable pageable);

       // @Query(value = "SELECT count(c.id) FROM Communication c " +
       //               "WHERE c.parentComment IS NULL " +
       //               "AND (:status IS NULL OR c.commentStatus = :status) " +
       //               "AND (:keyword IS NULL OR LOWER(c.content) LIKE LOWER(CONCAT('%', :keyword, '%'))) " +
       //               "AND (CAST(:startDate AS timestamp) IS NULL OR c.createdAt >= :startDate) " +
       //               "AND (CAST(:endDate AS timestamp) IS NULL OR c.createdAt <= :endDate)")
       // long countRootCommunications(@Param("status") CommentStatus status,
       //               @Param("keyword") String keyword,
       //               @Param("startDate") LocalDateTime startDate,
       //               @Param("endDate") LocalDateTime endDate);

       @Query("SELECT DISTINCT c FROM Communication c " +
                     "LEFT JOIN FETCH c.user u " +
                     "LEFT JOIN FETCH c.lesson l " +
                     "LEFT JOIN FETCH l.chapter ch " +
                     "LEFT JOIN FETCH ch.subject s " +
                     "LEFT JOIN FETCH c.replies r " +
                     "LEFT JOIN FETCH r.user ru " +
                     "WHERE c.id IN :ids")
       List<Communication> findByIdsWithDetails(@Param("ids") List<Long> ids);

       @Query("SELECT c FROM Communication c " +
                     "LEFT JOIN FETCH c.user u " +
                     "LEFT JOIN FETCH c.lesson l " +
                     "LEFT JOIN FETCH l.chapter ch " +
                     "LEFT JOIN FETCH ch.subject s " +
                     "LEFT JOIN FETCH c.replies r " +
                     "LEFT JOIN FETCH r.user ru " +
                     "WHERE c.id = :id")
       Optional<Communication> findByIdWithDetails(Long id);

       @EntityGraph(value = "Communication.withRepliesAndUser")
       @Query("SELECT c FROM Communication c WHERE c.parentComment IS NULL AND c.lesson.id = :lessonId AND c.commentStatus = 'APPROVED' ORDER BY c.createdAt DESC")
       List<Communication> findApprovedRootCommentByLessonId(@Param("lessonId") Long lessonId);

       @Query(value = "SELECT c.id FROM Communication c " +
                     "WHERE c.parentComment IS NULL " +
                     "AND (:status IS NULL OR c.commentStatus = :status) " +
                     "AND (CAST(:startDate AS timestamp) IS NULL OR c.createdAt >= :startDate) " +
                     "AND (CAST(:endDate AS timestamp) IS NULL OR c.createdAt <= :endDate) " +
                     "AND (" +
                     "    LOWER(c.content) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                     "    EXISTS (SELECT 1 FROM Communication r WHERE r.parentComment = c AND LOWER(r.content) LIKE LOWER(CONCAT('%', :keyword, '%')))"
                     +
                     ")")
       Page<Long> findRootCommunicationIdsWithKeywordSearch(
                     @Param("status") CommentStatus status,
                     @Param("keyword") String keyword,
                     @Param("startDate") LocalDateTime startDate,
                     @Param("endDate") LocalDateTime endDate,
                     Pageable pageable);

       @Query("SELECT count(c.id) FROM Communication c WHERE (:status IS NULL OR c.commentStatus = :status)")
       long countAllByStatus(@Param("status") CommentStatus status);
}