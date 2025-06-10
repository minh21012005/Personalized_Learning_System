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
                model.addAttribute("error", "Only parents can send invites");
                return "client/invite/invite_form";
            }

            inviteService.createInvite(parent.getUserId(), studentEmail, request);
            return "redirect:/invite/success";
        } catch (MessagingException e) {
            model.addAttribute("error", "Failed to send invite email");
            return "client/invite/invite_form";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "client/invite/invite_form";
        }
    }

    // Hiển thị trang thành công sau khi gửi lời mời
    @GetMapping("/invite/success")
    public String showInviteSuccess(Model model) {
        return "client/invite/invite_success";
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
            return "redirect:/invite/confirm-success";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("inviteCode", inviteCode);
            return "client/invite/confirm_invite";
        }
    }

    // Hiển thị trang thành công sau khi xác nhận lời mời
    @GetMapping("/invite/confirm-success")
    public String showConfirmSuccess(Model model) {
        return "client/invite/confirm_success";
    }
}