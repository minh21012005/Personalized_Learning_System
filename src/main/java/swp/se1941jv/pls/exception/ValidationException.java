package swp.se1941jv.pls.exception;

public class ValidationException extends ApplicationException {
    public ValidationException(String message) {
        super("VALIDATION_ERROR", message);
    }
}