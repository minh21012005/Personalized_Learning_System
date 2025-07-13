package swp.se1941jv.pls.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Communication;
import swp.se1941jv.pls.entity.Communication.CommentStatus;

import java.util.List;
import java.util.Optional;

@Repository
public interface CommunicationRepository extends JpaRepository<Communication, Long> {

       @Query(value = "SELECT c.id FROM Communication c " +
                   "WHERE c.parentComment IS NULL " +
                   "AND (:status IS NULL OR c.commentStatus = :status)")
        Page<Long> findRootCommunicationIds(@Param("status") CommentStatus status, Pageable pageable);

        @Query(value = "SELECT count(c.id) FROM Communication c " +
                   "WHERE c.parentComment IS NULL " +
                   "AND (:status IS NULL OR c.commentStatus = :status)")
        long countRootCommunications(@Param("status") CommentStatus status);


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

}