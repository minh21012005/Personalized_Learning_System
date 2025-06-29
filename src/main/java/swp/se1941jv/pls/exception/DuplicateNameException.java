package swp.se1941jv.pls.exception;

public class DuplicateNameException extends ApplicationException {
    public DuplicateNameException(String message) {
        super("DUPLICATE_NAME", message);
    }
}