package swp.se1941jv.pls.controller.admin;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
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
import swp.se1941jv.pls.entity.Role;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.service.RoleService;
import swp.se1941jv.pls.service.UploadService;
import swp.se1941jv.pls.service.UserService;

@Controller
public class UserController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final RoleService roleService;
    private final UploadService uploadService;

    public UserController(UserService userService, PasswordEncoder passwordEncoder, RoleService roleService,
            UploadService uploadService) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.roleService = roleService;
        this.uploadService = uploadService;
    }

    @GetMapping("/super-admin/user")
    public String getUserPage(@RequestParam Optional<String> page,
            @RequestParam Optional<String> role,
            @RequestParam Optional<String> name,
            Model model) {
        int pageNumber;
        try {
            pageNumber = page.map(Integer::parseInt).orElse(1);
        } catch (Exception e) {
            pageNumber = 1;
        }

        int pageSize = 8;

        List<Role> roles = roleService.getAllRoles();

        String roleFilter = null;
        if (role.isPresent()) {
            boolean isValidRole = roles.stream()
                    .anyMatch(r -> r.getRoleName().equals(role.get()));
            if (isValidRole) {
                roleFilter = role.get();
            }
        }

        String nameFilter = name.orElse(null);

        Pageable pageable = PageRequest.of(pageNumber - 1, pageSize, Sort.by(Sort.Direction.DESC, "userId"));
        Page<User> pageUser = userService.findUsersWithFilters(roleFilter, nameFilter, pageable);
        int totalPage = pageUser.getTotalPages();

        if (pageNumber < 1 || (pageNumber > totalPage && totalPage > 0)) {
            return "error/404";
        }

        List<User> users = pageUser.getContent();

        model.addAttribute("users", users);
        model.addAttribute("roles", roles);
        model.addAttribute("currentPage", pageNumber);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("selectedRole", roleFilter != null ? roleFilter : "");
        model.addAttribute("paramName", nameFilter);

        return "admin/user/show";
    }

    @GetMapping("super-admin/user/create")
    public String getUserCreatePage(Model model) {
        List<Role> roles = roleService.getAllRoles();
        model.addAttribute("roles", roles);
        model.addAttribute("newUser", new User());
        return "admin/user/create";
    }

    @PostMapping("/super-admin/user/create")
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
            model.addAttribute("roles", this.roleService.getAllRoles());
            return "admin/user/create";
        }

        String contentType = file.getContentType();
        if (!file.isEmpty() && !isImageFile(contentType)) {
            model.addAttribute("roles", this.roleService.getAllRoles());
            model.addAttribute("fileError", "Chỉ được chọn ảnh định dạng PNG, JPG, JPEG!");
            return "admin/user/create";
        }

        // save user
        String avatar = this.uploadService.handleSaveUploadFile(file, "avatar");
        String hassPassword = this.passwordEncoder.encode(newUser.getPassword());
        newUser.setAvatar(avatar);
        newUser.setPassword(hassPassword);
        newUser.setRole(this.roleService.getRoleByName(newUser.getRole().getRoleName()));
        newUser.setEmailVerify(true);
        this.userService.saveUser(newUser);
        return "redirect:/super-admin/user";
    }

    // Hàm kiểm tra content type của file có phải là ảnh hợp lệ
    private boolean isImageFile(String contentType) {
        return contentType != null &&
                (contentType.equals("image/png") ||
                        contentType.equals("image/jpg") ||
                        contentType.equals("image/jpeg"));
    }

    @GetMapping("/super-admin/user/{id}")
    public String getDetailUserPage(Model model, @PathVariable long id) {
        User user = this.userService.getUserById(id);
        if (user == null) {
            return "error/404";
        }
        if (user.getUserCreated() != null) {
            User createdUser = this.userService.getUserById(user.getUserCreated());
            model.addAttribute("createdUser", createdUser);
        }

        if (user.getUserUpdated() != null) {
            User updatedUser = this.userService.getUserById(user.getUserUpdated());
            model.addAttribute("updatedUser", updatedUser);
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        model.addAttribute("createdAtFormatted", user.getCreatedAt().format(formatter));
        model.addAttribute("updatedAtFormatted", user.getUpdatedAt().format(formatter));
        model.addAttribute("user", user);
        model.addAttribute("dobFormatted", user.getDob().format(formatter));
        return "admin/user/detail";
    }

    @GetMapping("/super-admin/user/update/{id}")
    public String getUpdateUserPage(Model model, @PathVariable long id) {
        User user = this.userService.getUserById(id);
        if (user == null) {
            return "error/404";
        }
        List<Role> roles = this.roleService.getAllRoles();
        model.addAttribute("roles", roles);
        model.addAttribute("user", user);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        model.addAttribute("dobFormatted", user.getDob().format(formatter));
        return "admin/user/update";
    }

    @PostMapping("/super-admin/user/update")
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

        // Có lỗi chuyển hướng về trang update
        if (newUserBindingResult.hasErrors()) {
            model.addAttribute("roles", this.roleService.getAllRoles());
            return "admin/user/update";
        }

        String contentType = file.getContentType();
        if (!file.isEmpty() && !isImageFile(contentType)) {
            model.addAttribute("roles", this.roleService.getAllRoles());
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
        return "redirect:/super-admin/user";
    }
}
