package swp.se1941jv.pls.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Notification;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByTargetTypeAndTargetValue(String targetType, Long targetValue);

    Page<Notification> findByTargetTypeContainingIgnoreCase(String targetType, Pageable pageable);

    Page<Notification> findByTitleContainingIgnoreCaseAndTargetTypeContainingIgnoreCase(String title, String targetType,
            Pageable pageable);

    Page<Notification> findByTitleContainingIgnoreCase(String title, Pageable pageable);
}
