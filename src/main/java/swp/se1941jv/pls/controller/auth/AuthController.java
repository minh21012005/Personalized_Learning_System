package swp.se1941jv.pls.controller.auth;

import jakarta.mail.MessagingException;
import jakarta.validation.Valid;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import swp.se1941jv.pls.dto.request.RegisterDTO;
import swp.se1941jv.pls.dto.request.ResetPasswordDTO;
import swp.se1941jv.pls.entity.Role;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.service.EmailService;
import swp.se1941jv.pls.service.UserService;

@Controller
public class AuthController {
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final EmailService emailService;

    public AuthController(UserService userService, PasswordEncoder passwordEncoder,EmailService emailService) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.emailService = emailService;
    }

    @GetMapping("/login")
    public String login(Model model) {
        return "client/auth/login";
    }

    @GetMapping("/access-deny")
    public String accessDenied(Model model) {
        return "client/auth/accessDeny";
    }

    @GetMapping("/register")
    public String register(Model model) {
        model.addAttribute("registerUser", new RegisterDTO());
        return "client/auth/register";
    }


    @PostMapping("/register")
    public String registerUser(Model model,
                               @ModelAttribute("registerUser") @Valid RegisterDTO registerDTO,
                               BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            return "client/auth/register";
        }

        User newUser = new User();
        newUser.setEmail(registerDTO.getEmail());
        newUser.setPassword(this.passwordEncoder.encode(registerDTO.getPassword()));
        newUser.setFullName(registerDTO.getFullName());
        newUser.setDob(registerDTO.getDob());
        newUser.setPhoneNumber(registerDTO.getPhoneNumber());
        newUser.setIsActive(true);
        newUser.setEmailVerify(false);

        // Assign the selected role
        Role selectedRole = this.userService.getRoleByName(registerDTO.getRole());
        newUser.setRole(selectedRole);

        this.userService.saveUser(newUser);

        return "redirect:/login";
    }

    // Xử lý yêu cầu quên mật khẩu
    @GetMapping("/forgot-password")
    public String showForgotPasswordForm(Model model) {
        model.addAttribute("email", "");
        return "client/auth/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(@RequestParam("email") String email, Model model) {
        User user = userService.getUserByEmail(email);
        String message;

        // Luôn hiển thị thông báo chung để tránh tiết lộ thông tin về sự tồn tại của email
        message = "Nếu email tồn tại, chúng tôi đã gửi một liên kết đặt lại mật khẩu tới hộp thư của bạn.";

        if (user != null) {
            // Tạo token reset password
            String token = userService.generateResetPasswordToken(user);

            // Gửi email chứa liên kết reset password
            try {
                emailService.sendResetPasswordEmail(email, token);
            } catch (MessagingException e) {
                message = "Có lỗi xảy ra khi gửi email. Vui lòng thử lại sau.";
            }
        }

        model.addAttribute("message", message);
        return "client/auth/forgot-password";
    }

    // Hiển thị form reset password
    @GetMapping("/reset-password")
    public String showResetPasswordForm(@RequestParam("token") String token, Model model) {
        User user = userService.findUserByResetPasswordToken(token);
        if (user == null) {
            model.addAttribute("error", "Liên kết không hợp lệ hoặc đã hết hạn.");
            return "client/auth/reset-password";
        }

        model.addAttribute("resetPasswordDTO", new ResetPasswordDTO());
        model.addAttribute("token", token);
        return "client/auth/reset-password";
    }

    // Xử lý reset password
    @PostMapping("/reset-password")
    public String processResetPassword(@RequestParam("token") String token,
                                       @ModelAttribute("resetPasswordDTO") @Valid ResetPasswordDTO resetPasswordDTO,
                                       BindingResult bindingResult,
                                       Model model) {
        User user = userService.findUserByResetPasswordToken(token);
        if (user == null) {
            model.addAttribute("error", "Liên kết không hợp lệ hoặc đã hết hạn.");
            return "client/auth/reset-password";
        }

        // Kiểm tra mật khẩu mới và xác nhận mật khẩu
        if (!resetPasswordDTO.getPassword().equals(resetPasswordDTO.getConfirmPassword())) {
            bindingResult.rejectValue("confirmPassword", "error.confirmPassword", "Mật khẩu xác nhận không khớp!");
        }

        if (bindingResult.hasErrors()) {
            return "client/auth/reset-password";
        }

        // Cập nhật mật khẩu mới
        user.setPassword(passwordEncoder.encode(resetPasswordDTO.getPassword()));
        userService.clearResetPasswordToken(user); // Xóa token sau khi reset thành công
        userService.saveUser(user);

        model.addAttribute("message", "Mật khẩu của bạn đã được đặt lại thành công. Vui lòng đăng nhập.");
        return "client/auth/login";
    }

}
