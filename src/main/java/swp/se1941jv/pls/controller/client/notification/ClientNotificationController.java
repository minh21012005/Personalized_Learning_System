package swp.se1941jv.pls.controller.client.notification;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.entity.UserNotification;
import swp.se1941jv.pls.service.NotificationService;
import swp.se1941jv.pls.service.UserService;

import java.security.Principal;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/notification/client")
@RequiredArgsConstructor
public class ClientNotificationController {

    private static final Logger logger = LoggerFactory.getLogger(ClientNotificationController.class);
    private final NotificationService notificationService;
    private final UserService userService;

    /**
     * Lấy thông tin người dùng đang đăng nhập từ Security Context.
     */
    private User getCurrentAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
            return null;
        }
        Object principal = authentication.getPrincipal();
        String username;
        if (principal instanceof UserDetails) {
            username = ((UserDetails) principal).getUsername();
        } else if (principal instanceof Principal) {
            username = ((Principal) principal).getName();
        } else {
            username = principal.toString();
        }
        return userService.getUserByEmail(username);
    }

    /**
     * API: Lấy số lượng thông báo chưa đọc.
     * Dùng cho huy hiệu (badge) trên chuông.
     */
    @GetMapping("/unread-count")
    @ResponseBody
    public ResponseEntity<Map<String, Long>> getUnreadNotificationCount() {
        User currentUser = getCurrentAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.ok(Collections.singletonMap("count", 0L));
        }
        long count = notificationService.countUnreadNotificationsForUser(currentUser);
        return ResponseEntity.ok(Collections.singletonMap("count", count));
    }

    /**
     * API: Lấy danh sách các thông báo gần đây để hiển thị trong dropdown.
     * Trả về một fragment HTML.
     */
    @GetMapping("/recent-list")
    public String getRecentNotificationList(Model model) {
        User currentUser = getCurrentAuthenticatedUser();
        List<UserNotification> userNotifications;
        long totalNotifications = 0;

        if (currentUser != null) {
            // Lấy 5 thông báo đầu tiên
            Page<UserNotification> firstPage = notificationService.getAllNotificationsForUser(currentUser, PageRequest.of(0, 5, Sort.by(Sort.Direction.DESC, "notification.createdAt")));
            userNotifications = firstPage.getContent();
            totalNotifications = firstPage.getTotalElements();
            logger.debug("Fetched {} recent notifications for user {}", userNotifications.size(), currentUser.getUserId());
        } else {
            userNotifications = Collections.emptyList();
            logger.debug("No authenticated user, returning empty notification list.");
        }
        model.addAttribute("clientUserNotifications", userNotifications);
        model.addAttribute("totalNotifications", totalNotifications);
        model.addAttribute("currentSize", userNotifications.size());

        return "client/notification/notification_dropdown"; // View JSP chính
    }

    /**
     * API: Lấy các trang thông báo tiếp theo (cho chức năng "Tải thêm").
     * Trả về một fragment HTML chỉ chứa các item thông báo.
     */
    @GetMapping("/load-more")
    public String loadMoreNotifications(Model model,
                                        @RequestParam(defaultValue = "1") int page,
                                        @RequestParam(defaultValue = "5") int size) {
        User currentUser = getCurrentAuthenticatedUser();
        if (currentUser == null) {
            // Có thể trả về một fragment rỗng hoặc lỗi nếu cần
            return "client/notification/notification_items_fragment"; 
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "notification.createdAt"));
        Page<UserNotification> notificationPage = notificationService.getAllNotificationsForUser(currentUser, pageable);

        model.addAttribute("clientUserNotifications", notificationPage.getContent());

        return "client/notification/notification_items_fragment";
    }


    /**
     * API: Đánh dấu MỘT thông báo là đã đọc.
     */
    @PostMapping("/mark-as-read/{notificationId}")
    @ResponseBody
    public ResponseEntity<?> markNotificationAsRead(@PathVariable Long notificationId) {
        User currentUser = getCurrentAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "Unauthorized"));
        }
        boolean updated = notificationService.markNotificationAsRead(currentUser, notificationId);
        if (updated) {
            return ResponseEntity.ok(Map.of("success", true, "message", "Notification marked as read."));
        }
        return ResponseEntity.ok(Map.of("success", false, "message", "Notification already read or not found."));
    }


    @PostMapping("/mark-all-as-read")
    @ResponseBody
    public ResponseEntity<?> markAllAsRead() {
        User currentUser = getCurrentAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "Unauthorized"));
        }
        int updatedCount = notificationService.markAllNotificationsAsRead(currentUser);
        return ResponseEntity.ok(Map.of("success", true, "updatedCount", updatedCount));
    }

}