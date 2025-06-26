package swp.se1941jv.pls.controller.admin;


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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import swp.se1941jv.pls.entity.Notification;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.entity.UserNotification;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Subject;
import swp.se1941jv.pls.service.NotificationService;
import swp.se1941jv.pls.service.UserService;

import java.security.Principal;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/api/admin/notification")
@RequiredArgsConstructor
public class ManageNotificationController {
    private static final Logger logger = LoggerFactory.getLogger(ManageNotificationController.class);
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
        logger.debug("Admin {} has {} unread notifications.", currentUser.getUserId(), count);
        return ResponseEntity.ok(Collections.singletonMap("count", count));
    }

    @GetMapping("/unread-list")
    public String getUnreadNotificationList(Model model, @RequestParam(defaultValue = "7") int limit) {
        User currentUser = getCurrentAuthenticatedUser();
        List<UserNotification> unreadUserNotifications;
        if (currentUser != null) {
            unreadUserNotifications = notificationService.getUnreadNotificationsForUser(currentUser, limit);
            logger.debug("Admin Fetched {} unread notifications for user {} for dropdown.", unreadUserNotifications.size(), currentUser.getUserId());
        } else {
            unreadUserNotifications = Collections.emptyList();
            logger.debug("No authenticated Admin, returning empty notification list for dropdown.");
        }
        model.addAttribute("adminUserNotifications", unreadUserNotifications);

        return "admin/notification/notification_dropdown";
    }

}
