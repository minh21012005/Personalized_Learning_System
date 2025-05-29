package swp.se1941jv.pls.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import swp.se1941jv.pls.entity.Role;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.RoleRepository;
import swp.se1941jv.pls.repository.UserRepository;
import swp.se1941jv.pls.service.specification.UserSpecification;

import java.util.List;
import java.util.regex.Pattern;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    // Regex để kiểm tra mật khẩu mạnh
    private static final String PASSWORD_PATTERN =
            "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()\\-_+=\\[\\]{}|;:'\",.<>?/]).{8,}$";

    private static final Pattern pattern = Pattern.compile(PASSWORD_PATTERN);

    public UserService(UserRepository userRepository, RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
    }

    /**
     * Kiểm tra xem mật khẩu có mạnh không dựa trên các tiêu chí:
     * - Ít nhất 8 ký tự
     * - Chứa ít nhất một chữ cái viết hoa (A-Z)
     * - Chứa ít nhất một chữ cái viết thường (a-z)
     * - Chứa ít nhất một chữ số (0-9)
     * - Chứa ít nhất một ký tự đặc biệt (!@#$%^&*()-_+=[]{}|;:'",.<>?/)
     *
     * @param password Mật khẩu cần kiểm tra
     * @return true nếu mật khẩu mạnh, false nếu không
     */
    public boolean isStrongPassword(String password) {
        if (password == null) {
            return false;
        }
        return pattern.matcher(password).matches();
    }

    public UserRepository getUserRepository() {
        return userRepository;
    }

    public List<User> getAllUsers() {
        return this.userRepository.findAll();
    }

    public Page<User> getAllUsers(Pageable pageable) {
        return this.userRepository.findAll(pageable);
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }
    //
    // public List<User> getAllUsersByEmail(String email) {
    // return this.userRepository.findAllByEmail(email);
    // }

    public User saveUser(User user) {
        return this.userRepository.save(user);
    }

    public User getUserById(Long id) {
        return this.userRepository.findById(id).orElse(null);
    }

    public void deleteUserById(Long id) {
        this.userRepository.deleteById(id);
    }
    //
    // public Role getRoleByName(String name) {
    // return this.roleRepository.findByRoleName(name);
    // }
    //
    // public boolean checkEmailExist(String email) {
    // return this.userRepository.existsByEmail(email);
    // }

    public long countUsers() {
        return this.userRepository.count();
    }

    public boolean existsByEmail(String email) {
        return this.userRepository.existsByEmail(email);
    }

    public boolean existsByPhoneNumber(String phoneNumber) {
        return this.userRepository.existsByPhoneNumber(phoneNumber);
    }

    public boolean existsByEmailAndUserIdNot(String email, long id) {
        return this.userRepository.existsByEmailAndUserIdNot(email, id);
    }

    public boolean existsByPhoneNumberAndUserIdNot(String phoneNumber, long id) {
        return this.userRepository.existsByPhoneNumberAndUserIdNot(phoneNumber, id);
    }


    public boolean verifyPassword(Long userId, String password) {
        User user = getUserById(userId);
        if (user == null) {
            return false;
        }
        return passwordEncoder.matches(password, user.getPassword());
    }

    public void updatePassword(Long userId, String newPassword) {
        User user = getUserById(userId);
        if (user != null) {
            user.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(user);
        }
    }
//    public Page<User> findUsersWithRole(String roleName, Pageable pageable) {
//        return userRepository.findAll(UserSpecification.hasRole(roleName), pageable);
//    }

    public Page<User> findUsersWithFilters(String roleName, String fullName, Pageable pageable) {
        return this.userRepository.findAll(UserSpecification.findUsersWithFilters(roleName, fullName), pageable);

    }

}