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


    private User getCurrentAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && !(authentication.getPrincipal() instanceof String && authentication.getPrincipal().equals("anonymousUser"))) {
            Object principal = authentication.getPrincipal();
            String username;
            if (principal instanceof UserDetails) {
                username = ((UserDetails) principal).getUsername();
            } else if (principal instanceof Principal) {
                username = ((Principal) principal).getName();
            }
            else {
                username = principal.toString();
            }
            return userService.getUserByEmail(username); 
        }
        return null;
    }

    @GetMapping("/unread-count")
    @ResponseBody
    public ResponseEntity<Map<String, Long>> getUnreadNotificationCount() {
        User currentUser = getCurrentAuthenticatedUser();
        if (currentUser == null) {
            return ResponseEntity.ok(Collections.singletonMap("count", 0L));
        }
        long count = notificationService.countUnreadNotificationsForUser(currentUser);
        logger.debug("User {} has {} unread notifications.", currentUser.getUserId(), count);
        return ResponseEntity.ok(Collections.singletonMap("count", count));
    }

    @GetMapping("/unread-list")
    public String getUnreadNotificationList(Model model, @RequestParam(defaultValue = "7") int limit) {
        User currentUser = getCurrentAuthenticatedUser();
        List<UserNotification> unreadUserNotifications;
        if (currentUser != null) {
            unreadUserNotifications = notificationService.getUnreadNotificationsForUser(currentUser, limit);
            logger.debug("Fetched {} unread notifications for user {} for dropdown.", unreadUserNotifications.size(), currentUser.getUserId());
        } else {
            unreadUserNotifications = Collections.emptyList();
            logger.debug("No authenticated user, returning empty notification list for dropdown.");
        }
        model.addAttribute("clientUserNotifications", unreadUserNotifications);

        return "client/notification/notification_dropdown";
    }


    @GetMapping("/all")
    public String showAllClientNotificationsPage(Model model,
                                                 @RequestParam(defaultValue = "0") int page,
                                                 @RequestParam(defaultValue = "10") int size) {
        User currentUser = getCurrentAuthenticatedUser();
        if (currentUser == null) {
            logger.warn("Attempt to access all notifications page without authentication. Redirecting to login.");
            return "redirect:/login";
        }

        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "notification.createdAt"));
        Page<UserNotification> notificationPage = notificationService.getAllNotificationsForUser(currentUser, pageable);

        model.addAttribute("notificationPage", notificationPage);
        model.addAttribute("pageTitle", "Tất cả Thông báo");

        model.addAttribute("clientContentPage", "client/notification/all_notifications_content"); 

        return "client/homepage/show";
    }
}