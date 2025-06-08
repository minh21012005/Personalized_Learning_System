package swp.se1941jv.pls.service;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import swp.se1941jv.pls.entity.*;
import swp.se1941jv.pls.entity.Package; // Đảm bảo đúng import
import swp.se1941jv.pls.entity.keys.KeyUserNotification;
import swp.se1941jv.pls.repository.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private static final Logger logger = LoggerFactory.getLogger(NotificationService.class);

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final UserNotificationRepository userNotificationRepository;
    private final PackageRepository packageRepository;
    private final SubjectRepository subjectRepository;
    private final RoleRepository roleRepository;

    @Transactional
    public Notification createNotification(
            String title, String content, String link, String thumbnail,
            String targetType, List<?> targetValue) {
        if (targetValue == null || targetValue.isEmpty()) {
            throw new IllegalArgumentException("Giá trị đối tượng nhận không được để trống.");
        }

        List<User> recipients = new ArrayList<>();
        List<Long> longIdList;
        List<String> stringValueList;

        switch (targetType) {
            case "USER":
                longIdList = targetValue.stream().map(obj -> Long.parseLong(obj.toString())).collect(Collectors.toList());
                List<String> userTargetRoles = Arrays.asList("STUDENT", "PARENT");
                List<String> upperUserTargetRoles = userTargetRoles.stream().map(String::toUpperCase).collect(Collectors.toList());
                List<User> potentialUsers = userRepository.findAllById(longIdList);
                recipients = potentialUsers.stream()
                        .filter(user -> Boolean.TRUE.equals(user.getIsActive()) &&
                                user.getRole() != null &&
                                upperUserTargetRoles.contains(user.getRole().getRoleName().toUpperCase()))
                        .collect(Collectors.toList());
                break;
            case "PACKAGE":
                longIdList = targetValue.stream().map(obj -> Long.parseLong(obj.toString())).collect(Collectors.toList());
                List<swp.se1941jv.pls.entity.Package> activeSelectedPackages = packageRepository.findAllActiveByIds(longIdList); // Giả định có findAllActiveByIds
                if (!activeSelectedPackages.isEmpty()) {
                    List<Long> activePackageIds = activeSelectedPackages.stream().map(swp.se1941jv.pls.entity.Package::getPackageId).collect(Collectors.toList());
                    recipients = userRepository.findActiveUsersByPackageIds(activePackageIds); // Giả định có
                }
                break;
            case "SUBJECT":
                longIdList = targetValue.stream().map(obj -> Long.parseLong(obj.toString())).collect(Collectors.toList());
                List<Subject> activeSelectedSubjects = subjectRepository.findAllActiveByIds(longIdList); // Giả định có
                if (!activeSelectedSubjects.isEmpty()) {
                    List<Long> activeSubjectIds = activeSelectedSubjects.stream().map(Subject::getSubjectId).collect(Collectors.toList());
                    recipients = userRepository.findActiveUsersBySubjectIds(activeSubjectIds); // Giả định có
                }
                break;
            case "ROLE":
                stringValueList = targetValue.stream().map(obj -> obj.toString().toUpperCase()).collect(Collectors.toList());
                recipients = userRepository.findActiveUsersByRoleNames(stringValueList); // Giả định có
                break;
            default:
                logger.warn("Unsupported targetType: {}", targetType);
                throw new IllegalArgumentException("Loại đối tượng nhận không được hỗ trợ: " + targetType);
        }
        recipients = recipients.stream().distinct().collect(Collectors.toList());
        if (recipients.isEmpty()) {
            logger.info("No suitable recipients found for notification: title='{}', targetType='{}', targetValue='{}'", title, targetType, targetValue);
            throw new IllegalStateException("Không tìm thấy người dùng phù hợp để nhận thông báo.");
        }
        Notification notification = Notification.builder()
                .title(title).content(content).link(link).thumbnail(thumbnail)
                .targetType(targetType).build();
        Notification savedNotification = notificationRepository.save(notification);
        logger.info("Notification created with ID: {}", savedNotification.getNotificationId());
        final Notification finalNotification = savedNotification;
        List<UserNotification> userNotifications = recipients.stream()
                .map(user -> UserNotification.builder()
                        .id(new KeyUserNotification(user.getUserId(), finalNotification.getNotificationId()))
                        .user(user).notification(finalNotification).isRead(false).build())
                .collect(Collectors.toList());
        userNotificationRepository.saveAll(userNotifications);
        logger.info("Saved {} UserNotification records for Notification ID: {}", userNotifications.size(), finalNotification.getNotificationId());
        return savedNotification;
    }

    public Page<Notification> getAllNotificationsPageable(String keyword, String filterTargetType, Pageable pageable) {
        logger.debug("Fetching notifications with keyword: '{}', targetType: '{}', pageable: {}", keyword, filterTargetType, pageable);
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasTargetType = filterTargetType != null && !filterTargetType.trim().isEmpty();

        if (hasKeyword && hasTargetType) {
            return notificationRepository.findByTitleContainingIgnoreCaseAndTargetTypeContainingIgnoreCase(keyword.trim(), filterTargetType.trim(), pageable);
        } else if (hasKeyword) {
            return notificationRepository.findByTitleContainingIgnoreCase(keyword.trim(), pageable);
        } else if (hasTargetType) {
            return notificationRepository.findByTargetTypeContainingIgnoreCase(filterTargetType.trim(), pageable);
        } else {
            return notificationRepository.findAll(pageable);
        }
    }
    
    public Optional<Notification> findNotificationById(Long id) {
        return notificationRepository.findById(id);
    }

    @Transactional
    public Notification updateNotification(Long id, String title, String content, String link, String thumbnail) {
        Notification existingNotification = notificationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy thông báo với ID: " + id));
        existingNotification.setTitle(title);
        existingNotification.setContent(content);
        existingNotification.setLink(link);
        existingNotification.setThumbnail(thumbnail);
        // Không thay đổi người nhận trong bản cập nhật này để đơn giản
        logger.info("Updating notification ID: {}", id);
        return notificationRepository.save(existingNotification);
    }

    @Transactional
    public void deleteNotificationById(Long id) {
        Notification notification = notificationRepository.findById(id)
                .orElseThrow(() -> {
                    logger.warn("Attempted to delete non-existing notification with ID: {}", id);
                    return new IllegalArgumentException("Không tìm thấy thông báo với ID: " + id + " để xóa.");
                });
        userNotificationRepository.deleteByNotification(notification);
        notificationRepository.delete(notification);
        logger.info("Deleted notification ID: {}", id);
    }

    public List<User> getTargetableUsersForForm() {
        List<String> targetRoleNames = Arrays.asList("STUDENT", "PARENT");
        List<String> upperTargetRoleNames = targetRoleNames.stream().map(String::toUpperCase).collect(Collectors.toList());
        return userRepository.findActiveUsersByRoleNames(upperTargetRoleNames);
    }

    public List<swp.se1941jv.pls.entity.Package> getTargetablePackagesForForm() {
        return packageRepository.findAllByIsActiveTrue();
    }

    public List<Subject> getTargetableSubjectsForForm() {
        return subjectRepository.findByIsActiveTrue();
    }

    public List<String> getTargetableRoleNamesForForm() {
        List<String> desiredRoles = Arrays.asList("STUDENT", "PARENT");
        return roleRepository.findAll().stream()
                             .map(Role::getRoleName)
                             .filter(name -> desiredRoles.stream().anyMatch(dr -> dr.equalsIgnoreCase(name)))
                             .distinct().sorted()
                             .collect(Collectors.toList());
    }
}