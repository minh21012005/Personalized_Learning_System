package swp.se1941jv.pls.repository;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import swp.se1941jv.pls.entity.Chapter;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.Subject;

import java.util.List;
import java.util.Optional;

public interface ChapterRepository extends JpaRepository<Chapter, Long>, JpaSpecificationExecutor<Chapter> {
    List<Chapter> findBySubjectSubjectIdAndStatusTrue(Long subjectId);
    Optional<Chapter> findByChapterIdAndStatusTrue(Long chapterId);
    boolean existsByChapterNameAndSubject(String chapterName, Subject subject);

    @Query("SELECT c FROM Chapter c WHERE c.subject.subjectId = :subjectId AND c.status = :isActive")
    List<Chapter> findBySubjectIdAndIsActive(@Param("subjectId") Long subjectId, @Param("isActive") boolean isActive);

    boolean existsByChapterNameAndSubject_SubjectId(String chapterName,Long subjectId);

    @Query("SELECT c FROM Chapter c LEFT JOIN FETCH c.lessons l WHERE c.chapterId = :chapterId AND (l.isHidden = false OR l.isHidden IS NULL)")
    Optional<Chapter> findByIdWithNonHiddenLessons(@Param("chapterId") Long chapterId);

    List<Chapter> findBySubjectSubjectId(Long subjectId);
}