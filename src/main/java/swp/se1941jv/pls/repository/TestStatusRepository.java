package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.TestStatus;

@Repository
public interface TestStatusRepository extends JpaRepository<TestStatus, Long> {
}
