package swp.se1941jv.pls.repository;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import org.springframework.data.jpa.repository.Query;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import swp.se1941jv.pls.entity.Lesson;

import java.util.Optional;


@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long>, JpaSpecificationExecutor<Lesson> {
    boolean existsByLessonNameAndChapter_ChapterId(String lessonName, Long chapterId);

    Optional<Lesson> findByLessonIdAndStatusTrue(Long lessonId);

    @Query("SELECT l FROM Lesson l WHERE l.chapter.chapterId = :chapterId AND l.status = :status")
    List<Lesson> findByChapterIdAndIsActive(@Param("chapterId") Long chapterId, @Param("status") Boolean status);


    @Query("SELECT l FROM Lesson l WHERE l.chapter.subject.subjectId = :subjectId AND l.status = :status ")
    List<Lesson> findBySubjectId(@Param("subjectId") Long subjectId, @Param("status") Boolean status);

    boolean existsByLessonNameAndChapter_ChapterIdAndLessonIdNot( String lessonName, Long chapterId, Long lessonId);
}