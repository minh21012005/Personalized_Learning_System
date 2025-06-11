package swp.se1941jv.pls.repository;

import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import org.springframework.data.jpa.repository.Query;
import swp.se1941jv.pls.entity.Lesson;

import java.util.List;

@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long> {

    @Query("SELECT l FROM Lesson l WHERE l.chapter.chapterId = :chapterId AND l.status = :status")
    List<Lesson> findByChapterIdAndIsActive(@Param("chapterId") Long chapterId, @Param("status") Boolean status);

}