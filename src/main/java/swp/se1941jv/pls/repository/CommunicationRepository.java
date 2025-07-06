package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Communication;

import java.util.List;
import java.util.Optional;

@Repository
public interface CommunicationRepository extends JpaRepository<Communication, Long> {

    // BƯỚC 1: Lấy ID của tất cả các comment gốc
    @Query("SELECT c.id FROM Communication c WHERE c.parentComment IS NULL ORDER BY c.createdAt DESC")
    List<Long> findAllRootCommunicationIds();

    // BƯỚC 2: Dùng danh sách ID để tải đầy đủ thông tin
    @Query("SELECT DISTINCT c FROM Communication c " +
           "LEFT JOIN FETCH c.user u " +
           "LEFT JOIN FETCH c.lesson l " +
           "LEFT JOIN FETCH l.chapter ch " +
           "LEFT JOIN FETCH ch.subject s " +
           "LEFT JOIN FETCH c.replies r " +
           "LEFT JOIN FETCH r.user ru " +
           "WHERE c.id IN :ids " +
           "ORDER BY c.createdAt DESC")
    List<Communication> findAllByIdsWithDetails(@Param("ids") List<Long> ids);

    @Query("SELECT c FROM Communication c " +
           "LEFT JOIN FETCH c.user u " +
           "LEFT JOIN FETCH c.lesson l " +
           "LEFT JOIN FETCH l.chapter ch " +
           "LEFT JOIN FETCH ch.subject s " +
           "LEFT JOIN FETCH c.replies r " +
           "LEFT JOIN FETCH r.user ru " +
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