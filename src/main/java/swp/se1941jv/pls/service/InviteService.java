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

        // Kiểm tra học sinh đã liên kết với phụ huynh hiện tại
        User student = userRepository.findByEmail(studentEmail);
        if (student != null && student.getParent() != null &&
                student.getParent().getUserId().equals(parentId)) {
            throw new RuntimeException("Học sinh với email này đã được liên kết với bạn");
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
        helper.setSubject("Liên kết tài khoản với phụ huynh - Hệ thống Học tập Cá nhân hóa");

        String emailContent = String.format(
                """
                        <!DOCTYPE html>
                        <html lang="vi">
                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Liên kết tài khoản</title>
                        </head>
                        <body style="margin: 0; padding: 0; font-family: 'Poppins', Arial, sans-serif; background-color: #f5f7fa; color: #333;">
                            <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%%" style="background-color: #f5f7fa;">
                                <tr>
                                    <td align="center" style="padding: 40px 20px;">
                                        <!-- Main container -->
                                        <table role="presentation" border="0" cellpadding="0" cellspacing="0" width="100%%" style="max-width: 600px; background-color: #ffffff; border-radius: 15px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);">
                                            <!-- Header -->
                                            <tr>
                                                <td style="background: linear-gradient(135deg, #045bd8 0%%, #2a5298 100%%); border-radius: 15px 15px 0 0; padding: 30px 20px; text-align: center;">

                                                </td>
                                            </tr>
                                            <!-- Content -->
                                            <tr>
                                                <td style="padding: 40px 30px; text-align: center;">
                                                    <h1 style="font-size: 28px; font-weight: 600; color: #045bd8; margin: 0 0 20px;">Xác thực Email</h1>
                                                    <p style="font-size: 16px; line-height: 1.5; margin: 0 0 20px;">
                                                        Phụ huynh của bạn đã gửi lời mời để liên kết với tài khoản của bạn. Vui lòng nhấp vào liên kết dưới đây để xác nhận
                                                    </p>
                                                    <a href="%s" style="display: inline-block; background-color: #045bd8; color: #ffffff; text-decoration: none; font-size: 16px; font-weight: 500; padding: 12px 30px; border-radius: 5px; margin: 20px 0;">Xác thực Email</a>
                                                    <p style="font-size: 14px; line-height: 1.5; color: #666; margin: 20px 0;">
                                                        Liên kết này sẽ hết hạn sau 24 giờ. Nếu bạn không nhận ra lời mời này hoặc không phải là người được mời, xin vui lòng bỏ qua email này
                                                    </p>
                                                </td>
                                            </tr>
                                            <!-- Footer -->
                                            <tr>
                                                <td style="background-color: #f5f7fa; border-radius: 0 0 15px 15px; padding: 20px; text-align: center;">
                                                    <p style="font-size: 14px; color: #666; margin: 0;">
                                                        Bạn cần hỗ trợ? <a href="mailto:support@pls.com" style="color: #045bd8; text-decoration: none;">Liên hệ với chúng tôi</a>
                                                    </p>
                                                    <p style="font-size: 12px; color: #999; margin: 10px 0 0;">
                                                        © 2025 Hệ thống Học tập Cá nhân hóa. Mọi quyền được bảo lưu.
                                                    </p>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </body>
                        </html>
                        """,
                confirmationLink);

        helper.setText(emailContent, true); // true để gửi email dưới dạng HTML
        mailSender.send(message);
    }
}