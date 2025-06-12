package swp.se1941jv.pls.exception.Lesson;

public class DuplicateLessonNameException extends RuntimeException{
    public DuplicateLessonNameException(String message) {
        super(message);
    }
}
