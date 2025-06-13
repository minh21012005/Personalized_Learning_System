package swp.se1941jv.pls.controller.client;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import swp.se1941jv.pls.dto.request.PasswordChangeRequest;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.service.UploadService;
import swp.se1941jv.pls.service.UserService;

import jakarta.validation.Valid;

@Controller
public class UserProfileController {

    private final UserService userService;
    private final UploadService uploadService;

    public UserProfileController(UserService userService, UploadService uploadService) {
        this.userService = userService;
        this.uploadService = uploadService;
    }

    @GetMapping("/account/profile")
    public String getProfile(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("id");
        if (userId == null) {
            return "redirect:/login";
        }
        User user = userService.getUserById(userId);
            model.addAttribute("user", user);
        return "client/profile/show";
    }

    @PostMapping("/account/profile")
    public String updateProfile(
            HttpSession session,
            @ModelAttribute("user") @Valid User user,
            BindingResult bindingResult,
            @RequestParam("file") MultipartFile file,
            Model model) {

        Long userId = (Long) session.getAttribute("id");
        if (userId == null) {
            return "redirect:/login";
        }

        User currentUser = userService.getUserById(userId);

        // Kiểm tra email đã được dùng bởi user khác chưa
        if (userService.existsByEmailAndUserIdNot(user.getEmail(), userId)) {
            bindingResult.rejectValue("email", "error.email", "Email đã được sử dụng bởi người dùng khác!");
        }
        // Kiểm tra số điện thoại đã được dùng bởi user khác chưa
        if (userService.existsByPhoneNumberAndUserIdNot(user.getPhoneNumber(), userId)) {
            bindingResult.rejectValue("phoneNumber", "error.phoneNumber", "Số điện thoại đã được sử dụng!");
        }

        String contentType = file.getContentType();
            if (!file.isEmpty() && !isImageFile(contentType)) {
            model.addAttribute("fileError", "Chỉ được chọn ảnh định dạng PNG, JPG, JPEG!");
            model.addAttribute("user", user);
            return "client/profile/show";
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("user", user);
            return "client/profile/show";
        }

        // Cập nhật thông tin
        currentUser.setFullName(user.getFullName());
        currentUser.setDob(user.getDob());
        currentUser.setEmail(user.getEmail());
        currentUser.setPhoneNumber(user.getPhoneNumber());

        // Xử lý ảnh đại diện
        if (file != null && !file.isEmpty()) {
            // Upload file mới
            String avatar = uploadService.handleSaveUploadFile(file, "avatar");
            currentUser.setAvatar(avatar);
            session.setAttribute("avatar", avatar);
        } else {
            // Giữ hoặc xóa ảnh dựa trên giá trị user.getAvatar()
            String avatar = user.getAvatar();
            currentUser.setAvatar(avatar); // Giữ ảnh hiện tại hoặc xóa nếu avatar rỗng
            session.setAttribute("avatar", avatar);
        }

        userService.saveUser(currentUser);

        // Cập nhật lại session
        session.setAttribute("fullName", currentUser.getFullName());
        session.setAttribute("email", currentUser.getEmail());

        model.addAttribute("user", currentUser);
        model.addAttribute("success", "Cập nhật thành công!");
        return "client/profile/show";
    }

    @GetMapping("/account/profile/change-password")
    public String showChangePasswordForm(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("id");
        if (userId == null) {
            return "redirect:/login";
        }
        User user = userService.getUserById(userId);
        model.addAttribute("user", user);
        model.addAttribute("passwordChangeRequest", new PasswordChangeRequest());
        return "client/profile/change-password";
    }

    @PostMapping("/account/profile/change-password")
    public String changePassword(
            HttpSession session,
            @ModelAttribute("passwordChangeRequest") @Valid PasswordChangeRequest passwordChangeRequest,
            BindingResult bindingResult,
            Model model) {

        Long userId = (Long) session.getAttribute("id");
        if (userId == null) {
            return "redirect:/login";
        }

        User currentUser = userService.getUserById(userId);
        model.addAttribute("user", currentUser);

        // Kiểm tra mật khẩu cũ
        if (!userService.verifyPassword(userId, passwordChangeRequest.getOldPassword())) {
            bindingResult.rejectValue("oldPassword", "error.oldPassword", "Mật khẩu cũ không đúng!");
        }
        // Kiểm tra độ mạnh của mật khẩu mới
        if (!userService.isStrongPassword(passwordChangeRequest.getNewPassword())) {
            bindingResult.rejectValue("newPassword", "error.newPassword",
                    "Mật khẩu mới phải có ít nhất 8 ký tự, chứa chữ hoa, chữ thường, số và ký tự đặc biệt!");
        }
        if (bindingResult.hasErrors()) {
            model.addAttribute("passwordChangeRequest", passwordChangeRequest);
            return "client/profile/change-password";
        }

        // Cập nhật mật khẩu mới
        userService.updatePassword(userId, passwordChangeRequest.getNewPassword());

        model.addAttribute("success", "Đổi mật khẩu thành công!");
        return "client/profile/change-password";
    }

    private boolean isImageFile(String contentType) {
        return contentType != null &&
                (contentType.equals("image/png") ||
                        contentType.equals("image/jpg") ||
                        contentType.equals("image/jpeg"));
    }
}