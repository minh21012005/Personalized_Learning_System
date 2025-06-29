package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Communication;

import java.util.List;
import java.util.Optional;

@Repository
public interface CommunicationRepository extends JpaRepository<Communication, Long> {

    // Đây là phương thức dành cho trang Communication HUB
    @Query("SELECT c FROM Communication c " +
           "LEFT JOIN FETCH c.user u " +
           "LEFT JOIN FETCH c.lesson l " +
           "LEFT JOIN FETCH l.chapter ch " +
           "LEFT JOIN FETCH ch.subject s " +
           "WHERE c.parentComment IS NULL " +
           "ORDER BY c.createdAt DESC")
    List<Communication> findAllRootCommunicationsOrderByCreatedAtDesc();

    // Đây là phương thức dành cho việc lấy chi tiết một comment (sau khi tạo mới)
    @Query("SELECT c FROM Communication c " +
           "LEFT JOIN FETCH c.user u " +
           "LEFT JOIN FETCH c.lesson l " +
           "LEFT JOIN FETCH l.chapter ch " +
           "LEFT JOIN FETCH ch.subject s " +
           "WHERE c.id = :id")
    Optional<Communication> findByIdWithDetails(Long id);

    // Đây là phương thức dành cho việc lấy comment theo từng bài học (nếu cần sau này)
    @Query("SELECT c FROM Communication c " +
           "LEFT JOIN FETCH c.user u " +
           "LEFT JOIN FETCH c.lesson l " +
           "LEFT JOIN FETCH l.chapter ch " +
           "LEFT JOIN FETCH ch.subject s " +
           "WHERE l.id = :lessonId AND c.parentComment IS NULL " +
           "ORDER BY c.createdAt DESC")
    List<Communication> findRootCommunicationsByLessonId(Long lessonId);
}