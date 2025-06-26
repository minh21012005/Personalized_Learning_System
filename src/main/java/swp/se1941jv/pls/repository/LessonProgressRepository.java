package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.LessonProgress;
import swp.se1941jv.pls.entity.keys.KeyLessonUser;

import java.util.Optional;

@Repository
public interface LessonProgressRepository extends JpaRepository<LessonProgress, KeyLessonUser> {

}
