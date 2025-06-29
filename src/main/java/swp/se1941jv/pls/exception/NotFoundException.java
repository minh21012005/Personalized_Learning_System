package swp.se1941jv.pls.exception;

public class NotFoundException extends ApplicationException {
    public NotFoundException(String message) {
        super("NOT_FOUND", message);
    }
}