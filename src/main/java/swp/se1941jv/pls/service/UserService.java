package swp.se1941jv.pls.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import swp.se1941jv.pls.dto.request.CreateStudentRequest;
import swp.se1941jv.pls.entity.Role;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.RoleRepository;
import swp.se1941jv.pls.repository.UserRepository;
import swp.se1941jv.pls.service.specification.UserSpecification;

import java.time.LocalDateTime;
import java.util.List;
import java.util.regex.Pattern;
import java.util.UUID;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    // Regex để kiểm tra mật khẩu mạnh
    private static final String PASSWORD_PATTERN = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#$%^&*()\\-_+=\\[\\]{}|;:'\",.<>?/]).{8,}$";

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

    public Role getRoleByName(String name) {
        return this.roleRepository.findByRoleName(name);
    }

    public boolean checkEmailExist(String email) {
        return this.userRepository.existsByEmail(email);
    }

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
    // public Page<User> findUsersWithRole(String roleName, Pageable pageable) {
    // return userRepository.findAll(UserSpecification.hasRole(roleName), pageable);
    // }

    public Page<User> findUsersWithFilters(String roleName, String fullName, Pageable pageable) {
        return this.userRepository.findAll(UserSpecification.findUsersWithFilters(roleName, fullName), pageable);

    }

    // Tạo token reset password và lưu vào user
    public String generateResetPasswordToken(User user) {
        String token = UUID.randomUUID().toString();
        user.setResetPasswordToken(token);
        user.setResetPasswordTokenExpiry(LocalDateTime.now().plusHours(1)); // Token hết hạn sau 1 giờ
        this.saveUser(user);
        return token;
    }

    // Tìm user bằng token reset password
    public User findUserByResetPasswordToken(String token) {
        User user = userRepository.findByResetPasswordToken(token);
        if (user == null || user.getResetPasswordTokenExpiry() == null) {
            return null;
        }
        // Kiểm tra xem token có hết hạn không
        if (user.getResetPasswordTokenExpiry().isBefore(LocalDateTime.now())) {
            return null; // Token đã hết hạn
        }
        return user;
    }

    // Xóa token sau khi reset password thành công
    public void clearResetPasswordToken(User user) {
        user.setResetPasswordToken(null);
        user.setResetPasswordTokenExpiry(null);
        this.saveUser(user);
    }

    // Tạo token xác thực email và lưu vào user
    public String generateEmailVerifyToken(User user) {
        String token = UUID.randomUUID().toString();
        user.setEmailVerifyToken(token);
        user.setEmailVerifyTokenExpiry(LocalDateTime.now().plusHours(24)); // Token hết hạn sau 24 giờ
        this.saveUser(user);
        return token;
    }

    // Tìm user bằng token xác thực email
    public User findUserByEmailVerifyToken(String token) {
        User user = userRepository.findByEmailVerifyToken(token);
        if (user == null || user.getEmailVerifyTokenExpiry() == null) {
            return null;
        }
        // Kiểm tra xem token có hết hạn không
        if (user.getEmailVerifyTokenExpiry().isBefore(LocalDateTime.now())) {
            return null; // Token đã hết hạn
        }
        return user;
    }

    // Xóa token xác thực email sau khi xác thực thành công
    public void clearEmailVerifyToken(User user) {
        user.setEmailVerifyToken(null);
        user.setEmailVerifyTokenExpiry(null);
        user.setEmailVerify(true); // Đánh dấu email đã được xác thực
        this.saveUser(user);
    }

    public String getUserFullName(Long userId) {
        if (userId == null || userId <= 0) {
            return "Unknown";
        }
        return userRepository.findById(userId)
                .map(User::getFullName)
                .orElse("Unknown");
    }

    public List<User> findContentManagers() {
        return userRepository.findByRole_RoleName("CONTENT_MANAGER");
    }

    @Transactional
    public User createStudentByParent(CreateStudentRequest request, String parentEmail, String avatarFileName) {
        if (existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email đã được sử dụng cho một tài khoản khác.");
        }
        if (existsByPhoneNumber(request.getPhoneNumber())) {
            throw new RuntimeException("Số điện thoại đã được sử dụng cho một tài khoản khác.");
        }

        User parent = getUserByEmail(parentEmail);
        if (parent == null || !parent.getRole().getRoleName().equals("PARENT")) {
            throw new RuntimeException("Không tìm thấy tài khoản phụ huynh hợp lệ.");
        }

        Role studentRole = roleRepository.findByRoleName("STUDENT");
        if (studentRole == null) {
            throw new IllegalStateException("Vai trò 'STUDENT' không tồn tại trong hệ thống.");
        }

        User student = new User();
        student.setFullName(request.getFullName());
        student.setEmail(request.getEmail());
        student.setPassword(passwordEncoder.encode(request.getPassword()));
        student.setDob(request.getDob());
        student.setPhoneNumber(request.getPhoneNumber());
        student.setRole(studentRole);
        student.setParent(parent);
        student.setIsActive(true);
        student.setAvatar(avatarFileName);
        student.setEmailVerify(true);
        return userRepository.save(student);
    }

    public int countActiveUser() {
        return this.userRepository.findAllByIsActiveTrue().size();
    }

}