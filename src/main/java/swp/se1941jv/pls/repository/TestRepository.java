package swp.se1941jv.pls.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.Test;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TestRepository extends JpaRepository<Test, Long>, JpaSpecificationExecutor<Test> {
    List<Test> findByTestCategoryTestCategoryIdAndIsOpen(Long testCategoryId, Boolean isOpen);
    List<Test> findByTestCategoryTestCategoryIdAndIsOpenAndLessonLessonId(Long testCategoryId, Boolean isOpen, Long lessonId);
    List<Test> findByTestCategoryTestCategoryIdAndIsOpenAndChapterChapterId(Long testCategoryId, Boolean isOpen, Long chapterId);
    List<Test> findByTestCategoryTestCategoryIdAndIsOpenAndSubjectSubjectId(Long testCategoryId, Boolean isOpen, Long subjectId);
    Test findByLesson(Lesson lesson);
}

