package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;

import java.util.List;
import java.util.Optional;

public interface ChapterRepository extends JpaRepository<Chapter, Long>, JpaSpecificationExecutor<Chapter> {
    List<Chapter> findBySubjectSubjectIdAndStatusTrue(Long subjectId);
    Optional<Chapter> findByChapterIdAndStatusTrue(Long chapterId);
    boolean existsByChapterNameAndSubject(String chapterName, Subject subject);
    List<Chapter> findBySubject(Subject subject);
}