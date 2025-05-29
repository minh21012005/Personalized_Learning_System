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
        helper.setSubject("Đặt lại mật khẩu");

        // Tạo URL reset password
        String resetUrl = baseUrl + "/reset-password?token=" + token;
        String emailContent = "<h1>Đặt lại mật khẩu</h1>" +
                "<p>Vui lòng nhấp vào liên kết dưới đây để đặt lại mật khẩu của bạn:</p>" +
                "<p><a href='" + resetUrl + "'>Đặt lại mật khẩu</a></p>" +
                "<p>Liên kết này sẽ hết hạn sau 1 giờ.</p>" +
                "<p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.</p>";

        helper.setText(emailContent, true); // true để gửi email dưới dạng HTML

        mailSender.send(message);
    }
}