package swp.se1941jv.pls.repository;


import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Grade;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.Subject;

import java.util.List;
import java.util.Optional;

@Repository
public interface ChapterRepository extends JpaRepository<Chapter, Long>, JpaSpecificationExecutor<Chapter> {
    boolean existsByChapterNameAndSubject(String chapterName, Subject subject);

    List<Chapter> findBySubject(Subject subject);

    Optional<Chapter> getChapterByChapterId(Long chapterId);

    @Query("SELECT c FROM Chapter c WHERE c.subject.subjectId = :subjectId AND c.status = :isActive")
    List<Chapter> findBySubjectIdAndIsActive(@Param("subjectId") Long subjectId, @Param("isActive") boolean isActive);

}