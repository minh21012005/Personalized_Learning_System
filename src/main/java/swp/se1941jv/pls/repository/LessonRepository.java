package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Lesson;

import java.util.Optional;

@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long>, JpaSpecificationExecutor<Lesson> {
    boolean existsByLessonNameAndChapterChapterId(String lessonName, Long chapterId);
    Optional<Lesson> findByLessonIdAndStatusTrue(Long lessonId);
}
