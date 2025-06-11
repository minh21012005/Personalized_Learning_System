package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import swp.se1941jv.pls.entity.Lesson;

import java.util.Optional;

public interface LessonRepository extends JpaRepository<Lesson, Long>, JpaSpecificationExecutor<Lesson> {
    /**
     * Kiểm tra xem tên bài học đã tồn tại trong chương chưa.
     *
     * @param lessonName Tên bài học
     * @param chapterId  ID của chương
     * @return true nếu tên bài học đã tồn tại, false nếu không
     */
    boolean existsByLessonNameAndChapter_ChapterId(String lessonName, Long chapterId);

    /**
     * Tìm bài học theo ID và trạng thái active.
     *
     * @param lessonId ID của bài học
     * @return Optional chứa bài học nếu tìm thấy và active
     */
    Optional<Lesson> findByLessonIdAndStatusTrue(Long lessonId);
}