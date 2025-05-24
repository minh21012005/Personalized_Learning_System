package swp.se1941jv.pls.controller.admin;

import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.service.RoleService;
import swp.se1941jv.pls.service.UploadService;
import swp.se1941jv.pls.service.UserService;

@Controller
public class UserController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final RoleService roleService;
    private UploadService uploadService;

    public UserController(UserService userService, PasswordEncoder passwordEncoder, RoleService roleService,
            UploadService uploadService) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.roleService = roleService;
        this.uploadService = uploadService;
    }

    @GetMapping("/admin/user")
    public String getUserPage(Model model) {
        List<User> users = this.userService.getAllUsers();
        model.addAttribute("users", users);
        return "admin/user/show";
    }

    @GetMapping("admin/user/create")
    public String getUserCreatePage(Model model) {
        model.addAttribute("newUser", new User());
        return "admin/user/create";
    }

    @PostMapping("/admin/user/create")
    public String createUser(Model model, @ModelAttribute("newUser") @Valid User newUser,
            BindingResult newUserBindingResult,
            @RequestParam("file") MultipartFile file) {

        // Kiểm tra nếu email đã tồn tại
        if (this.userService.existsByEmail(newUser.getEmail())) {
            newUserBindingResult.rejectValue("email", "error.newUser", "Email đã được sử dụng!");
        }

        // Có lỗi chuyển hướng về trang create
        if (newUserBindingResult.hasErrors()) {
            return "admin/user/create";
        }

        // save user
        String avatar = this.uploadService.handleSaveUploadFile(file, "avatar");
        String hassPassword = this.passwordEncoder.encode(newUser.getPassword());
        newUser.setAvatar(avatar);
        newUser.setPassword(hassPassword);
        newUser.setIsActive(true);
        newUser.setRole(this.roleService.getRoleByName(newUser.getRole().getRoleName()));
        this.userService.saveUser(newUser);
        return "redirect:/admin/user";
    }
}
