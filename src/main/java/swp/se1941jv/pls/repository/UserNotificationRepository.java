package swp.se1941jv.pls.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying; // Import
import org.springframework.data.jpa.repository.Query; // Import
import org.springframework.data.repository.query.Param; // Import
import org.springframework.stereotype.Repository;
import swp.se1941jv.pls.entity.Notification; // Import
import swp.se1941jv.pls.entity.UserNotification;
import swp.se1941jv.pls.entity.keys.KeyUserNotification;

public interface UserNotificationRepository extends JpaRepository<UserNotification, KeyUserNotification> {
    @Modifying 
    @Query("DELETE FROM UserNotification un WHERE un.notification = :notification")
    void deleteByNotification(@Param("notification") Notification notification);
}
