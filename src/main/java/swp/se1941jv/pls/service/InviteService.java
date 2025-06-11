package swp.se1941jv.pls.service;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import swp.se1941jv.pls.entity.Invite;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.InviteRepository;
import swp.se1941jv.pls.repository.UserRepository;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Service
public class InviteService {

    private final UserRepository userRepository;
    private final InviteRepository inviteRepository;
    private final JavaMailSender mailSender;

    public InviteService(UserRepository userRepository, InviteRepository inviteRepository, JavaMailSender mailSender) {
        this.userRepository = userRepository;
        this.inviteRepository = inviteRepository;
        this.mailSender = mailSender;
    }

    public void createInvite(Long parentId, String studentEmail, HttpServletRequest request) throws MessagingException {
        // Tìm Parent
        User parent = this.userRepository.findById(parentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng là phụ huynh!"));

        // Kiểm tra vai trò Parent
        if (!parent.getRole().getRoleName().equals("PARENT")) {
            throw new RuntimeException("Bạn không có vai trò là phụ huynh!");
        }

        // Kiểm tra email hợp lệ
        if (!studentEmail.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new RuntimeException("Email không hợp lệ!");
        }

        // Tạo mã mời ngẫu nhiên
        String inviteCode = UUID.randomUUID().toString();

        // Lưu lời mời
        Invite invite = Invite.builder()
                .parent(parent)
                .studentEmail(studentEmail)
                .inviteCode(inviteCode)
                .createdAt(LocalDateTime.now())
                .expiresAt(LocalDateTime.now().plusHours(24))
                .isUsed(false)
                .build();
        inviteRepository.save(invite);

        // Tạo URL động
        String confirmationLink = ServletUriComponentsBuilder
                .fromRequestUri(request)
                .replacePath("/invite/confirm")
                .queryParam("code", inviteCode)
                .build()
                .toUriString();

        // Gửi email
        sendInviteEmail(studentEmail, confirmationLink);
    }

    public void confirmInvite(String inviteCode, Long studentId) {
        // Tìm lời mời
        Optional<Invite> inviteOpt = this.inviteRepository.findByInviteCode(inviteCode);
        Invite invite = inviteOpt.orElseThrow(() -> new RuntimeException("Mã liên kết không hợp lệ!"));

        // Kiểm tra trạng thái
        if (invite.getIsUsed()) {
            throw new RuntimeException("Mã liên kết đã được sử dụng!");
        }
        if (invite.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Mã liên kết đã hết hạn!");
        }

        // Tìm Student
        User student = this.userRepository.findById(studentId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng là học sinh!"));

        // Kiểm tra vai trò và email
        if (!student.getRole().getRoleName().equals("STUDENT")) {
            throw new RuntimeException("Bạn không có vai trò là học sinh!");
        }
        if (!student.getEmail().equals(invite.getStudentEmail())) {
            throw new RuntimeException("Bạn không có quyền sử dụng mã liên kết này!");
        }

        // Liên kết Parent và Student
        student.setParent(invite.getParent());
        invite.getParent().getChildren().add(student);

        // Cập nhật trạng thái lời mời
        invite.setIsUsed(true);

        // Lưu thay đổi
        this.userRepository.save(student);
        this.userRepository.save(invite.getParent());
        this.inviteRepository.save(invite);
    }

    private void sendInviteEmail(String toEmail, String confirmationLink) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true);
        helper.setTo(toEmail);
        helper.setSubject("Invitation to Join as a Student");
        helper.setText("Please click the following link to confirm your account as a student: <a href=\""
                + confirmationLink + "\">Confirm</a>", true);
        mailSender.send(message);
    }
}