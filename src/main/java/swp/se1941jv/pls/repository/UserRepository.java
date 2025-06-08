package swp.se1941jv.pls.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import swp.se1941jv.pls.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long>, JpaSpecificationExecutor<User> {
    User findByEmail(String email);

    List<User> findAll();

    Page<User> findAll(Pageable pageable);

    Page<User> findAll(Specification<User> spec, Pageable pageable);

    boolean existsByEmail(String email);

    boolean existsByPhoneNumber(String phone);

    boolean existsByEmailAndUserIdNot(String email, Long userId);

    boolean existsByPhoneNumberAndUserIdNot(String phoneNumber, Long userId);
    User findByResetPasswordToken(String token);

    User findByEmailVerifyToken(String token);





     List<User> findAllByIsActiveTrue();

    /**
     * Tìm User đang active (isActive = true) theo danh sách tên Role (không phân biệt hoa thường).
     * Dùng cho getTargetableUsersForForm và createNotification (targetType="ROLE").
     * @param roleNames danh sách tên Role (ví dụ: ["STUDENT", "PARENT"])
     * @return danh sách User phù hợp
     */
    @Query("SELECT u FROM User u WHERE u.isActive = true AND UPPER(u.role.roleName) IN :upperCaseRoleNames")
    List<User> findActiveUsersByRoleNames(@Param("upperCaseRoleNames") List<String> upperCaseRoleNames);

    /**
     * (TỐI ƯU CHO createNotification targetType="PACKAGE")
     * Tìm User đang active theo danh sách Package ID.
     * Package cũng phải active.
     */
    @Query("SELECT DISTINCT u FROM User u JOIN u.userPackages up JOIN up.pkg p " +
           "WHERE u.isActive = true AND p.isActive = true AND p.packageId IN :packageIds")
    List<User> findActiveUsersByPackageIds(@Param("packageIds") List<Long> packageIds);

    /**
     * (TỐI ƯU CHO createNotification targetType="SUBJECT")
     * Tìm User đang active theo danh sách Subject ID.
     * Subject và Package liên quan cũng phải active.
     */
    @Query("SELECT DISTINCT u FROM User u JOIN u.userPackages up JOIN up.pkg p JOIN p.packageSubjects ps JOIN ps.subject s " +
           "WHERE u.isActive = true AND p.isActive = true AND s.isActive = true AND s.subjectId IN :subjectIds")
    List<User> findActiveUsersBySubjectIds(@Param("subjectIds") List<Long> subjectIds);
}