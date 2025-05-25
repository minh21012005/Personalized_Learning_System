package swp.se1941jv.pls.service.validator;

import java.time.LocalDate;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

public class AdultValidator implements ConstraintValidator<Adult, LocalDate> {

    @Override
    public boolean isValid(LocalDate birthDate, ConstraintValidatorContext context) {
        if (birthDate == null) {
            return false;
        }
        return birthDate.plusYears(18).isBefore(LocalDate.now()) || birthDate.plusYears(18).isEqual(LocalDate.now());
    }
}
