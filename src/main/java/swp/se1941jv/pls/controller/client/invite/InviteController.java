package swp.se1941jv.pls.controller.client.invite;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.service.InviteService;
import swp.se1941jv.pls.service.UserService;
import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class InviteController {

    private final InviteService inviteService;
    private final UserService userService;

    public InviteController(InviteService inviteService, UserService userService) {
        this.inviteService = inviteService;
        this.userService = userService;
    }

    // Hiển thị form gửi lời mời
    @GetMapping("/invite/create")
    public String showInviteForm(Model model) {
        return "client/invite/invite_form";
    }

    // Xử lý gửi lời mời
    @PostMapping("/invite/create")
    public String createInvite(@RequestParam String studentEmail, Authentication authentication, Model model,
            HttpServletRequest request) {
        try {
            String email = authentication.getName();
            User parent = this.userService.getUserByEmail(email);

            if (!parent.getRole().getRoleName().equals("PARENT")) {
                model.addAttribute("error", "Chỉ phụ huynh mới có thể gửi liên kết tài khoản tới con của họ!");
                return "client/invite/invite_form";
            }

            inviteService.createInvite(parent.getUserId(), studentEmail, request);
            model.addAttribute("message", "Nếu email tồn tại, chúng tôi đã gửi một liên kết tới hộp thư của con bạn!");
            return "client/invite/invite_form";
        } catch (MessagingException e) {
            model.addAttribute("error", "Email gửi không thành công!");
            return "client/invite/invite_form";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "client/invite/invite_form";
        }
    }

    // Hiển thị trang xác nhận lời mời
    @GetMapping("/invite/confirm")
    public String showConfirmForm(@RequestParam String code, Model model) {
        model.addAttribute("inviteCode", code);
        return "client/invite/confirm_invite";
    }

    // Xử lý xác nhận lời mời
    @PostMapping("/invite/confirm")
    public String confirmInvite(@RequestParam String inviteCode, Authentication authentication, Model model) {
        try {
            String email = authentication.getName();
            User student = this.userService.getUserByEmail(email);
            inviteService.confirmInvite(inviteCode, student.getUserId());
            model.addAttribute("message", "Xác nhận liên kết tài khoản với phụ huynh thành công!");
            return "client/invite/confirm_invite";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("inviteCode", inviteCode);
            return "client/invite/confirm_invite";
        }
    }
}