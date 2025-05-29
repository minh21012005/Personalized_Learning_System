package swp.se1941jv.pls.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    @Value("${app.base-url}")
    private String baseUrl;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void sendResetPasswordEmail(String toEmail, String token) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true);

        helper.setFrom(fromEmail);
        helper.setTo(toEmail);
        helper.setSubject("Đặt lại mật khẩu - Hệ thống Học tập Cá nhân hóa");

        // Tạo URL reset password
        String resetUrl = baseUrl + "/reset-password?token=" + token;

        // HTML email template
        String emailContent = String.format(
                """
                <!DOCTYPE html>
                <html lang="vi">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Đặt lại mật khẩu</title>
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
                                            <h1 style="font-size: 28px; font-weight: 600; color: #045bd8; margin: 0 0 20px;">Đặt lại mật khẩu</h1>
                                            <p style="font-size: 16px; line-height: 1.5; margin: 0 0 20px;">
                                                Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản của mình. Vui lòng nhấp vào nút dưới đây để đặt lại mật khẩu:
                                            </p>
                                            <a href="%s" style="display: inline-block; background-color: #045bd8; color: #ffffff; text-decoration: none; font-size: 16px; font-weight: 500; padding: 12px 30px; border-radius: 5px; margin: 20px 0;">Đặt lại mật khẩu</a>
                                            <p style="font-size: 14px; line-height: 1.5; color: #666; margin: 20px 0;">
                                                Liên kết này sẽ hết hạn sau 1 giờ. Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.
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
                resetUrl
        );

        helper.setText(emailContent, true); // true để gửi email dưới dạng HTML

        mailSender.send(message);
    }
}