package swp.se1941jv.pls.exception;

public class RelationshipException extends ApplicationException {
    public RelationshipException(String message) {
        super("RELATIONSHIP_ERROR", message);
    }
}