package swp.se1941jv.pls.controller.admin;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import swp.se1941jv.pls.entity.Notification;
import swp.se1941jv.pls.entity.User; 
import swp.se1941jv.pls.entity.Package; 
import swp.se1941jv.pls.entity.Subject; 
import swp.se1941jv.pls.service.NotificationService;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/notification")
public class NotificationController {

    private final NotificationService notificationService;
    private static final Logger logger = LoggerFactory.getLogger(NotificationController.class);

    @GetMapping("")
    public String handleBaseNotificationPath() {
        logger.debug("Redirecting from /admin/notification to /admin/notification/show");
        return "redirect:/admin/notification/show";
    }

    @GetMapping("/create")
    public String showCreateNotificationForm(Model model) {
        logger.info("Accessing create notification form page.");
        model.addAttribute("pageTitle", "Tạo thông báo mới");
        populateFormModelAttributes(model);

       
        model.addAttribute("isEditMode", false); 
        model.addAttribute("title", "");
        model.addAttribute("content", "");
        model.addAttribute("link", "");
        model.addAttribute("thumbnail", "");
        model.addAttribute("selectedTargetType", "");
        model.addAttribute("selectedTargetValues", Collections.emptyList());
        
        model.addAttribute("formAction", "/admin/notification/create"); 
        model.addAttribute("contentPage", "form_content.jsp");
        return "admin/notification/show";
    }

    @PostMapping("/create")
    public String processCreateNotification(
            @RequestParam String title, @RequestParam String content, @RequestParam String link,
            @RequestParam(required = false) String thumbnail, @RequestParam String targetType,
            @RequestParam(value = "targetValue", required = false) List<String> targetValue,
            RedirectAttributes redirectAttributes, Model model) {

        logger.info("Attempting to create notification via POST: title='{}', targetType='{}'", title, targetType);

        if (!isValidNotificationInput(title, content, link, targetType, targetValue, model)) {
            logger.warn("Validation failed for creating notification: {}", model.getAttribute("errorMessage"));
            model.addAttribute("pageTitle", "Tạo thông báo mới (Lỗi)");
            populateFormModelAttributes(model);
            model.addAttribute("isEditMode", false);
            model.addAttribute("title", title); model.addAttribute("content", content);
            model.addAttribute("link", link); model.addAttribute("thumbnail", thumbnail);
            model.addAttribute("selectedTargetType", targetType);
            model.addAttribute("selectedTargetValues", targetValue != null ? targetValue : Collections.emptyList());
            model.addAttribute("formAction", "/admin/notification/create");
            model.addAttribute("contentPage", "form_content.jsp");
            return "admin/notification/show";
        }

        try {
            Notification createdNotification = notificationService.createNotification(
                    title, content, link, thumbnail, targetType, targetValue);
            logger.info("Notification created successfully with ID: {}", createdNotification.getNotificationId());
            redirectAttributes.addFlashAttribute("successMessage", "Gửi thông báo thành công!");
            return "redirect:/admin/notification/show";
        } catch (IllegalArgumentException | IllegalStateException ex) {
            handleServiceException(ex, "Tạo thông báo mới (Lỗi)", model, title, content, link, thumbnail, targetType, targetValue, false, null, "/admin/notification/create");
        } catch (Exception ex) {
            handleGenericException(ex, "Tạo thông báo mới (Lỗi)", "tạo", model, title, content, link, thumbnail, targetType, targetValue, false, null, "/admin/notification/create");
        }
        return "admin/notification/show";
    }

    @GetMapping("/show")
    public String showNotificationList(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "filterTargetType", required = false) String filterTargetType,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "5") int size,
            Model model) {

        logger.info("Accessing notification list page. Page: {}, Size: {}, Keyword: '{}', TargetType: '{}'",
                page, size, keyword, filterTargetType);
        model.addAttribute("pageTitle", "Danh sách thông báo");

        try {
            Sort sort = Sort.by(Sort.Direction.DESC, "notificationId"); 
            Pageable pageable = PageRequest.of(page, size, sort);
            Page<Notification> notificationPage = notificationService.getAllNotificationsPageable(keyword, filterTargetType, pageable);

            model.addAttribute("notificationList", notificationPage.getContent());
            model.addAttribute("totalPages", notificationPage.getTotalPages());
            model.addAttribute("currentPage", notificationPage.getNumber());
            model.addAttribute("totalItems", notificationPage.getTotalElements());
            model.addAttribute("pageSize", size);
            model.addAttribute("keyword", keyword);
            model.addAttribute("filterTargetType", filterTargetType);

        } catch (Exception e) {
            logger.error("Error fetching notification list", e);
            model.addAttribute("errorMessage", "Không thể tải danh sách thông báo.");
            setEmptyPageAttributes(model, size, keyword, filterTargetType);
        }
        model.addAttribute("contentPage", "list_content.jsp");
        return "admin/notification/show";
    }

    @GetMapping("/edit/{id}")
    public String showEditNotificationForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        logger.info("Accessing edit form for notification ID: {}", id);
        try {
            Optional<Notification> notificationOpt = notificationService.findNotificationById(id);
            if (notificationOpt.isPresent()) {
                model.addAttribute("pageTitle", "Sửa thông báo");
                populateFormModelAttributes(model);
                Notification notification = notificationOpt.get();
                model.addAttribute("isEditMode", true); 
                model.addAttribute("notificationId", notification.getNotificationId());
                model.addAttribute("title", notification.getTitle());
                model.addAttribute("content", notification.getContent());
                model.addAttribute("link", notification.getLink());
                model.addAttribute("thumbnail", notification.getThumbnail());
                model.addAttribute("selectedTargetType", notification.getTargetType()); 
                model.addAttribute("selectedTargetValues", Collections.emptyList()); 
                
                model.addAttribute("formAction", "/admin/notification/edit/" + id); 
                model.addAttribute("contentPage", "form_content.jsp");
                return "admin/notification/show";
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy thông báo với ID: " + id);
                return "redirect:/admin/notification/show";
            }
        } catch (Exception e) {
            logger.error("Error showing edit form for notification ID: {}: {}", id, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi tải form sửa thông báo.");
            return "redirect:/admin/notification/show";
        }
    }

    @PostMapping("/edit/{id}")
    public String processUpdateNotification(@PathVariable("id") Long id,
                                         @RequestParam String title, @RequestParam String content,
                                         @RequestParam String link, @RequestParam(required = false) String thumbnail,
                                         
                                         RedirectAttributes redirectAttributes, Model model) {
        logger.info("Processing update for notification ID: {}", id);

        
        if (title == null || title.trim().isEmpty()) model.addAttribute("errorMessage", "Tiêu đề không được để trống!");
        else if (content == null || content.trim().isEmpty()) model.addAttribute("errorMessage", "Nội dung không được để trống!");
        else if (link == null || link.trim().isEmpty()) model.addAttribute("errorMessage", "Link không được để trống!");
        
        if (model.containsAttribute("errorMessage")) {
             logger.warn("Validation failed for updating notification ID {}: {}", id, model.getAttribute("errorMessage"));
            model.addAttribute("pageTitle", "Sửa thông báo (Lỗi)");
            populateFormModelAttributes(model); // Vẫn cần nếu form có select box chung
            model.addAttribute("isEditMode", true);
            model.addAttribute("notificationId", id);
            model.addAttribute("title", title); model.addAttribute("content", content);
            model.addAttribute("link", link); model.addAttribute("thumbnail", thumbnail);
            // Lấy lại targetType của notification hiện tại để hiển thị, không cho sửa
             Optional<Notification> currentNotifOpt = notificationService.findNotificationById(id);
             currentNotifOpt.ifPresent(n -> model.addAttribute("selectedTargetType", n.getTargetType()));

            model.addAttribute("formAction", "/admin/notification/edit/" + id);
            model.addAttribute("contentPage", "form_content.jsp");
            return "admin/notification/show";
        }

        try {
            notificationService.updateNotification(id, title, content, link, thumbnail);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông báo thành công!");
            return "redirect:/admin/notification/show";
        } catch (IllegalArgumentException ex) { // Ví dụ: ID không tìm thấy từ service
            handleServiceException(ex, "Sửa thông báo (Lỗi)", model, title, content, link, thumbnail, null, null, true, id, "/admin/notification/edit/" + id);
        } catch (Exception ex) {
            handleGenericException(ex, "Sửa thông báo (Lỗi)", "cập nhật", model, title, content, link, thumbnail, null, null, true, id, "/admin/notification/edit/" + id);
        }
         return "admin/notification/show";
    }

    @PostMapping("/delete/{id}")
    public String deleteNotification(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        logger.info("Attempting to delete notification ID: {}", id);
        try {
            notificationService.deleteNotificationById(id);
            redirectAttributes.addFlashAttribute("successMessage", "Xóa thông báo thành công!");
        } catch (IllegalArgumentException ex) { 
             logger.warn("Error deleting notification ID {}: {}", id, ex.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        } 
        catch (Exception e) {
            logger.error("Error deleting notification ID: " + id, e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi xóa thông báo.");
        }
        return "redirect:/admin/notification/show";
    }

   
    private void populateFormModelAttributes(Model model) {
        String formErrorAccumulator = ""; 

        try {
            List<User> users = notificationService.getTargetableUsersForForm();
            model.addAttribute("allUsers", users);
            logger.debug("Populated 'allUsers' with {} entries for notification form.", users.size());
        } catch (Exception e) {
            logger.error("Error populating users for notification form", e);
            model.addAttribute("allUsers", Collections.emptyList()); 
            formErrorAccumulator += "Lỗi khi tải danh sách Người dùng. ";
        }

        try {
            List<swp.se1941jv.pls.entity.Package> packages = notificationService.getTargetablePackagesForForm();
            model.addAttribute("allPackages", packages);
            logger.debug("Populated 'allPackages' with {} entries for notification form.", packages.size());
        } catch (Exception e) {
            logger.error("Error populating packages for notification form", e);
            model.addAttribute("allPackages", Collections.emptyList());
            formErrorAccumulator += "Lỗi khi tải danh sách Gói học. ";
        }

        try {
            List<Subject> subjects = notificationService.getTargetableSubjectsForForm();
            model.addAttribute("allSubjects", subjects);
            logger.debug("Populated 'allSubjects' with {} entries for notification form.", subjects.size());
        } catch (Exception e) {
            logger.error("Error populating subjects for notification form", e);
            model.addAttribute("allSubjects", Collections.emptyList());
            formErrorAccumulator += "Lỗi khi tải danh sách Môn học. ";
        }

        try {
            List<String> roles = notificationService.getTargetableRoleNamesForForm();
            model.addAttribute("allRoles", roles);
            logger.debug("Populated 'allRoles' with {} entries for notification form: {}", roles.size(), roles);
        } catch (Exception e) {
            logger.error("Error populating roles for notification form", e);
            model.addAttribute("allRoles", Collections.emptyList());
            formErrorAccumulator += "Lỗi khi tải danh sách Vai trò.";
        }

       
        if (!formErrorAccumulator.isEmpty()) {
            model.addAttribute("formErrorMessage", formErrorAccumulator.trim());
        }
    }

    private boolean isValidNotificationInput(String title, String content, String link, String targetType, List<String> targetValue, Model model) {
        if (title == null || title.trim().isEmpty()) { model.addAttribute("errorMessage", "Tiêu đề không được để trống!"); return false; }
        if (content == null || content.trim().isEmpty()) { model.addAttribute("errorMessage", "Nội dung không được để trống!"); return false; }
        if (link == null || link.trim().isEmpty()) { model.addAttribute("errorMessage", "Link không được để trống!"); return false; }
        if (targetType == null || targetType.trim().isEmpty()) { model.addAttribute("errorMessage", "Đối tượng nhận không được để trống!"); return false; }
        if (targetValue == null || targetValue.isEmpty()) { model.addAttribute("errorMessage", "Vui lòng chọn ít nhất một giá trị cho đối tượng nhận!"); return false; }
        return true;
    }
    
    private void setEmptyPageAttributes(Model model, int size, String keyword, String filterTargetType) {
        model.addAttribute("notificationList", Collections.emptyList());
        model.addAttribute("totalPages", 0);
        model.addAttribute("currentPage", 0);
        model.addAttribute("totalItems", 0L);
        model.addAttribute("pageSize", size);
        model.addAttribute("keyword", keyword);
        model.addAttribute("filterTargetType", filterTargetType);
    }

    private void handleServiceException(Exception ex, String pageTitle, Model model,
                                     String title, String content, String link, String thumbnail,
                                     String targetType, List<String> targetValue,
                                     boolean isEditMode, Long notificationId, String formAction) {
        logger.warn("Service exception during notification processing: {}", ex.getMessage());
        model.addAttribute("errorMessage", ex.getMessage());
        setFormAttributesForError(pageTitle, model, title, content, link, thumbnail, targetType, targetValue, isEditMode, notificationId, formAction);
    }

    private void handleGenericException(Exception ex, String pageTitle, String actionType, Model model,
                                        String title, String content, String link, String thumbnail,
                                        String targetType, List<String> targetValue,
                                        boolean isEditMode, Long notificationId, String formAction) {
        logger.error("Unexpected error during notification {} processing: {}", actionType, ex.getMessage(), ex);
        model.addAttribute("errorMessage", "Đã có lỗi không mong muốn xảy ra khi " + actionType + " thông báo.");
        setFormAttributesForError(pageTitle, model, title, content, link, thumbnail, targetType, targetValue, isEditMode, notificationId, formAction);
    }

    private void setFormAttributesForError(String pageTitle, Model model,
                                           String title, String content, String link, String thumbnail,
                                           String targetType, List<String> targetValue,
                                           boolean isEditMode, Long notificationId, String formAction) {
        model.addAttribute("pageTitle", pageTitle);
        populateFormModelAttributes(model);
        model.addAttribute("isEditMode", isEditMode);
        if (isEditMode) {
            model.addAttribute("notificationId", notificationId);
             
            if (targetType == null && notificationId != null) {
                 Optional<Notification> currentNotifOpt = notificationService.findNotificationById(notificationId);
                 currentNotifOpt.ifPresent(n -> model.addAttribute("selectedTargetType", n.getTargetType()));
            } else {
                model.addAttribute("selectedTargetType", targetType);
            }
        } else {
             model.addAttribute("selectedTargetType", targetType);
        }
        model.addAttribute("title", title);
        model.addAttribute("content", content);
        model.addAttribute("link", link);
        model.addAttribute("thumbnail", thumbnail);
        model.addAttribute("selectedTargetValues", targetValue != null ? targetValue : Collections.emptyList());
        model.addAttribute("formAction", formAction);
        model.addAttribute("contentPage", "form_content.jsp");
    }
}