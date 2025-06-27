package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.QuestionBank;

import java.util.List;

@Repository
public interface QuestionBankRepository extends JpaRepository<QuestionBank, Long>, JpaSpecificationExecutor<QuestionBank> {

    @Query("SELECT q FROM QuestionBank q WHERE q.lesson.lessonId IN :lessonIds AND q.active = true")
    List<QuestionBank> findByLessonIdsIn(List<Long> lessonIds);

    @Query("SELECT q FROM QuestionBank q WHERE q.lesson.lessonId IN :lessonIds AND q.levelQuestion.levelQuestionName = :levelName AND q.active = true")
    List<QuestionBank> findByLessonLessonIdInAndLevelQuestionLevelName(List<Long> lessonIds, String levelName);


    List<QuestionBank> findByLessonChapterChapterId(Long lessonChapterChapterId);

    List<QuestionBank> findByLessonChapterSubjectSubjectId(Long lessonChapterSubjectSubjectId);
}