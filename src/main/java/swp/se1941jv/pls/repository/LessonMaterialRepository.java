package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import swp.se1941jv.pls.entity.LessonMaterial;

public interface LessonMaterialRepository extends JpaRepository<LessonMaterial,Long> {
    void deleteByFilePath(String filePath);
}
