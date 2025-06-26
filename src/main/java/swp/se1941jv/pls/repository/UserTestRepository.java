package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.UserTest;

@Repository
public interface UserTestRepository extends JpaRepository<UserTest, Long> {
    @Query("SELECT ut FROM UserTest ut WHERE ut.test.testId = ?1 and ut.user.userId = ?2")
    UserTest findByTestIdUserId(Long testId, Long userId);

}
