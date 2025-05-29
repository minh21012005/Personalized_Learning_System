package swp.se1941jv.pls.controller.auth;

import jakarta.validation.Valid;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import swp.se1941jv.pls.dto.request.RegisterDTO;
import swp.se1941jv.pls.entity.Role;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.service.UserService;

@Controller
public class AuthController {
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    public AuthController(UserService userService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
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

}
