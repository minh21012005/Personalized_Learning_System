package swp.se1941jv.pls.service.validator;

import org.springframework.stereotype.Service;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import swp.se1941jv.pls.dto.request.RegisterDTO;
import swp.se1941jv.pls.service.UserService;
import java.time.LocalDate;
import java.time.Period;

@Service
public class RegisterValidator implements ConstraintValidator<RegisterChecked, RegisterDTO> {

    private final UserService userService;

    public RegisterValidator(UserService userService) {
        this.userService = userService;
    }

    @Override
    public boolean isValid(RegisterDTO user, ConstraintValidatorContext context) {
        boolean valid = true;

        // Check if password fields match
        if (!user.getPassword().equals(user.getConfirmPassword())) {
            context.buildConstraintViolationWithTemplate("Confirm password nhập không chính xác!")
                    .addPropertyNode("confirmPassword")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();
            valid = false;
        }

        // Check if email exists
        if (this.userService.checkEmailExist(user.getEmail())) {
            context.buildConstraintViolationWithTemplate("Email đã tồn tại!")
                    .addPropertyNode("email")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();
            valid = false;
        }

        // Check if phone number exists
        if (this.userService.existsByPhoneNumber(user.getPhoneNumber())) {
            context.buildConstraintViolationWithTemplate("Số điện thoại đã tồn tại!")
                    .addPropertyNode("phoneNumber")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();
            valid = false;
        }

        // Calculate age based on date of birth and current system date
        LocalDate currentDate = LocalDate.now(); // Use system date
        LocalDate dob = user.getDob();
        if (dob != null) {
            int age = Period.between(dob, currentDate).getYears();
//            System.out.println("age: " + age + "");

            // Validate age based on role
            String role = user.getRole();
            if ("STUDENT".equals(role)) {
                if (age <= 5) {
                    context.buildConstraintViolationWithTemplate("Học sinh phải trên 5 tuổi!")
                            .addPropertyNode("dob")
                            .addConstraintViolation()
                            .disableDefaultConstraintViolation();
                    valid = false;
                }
            } else if ("PARENT".equals(role)) {
                if (age <= 18) {
                    context.buildConstraintViolationWithTemplate("Phụ huynh phải trên 18 tuổi!")
                            .addPropertyNode("dob")
                            .addConstraintViolation()
                            .disableDefaultConstraintViolation();
                    valid = false;
                }
            }
        }

        return valid;
    }
}