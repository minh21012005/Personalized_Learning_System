package swp.se1941jv.pls.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.entity.LessonProgress;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface LessonProgressRepository extends JpaRepository<LessonProgress, Long> {

    Optional<LessonProgress> findByUserAndLessonAndSubjectAndPackageEntity(User user, Lesson lesson, Subject subject, Package packageEntity);

    List<LessonProgress> findByUserAndSubjectAndPackageEntity(User user, Subject subject, Package packageEntity);

    Optional<LessonProgress> findByUserUserIdAndLessonLessonIdAndPackageEntityPackageId(Long userId, Long lessonId, Long packageId);

    Page<LessonProgress> findByUserUserIdOrderByUpdatedAtDesc(Long userId, Pageable pageable);

    @Query("SELECT lp FROM LessonProgress lp WHERE lp.user.userId = :userId AND lp.updatedAt BETWEEN :startTime AND :endTime")
    List<LessonProgress> findByUserIdAndLastUpdatedBetween(@Param("userId") Long userId,
                                                           @Param("startTime") LocalDateTime startTime,
                                                           @Param("endTime") LocalDateTime endTime);

    long countByUserUserId(Long userId);

}