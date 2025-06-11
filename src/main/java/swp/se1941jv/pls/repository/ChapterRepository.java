package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Chapter;
import swp.se1941jv.pls.entity.Subject;

import java.util.List;

@Repository
public interface ChapterRepository extends JpaRepository<Chapter, Long>, Specification<Chapter> {
    List<Chapter> findBySubjectSubjectIdAndStatusTrue(Long subjectId);
    boolean existsByChapterNameAndSubject(String chapterName, Subject subject);
}