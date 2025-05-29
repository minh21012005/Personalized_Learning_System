package swp.se1941jv.pls.repository;


import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.stereotype.Repository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import swp.se1941jv.pls.entity.Subject;


@Repository
public interface SubjectRepository extends JpaRepository<Subject, Long>{
 @Query("SELECT s FROM Subject s WHERE " +
           "(:subjectName IS NULL OR LOWER(s.subjectName) LIKE LOWER(CONCAT('%', :subjectName, '%'))) AND " +
           "(:gradeId IS NULL OR s.grade.gradeId = :gradeId)")
    Page<Subject> findByFilter(@Param("subjectName") String subjectName,
                               @Param("gradeId") Long gradeId,
                               Pageable pageable);
}
