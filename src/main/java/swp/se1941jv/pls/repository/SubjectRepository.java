package swp.se1941jv.pls.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import swp.se1941jv.pls.entity.Subject;

@Repository
public interface SubjectRepository extends JpaRepository<Subject, Long> {
       @Query("SELECT s FROM Subject s WHERE s.grade.gradeId = :gradeId AND s.isActive = :isActive")
       List<Subject> findByGradeIdAndIsActive(@Param("gradeId") Long gradeId, @Param("isActive") boolean isActive);

    @Query("SELECT s FROM Subject s WHERE s.isActive = :isActive")
    List<Subject> findSubjectIsActive(@Param("isActive") boolean isActive);

       // Sử dụng naming convention cho phân trang và tìm kiếm
       Page<Subject> findByGradeGradeIdAndIsActiveAndSubjectNameContainingIgnoreCase(
                     Long gradeId, boolean isActive, String subjectName, Pageable pageable);

       Page<Subject> findByGradeGradeIdAndIsActive(Long gradeId, boolean isActive, Pageable pageable);

       // Thêm phương thức cho Subject hàng chờ
       Page<Subject> findByGradeIsNullAndIsActiveAndSubjectNameContainingIgnoreCase(
                     boolean isActive, String subjectName, Pageable pageable);

       Page<Subject> findByGradeIsNullAndIsActive(boolean isActive, Pageable pageable);

       @Query("SELECT s FROM Subject s WHERE " +
                     "(:subjectName IS NULL OR LOWER(s.subjectName) LIKE LOWER(CONCAT('%', :subjectName, '%'))) AND " +
                     "(:gradeId IS NULL OR s.grade.gradeId = :gradeId)")
       Page<Subject> findByFilter(@Param("subjectName") String subjectName,
                     @Param("gradeId") Long gradeId,
                     Pageable pageable);

    @Query("SELECT s FROM Subject s JOIN s.statusHistories sh WHERE sh.status = 'PENDING' " +
            "AND (:subjectName IS NULL OR LOWER(s.subjectName) LIKE LOWER(CONCAT('%', :subjectName, '%'))) " +
            "AND (:submittedByName IS NULL OR LOWER(sh.submittedBy.fullName) LIKE LOWER(CONCAT('%', :submittedByName, '%'))) " +
            "GROUP BY s.subjectId, s.subjectName, s.subjectDescription, s.subjectImage, s.isActive, s.grade " +
            "ORDER BY MAX(sh.changedAt) DESC")
    Page<Subject> findPendingSubjects(@Param("subjectName") String subjectName,
                                      @Param("submittedByName") String submittedByName,
                                      Pageable pageable);

       List<Subject> findAll();

       List<Subject> findByIsActiveTrue();

         @Query("SELECT s FROM Subject s WHERE s.subjectId IN :ids AND s.isActive = true")
    List<Subject> findAllActiveByIds(@Param("ids") List<Long> ids);

    Optional<Subject> findBySubjectId(Long subjectId);

}
