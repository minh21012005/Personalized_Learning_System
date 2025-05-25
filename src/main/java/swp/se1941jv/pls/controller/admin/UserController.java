package swp.se1941jv.pls.controller.admin;

import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
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

        // Kiểm tra số điện thoại đã tồn tại
        if (this.userService.existsByPhoneNumber(newUser.getPhoneNumber())) {
            newUserBindingResult.rejectValue("phoneNumber", "error.newUser", "Số điện thoại đã được sử dụng!");
        }

        // Có lỗi chuyển hướng về trang create
        if (newUserBindingResult.hasErrors()) {
            return "admin/user/create";
        }

        String contentType = file.getContentType();
        if (!file.isEmpty() && !isImageFile(contentType)) {
            model.addAttribute("fileError", "Chỉ được chọn ảnh định dạng PNG, JPG, JPEG!");
            return "admin/user/create";
        }

        // save user
        String avatar = this.uploadService.handleSaveUploadFile(file, "avatar");
        String hassPassword = this.passwordEncoder.encode(newUser.getPassword());
        newUser.setAvatar(avatar);
        newUser.setPassword(hassPassword);
        newUser.setRole(this.roleService.getRoleByName(newUser.getRole().getRoleName()));
        this.userService.saveUser(newUser);
        return "redirect:/admin/user";
    }

    // Hàm kiểm tra content type của file có phải là ảnh hợp lệ
    private boolean isImageFile(String contentType) {
        return contentType != null &&
                (contentType.equals("image/png") ||
                        contentType.equals("image/jpg") ||
                        contentType.equals("image/jpeg"));
    }

    @GetMapping("/admin/user/{id}")
    public String getDetailUserPage(Model model, @PathVariable long id) {
        User user = this.userService.getUserById(id);
        if (user == null) {
            return "error/404";
        }
        model.addAttribute("user", user);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        model.addAttribute("dobFormatted", user.getDob().format(formatter));
        return "admin/user/detail";
    }

    @GetMapping("/admin/user/update/{id}")
    public String getUpdateUserPage(Model model, @PathVariable long id) {
        User user = this.userService.getUserById(id);
        if (user == null) {
            return "error/404";
        }
        model.addAttribute("user", user);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        model.addAttribute("dobFormatted", user.getDob().format(formatter));
        return "admin/user/update";
    }

    @PostMapping("/admin/user/update")
    public String updateUser(Model model, @ModelAttribute("user") @Valid User newUser,
            BindingResult newUserBindingResult,
            @RequestParam("file") MultipartFile file) {

        // Kiểm tra email đã được dùng bởi user khác chưa
        if (userService.existsByEmailAndUserIdNot(newUser.getEmail(), newUser.getUserId())) {
            newUserBindingResult.rejectValue("email", "error.email", "Email đã được sử dụng bởi người dùng khác!");
        }

        // Kiểm tra số điện thoại đã được dùng bởi user khác chưa
        if (userService.existsByPhoneNumberAndUserIdNot(newUser.getPhoneNumber(), newUser.getUserId())) {
            newUserBindingResult.rejectValue("phoneNumber", "error.phoneNumber", "Số điện thoại đã được sử dụng!");
        }

        if (newUserBindingResult.hasErrors()) {
            for (FieldError error : newUserBindingResult.getFieldErrors()) {
                System.out.println("Lỗi ở field: " + error.getField());
                System.out.println("Thông báo lỗi: " + error.getDefaultMessage());
            }
            return "admin/user/update";
        }

        // Có lỗi chuyển hướng về trang update
        if (newUserBindingResult.hasErrors()) {
            return "admin/user/update";
        }

        String contentType = file.getContentType();
        if (!file.isEmpty() && !isImageFile(contentType)) {
            model.addAttribute("fileError", "Chỉ được chọn ảnh định dạng PNG, JPG, JPEG!");
            return "admin/user/update";
        }

        // save user
        if (!file.isEmpty()) {
            String avatar = this.uploadService.handleSaveUploadFile(file, "avatar");
            newUser.setAvatar(avatar);
        }
        newUser.setRole(this.roleService.getRoleByName(newUser.getRole().getRoleName()));
        this.userService.saveUser(newUser);
        return "redirect:/admin/user";
    }
}
