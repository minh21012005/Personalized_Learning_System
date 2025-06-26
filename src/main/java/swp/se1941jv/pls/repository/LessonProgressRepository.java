package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Lesson;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.entity.LessonProgress;

import java.util.List;
import java.util.Optional;

@Repository
public interface LessonProgressRepository extends JpaRepository<LessonProgress, Long> {

    Optional<LessonProgress> findByUserAndLessonAndSubjectAndPackageEntity(User user, Lesson lesson, Subject subject, Package packageEntity);

    List<LessonProgress> findByUserAndSubjectAndPackageEntity(User user, Subject subject, Package packageEntity);
}